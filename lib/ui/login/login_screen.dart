import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:trustlaundry/logic/language/language_cubit.dart';
import 'package:trustlaundry/ui/otp/views/otpScreen.dart';

import '../../config/routes.dart';
import '../../constants/colors.dart';
import '../../constants/fonts.dart';
import '../../generated/l10n.dart';
import '../../logic/phone_auth/phone_auth_cubit.dart';
import '../../widgets/snack_bar.dart';
import '../../widgets/text_field.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final formKey = GlobalKey<FormState>();

  final phoneNumber = TextEditingController();
  final phoneNumberFocus = FocusNode();

  final username = TextEditingController();
 // final email = TextEditingController();

  final usernameFocus = FocusNode();
 // final emailFocus = FocusNode();
  // String currentLanguage = "en";
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Padding(
        padding: EdgeInsets.only(
          left: width / 20,
          right: width / 20,
          bottom: height / 30,
        ),
        child: Form(
          key: formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: height / 15,
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Icon(
                    Icons.arrow_back_ios,
                    size: width / 16,
                  ),
                ),
                Center(
                  child: Image.asset(
                    "assets/images/logo.jpeg",
                    height: height / 4,
                  ),
                ),
                Text(
                  S.of(context).welcome,
                  style: TextStyle(
                    fontSize: width / 18,
                    fontFamily: AppFonts.poppins,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "  ${S.of(context).loginText}",
                  style: TextStyle(
                    fontSize: width / 34,
                    fontFamily: AppFonts.poppins,
                    color: AppColors.kGrey,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                SizedBox(
                  height: height / 80,
                ),
                CustomTextField(
                  focus: phoneNumberFocus,
                  validator: (value) {
                    if (value.isEmpty) {
                      CustomSnackBar.show(
                        context,
                        S.of(context).phoneNumberEmpty,
                        AppColors.kRed,
                      );
                      return '';
                      } else if (value.length!= 8 && value.length!=16) {
                        CustomSnackBar.show(
                          context,
                          S.of(context).phoneNumberWrong,
                          AppColors.kRed,
                        );
                        return '';
                    } else {
                      return null;
                    }
                  },
                  controller: phoneNumber,
                  hintText: S.of(context).phoneNumber,
                ),
                SizedBox(
                  height: height / 120,
                ),
                CustomTextField(
                  focus: usernameFocus,
                  validator: (value) {
                    if (value.isEmpty) {
                      CustomSnackBar.show(
                        context,
                        S.of(context).usernameEmpty,
                        AppColors.kRed,
                      );
                      return '';
                    } else {
                      return null;
                    }
                  },
                  controller: username,
                  hintText: S.of(context).username,
                ),
                // SizedBox(
                //   height: height / 120,
                // ),
                // CustomTextField(
                //   focus: emailFocus,
                //   validator: (value) {
                //     if (value.isEmpty) {
                //       CustomSnackBar.show(
                //         context,
                //         S.of(context).emailEmpty,
                //         AppColors.kRed,
                //       );
                //       return '';
                //     } else {
                //       return null;
                //     }
                //   },
                //   controller: email,
                //   hintText: S.of(context).email,
                // ),
                SizedBox(
                  height: height / 30,
                ),
                SizedBox(
                  width: width,
                  height: height / 17,
                  child: BlocBuilder<LanguageCubit, String>(
                    builder: (context, state) {
                      return ElevatedButton(
                        onPressed: () async {
                          if (formKey.currentState!.validate()) {
                            await BlocProvider.of<PhoneAuthCubit>(context)
                                .sendOTP(phoneNumber.text.trim(), state);
                          }
                        },
                        style: Theme.of(context)
                            .elevatedButtonTheme
                            .style!
                            .copyWith(
                                backgroundColor: const WidgetStatePropertyAll(
                                    AppColors.kBlueLight)),
                        child: BlocConsumer<PhoneAuthCubit, PhoneAuthState>(
                          listenWhen: (previous, current) {
                            return previous != current;
                          },
                          listener: (context, state) {
                            if (state is PhoneAuthPhoneNumberSubmited) {
                              Navigator.pop(context);
                              Navigator.of(context)
                                  .pushNamed(AppRoutes.otp, arguments: {
                                "username": username.text.trim(),
                               // "email": email.text.trim(),
                                "phoneNumber": phoneNumber.text.trim(),
                                "navigateTo": NavigationFromOtpTo.home,
                              });
                            } else if (state is PhoneAuthError) {
                              CustomSnackBar.show(
                                context,
                                state.errorMsg,
                                AppColors.kRed,
                              );
                            }
                          },
                          builder: (context, state) {
                            if (state is PhoneAuthLoading) {
                              return LoadingAnimationWidget.discreteCircle(
                                color: AppColors.kWhite,
                                size: height / 40,
                              );
                            } else {
                              return Text(
                                S.of(context).sign_in,
                                style: TextStyle(
                                  fontSize: width / 26,
                                  color: AppColors.kWhite,
                                  fontFamily: AppFonts.poppins,
                                  fontWeight: FontWeight.bold,
                                ),
                              );
                            }
                          },
                        ),
                      );
                    },
                  ),
                ),
                SizedBox(height: height/3,),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
