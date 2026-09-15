import 'package:arena/components/custom_button.dart';
import 'package:arena/components/icon_button/custom_icon_button_circle.dart';
import 'package:arena/components/custom_spacing.dart';
import 'package:arena/components/custom_text.dart';
import 'package:arena/components/text_field/custom_text_field.dart';
import 'package:arena/pages/auth/forgot_password/components/forgot_password_info_box.dart';
import 'package:arena/pages/profile/change_password/bloc/change_password_bloc.dart';
import 'package:flutter/material.dart';
import 'package:arena/config/theme/app_colors.dart';
import 'package:arena/config/design/app_snack_bar.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:arena/config/routes/app_routes.dart';

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({super.key});

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final TextEditingController currentPasswordController =
      TextEditingController();
  final TextEditingController codeController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final TextEditingController emailController = TextEditingController();

  final FocusNode _currentPasswordFocus = FocusNode();
  final FocusNode _codeFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();
  final FocusNode _confirmPasswordFocus = FocusNode();

  @override
  void initState() {
    super.initState();
    emailController.text = context.read<ChangePasswordBloc>().state.email;
    _currentPasswordFocus.addListener(() {
      if (!_currentPasswordFocus.hasFocus) {
        context.read<ChangePasswordBloc>().add(
          ChangePasswordValidate(
            currentPassword: currentPasswordController.text,
          ),
        );
      }
    });
    _codeFocus.addListener(() {
      if (!_codeFocus.hasFocus) {
        context.read<ChangePasswordBloc>().add(
          ChangePasswordValidate(code: codeController.text),
        );
      }
    });
    _passwordFocus.addListener(() {
      if (!_passwordFocus.hasFocus) {
        context.read<ChangePasswordBloc>().add(
          ChangePasswordValidate(newPassword: passwordController.text),
        );
      }
    });
    _confirmPasswordFocus.addListener(() {
      if (!_confirmPasswordFocus.hasFocus) {
        context.read<ChangePasswordBloc>().add(
          ChangePasswordValidate(
            confirmPassword: confirmPasswordController.text,
          ),
        );
      }
    });
  }

  @override
  void dispose() {
    currentPasswordController.dispose();
    codeController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    emailController.dispose();
    _currentPasswordFocus.dispose();
    _codeFocus.dispose();
    _passwordFocus.dispose();
    _confirmPasswordFocus.dispose();
    super.dispose();
  }

  void _handleBack(BuildContext context, ChangePasswordState state) {
    if (state.step == ChangePasswordStep.request) {
      context.pop();
    } else {
      context.read<ChangePasswordBloc>().add(ChangePasswordStepBack());
    }
  }

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).primaryColor;

    return SafeArea(
      top: false,
      child: Scaffold(
        appBar: AppBar(
          title: const CustomText(
            text: "Ganti Password",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
          centerTitle: false,
          elevation: 0,
          backgroundColor: Colors.transparent,
          foregroundColor: SupportAppColors.greyDarkerColor,
          leadingWidth: 72,
          leading: Padding(
            padding: const EdgeInsets.only(left: 16.0),
            child: BlocBuilder<ChangePasswordBloc, ChangePasswordState>(
              builder: (context, state) => CustomIconbuttonCircle(
                prefixIcon: Icons.arrow_back,
                onPressed: () => _handleBack(context, state),
                backgroundColor: SupportAppColors.white,
                iconColor: SupportAppColors.greyDarkerColor,
                iconSize: 24,
                width: 40,
                height: 40,
              ),
            ),
          ),
        ),
        body: BlocConsumer<ChangePasswordBloc, ChangePasswordState>(
          listenWhen: (previous, current) =>
              previous.isSuccess != current.isSuccess && current.isSuccess ||
              previous.errorMessage != current.errorMessage,
          listener: (context, state) {
            if (state.isSuccess) {
              AppSnackBar.success(
                context: context,
                message: "Password berhasil diganti",
              );
              context.go(AppRoutes.login);
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
                  switch (state.step) {
                    ChangePasswordStep.request => _buildRequestStep(
                      context,
                      state,
                      primary,
                    ),
                    ChangePasswordStep.otp => _buildOtpStep(
                      context,
                      state,
                      primary,
                    ),
                    ChangePasswordStep.reset => _buildResetStep(
                      context,
                      state,
                      primary,
                    ),
                  },
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildRequestStep(
    BuildContext context,
    ChangePasswordState state,
    Color primary,
  ) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const ForgotPasswordInfoBox(
            icon: Icons.lock_outline,
            text:
                "Masukkan password saat ini untuk memverifikasi identitas Anda sebelum mengganti password",
          ),
          const CustomSpacing(height: 24),
          CustomText(
            text: 'Password Saat Ini',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: SupportAppColors.greyDarkerColor,
            ),
          ),
          const CustomSpacing(height: 8),
          CustomTextField(
            controller: currentPasswordController,
            focusNode: _currentPasswordFocus,
            hint: '••••••••',
            label: '••••••••',
            filled: true,
            fillColor: SupportAppColors.white,
            borderColor: state.currentPasswordError != null
                ? AppColors.error
                : Colors.transparent,
            obscureText: true,
            errorText: state.currentPasswordError,
            onChanged: (value) {
              context.read<ChangePasswordBloc>().add(
                ChangePasswordCurrentPasswordChanged(password: value),
              );
            },
          ),
          const Spacer(),
          CustomButton(
            text: state.isLoading ? 'Memuat...' : 'Kirim Kode',
            backgroundColor: primary,
            foregroundColor: Colors.white,
            onPressed: state.isLoading
                ? null
                : () {
                    FocusScope.of(context).unfocus();
                    context.read<ChangePasswordBloc>().add(
                      ChangePasswordSendOtp(),
                    );
                  },
          ),
        ],
      ),
    );
  }

  Widget _buildOtpStep(
    BuildContext context,
    ChangePasswordState state,
    Color primary,
  ) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const ForgotPasswordInfoBox(
            icon: Icons.verified_user_outlined,
            text:
                "Kami telah mengirimkan kodenya ke email anda. Silahkan isi kode di bawah ini",
          ),
          const CustomSpacing(height: 24),
          CustomText(
            text: 'Kode',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: SupportAppColors.greyDarkerColor,
            ),
          ),
          const CustomSpacing(height: 8),
          CustomTextField(
            controller: codeController,
            focusNode: _codeFocus,
            hint: 'Masukkan 6 digit kode',
            label: 'Masukkan 6 digit kode',
            filled: true,
            fillColor: SupportAppColors.white,
            borderColor: state.codeError != null
                ? AppColors.error
                : Colors.transparent,
            textInputType: TextInputType.number,
            errorText: state.codeError,
            onChanged: (value) {
              context.read<ChangePasswordBloc>().add(
                ChangePasswordCodeChanged(code: value),
              );
            },
          ),
          const CustomSpacing(height: 16),
          Align(
            alignment: Alignment.centerRight,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                CustomText(
                  text: "Tidak dapat kodenya? ",
                  style: TextStyle(
                    color: SupportAppColors.greyColor,
                    fontSize: 13,
                  ),
                ),
                InkWell(
                  onTap: state.isLoading
                      ? null
                      : () {
                          context.read<ChangePasswordBloc>().add(
                            ChangePasswordResendCode(),
                          );
                        },
                  child: CustomText(
                    text: "Kirim ulang",
                    style: TextStyle(
                      color: primary,
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Spacer(),
          CustomButton(
            text: state.isLoading ? 'Memuat...' : 'Verifikasi',
            backgroundColor: primary,
            foregroundColor: Colors.white,
            onPressed: state.isLoading
                ? null
                : () {
                    FocusScope.of(context).unfocus();
                    context.read<ChangePasswordBloc>().add(
                      ChangePasswordVerifyCode(code: codeController.text),
                    );
                  },
          ),
        ],
      ),
    );
  }

  Widget _buildResetStep(
    BuildContext context,
    ChangePasswordState state,
    Color primary,
  ) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const ForgotPasswordInfoBox(
            icon: Icons.lock_outline,
            text:
                "Buat password baru yang kuat dan jangan gunakan yang sama dengan sebelumnya!",
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
              state.isPasswordVisible ? Icons.visibility : Icons.visibility_off,
              color: SupportAppColors.greyColor,
            ),
            errorText: state.passwordError,
            onTapSuffixIcon: () {
              context.read<ChangePasswordBloc>().add(
                ChangePasswordTogglePasswordVisibility(),
              );
            },
            onChanged: (value) {
              context.read<ChangePasswordBloc>().add(
                ChangePasswordNewPasswordChanged(password: value),
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
              context.read<ChangePasswordBloc>().add(
                ChangePasswordConfirmPasswordChanged(password: value),
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
                    context.read<ChangePasswordBloc>().add(
                      ChangePasswordReset(
                        newPassword: passwordController.text,
                        confirmPassword: confirmPasswordController.text,
                        code: codeController.text,
                      ),
                    );
                  },
          ),
        ],
      ),
    );
  }
}
