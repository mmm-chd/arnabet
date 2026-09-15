import 'package:arena/components/custom_button.dart';
import 'package:arena/components/icon_button/custom_icon_button_circle.dart';
import 'package:arena/components/custom_spacing.dart';
import 'package:arena/components/custom_text.dart';
import 'package:arena/components/text_field/custom_text_field.dart';
import 'package:arena/pages/auth/forgot_password/bloc/forgot_password_bloc.dart';
import 'package:arena/pages/auth/forgot_password/components/forgot_password_info_box.dart';
import 'package:flutter/material.dart';
import 'package:arena/config/theme/app_colors.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:arena/config/routes/app_routes.dart';

class ForgotPasswordVerificationPage extends StatefulWidget {
  const ForgotPasswordVerificationPage({super.key});

  @override
  State<ForgotPasswordVerificationPage> createState() =>
      _ForgotPasswordVerificationPageState();
}

class _ForgotPasswordVerificationPageState
    extends State<ForgotPasswordVerificationPage> {
  final TextEditingController codeController = TextEditingController();
  final FocusNode _codeFocus = FocusNode();

  @override
  void initState() {
    super.initState();
    _codeFocus.addListener(() {
      if (!_codeFocus.hasFocus) {
        context.read<ForgotPasswordBloc>().add(
          ForgotPasswordValidate(code: codeController.text),
        );
      }
    });
  }

  @override
  void dispose() {
    codeController.dispose();
    _codeFocus.dispose();
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
            text: "Verifikasi Email",
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
          listenWhen: (previous, current) =>
              previous.step != current.step ||
              previous.isCodeVerified != current.isCodeVerified ||
              previous.errorMessage != current.errorMessage,
          listener: (context, state) {
            if (state.step == ForgotPasswordStep.reset &&
                state.isCodeVerified) {
              context.push(
                AppRoutes.forgotPasswordReset,
                extra: codeController.text,
              );
            }
            if (state.errorMessage != null) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: CustomText(text: state.errorMessage!)),
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
                      context.read<ForgotPasswordBloc>().add(
                        ForgotPasswordCodeChanged(code: value),
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
                                  context.read<ForgotPasswordBloc>().add(
                                    ForgotPasswordResendCode(),
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
                            context.read<ForgotPasswordBloc>().add(
                              ForgotPasswordVerifyCode(
                                code: codeController.text,
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
