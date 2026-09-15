import 'dart:async';

import 'package:arena/components/icon_button/custom_icon_button_circle.dart';
import 'package:arena/components/custom_button.dart';
import 'package:arena/components/custom_spacing.dart';
import 'package:arena/components/custom_text.dart';
import 'package:arena/config/theme/app_colors.dart';
import 'package:arena/pages/add_user/bloc/add_user_bloc.dart';
import 'package:arena/pages/add_user/bloc/add_user_event.dart';
import 'package:arena/pages/add_user/bloc/add_user_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class InviteSendPage extends StatefulWidget {
  final String email;
  final String role;
  const InviteSendPage({super.key, required this.email, required this.role});

  @override
  State<InviteSendPage> createState() => _InviteSendPageState();
}

class _InviteSendPageState extends State<InviteSendPage> {
  int _remainingSeconds = 30;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      if (_remainingSeconds == 0) {
        timer.cancel();
      } else {
        setState(() {
          _remainingSeconds--;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) _timer?.cancel();
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: AppColors.bgColor,
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
              onPressed: () {
                _timer?.cancel();
                context.pop();
              },
            ),
          ),
          titleSpacing: 16,
          title: const CustomText(
            text: "Undangan",
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w600,
              fontSize: 20,
            ),
          ),
        ),
        body: BlocBuilder<AddUserBloc, AddUserState>(
          builder: (context, state) {
            return Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      color: SupportAppColors.lightRed,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Icon(
                      Icons.mail_outline,
                      color: SupportAppColors.normalRed,
                      size: 50,
                    ),
                  ),

                  const CustomSpacing(height: 24),

                  const CustomText(
                    text: "Undangan Terkirim!",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),

                  const CustomSpacing(height: 12),

                  CustomText(
                    text:
                        "Email undangan sudah dikirim ke ${widget.email}. "
                        "User perlu membuka email dan mengatur password "
                        "untuk mengaktifkan akun.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: SupportAppColors.greyColor,
                      height: 1.5,
                    ),
                  ),

                  const CustomSpacing(height: 20),

                  CustomText(
                    text: _remainingSeconds == 0
                        ? "Kirim ulang"
                        : "Kirim ulang dalam ${_remainingSeconds}s",
                    style: TextStyle(color: SupportAppColors.greyColor),
                  ),

                  const CustomSpacing(height: 62),

                  CustomButton(
                    text: state.isLoading
                        ? "Mengirim Undangan..."
                        : "Kirim Ulang",
                    backgroundColor: AppColors.primary,
                    foregroundColor: SupportAppColors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    onPressed: state.isLoading
                        ? null
                        : _remainingSeconds == 0
                        ? () {
                            context.read<AddUserBloc>().add(
                              ResendInviteUser(
                                email: widget.email,
                                role: widget.role,
                              ),
                            );
                            setState(() {
                              _remainingSeconds = 30;
                            });
                          }
                        : null,
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
