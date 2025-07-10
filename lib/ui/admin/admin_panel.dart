import 'package:animated_digit/animated_digit.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../config/routes.dart';
import '../../logic/theme/theme_cubit.dart';

import '../../constants/colors.dart';
import '../../constants/fonts.dart';
import '../../generated/l10n.dart';
import '../../logic/language/language_cubit.dart';

class AdminPanel extends StatelessWidget {
  const AdminPanel({super.key});

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
              S.of(context).adminPanel,
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
        padding: EdgeInsets.only(
          left: width / 18,
          right: width / 18,
          top: height / 65,
          bottom: height / 65,
        ),
        child: BlocBuilder<ThemeCubit, bool>(
          builder: (context, isDark) {
            return Column(children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).pushNamed(AppRoutes.users);
                    },
                    child: Container(
                      height: height / 7,
                      width: width / 2.4,
                      padding: EdgeInsets.symmetric(
                        vertical: height / 80,
                        horizontal: width / 70,
                      ),
                      decoration: BoxDecoration(
                        color: isDark ? AppColors.kBlueLight : AppColors.kWhite,
                        boxShadow: isDark
                            ? []
                            : const [
                                BoxShadow(
                                  color: AppColors.kGreyForDivider,
                                  blurRadius: 5,
                                  spreadRadius: 0,
                                ),
                              ],
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            S.of(context).totalUsers,
                            style: TextStyle(
                              fontSize: width / 30,
                              fontFamily: AppFonts.poppins,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          StreamBuilder<QuerySnapshot>(
                              stream: FirebaseFirestore.instance
                                  .collection("users")
                                  .snapshots(),
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  return AnimatedDigitWidget(
                                    value: int.parse(snapshot.data!.docs.length.toString().split('').reversed.join()),
                                    textStyle: TextStyle(
                                      fontSize: width / 14,
                                      color: isDark
                                          ? AppColors.kWhite
                                          : AppColors.kBlueLight,
                                      fontFamily: AppFonts.poppins,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  );
                                } else if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return const CircularProgressIndicator();
                                } else {
                                  return Text(
                                    S.of(context).tryAgain,
                                    style: TextStyle(
                                      fontSize: width / 18,
                                      fontFamily: AppFonts.poppins,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  );
                                }
                              }),
                        ],
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).pushNamed(AppRoutes.adminOrders);
                    },
                    child: Container(
                      height: height / 7,
                      width: width / 2.4,
                      padding: EdgeInsets.symmetric(
                        vertical: height / 80,
                        horizontal: width / 30,
                      ),
                      decoration: BoxDecoration(
                        color: isDark ? AppColors.kBlueLight : AppColors.kWhite,
                        boxShadow: isDark
                            ? []
                            : const [
                                BoxShadow(
                                  color: AppColors.kGreyForDivider,
                                  blurRadius: 5,
                                  spreadRadius: 0,
                                ),
                              ],
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            S.of(context).totalOrders,
                            style: TextStyle(
                              fontSize: width / 28,
                              fontFamily: AppFonts.poppins,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          StreamBuilder<QuerySnapshot>(
                              stream: FirebaseFirestore.instance
                                  .collection("orders")
                                  .snapshots(),
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  return AnimatedDigitWidget(
                                    value: int.parse(snapshot.data!.docs.length.toString().split('').reversed.join()),
                                    textStyle: TextStyle(
                                      fontSize: width / 14,
                                      color: isDark
                                          ? AppColors.kWhite
                                          : AppColors.kBlueLight,
                                      fontFamily: AppFonts.poppins,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  );
                                } else if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return const CircularProgressIndicator();
                                } else {
                                  return Text(
                                    S.of(context).tryAgain,
                                    style: TextStyle(
                                      fontSize: width / 18,
                                      fontFamily: AppFonts.poppins,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  );
                                }
                              }),
                        ],
                      ),
                    ),
                  )
                ],
              ),
              SizedBox(
                height: height / 60,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).pushNamed(AppRoutes.reports);
                    },
                    child: Container(
                      height: height / 7,
                      width: width / 2.4,
                      padding: EdgeInsets.symmetric(
                        vertical: height / 80,
                        horizontal: width / 30,
                      ),
                      decoration: BoxDecoration(
                        color: isDark ? AppColors.kBlueLight : AppColors.kWhite,
                        boxShadow: isDark
                            ? []
                            : const [
                                BoxShadow(
                                  color: AppColors.kGreyForDivider,
                                  blurRadius: 5,
                                  spreadRadius: 0,
                                ),
                              ],
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            S.of(context).reports,
                            style: TextStyle(
                              fontSize: width / 28,
                              fontFamily: AppFonts.poppins,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          StreamBuilder<QuerySnapshot>(
                              stream: FirebaseFirestore.instance
                                  .collection("reports")
                                  .snapshots(),
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  return AnimatedDigitWidget(
                                    value:int.parse(snapshot.data!.docs.length.toString().split('').reversed.join()),
                                    textStyle: TextStyle(
                                      fontSize: width / 14,
                                      color: isDark
                                          ? AppColors.kWhite
                                          : AppColors.kBlueLight,
                                      fontFamily: AppFonts.poppins,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  );
                                } else if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return const CircularProgressIndicator();
                                } else {
                                  return Text(
                                    S.of(context).tryAgain,
                                    style: TextStyle(
                                      fontSize: width / 18,
                                      fontFamily: AppFonts.poppins,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  );
                                }
                              }),
                        ],
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).pushNamed(AppRoutes.adminRequests);
                    },
                    child: Container(
                      height: height / 7,
                      width: width / 2.4,
                      padding: EdgeInsets.symmetric(
                        vertical: height / 80,
                        horizontal: width / 30,
                      ),
                      decoration: BoxDecoration(
                        color: isDark ? AppColors.kBlueLight : AppColors.kWhite,
                        boxShadow: isDark
                            ? []
                            : const [
                                BoxShadow(
                                  color: AppColors.kGreyForDivider,
                                  blurRadius: 5,
                                  spreadRadius: 0,
                                ),
                              ],
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            S.of(context).driverRequests,
                            style: TextStyle(
                              fontSize: width / 28,
                              fontFamily: AppFonts.poppins,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          StreamBuilder<QuerySnapshot>(
                              stream: FirebaseFirestore.instance
                                  .collection("driverRequests")
                                  .snapshots(),
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  return AnimatedDigitWidget(
                                    value: int.parse(snapshot.data!.docs.length.toString().split('').reversed.join()),
                                    textStyle: TextStyle(
                                      fontSize: width / 14,
                                      color: isDark
                                          ? AppColors.kWhite
                                          : AppColors.kBlueLight,
                                      fontFamily: AppFonts.poppins,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  );
                                } else if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return const CircularProgressIndicator();
                                } else {
                                  return Text(
                                    S.of(context).tryAgain,
                                    style: TextStyle(
                                      fontSize: width / 18,
                                      fontFamily: AppFonts.poppins,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  );
                                }
                              }),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: height / 60,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).pushNamed(AppRoutes.banners);
                    },
                    child: Container(
                      height: height / 7,
                      width: width / 2.4,
                      padding: EdgeInsets.symmetric(
                        vertical: height / 80,
                        horizontal: width / 30,
                      ),
                      decoration: BoxDecoration(
                        color: isDark ? AppColors.kBlueLight : AppColors.kWhite,
                        boxShadow: isDark
                            ? []
                            : const [
                                BoxShadow(
                                  color: AppColors.kGreyForDivider,
                                  blurRadius: 5,
                                  spreadRadius: 0,
                                ),
                              ],
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Center(
                        child: Text(
                          S.of(context).banners,
                          style: TextStyle(
                            fontSize: width / 28,
                            fontFamily: AppFonts.poppins,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).pushNamed(AppRoutes.notifsCenter);
                    },
                    child: Container(
                      height: height / 7,
                      width: width / 2.4,
                      padding: EdgeInsets.symmetric(
                        vertical: height / 80,
                        horizontal: width / 30,
                      ),
                      decoration: BoxDecoration(
                        color: isDark ? AppColors.kBlueLight : AppColors.kWhite,
                        boxShadow: isDark
                            ? []
                            : const [
                                BoxShadow(
                                  color: AppColors.kGreyForDivider,
                                  blurRadius: 5,
                                  spreadRadius: 0,
                                ),
                              ],
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Center(
                        child: Text(
                          S.of(context).notifCenter,
                          style: TextStyle(
                            fontSize: width / 28,
                            fontFamily: AppFonts.poppins,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
              SizedBox(
                height: height / 60,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).pushNamed(AppRoutes.addSection);
                    },
                    child: Container(
                      height: height / 7,
                      width: width / 2.4,
                      padding: EdgeInsets.symmetric(
                        vertical: height / 80,
                        horizontal: width / 30,
                      ),
                      decoration: BoxDecoration(
                        color: isDark ? AppColors.kBlueLight : AppColors.kWhite,
                        boxShadow: isDark
                            ? []
                            : const [
                                BoxShadow(
                                  color: AppColors.kGreyForDivider,
                                  blurRadius: 5,
                                  spreadRadius: 0,
                                ),
                              ],
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Center(
                        child: Text(
                          S.of(context).manageSections,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: width / 28,
                            fontFamily: AppFonts.poppins,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).pushNamed(AppRoutes.productsAdmin);
                    },
                    child: Container(
                      height: height / 7,
                      width: width / 2.4,
                      padding: EdgeInsets.symmetric(
                        vertical: height / 80,
                        horizontal: width / 30,
                      ),
                      decoration: BoxDecoration(
                        color: isDark ? AppColors.kBlueLight : AppColors.kWhite,
                        boxShadow: isDark
                            ? []
                            : const [
                                BoxShadow(
                                  color: AppColors.kGreyForDivider,
                                  blurRadius: 5,
                                  spreadRadius: 0,
                                ),
                              ],
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Center(
                        child: Text(
                          S.of(context).manageProducts,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: width / 28,
                            fontFamily: AppFonts.poppins,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
              const SizedBox(height: 10,),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  GestureDetector(
                        onTap: () {
                          Navigator.of(context).pushNamed(AppRoutes.prodOrdersAdmin);
                        },
                        child: Container(
                          height: height / 7,
                          width: width / 2.4,
                          padding: EdgeInsets.symmetric(
                            vertical: height / 80,
                            horizontal: width / 70,
                          ),
                          decoration: BoxDecoration(
                            color: isDark ? AppColors.kBlueLight : AppColors.kWhite,
                            boxShadow: isDark
                                ? []
                                : const [
                                    BoxShadow(
                                      color: AppColors.kGreyForDivider,
                                      blurRadius: 5,
                                      spreadRadius: 0,
                                    ),
                                  ],
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Column(
                            
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                S.of(context).totalProdOrders,
                                style: TextStyle(
                                  fontSize: width / 30,
                                  fontFamily: AppFonts.poppins,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              StreamBuilder<QuerySnapshot>(
                                  stream: FirebaseFirestore.instance
                                      .collection("prodOrders")
                                      .snapshots(),
                                  builder: (context, snapshot) {
                                    if (snapshot.hasData) {
                                      return AnimatedDigitWidget(
                                        value:int.parse(snapshot.data!.docs.length.toString().split('').reversed.join()),
                                        textStyle: TextStyle(
                                          fontSize: width / 14,
                                          color: isDark
                                              ? AppColors.kWhite
                                              : AppColors.kBlueLight,
                                          fontFamily: AppFonts.poppins,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      );
                                    } else if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return const CircularProgressIndicator();
                                    } else {
                                      return Text(
                                        S.of(context).tryAgain,
                                        style: TextStyle(
                                          fontSize: width / 18,
                                          fontFamily: AppFonts.poppins,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      );
                                    }
                                  }),
                            ],
                          ),
                        ),
                      ),
                ],
              ),
            ]);
          },
        ),
      ),
    );
  }
}
