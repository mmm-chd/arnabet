import 'package:arena/components/bottom_sheet/custom_bottom_sheet_v2.dart';
import 'package:arena/components/custom_button.dart';
import 'package:arena/components/custom_spacing.dart';
import 'package:arena/components/custom_text.dart';
import 'package:arena/components/icon_button/custom_iconButton.dart';
import 'package:arena/components/icon_button/custom_icon_button_circle.dart';
import 'package:arena/config/design/app_snack_bar.dart';
import 'package:arena/config/design/custom_icons.dart';
import 'package:arena/config/theme/app_colors.dart';
import 'package:arena/helper/currency_local_formatter.dart';
import 'package:arena/services/order/invoice_print_service.dart';
import 'package:arena/services/printer/thermal_printer_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_thermal_printer/utils/printer.dart';
import 'package:go_router/go_router.dart';
import 'package:image/image.dart' as img;

class PaymentReceiptPage extends StatefulWidget {
  final String invoiceId;
  final num totalAmount;
  final String? customerName;
  final String? vehicleModel;
  final String? vehiclePlate;
  final String? paymentMethod;
  final String? transactionTime;
  final VoidCallback? onDone;
  final bool hideDoneButton;
  final String? orderId;
  final bool hideName;
  final bool isSuccess;
  final String? failureReason;
  final VoidCallback? onRetry;

  const PaymentReceiptPage({
    super.key,
    required this.invoiceId,
    required this.totalAmount,
    this.customerName,
    this.vehicleModel,
    this.vehiclePlate,
    this.paymentMethod,
    this.transactionTime,
    this.onDone,
    this.hideDoneButton = true,
    this.orderId,
    this.hideName = false,
    this.isSuccess = true,
    this.failureReason,
    this.onRetry,
  });

  @override
  State<PaymentReceiptPage> createState() => _PaymentReceiptPageState();
}

class _PaymentReceiptPageState extends State<PaymentReceiptPage> {
  static const _successGreen = SupportAppColors.normalGreen;

  final ThermalPrinterService _printerService = ThermalPrinterService.instance;
  final InvoicePrintService _invoiceService = InvoicePrintService();
  bool _printing = false;
  bool _previewing = false;

  @override
  void initState() {
    super.initState();
    _printerService.startScan();
  }

  @override
  void dispose() {
    _printerService.stopScan();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                Align(
                  alignment: Alignment.topLeft,
                  child: CustomIconbuttonCircle(
                    prefixIcon: Icons.arrow_back,
                    backgroundColor: SupportAppColors.white,
                    iconColor: SupportAppColors.greyDarkerColor,
                    iconSize: 28,
                    width: 60,
                    height: 60,
                    onPressed: () => context.pop(),
                  ),
                ),
                _buildStatusHeader(),
                const CustomSpacing(height: 24),
                _buildReceiptCard(),
                if (widget.isSuccess) ...[
                  const CustomSpacing(height: 16),
                  _buildPrinterStatus(context),
                  const CustomSpacing(height: 16),
                  _buildCetakButton(context),
                  // if (kDebugMode) ...[
                  //   const CustomSpacing(height: 12),\
                  //   _buildPreviewButton(context),
                  // ],
                ],
                if (!widget.isSuccess) ...[
                  const CustomSpacing(height: 24),
                  _buildFailureActions(context),
                ],
                if (!widget.hideDoneButton) ...[
                  const CustomSpacing(height: 16),
                  _buildDoneButton(context),
                  const CustomSpacing(height: 24),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      elevation: 0,
      backgroundColor: AppColors.bgColor,
      surfaceTintColor: AppColors.bgColor,
      automaticallyImplyLeading: false,
      leadingWidth: 72,
      leading: CustomIconbuttonCircle(
        prefixIcon: Icons.arrow_back,
        backgroundColor: SupportAppColors.white,
        iconColor: SupportAppColors.greyDarkerColor,
        iconSize: 24,
        width: 40,
        height: 40,
        onPressed: () => Navigator.of(context).pop(),
      ),
    );
  }

