import 'dart:io';

import 'package:arena/components/bottom_sheet/custom_bottom_sheet_v2.dart';
import 'package:arena/components/current_user_avatar.dart';
import 'package:arena/components/icon_button/custom_icon_button_circle.dart';
import 'package:arena/components/custom_spacing.dart';
import 'package:arena/components/custom_text.dart';
import 'package:arena/components/custom_timeline_filter.dart';
import 'package:arena/config/design/custom_icons.dart';
import 'package:arena/config/routes/app_routes.dart';
import 'package:arena/config/theme/app_colors.dart';
import 'package:arena/models/enums/role.dart';
import 'package:arena/pages/report/bloc/report_bloc.dart';
import 'package:arena/pages/report/bloc/report_event.dart';
import 'package:arena/pages/report/bloc/report_state.dart';
import 'package:arena/services/report/report_export_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:share_plus/share_plus.dart';

import 'tabs/ringkasan_tab.dart';
import 'tabs/pergerakan_tab.dart';
import 'tabs/penjualan_tab.dart';
import 'tabs/persediaan_tab.dart';
import 'package:arena/utils/nav_drawer.dart';

class ReportPage extends StatefulWidget {
  final Role role;

  const ReportPage({super.key, required this.role});

  @override
  State<ReportPage> createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage>
    with SingleTickerProviderStateMixin {
  late final bool _isWarehouse = widget.role == Role.warehouseStaff;
  late TabController _tabController;

  final List<String> _periods = const ['1D', '1W', '1M', '6M', '1Y'];
  static const List<String> _periodLabels = ['1h', '1m', '1b', '6b', '1thn'];
  int selectedFilter = 2;
  DateTime? startDate;
  DateTime? endDate;

  final List<int> _loadedFilterPerTab = [-1, -1, -1, -1];
  String _loadedDateKey = "";
  int _lastNotifiedTab = 0;

  final GlobalKey<NestedScrollViewState> _nestedScrollKey =
      GlobalKey<NestedScrollViewState>();
  int? _pendingResetTab;

  static const Duration _scrollToTopDuration = Duration(milliseconds: 320);
  static const Curve _scrollToTopCurve = Curves.easeOutCubic;

  String get _currentPeriod => _periods[selectedFilter];
  int get _activeTabIndex => _isWarehouse ? 2 : _tabController.index;

  String get _dateKey {
    final start = startDate?.millisecondsSinceEpoch ?? 0;
    final end = endDate?.millisecondsSinceEpoch ?? 0;
    return "$start-$end";
  }

  bool _isLoaded(int tabIndex) {
    if (_loadedFilterPerTab[tabIndex] != selectedFilter) return false;
    return _loadedDateKey == _dateKey;
  }

  void _dispatchTabLoad(int tabIndex, {bool force = false}) {
    if (!force && _isLoaded(tabIndex)) return;
    _loadedFilterPerTab[tabIndex] = selectedFilter;
    _loadedDateKey = _dateKey;

    final bloc = context.read<ReportBloc>();
    switch (tabIndex) {
      case 0:
        bloc.add(
          LoadReportSummary(
            period: _currentPeriod,
            startDate: startDate,
            endDate: endDate,
          ),
        );
      case 1:
        bloc.add(
          LoadTopProducts(
            period: _currentPeriod,
            startDate: startDate,
            endDate: endDate,
          ),
        );
      case 2:
        bloc.add(
          LoadStockHealth(
            period: _currentPeriod,
            startDate: startDate,
            endDate: endDate,
          ),
        );
      case 3:
        bloc.add(
          LoadStockMovement(
            period: _currentPeriod,
            startDate: startDate,
            endDate: endDate,
          ),
        );
    }
  }

  void _onTabChanged() {
    if (_tabController.indexIsChanging) return;
    if (_tabController.index == _lastNotifiedTab) return;
    _lastNotifiedTab = _tabController.index;
    _dispatchTabLoad(_tabController.index);
    _evictOtherTabs(_tabController.index);
    _scrollToTop();
  }

  void _scrollToTop() {
    _animateToTop();
    _pendingResetTab = _activeTabIndex;
    WidgetsBinding.instance.addPostFrameCallback((_) => _animateToTop());
  }

  void _animateToTop() {
    final state = _nestedScrollKey.currentState;
    if (state == null) return;

    final outer = state.outerController;
    if (!outer.hasClients) return;
    final outerPosition = outer.positions.first;
    outerPosition.animateTo(
      outerPosition.minScrollExtent,
      duration: _scrollToTopDuration,
      curve: _scrollToTopCurve,
    );
  }

  void _evictOtherTabs(int activeTab) {
    context.read<ReportBloc>().add(
      ClearInactiveReportData(activeTab: activeTab),
    );
    for (var i = 0; i < _loadedFilterPerTab.length; i++) {
      if (i != activeTab) _loadedFilterPerTab[i] = -1;
    }
  }

  Future<void> _refreshActiveTab() async {
    _evictOtherTabs(_activeTabIndex);
    _dispatchTabLoad(_activeTabIndex, force: true);

    final bloc = context.read<ReportBloc>();
    await bloc.stream
        .firstWhere(
          (state) =>
              state.status == ReportStatus.ready ||
              state.status == ReportStatus.failure,
        )
        .timeout(const Duration(seconds: 20), onTimeout: () => bloc.state);
  }

  final ReportExportService _exportService = ReportExportService();
  bool _isExporting = false;

  Future<void> _handleRefresh() => _refreshActiveTab();

  Future<void> _export(ReportExportFormat format) async {
    if (_isExporting) return;
    setState(() => _isExporting = true);
    final messenger = ScaffoldMessenger.of(context);
    String? exportedPath;
    try {
      exportedPath = await _exportService.exportSummary(
        period: _currentPeriod,
        format: format,
        startDate: startDate,
        endDate: endDate,
      );
      await Share.shareXFiles([XFile(exportedPath)]);
    } catch (e) {
      messenger.showSnackBar(
        SnackBar(content: Text(e.toString().replaceAll("Exception: ", ""))),
      );
    } finally {
      if (exportedPath != null) {
        try {
          final file = File(exportedPath);
          if (await file.exists()) await file.delete();
        } catch (_) {}
      }
      if (mounted) setState(() => _isExporting = false);
    }
  }

  void _showExportSheet() {
    CustomBottomSheetV2.show(
      context,
      hideHeader: true,
      children: [
        ListTile(
          leading: SvgPicture.asset(CustomIcons.pdf, width: 24, height: 24),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const CustomText(text: "Export PDF"),
          onTap: () {
            context.pop();
            _export(ReportExportFormat.pdf);
          },
        ),
        ListTile(
          leading: SvgPicture.asset(CustomIcons.excel, width: 24, height: 24),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const CustomText(text: "Export Excel"),
          onTap: () {
            context.pop();
            _export(ReportExportFormat.excel);
          },
        ),
      ],
    );
  }

  @override
  void initState() {
    super.initState();

    if (!_isWarehouse) {
      _tabController = TabController(length: 4, vsync: this)
        ..addListener(_onTabChanged);
    }
    _dispatchTabLoad(_activeTabIndex);
  }

  @override
  void dispose() {
    if (!_isWarehouse) {
      _tabController.dispose();
    }
    super.dispose();
  }

  Widget _buildTab(String text, int index) {
    return AnimatedBuilder(
      animation: _tabController,
      builder: (context, _) {
        final isActive = _tabController.index == index;

        return GestureDetector(
          onTap: () => _tabController.animateTo(
            index,
            duration: Duration.zero,
            curve: Curves.easeOut,
          ),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            margin: const EdgeInsets.only(right: 12),
            decoration: BoxDecoration(
              color: isActive ? AppColors.primary : Colors.transparent,
              borderRadius: BorderRadius.circular(8),
            ),
            child: CustomText(
              text: text,
              style: TextStyle(
                fontSize: 14,
                color: isActive
                    ? SupportAppColors.white
                    : SupportAppColors.greyColor,
                fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ReportBloc, ReportState>(
      listenWhen: (previous, current) =>
          previous.status != current.status &&
          current.status == ReportStatus.ready,
      listener: (context, state) {
        if (_pendingResetTab == null) return;
        _pendingResetTab = null;
        WidgetsBinding.instance.addPostFrameCallback((_) => _animateToTop());
      },
      child: SafeArea(
        top: false,
        child: RefreshIndicator(
          onRefresh: _handleRefresh,
          notificationPredicate: (notification) => notification.depth >= 1,
          child: NestedScrollView(
            key: _nestedScrollKey,
            headerSliverBuilder: (context, innerBoxIsScrolled) {
              return [
                SliverAppBar(
                  elevation: 0,
                  backgroundColor: AppColors.bgColor,
                  surfaceTintColor: AppColors.bgColor,
                  floating: !_isWarehouse,
                  snap: !_isWarehouse,
                  pinned: true,
                  automaticallyImplyLeading: false,
                  leadingWidth: 72,
                  leading: Padding(
                    padding: const EdgeInsets.only(left: 16),
                    child: CustomIconbuttonCircle(
                      prefixIcon: Icons.menu,
                      backgroundColor: SupportAppColors.white,
                      iconColor: SupportAppColors.greyDarkerColor,
                      iconSize: 24,
                      width: 40,
                      height: 40,
                      onPressed: () {
                        openNavDrawer(context);
                      },
                    ),
                  ),
                  titleSpacing: 16,
                  title: const CustomText(
                    text: "Laporan",
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
                  ),
                  actionsPadding: EdgeInsets.only(right: 16),
                  actions: [
                    if (!_isWarehouse)
                      AnimatedBuilder(
                        animation: _tabController,
                        builder: (context, _) {
                          final showExport = _tabController.index == 0;
                          return Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              if (showExport)
                                _isExporting
                                    ? const Padding(
                                        padding: EdgeInsets.only(right: 12),
                                        child: SizedBox(
                                          width: 20,
                                          height: 20,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                          ),
                                        ),
                                      )
                                    : CustomIconbuttonCircle(
                                        useSvg: true,
                                        isCustomIcon: true,
                                        assetPath: CustomIcons.export,
                                        backgroundColor: SupportAppColors.white,
                                        iconColor:
                                            SupportAppColors.greyDarkerColor,
                                        iconSize: 24,
                                        width: 60,
                                        height: 60,
                                        onPressed: _showExportSheet,
                                      ),
                              if (showExport) const CustomSpacing(width: 12),
                            ],
                          );
                        },
                      ),
                    InkWell(
                      borderRadius: BorderRadius.circular(50),
                      onTap: () => context.push(AppRoutes.profile),
                      child: const CurrentUserAvatar(),
                    ),
                  ],
                  bottom: PreferredSize(
                    preferredSize: Size.fromHeight(_isWarehouse ? 72 : 128),
                    child: Column(
                      children: [
                        if (!_isWarehouse) const CustomSpacing(height: 12),

                        if (!_isWarehouse)
                          Container(
                            color: AppColors.bgColor,
                            padding: const EdgeInsets.only(top: 0, bottom: 16),
                            child: CustomSpacing(
                              height: 40,
                              child: ListView(
                                scrollDirection: Axis.horizontal,
                                padding: const EdgeInsets.only(
                                  left: 16,
                                  right: 4,
                                ),
                                children: [
                                  _buildTab("Ringkasan", 0),
                                  _buildTab("Penjualan", 1),
                                  _buildTab("Persediaan", 2),
                                  _buildTab("Pergerakan", 3),
                                ],
                              ),
                            ),
                          ),
                        CustomTimelineFilter(
                          selectedIndex: selectedFilter,
                          labels: _periodLabels,
                          onChanged: (i) {
                            setState(() {
                              selectedFilter = i;
                              startDate = null;
                              endDate = null;
                            });
                            _refreshActiveTab();
                          },
                          startDate: startDate,
                          endDate: endDate,
                          onDateRangeSelected: (start, end) {
                            setState(() {
                              startDate = start;
                              endDate = end;
                            });
                            _refreshActiveTab();
                          },
                          hideDatePicker: false,
                          padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                        ),
                      ],
                    ),
                  ),
                ),
              ];
            },
            body: _isWarehouse
                ? const PersediaanTab()
                : TabBarView(
                    controller: _tabController,
                    physics: NeverScrollableScrollPhysics(),
                    children: [
                      const RingkasanTab(),
                      const PenjualanTab(),
                      const PersediaanTab(),
                      PergerakanTab(
                        period: _currentPeriod,
                        startDate: startDate,
                        endDate: endDate,
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}
