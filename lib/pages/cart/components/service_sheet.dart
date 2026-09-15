import 'package:arena/components/bottom_sheet/custom_bottom_sheet.dart';
import 'package:arena/components/bottom_sheet/custom_bottom_sheet_v2.dart';
import 'package:arena/components/build/build_label.dart';
import 'package:arena/components/custom_button.dart';
import 'package:arena/components/custom_spacing.dart';
import 'package:arena/components/custom_text.dart';
import 'package:arena/components/text_field/custom_text_field.dart';
import 'package:arena/config/design/app_snack_bar.dart';
import 'package:arena/config/theme/app_colors.dart';
import 'package:arena/helper/currency_input_formatter.dart';
import 'package:arena/helper/currency_local_formatter.dart';
import 'package:arena/helper/string_extension_helper.dart';
import 'package:arena/models/jasa/jasa_list_model.dart';
import 'package:arena/pages/cart/bloc/cart_bloc.dart';
import 'package:arena/pages/cart/bloc/cart_event.dart';
import 'package:arena/pages/cart/bloc/cart_state.dart';
import 'package:arena/pages/jasa/bloc/jasa_bloc.dart';
import 'package:arena/pages/jasa/bloc/jasa_event.dart';
import 'package:arena/pages/jasa/bloc/jasa_state.dart';
import 'package:arena/repositories/jasa/jasa_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class ServiceSheet {
  static void show(BuildContext context) {
    CustomBottomsheet.show(
      context,
      title: 'Layanan Tambahan',
      initialChildSize: 0.7,
      onDismissed: () {},
      children: [
        BlocProvider<JasaBloc>(
          create: (_) =>
              JasaBloc(repository: JasaRepository())..add(const LoadServices()),
          child: const _ServiceSheetView(),
        ),
      ],
    );
  }
}

class _ServiceSheetView extends StatelessWidget {
  const _ServiceSheetView();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<JasaBloc, JasaState>(
      listenWhen: (previous, current) =>
          previous.status != current.status && current.isFailure,
      listener: (context, state) {
        AppSnackBar.error(
          context: context,
          message: state.errorMessage ?? 'Terjadi kesalahan',
        );
      },
      builder: (context, state) {
        final bloc = context.read<JasaBloc>();
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            CustomButton(
              text: 'Tambah Service',
              backgroundColor: AppColors.primary,
              foregroundColor: SupportAppColors.white,
              onPressed: () => _showServiceForm(context, bloc),
            ),
            const CustomSpacing(height: 16),
            _buildList(context, state, bloc),
          ],
        );
      },
    );
  }

  Widget _buildList(BuildContext context, JasaState state, JasaBloc bloc) {
    if (state.isLoading || state.isInitial) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 32),
        child: Center(child: CircularProgressIndicator()),
      );
    }

    if (state.isFailure && state.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 32),
        child: Center(
          child: CustomText(
            text: state.errorMessage ?? 'Gagal memuat layanan',
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    if (state.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 32),
        child: Center(child: CustomText(text: 'Belum ada layanan')),
      );
    }

    return Column(
      children: state.services
          .map((service) => _ServiceItem(service: service, bloc: bloc))
          .toList(),
    );
  }
}

class _ServiceItem extends StatelessWidget {
  final Datum service;
  final JasaBloc bloc;

  const _ServiceItem({required this.service, required this.bloc});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CartBloc, CartState>(
      buildWhen: (previous, current) =>
          previous.cartListData?.items != current.cartListData?.items,
      builder: (context, cartState) {
        final selected = cartState.isServiceInCart(service.id);
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: InkWell(
            onTap: selected
                ? null
                : () => context.read<CartBloc>().add(
                      AddServiceToCart(
                        serviceId: service.id ?? 0,
                        quantity: 1,
                      ),
                    ),
            borderRadius: BorderRadius.circular(12),
            child: Ink(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.bgColor,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: selected ? AppColors.primary : Colors.transparent,
                  width: 1.5,
                ),
              ),
              child: Row(
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: 22,
                    height: 22,
                    margin: const EdgeInsets.only(right: 12),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: selected ? AppColors.primary : Colors.transparent,
                      border: Border.all(
                        color: selected
                            ? AppColors.primary
                            : SupportAppColors.greyColor,
                        width: 2,
                      ),
                    ),
                    child: selected
                        ? const Icon(
                            Icons.check,
                            size: 14,
                            color: SupportAppColors.white,
                          )
                        : null,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomText(
                          text: service.displayName,
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 15,
                          ),
                        ),
                        const CustomSpacing(height: 2),
                        CustomText(
                          text: service.displayPrice,
                          style: const TextStyle(
                            color: SupportAppColors.greyColor,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.edit,
                      color: SupportAppColors.normalOrange,
                    ),
                    onPressed: () =>
                        _showServiceForm(context, bloc, service: service),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete, color: AppColors.error),
                    onPressed: () => _showDeleteConfirm(context, bloc, service),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

void _showServiceForm(BuildContext context, JasaBloc bloc, {Datum? service}) {
  final isEdit = service != null;
  final nameController = TextEditingController(text: service?.name ?? '');
  final priceController = TextEditingController(
    text: (service?.price ?? 0) > 0
        ? service!.price!.toLocaleCurrency(showSymbol: false, symbol: null)
        : '',
  );

  CustomBottomSheetV2.show(
    context,
    title: isEdit ? 'Edit Service' : 'Tambah Service',
    initialChildSize: 0.6,
    onDismissed: () {},
    onSave: () {
      final name = nameController.text.trim();
      final price = priceController.text.fromCurrencyToInt();
      if (name.isEmpty) return false;
      if (isEdit) {
        bloc.add(UpdateService(id: service.id ?? 0, name: name, price: price));
      } else {
        bloc.add(AddService(name: name, price: price));
      }
      return true;
    },
    children: [
      const BuildLabel(text: "Nama Service", isRequired: true),
      CustomTextField(
        controller: nameController,
        label: 'Nama Service',
        hint: 'Masukkan nama service',
      ),
      const CustomSpacing(height: 16),
      const BuildLabel(text: "Harga", isRequired: true),
      CustomTextField(
        controller: priceController,
        label: 'Harga',
        hint: '000.000',
        prefixText: 'Rp ',
        isNumber: true,
        inputFormatters: [CurrencyInputFormatter()],
      ),
    ],
  );
}

void _showDeleteConfirm(BuildContext context, JasaBloc bloc, Datum service) {
  CustomBottomsheet.show(
    context,
    title: 'Hapus Service',
    initialChildSize: 0.4,
    onDismissed: () {},
    secondaryButtonText: 'Batal',
    primaryButtonText: 'Hapus',
    pBackgroundColor: AppColors.primary,
    sBackgroundColor: SupportAppColors.white,
    onReset: () {
      context.pop();
    },
    onPressed: () {
      bloc.add(DeleteService(id: service.id ?? 0));
      context.pop();
      return null;
    },
    children: [
      CustomText(
        text: 'Apakah anda yakin ingin menghapus ${service.displayName}?',
        style: const TextStyle(fontSize: 16),
        textAlign: TextAlign.center,
      ),
    ],
  );
}
