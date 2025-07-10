import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import '../../../constants/colors.dart';
import '../../../constants/fonts.dart';
import '../../../generated/l10n.dart';
import '../../../logic/payment.dart';
import '../../payment/payment_webview.dart';
import '../../../widgets/sign_in_dialog.dart';
import 'package:widget_and_text_animator/widget_and_text_animator.dart';

class SubsTile extends StatefulWidget {
  final int index;
  final double pay;
  final double get;
  const SubsTile(
      {super.key, required this.index, required this.pay, required this.get});

  @override
  State<SubsTile> createState() => _SubsTileState();
}

class _SubsTileState extends State<SubsTile> {
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return GestureAnimator(
      onTap: () async {
        if (FirebaseAuth.instance.currentUser != null) {
          setState(() {
            isLoading = true;
          });
          await PaymentService.createCharge(
            paymentFor: PaymentFor.sub,
            amount: widget.pay,
            currency: "KWD",
            get: widget.get,
            description: "Payment for trust laundry",
            context: context,
          );
           setState(() {
            isLoading = false;
          });
        } else {
          showDialog(
            context: context,
            builder: (context) {
              return const SignInDialog();
            },
          );
        }
      },
      child: Container(
        // Wider than the square border
        padding: EdgeInsets.all(width / 26),
        margin: EdgeInsets.only(bottom: width / 50),
        decoration: BoxDecoration(
          color: AppColors.kPrimaryColor,
          borderRadius: BorderRadius.circular(height > 1000 ? 30 : 8),
        ),
        child: isLoading
            ? Center(
                child: LoadingAnimationWidget.discreteCircle(
                  color: AppColors.kWhite,
                  size: height / 40,
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: "${widget.pay.toString().split(".")[0]} ",
                          style: TextStyle(
                            color: AppColors.kWhite,
                            fontSize: width / 20,
                            fontFamily: AppFonts.poppins,
                            fontWeight: FontWeight.bold, // Bold for `pay`
                          ),
                        ),
                        TextSpan(
                          text: "${S.of(context).kwd}    ",
                          style: TextStyle(
                            color: AppColors.kWhite,
                            fontSize: width / 24,
                            fontFamily: AppFonts.poppins,
                            fontWeight:
                                FontWeight.normal, // Normal weight for currency
                          ),
                        ),
                        TextSpan(
                          text: "${S.of(context).taghsel} ",
                          style: TextStyle(
                            color: AppColors.kWhite,
                            fontSize: width / 24,
                            fontFamily: AppFonts.poppins,
                            fontWeight:
                                FontWeight.normal, // Normal weight for text
                          ),
                        ),
                        TextSpan(
                          text: "    ${widget.get.toString().split(".")[0]} ",
                          style: TextStyle(
                            color: AppColors.kWhite,
                            fontSize: width / 20,
                            fontFamily: AppFonts.poppins,
                            fontWeight: FontWeight.bold, // Bold for `get`
                          ),
                        ),
                        TextSpan(
                          text: S.of(context).kwd,
                          style: TextStyle(
                            color: AppColors.kWhite,
                            fontSize: width / 24,
                            fontFamily: AppFonts.poppins,
                            fontWeight:
                                FontWeight.normal, // Normal weight for currency
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
