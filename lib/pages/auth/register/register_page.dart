import 'package:arena/components/custom_button.dart';
import 'package:arena/components/custom_spacing.dart';
import 'package:arena/components/custom_text.dart';
import 'package:arena/components/text_field/custom_text_field.dart';
import 'package:arena/config/design/app_snack_bar.dart';
import 'package:arena/config/design/custom_icons.dart';
import 'package:arena/config/routes/app_routes.dart';
import 'package:arena/pages/auth/register/bloc/register_bloc.dart';
import 'package:arena/pages/auth/register/bloc/register_event.dart';
import 'package:arena/pages/auth/register/bloc/register_state.dart';
import 'package:flutter/material.dart';
import 'package:arena/config/theme/app_colors.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  final FocusNode _nameFocus = FocusNode();
  final FocusNode _emailFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();
  final FocusNode _confirmPasswordFocus = FocusNode();

  void _clearForm() {
    nameController.clear();
    passwordController.clear();
    confirmPasswordController.clear();
    context.read<RegisterBloc>().add(const RegisterClearForm());
    context.read<RegisterBloc>().add(const RegisterClearError());
  }

  @override
  void initState() {
    super.initState();

    _nameFocus.addListener(() {
      if (!_nameFocus.hasFocus) {
        context.read<RegisterBloc>().add(
          RegisterValidate(name: nameController.text),
        );
      }
    });

    _passwordFocus.addListener(() {
      if (!_passwordFocus.hasFocus) {
        context.read<RegisterBloc>().add(
          RegisterValidate(password: passwordController.text),
        );
      }
    });

    _confirmPasswordFocus.addListener(() {
      if (!_confirmPasswordFocus.hasFocus) {
        context.read<RegisterBloc>().add(
          RegisterValidate(confirmPassword: confirmPasswordController.text),
        );
      }
    });
  }

  @override
  void dispose() {
    nameController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    _nameFocus.dispose();
    _emailFocus.dispose();
    _passwordFocus.dispose();
    _confirmPasswordFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).primaryColor;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: BlocConsumer<RegisterBloc, RegisterState>(
        listener: (context, state) {
          if (state.isSuccess) {
            AppSnackBar.success(
              context: context,
              message: state.message ?? "Registrasi berhasil",
            );
            context.go(AppRoutes.login, extra: state.email);
          } else if (state.isFailure) {
            AppSnackBar.error(context: context, message: state.message!);
          }
        },
        builder: (context, state) {
          final isLoading = state.isLoading;
          final isPasswordVisible = state.isPasswordVisible;
          final isConfirmPasswordVisible = state.isConfirmPasswordVisible;
          final nameError = state.nameError;
          final passwordError = state.passwordError;
          final confirmPasswordError = state.confirmPasswordError;

          return SafeArea(
            child: GestureDetector(
              onTap: () {
                FocusScope.of(context).unfocus();
              },
              child: Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const CustomSpacing(height: 42),

                      Center(
                        child: SvgPicture.asset(
                          isDark ? CustomIcons.logoDark : CustomIcons.logoLight,
                          width: 84,
                        ),
                      ),

                      const CustomSpacing(height: 24),

                      Center(
                        child: CustomText(
                          text: 'ARENA BAN KUDUS',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: SupportAppColors.greyDarkerColor,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),

                      const CustomSpacing(height: 8),

                      Center(
                        child: CustomText(
                          text: 'Daftar Akun Baru',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: SupportAppColors.greyColor),
                        ),
                      ),

                      const CustomSpacing(height: 24),

                      CustomText(
                        text: 'Nama',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: SupportAppColors.greyDarkerColor,
                        ),
                      ),
                      const CustomSpacing(height: 8),

                      CustomTextField(
                        controller: nameController,
                        focusNode: _nameFocus,
                        hint: 'John Doe',
                        label: 'John Doe',
                        filled: true,
                        fillColor: SupportAppColors.white,
                        borderColor: nameError != null
                            ? AppColors.error
                            : Colors.transparent,
                        textInputType: TextInputType.name,
                        errorText: nameError,
                        onChanged: (value) {
                          context.read<RegisterBloc>().add(
                            RegisterNameChanged(name: value),
                          );
                        },
                      ),

                      const CustomSpacing(height: 24),

                      CustomText(
                        text: 'Password',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: SupportAppColors.greyDarkerColor,
                        ),
                      ),
                      const CustomSpacing(height: 8),

                      CustomTextField(
                        controller: passwordController,
                        focusNode: _passwordFocus,
                        textInputAction: TextInputAction.done,
                        hint: '••••••••',
                        label: '••••••••',
                        filled: true,
                        fillColor: SupportAppColors.white,
                        borderColor: passwordError != null
                            ? AppColors.error
                            : Colors.transparent,
                        obscureText: !isPasswordVisible,
                        useSuffixIcon: true,
                        suffixIcon: Icon(
                          isPasswordVisible
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: SupportAppColors.greyColor,
                        ),
                        errorText: passwordError,
                        onTapSuffixIcon: () {
                          context.read<RegisterBloc>().add(
                            const TogglePasswordVisibility(),
                          );
                        },
                        onChanged: (value) {
                          context.read<RegisterBloc>().add(
                            RegisterPasswordChanged(password: value),
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
                        textInputAction: TextInputAction.done,
                        hint: '••••••••',
                        label: '••••••••',
                        filled: true,
                        fillColor: SupportAppColors.white,
                        borderColor: confirmPasswordError != null
                            ? AppColors.error
                            : Colors.transparent,
                        obscureText: !isConfirmPasswordVisible,
                        useSuffixIcon: true,
                        suffixIcon: Icon(
                          isConfirmPasswordVisible
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: SupportAppColors.greyColor,
                        ),
                        errorText: confirmPasswordError,
                        onTapSuffixIcon: () {
                          context.read<RegisterBloc>().add(
                            const ToggleConfirmPasswordVisibility(),
                          );
                        },
                        onChanged: (value) {
                          context.read<RegisterBloc>().add(
                            RegisterConfirmPasswordChanged(
                              confirmPassword: value,
                            ),
                          );
                        },
                      ),

                      const CustomSpacing(height: 42),

                      CustomButton(
                        text: isLoading ? 'Memuat...' : 'Daftar',
                        backgroundColor: primary,
                        foregroundColor: Colors.white,
                        onPressed: isLoading
                            ? null
                            : () {
                                FocusScope.of(context).unfocus();

                                final name = nameController.text;
                                final password = passwordController.text;
                                final confirmPassword =
                                    confirmPasswordController.text;

                                context.read<RegisterBloc>().add(
                                  RegisterValidate(
                                    name: name,
                                    password: password,
                                    confirmPassword: confirmPassword,
                                  ),
                                );

                                final isNameValid = name.trim().length >= 2;
                                final isPasswordValid =
                                    password.length >= 6 &&
                                    !password.contains(' ');
                                final isConfirmValid =
                                    confirmPassword == password &&
                                    confirmPassword.isNotEmpty;

                                if (!isNameValid ||
                                    !isPasswordValid ||
                                    !isConfirmValid) {
                                  return;
                                }

                                _clearForm();
                                context.push(
                                  AppRoutes.codeRegistration,
                                  extra: RegisterFormData(
                                    name: name,
                                    password: password,
                                  ),
                                );
                              },
                      ),

                      const CustomSpacing(height: 16),

                      Center(
                        child: InkWell(
                          onTap: () => context.pop(),
                          borderRadius: BorderRadius.circular(8),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: 4.0,
                              horizontal: 8,
                            ),
                            child: RichText(
                              text: TextSpan(
                                text: 'Sudah punya akun? ',
                                style: TextStyle(
                                  color: SupportAppColors.greyColor,
                                ),
                                children: [
                                  TextSpan(
                                    text: 'Masuk',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      color: primary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),

                      const CustomSpacing(height: 42),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
