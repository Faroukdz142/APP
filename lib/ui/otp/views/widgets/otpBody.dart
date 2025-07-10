import 'package:flutter_svg/svg.dart';
import 'package:lottie/lottie.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:trustlaundry/logic/language/language_cubit.dart';
import '../../../../config/routes.dart';
import '../../../../logic/phone_auth/phone_auth_cubit.dart';
import '../../../../widgets/snack_bar.dart';
import '../../../../constants/colors.dart';
import '../../../../constants/fonts.dart';
import '../../../../generated/l10n.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import '../../../../logic/balance/balance_cubit.dart';
import '../../../../logic/otp_code_cubit/otp_code_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../logic/user/user_cubit.dart';
import '../otpScreen.dart';
import 'countDownWidget.dart';

class OtpBody extends StatefulWidget {
  final String phoneNumber;
  final String username;
 // final String email;
  final NavigationFromOtpTo navigateTo;
  OtpBody({
    super.key,
  //  required this.email,
    required this.username,
    required this.phoneNumber,
    required this.navigateTo,
  });

  @override
  State<OtpBody> createState() => _OtpBodyState();
}

class _OtpBodyState extends State<OtpBody> with TickerProviderStateMixin {
  AnimationController? _controller;
  int otpTimer = 60;
  final otpCodeController = TextEditingController();
  bool showResendButton = false;

  String getTitle() {
    switch (widget.navigateTo) {
      case NavigationFromOtpTo.home:
        return S.of(context).sign_in;
      case NavigationFromOtpTo.login:
        return S.of(context).sign_up;
      // case NavigationFromOtpTo.profile:
      //   return "Change Phone Number";
      // case NavigationFromOtpTo.resetPassword:
      //   return "Manage Password";
      default:
        return "Verification";
    }
  }

