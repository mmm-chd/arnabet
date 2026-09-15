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

class ForgotPasswordEmailPage extends StatefulWidget {
  const ForgotPasswordEmailPage({super.key});

  @override
  State<ForgotPasswordEmailPage> createState() =>
      _ForgotPasswordEmailPageState();
}

class _ForgotPasswordEmailPageState extends State<ForgotPasswordEmailPage> {
  final TextEditingController emailController = TextEditingController();
  final FocusNode _emailFocus = FocusNode();

  @override
  void initState() {
    super.initState();
    _emailFocus.addListener(() {
      if (!_emailFocus.hasFocus) {
        context.read<ForgotPasswordBloc>().add(
          ForgotPasswordValidate(email: emailController.text),
        );
      }
    });
  }

  @override
  void dispose() {
    emailController.dispose();
    _emailFocus.dispose();
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
            text: "Lupa Password",
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
              onPressed: () => context.pop(),
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
            if (state.isCodeSent &&
                state.step == ForgotPasswordStep.verification) {
              context.push(AppRoutes.forgotPasswordVerification);
            }
            if (state.errorMessage != null) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: CustomText(text: state.errorMessage!)),
              );
            }
          },
          listenWhen: (previous, current) =>
              (previous.isCodeSent != current.isCodeSent &&
                  current.isCodeSent) ||
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
                    icon: Icons.mail_outline,
                    text: "Masukan email anda untuk menerima kode verifikasi",
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
                    fillColor: SupportAppColors.white,
                    borderColor: state.emailError != null
                        ? AppColors.error
                        : Colors.transparent,
                    textInputType: TextInputType.emailAddress,
                    errorText: state.emailError,
                    onChanged: (value) {
                      context.read<ForgotPasswordBloc>().add(
                        ForgotPasswordEmailChanged(email: value),
                      );
                    },
                  ),

                  const Spacer(),

                  CustomButton(
                    text: state.isLoading ? 'Memuat...' : 'Lanjut',
                    backgroundColor: primary,
                    foregroundColor: Colors.white,
                    onPressed: state.isLoading
                        ? null
                        : () {
                            FocusScope.of(context).unfocus();
                            context.read<ForgotPasswordBloc>().add(
                              ForgotPasswordSendEmail(
                                email: emailController.text,
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
