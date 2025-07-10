import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ionicons/ionicons.dart';
import '../../constants/strings.dart';
import '../../logic/theme/theme_cubit.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../constants/colors.dart';
import '../../constants/fonts.dart';
import '../../generated/l10n.dart';
import '../../logic/language/language_cubit.dart';
import '../../logic/reports/reports_cubit.dart';

class AllReports extends StatefulWidget {
  const AllReports({super.key});

  @override
  State<AllReports> createState() => _AllReportsState();
}

class _AllReportsState extends State<AllReports> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    BlocProvider.of<ReportsCubit>(context).getReports();
  }

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
                S.of(context).reports,
                style: TextStyle(
                  fontSize: width / 23,
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
        body: BlocBuilder<ReportsCubit, ReportsState>(
          builder: (context, state) {
            if (state is ReportsSuccess) {
              return state.reports.isEmpty
                  ? Center(
                      child: Text(
                        S.of(context).noReports,
                        style: TextStyle(
                          fontSize: width / 30,
               
                          fontFamily: AppFonts.poppins,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.only(top: 8),
                      itemCount: state.reports.length,
                      itemBuilder: (context, index) {
                        return BlocBuilder<ThemeCubit, bool>(
                          builder: (context, isDark) {
                            return Container(
                              width: width,
                              margin: EdgeInsets.symmetric(
                                  horizontal: width / 30,
                                  vertical: height / 120),
                              padding: EdgeInsets.all(width / 30),
                              decoration: BoxDecoration(
                                color: isDark? AppColors.kBlueLight:AppColors.kWhite,
                                boxShadow:isDark?[]: const [
                                  BoxShadow(
                                    color: AppColors.kGreyForDivider,
                                    blurRadius: 10,
                                    spreadRadius: 0,
                                  ),
                                ],
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        "${index + 1}",
                                        style: TextStyle(
                                          fontSize: width / 26,
                               
                                          fontFamily: AppFonts.poppins,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(
                                        width: width / 20,
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          RichText(
                                            text: TextSpan(
                                              children: [
                                                TextSpan(
                                                  text:
                                                      "${S.of(context).email}: ",
                                                  style: TextStyle(
                                                    fontSize: width / 32,
                                            color: isDark?AppColors.kWhite: AppColors.kBlack,
                                                    fontFamily:
                                                        AppFonts.poppins,
                                                    fontWeight: FontWeight
                                                        .bold, // Bold for the label
                                                  ),
                                                ),
                                                TextSpan(
                                                  text:
                                                      "${state.reports[index].appUser.email} ",
                                                  style: TextStyle(
                                                    fontSize: width / 32,
                                            color: isDark?AppColors.kWhite: AppColors.kBlack,
                                                    fontFamily:
                                                        AppFonts.poppins,
                                                    fontWeight: FontWeight
                                                        .w400, // Regular weight for the value
                                                  ),
                                                ),
                                                TextSpan(
                                                  text:
                                                      "(${state.reports[index].appUser.role})",
                                                  style: TextStyle(
                                                    fontSize: width / 32,
                                            color: isDark?AppColors.kWhite: AppColors.kBlack,
                                                    fontFamily:
                                                        AppFonts.poppins,
                                                    fontWeight: FontWeight
                                                        .w400, // Regular weight for the value
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          SizedBox(
                                            width: width * .7,
                                            child: RichText(
                                              text: TextSpan(
                                                children: [
                                                  TextSpan(
                                                    text:
                                                        "${S.of(context).messagee} ",
                                                    style: TextStyle(
                                                      fontSize: width / 32,
                                              color: isDark?AppColors.kWhite: AppColors.kBlack,
                                                      fontFamily:
                                                          AppFonts.poppins,
                                                      fontWeight: FontWeight
                                                          .bold, // Bold for the label
                                                    ),
                                                  ),
                                                  TextSpan(
                                                    text:
                                                        "#${state.reports[index].message}",
                                                    style: TextStyle(
                                                      fontSize: width / 32,
                                              color: isDark?AppColors.kWhite: AppColors.kBlack,
                                                      fontFamily:
                                                          AppFonts.poppins,
                                                      fontWeight: FontWeight
                                                          .w400, // Regular weight for the value
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              maxLines:
                                                  4, // Keeps the maxLines constraint
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  GestureDetector(
                                    onTap: () async {
                                      await launchUrl(
                                        Uri.parse(
                                            "tel:$kuwait${state.reports[index].appUser.phoneNumber}"),
                                      );
                                    },
                                    child: Icon(
                                      Ionicons.call,
                                      size: width / 18,
                                      color: AppColors.kBlueLight,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      },
                    );
            } else if (state is ReportsLoading) {
              return const Center(child: CircularProgressIndicator());
            } else {
              return const SizedBox();
            }
          },
        ));
  }
}