  Widget _buildStatusHeader() {
    if (!widget.isSuccess) {
      return Column(
        children: [
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              color: AppColors.error,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.error_outline_rounded,
              color: SupportAppColors.white,
              size: 36,
            ),
          ),
          const CustomSpacing(height: 16),
          const CustomText(
            text: 'Transaksi Gagal',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: AppColors.error,
            ),
          ),
          const CustomSpacing(height: 4),
          CustomText(
            text: widget.failureReason ?? 'Silakan coba lagi.',
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 14,
              color: SupportAppColors.greyColor,
            ),
          ),
        ],
      );
    }
    return Column(
      children: [
        Container(
          width: 72,
          height: 72,
          decoration: const BoxDecoration(
            color: _successGreen,
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.check_circle_outline_rounded,
            color: SupportAppColors.white,
            size: 36,
          ),
        ),
        const CustomSpacing(height: 16),
        const CustomText(
          text: 'Transaksi Selesai!',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: _successGreen,
          ),
        ),
        const CustomSpacing(height: 4),
        const CustomText(
          text: 'Pembayaran berhasil diproses.',
          style: TextStyle(fontSize: 14, color: SupportAppColors.greyColor),
        ),
      ],
    );
  }

  Widget _buildReceiptCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: SupportAppColors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.07),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const CustomText(
            text: 'RINGKASAN',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: SupportAppColors.greyColor,
              letterSpacing: 1.5,
            ),
          ),
          const CustomSpacing(height: 4),
          CustomText(
            text: widget.totalAmount.toLocaleCurrency(decimalDigits: 0),
            style: const TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.w800,
              color: AppColors.primary,
            ),
          ),
          const CustomSpacing(height: 16),
          const _DottedLine(),
          const CustomSpacing(height: 16),
          _buildDataRow('Nomor Invoice', widget.invoiceId),
          if (widget.transactionTime != null) ...[
            const CustomSpacing(height: 12),
            _buildDataRow('Waktu', widget.transactionTime!),
          ],
          if (widget.customerName != null) ...[
            const CustomSpacing(height: 12),
            _buildDataRow('Pelanggan', widget.customerName!),
          ],
          if (widget.vehicleModel != null) ...[
            const CustomSpacing(height: 12),
            _buildDataRow('Kendaraan', widget.vehicleModel!),
          ],
          if (widget.vehiclePlate != null) ...[
            const CustomSpacing(height: 12),
            _buildDataRow('No. Polisi', widget.vehiclePlate!),
          ],
          if (widget.paymentMethod != null) ...[
            const CustomSpacing(height: 12),
            _buildDataRow('Metode', widget.paymentMethod!),
          ],
        ],
      ),
    );
  }

  Widget _buildPrinterStatus(BuildContext context) {
    return ValueListenableBuilder<ThermalPrinterState>(
      valueListenable: _printerService.state,
      builder: (context, state, _) {
        final printer = state.connectedPrinter;
        final connected = printer != null;
        final color = connected
            ? SupportAppColors.normalGreen
            : AppColors.error;

        return Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: () => _showPrinterSheet(context),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                color: SupportAppColors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: color.withValues(alpha: 0.4)),
              ),
              child: Row(
                children: [
                  Icon(
                    connected
                        ? Icons.print_rounded
                        : Icons.print_disabled_rounded,
                    color: color,
                    size: 20,
                  ),
                  const CustomSpacing(width: 8),
                  Expanded(
                    child: CustomText(
                      text: connected
                          ? 'Printer tersambung · ${printer.name ?? "Printer"}'
                          : 'Printer tidak tersambung · ketuk untuk memilih',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: color,
                      ),
                    ),
                  ),
                  const Icon(
                    Icons.chevron_right_rounded,
                    color: SupportAppColors.greyColor,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildCetakButton(BuildContext context) {
    return ValueListenableBuilder<ThermalPrinterState>(
      valueListenable: _printerService.state,
      builder: (context, state, _) {
        final printer = state.connectedPrinter;
        final canPrint =
            printer != null && widget.orderId != null && !_printing;
        final color = canPrint
            ? AppColors.primary
            : SupportAppColors.greyMidColor;

        return CustomIconbutton(
          text: _printing ? 'Mencetak...' : 'Cetak',
          fontWeight: FontWeight.w500,
          assetPath: CustomIcons.printer,
          iconColor: color,
          colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
          backgroundColor: SupportAppColors.white,
          foregroundColor: color,
          borderColor: color,
          splashColor: color,
          borderWidth: 1,
          isCustom: true,
          useSvg: true,
          useDInfin: true,
          useBorder: true,
          borderRadius: 16,
          onTap: canPrint ? _handleCetak : null,
        );
      },
    );
  }

  Future<void> _handleCetak() async {
    final orderId = widget.orderId;
    if (orderId == null || _printing) return;

    final connected = await _printerService.ensureConnected();
    if (!connected) {
      if (mounted) {
        AppSnackBar.error(
          context: context,
          message: 'Printer tidak tersambung. Silakan sambung ulang.',
        );
        _showPrinterSheet(context);
      }
      return;
    }

    final printer = _printerService.state.value.connectedPrinter;
    if (printer == null) return;

    setState(() => _printing = true);
    try {
      final pdfBytes = await _invoiceService.fetchInvoicePdf(
        orderId: orderId,
        hideName: widget.hideName,
      );
      await _invoiceService.printInvoicePdf(
        printer: printer,
        pdfBytes: pdfBytes,
      );
      if (mounted) {
        AppSnackBar.success(
          context: context,
          message: 'Invoice berhasil dicetak',
        );
      }
    } catch (e) {
      if (mounted) {
        AppSnackBar.error(
          context: context,
          message: e.toString().replaceAll('Exception: ', ''),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _printing = false);
      }
    }
  }

  Widget _buildPreviewButton(BuildContext context) {
    final canPreview = widget.orderId != null;
    final color = canPreview
        ? SupportAppColors.greyDarkerColor
        : SupportAppColors.greyMidColor;
    return CustomIconbutton(
      text: 'Preview Struk',
      fontWeight: FontWeight.w500,
      icon: Icons.visibility_outlined,
      iconColor: color,
      iconSize: 18,
      backgroundColor: SupportAppColors.white,
      foregroundColor: color,
      borderColor: color,
      borderWidth: 1,
      useBorder: true,
      useDInfin: true,
      borderRadius: 16,
      isLoading: _previewing,
      onTap: canPreview ? _handlePreview : null,
    );
  }

  Future<void> _handlePreview() async {
    final orderId = widget.orderId;
    if (orderId == null || _previewing) return;

    setState(() => _previewing = true);
    try {
      final pdfBytes = await _invoiceService.fetchInvoicePdf(
        orderId: orderId,
        hideName: widget.hideName,
      );
      if (!mounted) return;
      await _showReceiptPreview(pdfBytes);
    } catch (e) {
      if (mounted) {
        AppSnackBar.error(
          context: context,
          message: e.toString().replaceAll('Exception: ', ''),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _previewing = false);
      }
    }
  }

  Future<void> _showReceiptPreview(Uint8List pdfBytes) async {
    await showDialog<void>(
      context: context,
      builder: (_) => _ReceiptPreviewDialog(pdfBytes: pdfBytes),
    );
  }

  Future<void> _showPrinterSheet(BuildContext context) async {
    final refreshing = ValueNotifier<bool>(
      _printerService.state.value.scanning,
    );
    void syncRefreshing() {
      refreshing.value = _printerService.state.value.scanning;
    }

    _printerService.state.addListener(syncRefreshing);

    await CustomBottomSheetV2.show(
      context,
      title: 'Pilih Printer',
      initialChildSize: 0.6,
      onRefresh: _printerService.startScan,
      isRefreshing: refreshing,
      child: ValueListenableBuilder<ThermalPrinterState>(
        valueListenable: _printerService.state,
        builder: (context, state, _) {
          if (state.scanning && state.devices.isEmpty) {
            return const Padding(
              padding: EdgeInsets.symmetric(vertical: 32),
              child: Center(child: CircularProgressIndicator()),
            );
          } else if (state.devices.isEmpty) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 24),
              child: Column(
                children: [
                  if (state.error != null) ...[
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: SupportAppColors.lightRed,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.error_outline_rounded,
                            color: SupportAppColors.normalRed,
                            size: 20,
                          ),
                          const CustomSpacing(width: 8),
                          Expanded(
                            child: CustomText(
                              text: state.error!,
                              textAlign: TextAlign.left,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const CustomSpacing(height: 16),
                  ],
                  CustomText(
                    text:
                        'Pastikan Bluetooth HP menyala dan printer dalam mode pairing.',
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          } else {
            final devices = List<Printer>.from(state.devices)
              ..sort((a, b) {
                int rank(Printer p) {
                  if (p.isConnected ?? false) return 0;
                  if (p.address != null &&
                      p.address == _printerService.lastConnectedAddress) {
                    return 1;
                  }
                  return 2;
                }

                final ra = rank(a);
                final rb = rank(b);
                if (ra != rb) return ra.compareTo(rb);
                return (a.name ?? '').compareTo(b.name ?? '');
              });
            return ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: devices.length,
              separatorBuilder: (_, __) => const CustomSpacing(height: 8),
              itemBuilder: (context, index) {
                final device = devices[index];
                final isConnected = device.isConnected ?? false;
                final needsReconnect =
                    !isConnected &&
                    device.address != null &&
                    device.address == _printerService.lastConnectedAddress;
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                  decoration: BoxDecoration(
                    color: isConnected
                        ? SupportAppColors.lightGreen
                        : needsReconnect
                        ? SupportAppColors.lightOrange
                        : SupportAppColors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: isConnected
                          ? SupportAppColors.normalGreen
                          : needsReconnect
                          ? SupportAppColors.normalOrange
                          : SupportAppColors.greyMidColor,
                      width: isConnected || needsReconnect ? 1.5 : 1,
                    ),
                  ),
                  child: Material(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(16),
                    clipBehavior: Clip.antiAlias,
                    child: InkWell(
                      onTap: () {
                        if (isConnected) {
                          _printerService.disconnect(device);
                        } else {
                          _printerService.connect(device);
                        }
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        child: Row(
                          children: [
                            AnimatedSwitcher(
                              duration: const Duration(milliseconds: 300),
                              transitionBuilder: (child, animation) =>
                                  ScaleTransition(
                                    scale: animation,
                                    child: child,
                                  ),
                              child: Icon(
                                device.connectionType == ConnectionType.USB
                                    ? Icons.usb_rounded
                                    : Icons.bluetooth_rounded,
                                key: ValueKey(isConnected),
                                color: isConnected
                                    ? SupportAppColors.normalGreen
                                    : SupportAppColors.greyDarkerColor,
                                size: 24,
                              ),
                            ),
                            const CustomSpacing(width: 12),
                            Expanded(
                              child: AnimatedSwitcher(
                                duration: const Duration(milliseconds: 250),
                                child: Column(
                                  key: ValueKey(isConnected),
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    CustomText(
                                      text: device.name ?? 'Printer',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        color: isConnected
                                            ? SupportAppColors.normalGreen
                                            : SupportAppColors.greyDarkerColor,
                                      ),
                                    ),
                                    const CustomSpacing(height: 2),
                                    CustomText(
                                      text:
                                          '${device.connectionTypeString} · '
                                          '${isConnected
                                              ? "Tersambung"
                                              : needsReconnect
                                              ? "Perlu sambung ulang"
                                              : "Belum tersambung"}',
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: SupportAppColors.greyColor,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const CustomSpacing(width: 8),
                            AnimatedSwitcher(
                              duration: const Duration(milliseconds: 250),
                              child: CustomText(
                                key: ValueKey(isConnected),
                                text: isConnected
                                    ? 'Putuskan'
                                    : needsReconnect
                                    ? 'Sambung Ulang'
                                    : 'Sambungkan',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: isConnected
                                      ? SupportAppColors.normalGreen
                                      : needsReconnect
                                      ? SupportAppColors.normalOrange
                                      : AppColors.primary,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );

    _printerService.state.removeListener(syncRefreshing);
    refreshing.dispose();
  }

  Widget _buildDataRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: CustomText(
            text: label,
            style: const TextStyle(
              fontSize: 13,
              color: SupportAppColors.greyColor,
            ),
          ),
        ),
        Expanded(
          flex: 2,
          child: CustomText(
            text: value,
            textAlign: TextAlign.right,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: SupportAppColors.greyDarkerColor,
              fontFamily: 'JetBrainsMono',
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDoneButton(BuildContext context) {
    return CustomButton(
      text: 'Selesai',
      backgroundColor: AppColors.primary,
      foregroundColor: SupportAppColors.white,
      borderRadius: 16,
      onPressed: widget.onDone ?? () => Navigator.of(context).pop(),
    );
  }

  Widget _buildFailureActions(BuildContext context) {
    final onRetry = widget.onRetry;
    return Column(
      children: [
        if (onRetry != null) ...[
          CustomButton(
            text: 'Coba Lagi',
            backgroundColor: AppColors.primary,
            foregroundColor: SupportAppColors.white,
            borderRadius: 16,
            onPressed: onRetry,
          ),
          const CustomSpacing(height: 12),
        ],
        CustomButton(
          text: onRetry != null ? 'Kembali' : 'Selesai',
          backgroundColor: SupportAppColors.white,
          foregroundColor: AppColors.primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: const BorderSide(color: AppColors.primary, width: 1.5),
          ),
          onPressed: widget.onDone ?? () => Navigator.of(context).pop(),
        ),
      ],
    );
  }
}

class _ReceiptPreviewDialog extends StatefulWidget {
  final Uint8List pdfBytes;

  const _ReceiptPreviewDialog({required this.pdfBytes});

  @override
  State<_ReceiptPreviewDialog> createState() => _ReceiptPreviewDialogState();
}

class _ReceiptPreviewDialogState extends State<_ReceiptPreviewDialog> {
  static const _resolutions = [400, 800];

  final InvoicePrintService _invoiceService = InvoicePrintService();
  int _targetWidth = InvoicePrintService.printWidthPx;
  List<img.Image>? _images;
  String? _error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _images = null;
      _error = null;
    });
    try {
      final images = await _invoiceService.renderInvoicePages(
        widget.pdfBytes,
        targetWidth: _targetWidth,
      );
      if (!mounted) return;
      setState(() => _images = images);
    } catch (e) {
      if (!mounted) return;
      setState(() => _error = e.toString().replaceAll('Exception: ', ''));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog.fullscreen(
      backgroundColor: SupportAppColors.white,
      child: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 8, 4),
              child: Row(
                children: [
                  Expanded(
                    child: CustomText(
                      text: 'Preview Struk · ${_targetWidth}px',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: SupportAppColors.greyDarkerColor,
                      ),
                    ),
                  ),
                  for (final res in _resolutions) ...[
                    _resChip(res),
                    const CustomSpacing(width: 8),
                  ],
                  CustomIconbuttonCircle(
                    prefixIcon: Icons.close,
                    backgroundColor: SupportAppColors.greyMidTermColor,
                    iconColor: SupportAppColors.greyDarkerColor,
                    iconSize: 20,
                    width: 40,
                    height: 40,
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
            ),
            const Divider(height: 1, color: SupportAppColors.greyMidColor),
            Expanded(child: _buildBody()),
          ],
        ),
      ),
    );
  }

  Widget _resChip(int res) {
    final selected = res == _targetWidth;
    return InkWell(
      onTap: _images == null
          ? null
          : () {
              setState(() => _targetWidth = res);
              _load();
            },
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: selected
              ? AppColors.primary
              : SupportAppColors.greyMidTermColor,
          borderRadius: BorderRadius.circular(20),
        ),
        child: CustomText(
          text: '${res}px',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: selected
                ? SupportAppColors.white
                : SupportAppColors.greyDarkerColor,
          ),
        ),
      ),
    );
  }

  Widget _buildBody() {
    if (_error != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: CustomText(text: _error!, textAlign: TextAlign.center),
        ),
      );
    }
    if (_images == null) {
      return const Center(child: CircularProgressIndicator());
    }
    final images = _images!;
    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
            child: CustomText(
              text:
                  'Lebar asli ${images.first.width}px · pinch/zoom untuk melihat detail ketajaman',
              style: const TextStyle(
                fontSize: 12,
                color: SupportAppColors.greyColor,
              ),
            ),
          ),
          for (final image in images)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              child: _ReceiptPreviewImage(image: image),
            ),
        ],
      ),
    );
  }
}

class _ReceiptPreviewImage extends StatefulWidget {
  final img.Image image;

  const _ReceiptPreviewImage({required this.image});

  @override
  State<_ReceiptPreviewImage> createState() => _ReceiptPreviewImageState();
}

class _ReceiptPreviewImageState extends State<_ReceiptPreviewImage> {
  final TransformationController _controller = TransformationController();
  double? _lastWidth;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant _ReceiptPreviewImage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.image.width != widget.image.width ||
        oldWidget.image.height != widget.image.height) {
      _lastWidth = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final maxWidth = constraints.maxWidth;
        final scale = maxWidth / widget.image.width;
        final fittedHeight = widget.image.height * scale;

        if (_lastWidth != maxWidth) {
          _lastWidth = maxWidth;
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (!mounted || _lastWidth != maxWidth) return;
            _controller.value = Matrix4.diagonal3Values(scale, scale, 1.0);
          });
        }

        return SizedBox(
          width: maxWidth,
          height: fittedHeight,
          child: InteractiveViewer(
            transformationController: _controller,
            constrained: false,
            boundaryMargin: const EdgeInsets.all(400),
            minScale: 0.05,
            maxScale: 8,
            child: Image.memory(img.encodePng(widget.image), fit: BoxFit.fill),
          ),
        );
      },
    );
  }
}

class _DottedLine extends StatelessWidget {
  const _DottedLine();

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: const Size(double.infinity, 1),
      painter: _DottedLinePainter(),
    );
  }
}

class _DottedLinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = SupportAppColors.greyMidColor
      ..strokeWidth = 1;

    const dotLength = 4.0;
    const gapLength = 4.0;
    var startX = 0.0;

    while (startX < size.width) {
      canvas.drawLine(Offset(startX, 0), Offset(startX + dotLength, 0), paint);
      startX += dotLength + gapLength;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
