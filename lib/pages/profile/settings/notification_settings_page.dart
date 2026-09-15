import 'package:arena/components/custom_button.dart';
import 'package:arena/components/icon_button/custom_icon_button_circle.dart';
import 'package:arena/components/custom_spacing.dart';
import 'package:arena/components/custom_switch.dart';
import 'package:arena/components/custom_text.dart';
import 'package:arena/config/design/app_snack_bar.dart';
import 'package:arena/config/theme/app_colors.dart';
import 'package:arena/models/notification/notification_settings_model.dart';
import 'package:arena/pages/notification/bloc/notification_settings_bloc.dart';
import 'package:arena/pages/notification/bloc/notification_settings_event.dart';
import 'package:arena/pages/notification/bloc/notification_settings_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class NotificationSettingsPage extends StatelessWidget {
  const NotificationSettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<NotificationSettingsBloc, NotificationSettingsState>(
      listenWhen: (previous, current) =>
          current.errorMessage != null &&
          current.status != NotificationSettingsStatus.failure,
      listener: (context, state) {
        AppSnackBar.error(context: context, message: state.errorMessage!);
        context.read<NotificationSettingsBloc>().add(
          ClearNotificationSettingsError(),
        );
      },
      child: Scaffold(
        backgroundColor: const Color(0xffF5F5F5),
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          automaticallyImplyLeading: false,
          leadingWidth: 72,
          leading: Padding(
            padding: const EdgeInsets.only(left: 16),
            child: CustomIconbuttonCircle(
              prefixIcon: Icons.arrow_back,
              backgroundColor: Colors.white,
              iconColor: Colors.black,
              iconSize: 24,
              width: 40,
              height: 40,
              onPressed: () => context.pop(),
            ),
          ),
          titleSpacing: 16,
          title: const CustomText(
            text: "Notifikasi",
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w600,
              fontSize: 20,
            ),
          ),
        ),
        body: BlocBuilder<NotificationSettingsBloc, NotificationSettingsState>(
          builder: (context, state) {
            if (state.isInitial || state.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state.isFailure) {
              return _ErrorView(
                message: state.errorMessage ?? 'Gagal memuat pengaturan',
                onRetry: () => context.read<NotificationSettingsBloc>().add(
                  LoadNotificationSettings(),
                ),
              );
            }

            final bloc = context.read<NotificationSettingsBloc>();

            return ListView(
              padding: const EdgeInsets.all(16),
              children: [
                /// CHANNEL
                card("Channel Notifikasi", [
                  notifItem(
                    "Notifikasi In-App",
                    "Notifikasi push yang muncul di perangkat",
                    state.masterInApp,
                    (v) => bloc.add(ToggleMasterInApp(v)),
                  ),
                  notifItem(
                    "Email",
                    "Kirim ke email terdaftar",
                    state.masterEmail,
                    (v) => bloc.add(ToggleMasterEmail(v)),
                  ),
                ]),

                /// KATEGORI SETTING
                ..._buildSettingCards(context, bloc, state.settings),

                if (state.isSaving)
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Center(
                      child: CustomText(
                        text: "Menyimpan...",
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }

  List<Widget> _buildSettingCards(
    BuildContext context,
    NotificationSettingsBloc bloc,
    List<NotificationSettingItem> settings,
  ) {
    final cards = <Widget>[];
    for (final entry in _groups.entries) {
      final items = settings
          .where((s) => entry.value.contains(s.type))
          .toList(growable: false);
      if (items.isEmpty) continue;

      cards.add(
        card(entry.key, [
          for (final item in items)
            _settingItem(bloc, item, _labelFor(item.type!)),
        ]),
      );
    }

    final knownTypes = _groups.values.expand((e) => e).toSet();
    final unknown = settings
        .where((s) => !knownTypes.contains(s.type))
        .toList(growable: false);
    if (unknown.isNotEmpty) {
      cards.add(
        card('Notifikasi Lainnya', [
          for (final item in unknown)
            _settingItem(bloc, item, _labelFor(item.type!)),
        ]),
      );
    }

    return cards;
  }

  Widget _settingItem(
    NotificationSettingsBloc bloc,
    NotificationSettingItem item,
    _NotifMeta meta,
  ) {
    return notifSettingItem(
      title: meta.title,
      subtitle: meta.subtitle,
      inApp: item.enabledInApp ?? false,
      email: item.enabledEmail ?? false,
      showEmail: NotificationSettingsData.emailSupportedTypes.contains(
        item.type,
      ),
      onInAppChanged: (v) =>
          bloc.add(ToggleSettingInApp(type: item.type ?? '', value: v)),
      onEmailChanged: (v) =>
          bloc.add(ToggleSettingEmail(type: item.type ?? '', value: v)),
    );
  }

  Widget notifItem(
    String title,
    String subtitle,
    bool value,
    Function(bool) onChanged,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  text: title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const CustomSpacing(height: 2),
                CustomText(
                  text: subtitle,
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                ),
              ],
            ),
          ),
          CustomSwitch(
            value: value,
            onChanged: onChanged,
            activeThumbColor: Colors.white,
            activeTrackColor: SupportAppColors.normalRed,
            inactiveThumbColor: Colors.white,
            inactiveTrackColor: Colors.grey.shade300,
          ),
        ],
      ),
    );
  }

  Widget notifSettingItem({
    required String title,
    required String subtitle,
    required bool inApp,
    required bool email,
    required bool showEmail,
    required ValueChanged<bool> onInAppChanged,
    required ValueChanged<bool> onEmailChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  text: title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const CustomSpacing(height: 2),
                CustomText(
                  text: subtitle,
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                ),
              ],
            ),
          ),
          CustomSpacing(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              _toggleWithLabel("In-App", inApp, onInAppChanged),
              if (showEmail) ...[
                const CustomSpacing(height: 6),
                _toggleWithLabel("Email", email, onEmailChanged),
              ],
            ],
          ),
        ],
      ),
    );
  }

  Widget _toggleWithLabel(
    String label,
    bool value,
    ValueChanged<bool> onChanged,
  ) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        CustomText(
          text: label,
          style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
        ),
        const SizedBox(width: 4),
        Transform.scale(
          scale: 0.75,
          child: CustomSwitch(
            value: value,
            onChanged: onChanged,
            activeThumbColor: Colors.white,
            activeTrackColor: SupportAppColors.normalRed,
            inactiveThumbColor: Colors.white,
            inactiveTrackColor: Colors.grey.shade300,
          ),
        ),
      ],
    );
  }

  Widget card(String title, List<Widget> children) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomText(
            text: title,
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
          const CustomSpacing(height: 8),
          ...children,
        ],
      ),
    );
  }

  _NotifMeta _labelFor(String type) {
    return _typeLabels[type] ??
        _NotifMeta(
          type.replaceAll('_', ' ').toLowerCase(),
          'Notifikasi terkait',
        );
  }
}

