import 'package:arena/components/build/build_label.dart';
import 'package:arena/components/custom_button.dart';
import 'package:arena/components/icon_button/custom_icon_button_circle.dart';
import 'package:arena/components/custom_spacing.dart';
import 'package:arena/components/custom_text.dart';
import 'package:arena/components/text_field/custom_text_field.dart';
import 'package:arena/config/routes/app_routes.dart';
import 'package:arena/config/theme/app_colors.dart';
import 'package:arena/pages/add_user/bloc/add_user_bloc.dart';
import 'package:arena/pages/add_user/bloc/add_user_event.dart';
import 'package:arena/pages/add_user/bloc/add_user_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:arena/components/custom_filter_chip.dart';
import 'components/info_box.dart';

class AddUserPage extends StatefulWidget {
  const AddUserPage({super.key});

  @override
  State<AddUserPage> createState() => _AddUserPageState();
}

class _AddUserPageState extends State<AddUserPage> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final noteController = TextEditingController();
  final _emailFocus = FocusNode();

  String selectedDivisi = "";
  int selectedRole = 0;
  final roles = ["Gudang", "Owner", "Kasir", "Customer Service"];

  final Map<String, String> rolesValues = {
    "Gudang": "WAREHOUSE",
    "Owner": "OWNER",
    "Kasir": "CASHIER",
    "Customer Service": "CUSTOMER_SERVICE",
  };
  @override
  void initState() {
    super.initState();
    _emailFocus.addListener(() {
      if (!_emailFocus.hasFocus) {
        context.read<AddUserBloc>().add(
          AddUserValidate(email: emailController.text),
        );
      }
    });
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    noteController.dispose();
    _emailFocus.dispose();
    super.dispose();
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
              onPressed: () {
                context.pop();
              },
            ),
          ),
          titleSpacing: 16,
          title: const CustomText(
            text: "Tambah User",
            style: TextStyle(
              color: SupportAppColors.greyDarkerColor,
              fontWeight: FontWeight.w600,
              fontSize: 20,
            ),
          ),
          actionsPadding: const EdgeInsets.only(right: 16),
          actions: [
            CustomIconbuttonCircle(
              prefixIcon: Icons.more_vert,
              backgroundColor: SupportAppColors.white,
              iconColor: SupportAppColors.greyDarkerColor,
              iconSize: 24,
              width: 60,
              height: 60,
              onPressed: () {},
            ),
          ],
        ),
        body: BlocConsumer<AddUserBloc, AddUserState>(
          listener: (context, state) {
            if (state.isSuccess) {
              context.pushReplacement(
                AppRoutes.inviteSend,
                extra: {
                  'email': emailController.text,
                  'role': rolesValues[roles[selectedRole]] ?? '',
                },
              );
            }
          },
          builder: (context, state) {
            final emailError = state.emailError;
            final message = state.message;
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  const InfoBox(),
                  const CustomSpacing(height: 16),

                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: SupportAppColors.white,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        BuildLabel(text: "Email", isRequired: true),
                        const CustomSpacing(height: 4),
                        CustomTextField(
                          controller: emailController,
                          hint: "budibakwan@gmail.com",
                          label: "Masukkan email",
                          focusNode: _emailFocus,
                          borderColor: emailError != null
                              ? AppColors.error
                              : SupportAppColors.greyColor,
                          textInputType: TextInputType.emailAddress,
                          errorText:
                              (emailError != null && emailError.isNotEmpty)
                              ? emailError
                              : null,
                          filled: true,
                        ),
                        // const CustomSpacing(height: 16),
                        // const CustomText(text: "No.Hp"),
                        // const CustomSpacing(height: 4),
                        // CustomTextField(
                        //   controller: phoneController,
                        //   hint: "62 xxx-xxxx-xxxx",
                        //   label: "Masukkan no hp",
                        //   prefixText: "+ ",
                        //   filled: true,
                        //   isNumber: true,
                        // ),
                      ],
                    ),
                  ),
                  const CustomSpacing(height: 12),

                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.only(top: 16, bottom: 16),
                    decoration: BoxDecoration(
                      color: SupportAppColors.white,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              BuildLabel(text: "Divisi", isRequired: true),
                              const CustomSpacing(height: 12),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 38,
                          child: ListView.builder(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            scrollDirection: Axis.horizontal,
                            shrinkWrap: true,
                            itemCount: roles.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.only(right: 8),
                                child: CustomFilterChip(
                                  label: roles[index],
                                  isSelected: selectedRole == index,
                                  onTap: () {
                                    setState(() {
                                      selectedRole = index;
                                    });
                                  },
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),

                  const CustomSpacing(height: 24),

                  /// BUTTON
                  CustomButton(
                    text: state.isLoading ? "Mengirim..." : "Undang",
                    backgroundColor: AppColors.primary,
                    foregroundColor: SupportAppColors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    onPressed: state.isLoading
                        ? null
                        : () {
                            context.read<AddUserBloc>().add(
                              SubmitInviteUser(
                                email: emailController.text,
                                role: rolesValues[roles[selectedRole]]!,
                              ),
                            );
                          },
                  ),
                  if (state.isFailure) ...[
                    const CustomSpacing(height: 24),
                    CustomText(
                      text:
                          message?.replaceAll("Exception:", "") ??
                          "Unknown error",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: AppColors.error),
                    ),
                  ],
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
