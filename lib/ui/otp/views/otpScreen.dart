import 'package:flutter/material.dart';
import 'widgets/otpBody.dart';

enum NavigationFromOtpTo { login, home, resetPassword, profile }

class OtpScreen extends StatelessWidget {
  final String phoneNumber;
  final String username;
  //final String email;
  final NavigationFromOtpTo navigateTo;
  const OtpScreen({
    super.key,
    required this.username,
    //required this.email,
    required this.phoneNumber,
    required this.navigateTo,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: OtpBody(
       // email:email,
        username: username,
        phoneNumber: phoneNumber,
        navigateTo: navigateTo,
      ),
    );
  }
}
