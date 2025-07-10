import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../constants/colors.dart';

import '../../constants/fonts.dart';
import '../../generated/l10n.dart';
import '../../logic/language/language_cubit.dart';
class TermsAndConditions extends StatelessWidget {
  const TermsAndConditions({super.key});

  @override
  Widget build(BuildContext context) {
        final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return  Scaffold(
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
              S.of(context).termsAndConditions,
              style: TextStyle(
                fontSize: width / 18,
                color: AppColors.kWhite,
                fontFamily: AppFonts.poppins,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          actions: [
            SizedBox(width: width/10,),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              sectionTitle(context, S.of(context).introduction),
              sectionContent(context, S.of(context).introduction_for_terms),
              sectionTitle(context, S.of(context).user_accounts),
              sectionContent(context, S.of(context).user_accounts_content),
              sectionTitle(context, S.of(context).creating_orders),
              sectionContent(context, S.of(context).creating_orders_content),
              sectionTitle(context, S.of(context).payment_and_fees),
              sectionContent(context, S.of(context).payment_and_fees_content),
              sectionTitle(context, S.of(context).cancellation_and_refunds),
              sectionContent(context, S.of(context).cancellation_and_refunds_content),
              sectionTitle(context, S.of(context).user_responsibilities),
              sectionContent(context, S.of(context).user_responsibilities_content),
              sectionTitle(context, S.of(context).limitations_of_liability),
              sectionContent(context, S.of(context).limitations_of_liability_content),
              sectionTitle(context, S.of(context).modifications_to_service),
              sectionContent(context, S.of(context).modifications_to_service_content),
              sectionTitle(context, S.of(context).contact_info),
              sectionContent(context, S.of(context).contact_info_content),
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
        style:  TextStyle(
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