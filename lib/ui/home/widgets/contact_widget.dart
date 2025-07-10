import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:widget_and_text_animator/widget_and_text_animator.dart';

import '../../../constants/colors.dart';

class ContactWidget extends StatelessWidget {
  final String image;
  final String url;
  const ContactWidget({super.key,required this.image,required this.url});

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return GestureAnimator(
      onTap: () async {
        await launchUrl(Uri.parse(url));
      },
      child: Container(
        width: width / 6,
        height: width / 6,
        padding: EdgeInsets.zero,
        decoration: BoxDecoration(
          color: AppColors.kWhite,
          boxShadow: const [
            BoxShadow(
              color: AppColors.kGreyForDivider,
              blurRadius: 10,
              spreadRadius: 0,
            ),
          ],
          borderRadius: BorderRadius.circular(15),
        ),
        child: Center(
          child: SvgPicture.asset(
            image,
            height: width / 9,
          ),
        ),
      ),
    );
  }
}
