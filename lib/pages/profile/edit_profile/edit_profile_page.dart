import 'package:arena/components/custom_button.dart';
import 'package:arena/components/custom_spacing.dart';
import 'package:arena/components/custom_text.dart';
import 'package:arena/components/icon_button/custom_icon_button_circle.dart';
import 'package:arena/components/text_field/custom_text_field.dart';
import 'package:arena/config/design/app_snack_bar.dart';
import 'package:arena/config/theme/app_colors.dart';
import 'package:arena/pages/profile/bloc/profile_bloc.dart';
import 'package:arena/pages/profile/bloc/profile_event.dart';
import 'package:arena/pages/profile/edit_profile/bloc/edit_profile_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final TextEditingController _nameController = TextEditingController();
  final FocusNode _nameFocus = FocusNode();

  @override
  void initState() {
    super.initState();
    _nameController.text = context.read<EditProfileBloc>().state.name;
    _nameFocus.addListener(() {
      if (!_nameFocus.hasFocus) {
        context.read<EditProfileBloc>().add(
          EditProfileNameChanged(name: _nameController.text),
        );
      }
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _nameFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).primaryColor;

    return SafeArea(
      top: false,
      child: Scaffold(
        backgroundColor: AppColors.bgColor,
        appBar: AppBar(
          title: const CustomText(
            text: "Edit Profile",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
          centerTitle: false,
          elevation: 0,
          backgroundColor: Colors.transparent,
          foregroundColor: SupportAppColors.greyDarkerColor,
          leadingWidth: 72,
          leading: Padding(
            padding: const EdgeInsets.only(left: 16.0),
            child: CustomIconbuttonCircle(
              prefixIcon: Icons.arrow_back,
              onPressed: () => context.pop(),
              backgroundColor: SupportAppColors.white,
              iconColor: SupportAppColors.greyDarkerColor,
              iconSize: 24,
              width: 40,
              height: 40,
            ),
          ),
        ),
        body: BlocConsumer<EditProfileBloc, EditProfileState>(
          listenWhen: (previous, current) =>
              previous.isSuccess != current.isSuccess && current.isSuccess ||
              previous.errorMessage != current.errorMessage,
          listener: (context, state) {
            if (state.isSuccess) {
              AppSnackBar.success(
                context: context,
                message: "Profile berhasil diperbarui",
              );
              context.read<ProfileBloc>().add(LoadProfile());
              context.pop();
            } else if (state.errorMessage != null) {
              AppSnackBar.error(
                context: context,
                message: state.errorMessage!,
              );
            }
          },
          builder: (context, state) {
            return Padding(
              padding: const EdgeInsets.only(
                left: 16,
                right: 16,
                bottom: 16,
                top: 8,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                    text: 'Nama',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: SupportAppColors.greyDarkerColor,
                    ),
                  ),
                  const CustomSpacing(height: 8),
                  CustomTextField(
                    controller: _nameController,
                    focusNode: _nameFocus,
                    hint: 'Masukkan nama Anda',
                    label: 'Masukkan nama Anda',
                    filled: true,
                    fillColor: SupportAppColors.white,
                    borderColor: state.nameError != null
                        ? AppColors.error
                        : Colors.transparent,
                    errorText: state.nameError,
                    textInputAction: TextInputAction.done,
                    onChanged: (value) {
                      context.read<EditProfileBloc>().add(
                        EditProfileNameChanged(name: value),
                      );
                    },
                    onFieldSubmitted: (_) {
                      FocusScope.of(context).unfocus();
                      context.read<EditProfileBloc>().add(
                        EditProfileSubmitted(),
                      );
                    },
                  ),
                  const Spacer(),
                  CustomButton(
                    text: state.isLoading ? 'Menyimpan...' : 'Simpan',
                    backgroundColor: primary,
                    foregroundColor: Colors.white,
                    onPressed: state.isLoading
                        ? null
                        : () {
                            FocusScope.of(context).unfocus();
                            context.read<EditProfileBloc>().add(
                              EditProfileSubmitted(),
                            );
                          },
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
