import 'package:arena/components/custom_button.dart';
import 'package:arena/components/icon_button/custom_icon_button_circle.dart';
import 'package:arena/components/custom_spacing.dart';
import 'package:arena/components/custom_text.dart';
import 'package:arena/components/text_field/custom_text_field.dart';
import 'package:arena/config/design/app_snack_bar.dart';
import 'package:arena/pages/auth/forgot_password/bloc/forgot_password_bloc.dart';
import 'package:arena/pages/auth/forgot_password/components/forgot_password_info_box.dart';
import 'package:flutter/material.dart';
import 'package:arena/config/theme/app_colors.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:arena/config/routes/app_routes.dart';

class ForgotPasswordResetPage extends StatefulWidget {
  final String code;
  const ForgotPasswordResetPage({super.key, required this.code});

  @override
  State<ForgotPasswordResetPage> createState() =>
      _ForgotPasswordResetPageState();
}

class _ForgotPasswordResetPageState extends State<ForgotPasswordResetPage> {
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  final FocusNode _passwordFocus = FocusNode();
  final FocusNode _confirmPasswordFocus = FocusNode();

  @override
  void initState() {
    super.initState();
    _passwordFocus.addListener(() {
      if (!_passwordFocus.hasFocus) {
        context.read<ForgotPasswordBloc>().add(
          ForgotPasswordValidate(newPassword: passwordController.text),
        );
      }
    });
    _confirmPasswordFocus.addListener(() {
      if (!_confirmPasswordFocus.hasFocus) {
        context.read<ForgotPasswordBloc>().add(
          ForgotPasswordValidate(
            confirmPassword: confirmPasswordController.text,
          ),
        );
      }
    });
  }

  @override
  void dispose() {
    passwordController.dispose();
    confirmPasswordController.dispose();
    _passwordFocus.dispose();
    _confirmPasswordFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).primaryColor;

    return SafeArea(
      top: false,
      child: Scaffold(
        appBar: AppBar(
          title: const CustomText(
            text: "Reset Password",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
          centerTitle: false,
          elevation: 0,
          backgroundColor: Colors.transparent,
          foregroundColor: SupportAppColors.greyDarkerColor,
          leading: Padding(
            padding: const EdgeInsets.all(8.0),
            child: CustomIconbuttonCircle(
              prefixIcon: Icons.arrow_back,
              onPressed: () {
                context.read<ForgotPasswordBloc>().add(
                  ForgotPasswordStepBack(),
                );
                context.pop();
              },
              backgroundColor: SupportAppColors.white,
              iconColor: SupportAppColors.greyDarkerColor,
              iconSize: 24,
              width: 40,
              height: 40,
            ),
          ),
        ),
        body: BlocConsumer<ForgotPasswordBloc, ForgotPasswordState>(
          listener: (context, state) {
            if (state.isSuccess) {
              AppSnackBar.success(
                context: context,
                message: "Password berhasil direset",
              );
              context.go(AppRoutes.login);
            }
            if (state.errorMessage != null) {
              AppSnackBar.error(
                context: context,
                message: state.errorMessage ?? "Terjadi kesalahan",
              );
            }
          },
          listenWhen: (previous, current) =>
              previous.isSuccess != current.isSuccess && current.isSuccess ||
              previous.errorMessage != current.errorMessage,
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
                  const ForgotPasswordInfoBox(
                    icon: Icons.lock_outline,
                    text:
                        "Jangan khawatir, semua orang terkadang lupa password juga. Ayo buat baru!",
                  ),

                  const CustomSpacing(height: 24),

                  CustomText(
                    text: 'Password Baru',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: SupportAppColors.greyDarkerColor,
                    ),
                  ),
                  const CustomSpacing(height: 8),
                  CustomTextField(
                    controller: passwordController,
                    focusNode: _passwordFocus,
                    hint: '••••••••',
                    label: '••••••••',
                    filled: true,
                    fillColor: SupportAppColors.white,
                    borderColor: state.passwordError != null
                        ? AppColors.error
                        : Colors.transparent,
                    obscureText: !state.isPasswordVisible,
                    useSuffixIcon: true,
                    suffixIcon: Icon(
                      state.isPasswordVisible
                          ? Icons.visibility
                          : Icons.visibility_off,
                      color: SupportAppColors.greyColor,
                    ),
                    errorText: state.passwordError,
                    onTapSuffixIcon: () {
                      context.read<ForgotPasswordBloc>().add(
                        ForgotPasswordTogglePasswordVisibility(),
                      );
                    },
                    onChanged: (value) {
                      context.read<ForgotPasswordBloc>().add(
                        ForgotPasswordNewPasswordChanged(password: value),
                      );
                    },
                  ),

                  const CustomSpacing(height: 24),

                  CustomText(
                    text: 'Konfirmasi Password',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: SupportAppColors.greyDarkerColor,
                    ),
                  ),
                  const CustomSpacing(height: 8),
                  CustomTextField(
                    controller: confirmPasswordController,
                    focusNode: _confirmPasswordFocus,
                    hint: '••••••••',
                    label: '••••••••',
                    filled: true,
                    fillColor: SupportAppColors.white,
                    borderColor: state.confirmPasswordError != null
                        ? AppColors.error
                        : Colors.transparent,
                    obscureText: true,
                    errorText: state.confirmPasswordError,
                    onChanged: (value) {
                      context.read<ForgotPasswordBloc>().add(
                        ForgotPasswordConfirmPasswordChanged(password: value),
                      );
                    },
                  ),

                  const Spacer(),

                  CustomButton(
                    text: state.isLoading ? 'Memuat...' : 'Simpan',
                    backgroundColor: primary,
                    foregroundColor: Colors.white,
                    onPressed: state.isLoading
                        ? null
                        : () {
                            FocusScope.of(context).unfocus();
                            context.read<ForgotPasswordBloc>().add(
                              ForgotPasswordReset(
                                newPassword: passwordController.text,
                                confirmPassword: confirmPasswordController.text,
                                code: widget.code,
                              ),
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
