import 'package:flutter/material.dart';
import '../config/routes.dart';

import '../constants/colors.dart';
import '../constants/fonts.dart';
import '../generated/l10n.dart';

class SignInDialog extends StatelessWidget {
  const SignInDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return AlertDialog(
      content: SizedBox(
        height: height / 4.8,
        width: width * .6,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
          ),
          child: Column(
            children: [
              Text(
                S.of(context).sign_in,
                style: TextStyle(
                  fontSize: width / 20,
                  fontFamily: AppFonts.poppins,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: height / 60,
              ),
              Text(
                S.of(context).needLogin,
                style: TextStyle(
                  fontSize: width / 26,
                  color: AppColors.kGreyForTexts,
                  fontFamily: AppFonts.poppins,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Spacer(),
              SizedBox(
                width: width,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pushNamed(
                      AppRoutes.login,
                    );
                  },
                  child: Text(
                    S.of(context).sign_in,
                    style: TextStyle(
                      fontSize: width / 28,
                      color: AppColors.kWhite,
                      fontFamily: AppFonts.poppins,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