class _NotifMeta {
  final String title;
  final String subtitle;

  const _NotifMeta(this.title, this.subtitle);
}

const _typeLabels = <String, _NotifMeta>{
  'STOCK_ALERT': _NotifMeta(
    'Barang Menipis & Terlama',
    'Pemberitahuan stok menipis atau barang terlama',
  ),
  'OLD_DOT_ALERT': _NotifMeta(
    'Dot Status Terlama',
    'Peringatan DOT barang sudah lama/kritis',
  ),
  'STOCK_CHANGED': _NotifMeta(
    'Perubahan Stok',
    'Pemberitahuan perubahan stok di gudang',
  ),
  'PRODUCT_CHANGED': _NotifMeta(
    'Perubahan Produk',
    'Pemberitahuan perubahan data produk',
  ),
  'ORDER_NEED_PICKUP': _NotifMeta(
    'Order Siap Pickup',
    'Pemberitahuan order yang menunggu pickup',
  ),
  'ORDER_CANCELLED': _NotifMeta(
    'Order Dibatalkan',
    'Pemberitahuan order dibatalkan',
  ),
  'PAYMENT_SUCCESS': _NotifMeta(
    'Pembayaran Berhasil',
    'Konfirmasi pembayaran berhasil',
  ),
  'PAYMENT_FAILED_EXPIRED': _NotifMeta(
    'Pembayaran Gagal / Kadaluarsa',
    'Pemberitahuan pembayaran gagal atau kadaluarsa',
  ),
  'USER_INVITED': _NotifMeta(
    'User Diundang',
    'Pemberitahuan undangan user baru',
  ),
  'USER_SUCCESSFULLY_INVITED': _NotifMeta(
    'Undangan User Berhasil',
    'Undangan user berhasil diterima',
  ),
  'USER_DEACTIVATED': _NotifMeta(
    'User Dinonaktifkan',
    'Pemberitahuan user dinonaktifkan',
  ),
  'USER_ROLE_CHANGED': _NotifMeta(
    'Role User Diubah',
    'Pemberitahuan perubahan role user',
  ),
};

const _groups = <String, List<String>>{
  'Notifikasi Stok': ['STOCK_ALERT', 'OLD_DOT_ALERT', 'STOCK_CHANGED'],
  'Notifikasi Produk': ['PRODUCT_CHANGED'],
  'Notifikasi Order & Pembayaran': [
    'ORDER_NEED_PICKUP',
    'ORDER_CANCELLED',
    'PAYMENT_SUCCESS',
    'PAYMENT_FAILED_EXPIRED',
  ],
  'Notifikasi User': [
    'USER_INVITED',
    'USER_SUCCESSFULLY_INVITED',
    'USER_DEACTIVATED',
    'USER_ROLE_CHANGED',
  ],
};

class _ErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ErrorView({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.error_outline, size: 48, color: AppColors.error),
            const CustomSpacing(height: 16),
            CustomText(
              text: message,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
            ),
            const CustomSpacing(height: 16),
            CustomButton(
              text: "Coba Lagi",
              height: 44,
              width: 48,
              backgroundColor: SupportAppColors.normalRed,
              foregroundColor: Colors.white,
              fontSize: 14,
              onPressed: onRetry,
            ),
          ],
        ),
      ),
    );
  }
}
