import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import '../../config/routes.dart';
import '../../constants/colors.dart';
import '../../constants/fonts.dart';
import '../../generated/l10n.dart';
import '../../logic/auth/auth_cubit.dart';
import '../../widgets/snack_bar.dart';
import '../../widgets/text_field.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final formKey = GlobalKey<FormState>();

  final phoneNumber = TextEditingController();
  final phoneNumberFocus = FocusNode();
  final username = TextEditingController();
  
  final usernameFocus = FocusNode();

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    final authCubit = BlocProvider.of<AuthCubit>(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Padding(
        padding: EdgeInsets.only(
          left: width / 20,
          right: width / 20,
          //top: height / 18,
          bottom: height / 30,
        ),
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Image.asset(
                "assets/images/logo.jpeg",
                height: height / 3.5,
              ),
              Text(
                S.of(context).registerWelcome,
                style: TextStyle(
                  fontSize: width / 16,
                  fontFamily: AppFonts.poppins,
                  color: AppColors.kBlack,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                "  ${S.of(context).registerText}",
                style: TextStyle(
                  fontSize: width / 32,
                  fontFamily: AppFonts.poppins,
                  color: AppColors.kGrey,
                  fontWeight: FontWeight.w400,
                ),
              ),
              SizedBox(
                height: height / 30,
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
                  } else if (value.lenght < 8) {
                    CustomSnackBar.show(
                      context,
                      S.of(context).usernameShort,
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
              SizedBox(
                height: height / 30,
              ),
              SizedBox(
                width: width,
                height: height / 17,
                child: ElevatedButton(
                  onPressed: () async {
                    if (formKey.currentState!.validate()) {}
                  },
                  style: Theme.of(context).elevatedButtonTheme.style!.copyWith(
                      backgroundColor:
                          const WidgetStatePropertyAll(AppColors.kBlueLight)),
                  child: BlocConsumer<AuthCubit, AuthState>(
                    listener: (context, state) {
                      if (state is AuthSuccess) {
                      } else if (state is AuthFailure) {
                        CustomSnackBar.show(
                          context,
                          state.errorMessage,
                          AppColors.kRed,
                        );
                      }
                    },
                    builder: (context, state) {
                      if (state is AuthLoading) {
                        return LoadingAnimationWidget.discreteCircle(
                          color: AppColors.kWhite,
                          size: height / 40,
                        );
                      } else {
                        return Text(
                          S.of(context).sign_up,
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
                ),
              ),
              SizedBox(
                height: height / 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    S.of(context).already,
                    style: TextStyle(
                      fontSize: width / 30,
                      fontFamily: AppFonts.poppins,
                      color: AppColors.kGrey,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context)
                          .pushReplacementNamed(AppRoutes.login);
                    },
                    child: Text(
                      "  ${S.of(context).sign_in}",
                      style: TextStyle(
                        fontSize: width / 30,
                        fontFamily: AppFonts.poppins,
                        color: AppColors.kBlueLight,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