  @override
  void dispose() {
    _controller!.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: otpTimer),
    );

    _controller!.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          showResendButton = true;
        });
      }
    });

    _controller!.forward();

    super.initState();
  }

  void restartCountdown() {
    setState(() {
      showResendButton = false;
      _controller!.reset();
      _controller!.forward();
    });
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: width / 25,
        vertical: height / 20,
      ),
      child: SingleChildScrollView(
        child: Column(
          children: [
            ListTile(
              leading: GestureDetector(
                onTap: () => Navigator.of(context).pop(),
                child: Icon(
                  Icons.arrow_back_ios,
                  size: width / 15,
                ),
              ),
              title: Text(
                getTitle(),
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: width / 24,
                  fontFamily: AppFonts.poppins,
                  fontWeight: FontWeight.bold,
                ),
              ),
              contentPadding: EdgeInsets.zero,
              trailing: SizedBox(
                width: width / 12,
              ),
            ),
            SizedBox(
              height: height / 60,
            ),
            Lottie.network(
              "https://lottie.host/79e69b47-e67f-4000-82b9-ab0a71df308f/iqP4JnXTMW.json",
              height: height / 4.5,
            ),
            SizedBox(
              height: height / 60,
            ),
            Text(
              S.of(context).verifCode,
              style: TextStyle(
                fontSize: width / 24,
                fontFamily: AppFonts.poppins,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              height: height / 60,
            ),
            Text(
              "${S.of(context).verifText} ${widget.phoneNumber}",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: width / 30,
                color: AppColors.kGreyForTexts,
                fontFamily: AppFonts.poppins,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              height: height / 25,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: width / 90),
              child: Directionality(
                textDirection: TextDirection.ltr,
                child: PinCodeTextField(
                  controller: otpCodeController,
                  appContext: context,
                  length: 6,
                  keyboardType: TextInputType.number,
                  autoFocus: true,
                  autoUnfocus: true,
                  cursorHeight: width / 20,
                  textStyle: TextStyle(
                    color: AppColors.kBlack,
                    fontSize: width / 20,
                  ),
                  cursorColor: AppColors.kBlack,
                  obscureText: false,
                  animationType: AnimationType.fade,
                  onChanged: (value) {
                    BlocProvider.of<OtpCodeCubit>(context)
                        .onCodeChange(codeLength: value.length);
                  },
                  onCompleted: (submitedCode) {
                    otpCodeController.text = submitedCode;
                  },
                  pinTheme: PinTheme(
                    selectedFillColor: AppColors.kWhite,
                    shape: PinCodeFieldShape.box,
                    borderRadius: BorderRadius.circular(5),
                    fieldHeight: width / 7,
                    fieldWidth: width / 7,
                    borderWidth: width / 200,
                    selectedBorderWidth: width / 200,
                    activeBorderWidth: width / 200,
                    activeFillColor: AppColors.kWhite,
                    inactiveFillColor: AppColors.kGreyForPin,
                    activeColor: AppColors.kBlueLight,
                    selectedColor: AppColors.kBlueLight,
                    inactiveColor: AppColors.kGreyForPin,
                  ),
                  animationDuration: const Duration(
                    milliseconds: 300,
                  ),
                  enablePinAutofill: true,
                  enableActiveFill: true,
                ),
              ),
            ),
            const SizedBox(
              height: 6,
            ),
            SizedBox(
              width: width,
              height: height / 17,
              child: BlocBuilder<OtpCodeCubit, bool>(
                builder: (context, otpCodeReady) {
                  return BlocBuilder<LanguageCubit, String>(
                    builder: (context, state) {
                      return ElevatedButton(
                        onPressed: () async {
                          if (widget.navigateTo == NavigationFromOtpTo.home) {
                            await BlocProvider.of<PhoneAuthCubit>(context)
                                .verifyOTP(
                              otpCodeController.text.trim(),
                              widget.phoneNumber,
                              state,
                            );
                          }
                        },
                        style: Theme.of(context)
                            .elevatedButtonTheme
                            .style!
                            .copyWith(
                              backgroundColor: WidgetStateProperty.all(
                                otpCodeReady
                                    ? AppColors.kBlueLight
                                    : AppColors.kGreyForPin,
                              ),
                            ),
                        child: BlocConsumer<PhoneAuthCubit, PhoneAuthState>(
                          listenWhen: (previous, current) {
                            return previous != current;
                          },
                          listener: (context, state) {
                            if (state is PhoneAuthPhoneOTPVerified) {
                              BlocProvider.of<UserCubit>(context)
                                  .addUserData(
                               // email: widget.email,
                                username: widget.username,
                                phoneNumber: widget.phoneNumber,
                              )
                                  .then((v) {
                                BlocProvider.of<BalanceCubit>(context)
                                    .getBalance()
                                    .then((e) {
                                  Navigator.of(context).pushReplacementNamed(
                                    AppRoutes.home,
                                  );
                                });
                              });
                            }
                            if (state is PhoneAuthError) {
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
                                S.of(context).verify,
                                style: TextStyle(
                                  fontSize: width / 26,
                                  color: otpCodeReady
                                      ? AppColors.kWhite
                                      : AppColors.kGreyForTexts,
                                  fontFamily: AppFonts.poppins,
                                  fontWeight: FontWeight.bold,
                                ),
                              );
                            }
                          },
                        ),
                      );
                    },
                  );
                },
              ),
            ),
            SizedBox(
              height: height / 60,
            ),
            showResendButton
                ? BlocBuilder<LanguageCubit, String>(
                    builder: (context, state) {
                      return GestureDetector(
                        onTap: () async {
                          restartCountdown();
                          await BlocProvider.of<PhoneAuthCubit>(context)
                              .resendOTP(widget.phoneNumber, state,context);
                        },
                        child: Text(
                          S.of(context).resendCode,
                          style: TextStyle(
                            fontSize: width / 30,
                            fontFamily: AppFonts.poppins,
                            color: AppColors.kBlueLight,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      );
                    },
                  )
                : Countdown(
                    animation: StepTween(
                      begin: otpTimer,
                      end: 0,
                    ).animate(_controller!),
                  ),
          ],
        ),
      ),
    );
  }
}
