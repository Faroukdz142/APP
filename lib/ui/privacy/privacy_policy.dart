import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ionicons/ionicons.dart';
import '../../logic/cart/cart_cubit.dart';

import '../../config/routes.dart';
import '../../constants/colors.dart';
import '../../constants/fonts.dart';
import '../../generated/l10n.dart';
import '../../logic/language/language_cubit.dart';
import '../../models/cart.dart';

class PrivacyPolicy extends StatelessWidget {
  const PrivacyPolicy({super.key});

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: PreferredSize(
        preferredSize: MediaQuery.of(context).size / 16,
        child: AppBar(
          toolbarHeight: height / 20,
          backgroundColor: AppColors.kBlueLight,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(20),
            ),
          ),
          leading: BlocBuilder<LanguageCubit, String>(
            builder: (context, state) {
              return Padding(
                padding: EdgeInsets.only(
                    right: state == "ar" ? width / 30 : 0,
                    left: state == "en" ? width / 30 : 0),
                child: GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Icon(
                    Icons.arrow_back_ios,
                    color: AppColors.kWhite,
                    size: width / 18,
                  ),
                ),
              );
            },
          ),
          title: Center(
            child: Text(
              S.of(context).privacyP,
              style: TextStyle(
                fontSize: width / 18,
                color: AppColors.kWhite,
                fontFamily: AppFonts.poppins,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          actions: [
            SizedBox(
              width: width / 10,
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                S.of(context).effective_date,
                style: TextStyle(
                  fontSize: 16,
                  fontStyle: FontStyle.italic,
                  fontFamily: AppFonts.poppins,
                ),
              ),
              const SizedBox(height: 24),
              sectionTitle(context, S.of(context).introduction),
              sectionContent(context, S.of(context).introduction_content),
              sectionTitle(context, S.of(context).info_we_collect),
              sectionContent(context, S.of(context).info_we_collect_content),
              sectionTitle(context, S.of(context).how_we_use),
              sectionContent(context, S.of(context).how_we_use_content),
              sectionTitle(context, S.of(context).sharing_info),
              sectionContent(context, S.of(context).sharing_info_content),
              sectionTitle(context, S.of(context).your_rights),
              sectionContent(context, S.of(context).your_rights_content),
              sectionTitle(context, S.of(context).contact_us),
              sectionContent(context, S.of(context).contact_us_content),
            ],
          ),
        ),
      ),
    );
  }

  Widget sectionTitle(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 24.0, bottom: 8.0),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 20,
          fontFamily: AppFonts.poppins,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  // Helper widget for section content
  Widget sectionContent(BuildContext context, String content) {
    return Text(
      content,
      style: TextStyle(
        fontSize: 16,
        fontFamily: AppFonts.poppins,
      ),
    );
  }
}
