import 'package:arena/components/custom_button.dart';
import 'package:arena/components/icon_button/custom_icon_button_circle.dart';
import 'package:arena/components/custom_spacing.dart';
import 'package:arena/components/custom_text.dart';
import 'package:arena/components/otp_input/otp_input.dart';
import 'package:arena/config/design/app_snack_bar.dart';
import 'package:arena/config/routes/app_routes.dart';
import 'package:arena/config/theme/app_colors.dart';
import 'package:arena/pages/auth/register/bloc/register_bloc.dart';
import 'package:arena/pages/auth/register/bloc/register_event.dart';
import 'package:arena/pages/auth/register/bloc/register_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class CodeRegistrationPage extends StatefulWidget {
  final String name;
  final String password;

  const CodeRegistrationPage({
    super.key,
    required this.name,
    required this.password,
  });

  @override
  State<CodeRegistrationPage> createState() => _CodeRegistrationPageState();
}

class _CodeRegistrationPageState extends State<CodeRegistrationPage> {
  final GlobalKey<OtpInputState> _otpKey = GlobalKey<OtpInputState>();
  String _code = '';

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: AppColors.bgColor,
        appBar: AppBar(
          backgroundColor: AppColors.bgColor,
          surfaceTintColor: AppColors.bgColor,
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
              onPressed: () => context.go(AppRoutes.login),
            ),
          ),
          titleSpacing: 16,
          title: const CustomText(
            text: "Kode Undangan",
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w600,
              fontSize: 20,
            ),
          ),
        ),
        body: BlocConsumer<RegisterBloc, RegisterState>(
          listener: (context, state) {
            if (state.isSuccess) {
              AppSnackBar.success(context: context, message: state.message!);
              context.go(AppRoutes.login, extra: state.email);
            } else if (state.isFailure) {
              AppSnackBar.error(context: context, message: state.message!);
              _otpKey.currentState?.clear();
              setState(() {
                _code = '';
              });
            }
          },
          builder: (context, state) {
            final inviteTokenError = state.inviteTokenError;
            final isLoading = state.isLoading;

            return SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const CustomSpacing(height: 12),
                    CustomText(
                      text:
                          "Masukkan kode undangan yang kamu terima untuk "
                          "menyelesaikan pendaftaran akun.",
                      style: TextStyle(
                        color: SupportAppColors.greyColor,
                        height: 1.5,
                      ),
                    ),
                    const CustomSpacing(height: 24),

                    CustomText(
                      text: 'Kode Undangan',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: SupportAppColors.greyDarkerColor,
                      ),
                    ),
                    const CustomSpacing(height: 12),

                    OtpInput(
                      key: _otpKey,
                      length: 6,
                      hasError: inviteTokenError != null,
                      onChanged: (value) {
                        setState(() {
                          _code = value;
                        });
                        context.read<RegisterBloc>().add(
                          RegisterInviteTokenChanged(inviteToken: value),
                        );
                      },
                      onCompleted: (value) {
                        context.read<RegisterBloc>().add(
                          RegisterValidate(inviteToken: value),
                        );
                      },
                    ),

                    if (inviteTokenError != null) ...[
                      const CustomSpacing(height: 8),
                      CustomText(
                        text: inviteTokenError,
                        style: TextStyle(color: AppColors.error, fontSize: 12),
                      ),
                    ],

                    const Spacer(),

                    CustomButton(
                      text: isLoading ? 'Memuat...' : 'Konfirmasi',
                      backgroundColor: AppColors.primary,
                      foregroundColor: SupportAppColors.white,
                      onPressed: isLoading || _code.length < 6
                          ? null
                          : () {
                              context.read<RegisterBloc>().add(
                                SubmitRegister(
                                  name: widget.name,
                                  password: widget.password,
                                ),
                              );
                              FocusScope.of(context).unfocus();
                            },
                    ),

                    const CustomSpacing(height: 24),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
