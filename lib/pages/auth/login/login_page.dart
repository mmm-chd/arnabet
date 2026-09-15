import 'package:arena/components/text_field/custom_text_field.dart';
import 'package:arena/config/design/app_snack_bar.dart';
import 'package:arena/config/design/custom_icons.dart';
import 'package:arena/config/routes/app_routes.dart';
import 'package:arena/models/enums/enums.dart';
import 'package:arena/models/enums/role.dart';
import 'package:arena/pages/auth/login/bloc/login_bloc.dart';
import 'package:arena/services/auth/user_session.dart';
import 'package:arena/pages/profile/bloc/profile_bloc.dart';
import 'package:arena/pages/profile/bloc/profile_event.dart';
import 'package:arena/utils/token_expired_handler.dart';
import 'package:arena/components/custom_button.dart';
import 'package:arena/components/custom_spacing.dart';
import 'package:arena/components/custom_text.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:arena/config/theme/app_colors.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final FocusNode _emailFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();

  @override
  void initState() {
    super.initState();
    context.read<LoginBloc>().add(const LoginReset());
    _emailFocus.addListener(() {
      if (!_emailFocus.hasFocus) {
        context.read<LoginBloc>().add(
          LoginValidate(email: emailController.text),
        );
      }
    });

    _passwordFocus.addListener(() {
      if (!_passwordFocus.hasFocus) {
        context.read<LoginBloc>().add(
          LoginValidate(password: passwordController.text),
        );
      }
    });
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    _emailFocus.dispose();
    _passwordFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).primaryColor;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        body: BlocConsumer<LoginBloc, LoginState>(
          listener: (context, state) {
            if (state.isSuccess) {
              TokenExpiredInterceptor.resetUnauthorizedGuard();
              context.read<ProfileBloc>().add(LoadProfile());
              UserSession.setRole(state.role!);

              switch (state.role!) {
                case Role.owner:
                  context.go(AppRoutes.navOwnerPage);
                  break;
                case Role.warehouseStaff:
                  context.go(AppRoutes.navWarehousePage);
                  break;
                case Role.cashier:
                  context.go(AppRoutes.navCashierPage);
                  break;
                case Role.customerServices:
                  context.go(AppRoutes.navCsPage);
                  break;
                case Role.developer:
                  context.go(AppRoutes.navOwnerPage);
                  break;
                case Role.unknown:
                  context.go(AppRoutes.login);
                  AppSnackBar.error(context: context, message: state.message!);
                  break;
              }
            } else if (state.isFailure) {
              // AppSnackBar.error(
              //   context: context,
              //   message: state.message ?? state.error,
              // );
            }
          },
          builder: (context, state) {
            final isLoading = state.status == PageStatus.loading;
            final isPasswordVisible = state.isPasswordVisible;
            final emailError = state.emailError;
            final passwordError = state.passwordError;

            return SafeArea(
              child: Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
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
                          text: 'Masukkan Akun Anda',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: SupportAppColors.greyColor),
                        ),
                      ),

                      const CustomSpacing(height: 24),

                      CustomText(
                        text: 'Email',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: SupportAppColors.greyDarkerColor,
                        ),
                      ),
                      const CustomSpacing(height: 8),

                      CustomTextField(
                        controller: emailController,
                        focusNode: _emailFocus,
                        hint: 'JohnDoe@gmail.com',
                        label: 'JohnDoe@gmail.com',
                        filled: true,
                        borderColor: emailError != null
                            ? AppColors.error
                            : Colors.transparent,
                        textInputType: TextInputType.emailAddress,
                        errorText: (emailError != null && emailError.isNotEmpty)
                            ? emailError
                            : null,
                        onChanged: (value) {
                          context.read<LoginBloc>().add(
                            LoginEmailChanged(email: value),
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
                          context.read<LoginBloc>().add(
                            TogglePasswordVisibility(),
                          );
                        },
                        onChanged: (value) {
                          context.read<LoginBloc>().add(
                            LoginPasswordChanged(password: value),
                          );
                        },
                      ),

                      const CustomSpacing(height: 10),

                      Align(
                        alignment: Alignment.centerRight,
                        child: InkWell(
                          onTap: () {
                            emailController.clear();
                            passwordController.clear();
                            FocusScope.of(context).unfocus();
                            context.read<LoginBloc>().add(
                              const LoginClearError(),
                            );
                            context.push(AppRoutes.forgotPasswordEmail);
                          },
                          borderRadius: BorderRadius.circular(8),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: 4.0,
                              horizontal: 8,
                            ),
                            child: CustomText(
                              text: 'Lupa password?',
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                color: primary,
                              ),
                            ),
                          ),
                        ),
                      ),

                      const CustomSpacing(height: 42),

                      CustomButton(
                        text: isLoading ? 'Memuat...' : 'Masuk',
                        backgroundColor: primary,
                        foregroundColor: Colors.white,
                        onPressed: isLoading
                            ? null
                            : () {
                                FocusScope.of(context).unfocus();
                                context.read<LoginBloc>().add(LoginSubmitted());
                              },
                      ),

                      const CustomSpacing(height: 16),

                      Center(
                        child: RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: 'Belum punya akun? ',
                                style: TextStyle(
                                  color: SupportAppColors.greyColor,
                                ),
                              ),
                              TextSpan(
                                text: 'Daftar',
                                style: TextStyle(
                                  color: primary,
                                  fontWeight: FontWeight.w600,
                                ),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    emailController.clear();
                                    passwordController.clear();
                                    FocusScope.of(context).unfocus();
                                    context.read<LoginBloc>().add(
                                      const LoginClearError(),
                                    );
                                    context.push(AppRoutes.register);
                                  },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
