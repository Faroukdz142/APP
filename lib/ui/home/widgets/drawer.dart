import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ionicons/ionicons.dart';
import '../../../logic/language/language_cubit.dart';
import '../../../logic/navigation_cubit/navigation_cubit.dart';
import '../../../logic/phone_auth/phone_auth_cubit.dart';
import '../../../logic/theme/theme_cubit.dart';
import '../../../widgets/sign_in_dialog.dart';
import '../../../widgets/snack_bar.dart';

import '../../../config/routes.dart';
import '../../../constants/colors.dart';
import '../../../constants/fonts.dart';
import '../../../generated/l10n.dart';
import '../../../logic/balance/balance_cubit.dart';
import '../../../logic/user/user_cubit.dart';

int currentIndex = 0;

class DrawerBody extends StatefulWidget {
  const DrawerBody({super.key});

  @override
  State<DrawerBody> createState() => _DrawerBodyState();
}

class _DrawerBodyState extends State<DrawerBody> {
  String currentLanguage = "ar";
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final List basicRoutes = [
      {
        "title": S.of(context).home,
        "icon": Ionicons.home_outline,
      },
      {
        "title": S.of(context).myNotifs,
        "icon": Ionicons.notifications_outline,
      },
      {
        "title": S.of(context).cart,
        "icon": Ionicons.cart_outline,
      },
      {
        "title": S.of(context).settings,
        "icon": Ionicons.settings_outline,
      },
    ];
    final List additionalRoutes = [
      {
        "title": S.of(context).privacyP,
        "icon": Icons.privacy_tip_outlined,
      },
      {
        "title": S.of(context).termsAndConditions,
        "icon": Icons.security_outlined,
      },
      FirebaseAuth.instance.currentUser != null
          ? {
              "title": S.of(context).logout,
              "icon": Ionicons.log_out_outline,
            }
          : {
              "title": S.of(context).sign_in,
              "icon": Ionicons.log_in_outline,
            },
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          color: AppColors.kBlueLight,
          child: Column(
            children: [
              SizedBox(
                height: height / 20,
              ),
              Center(
                child: CircleAvatar(
                  backgroundColor: AppColors.kWhite,
                  radius: height / 16,
                  child: CircleAvatar(
                    radius: height / 17,
                    backgroundColor: AppColors.kBlueLight,
                    child: CircleAvatar(
                      backgroundColor: AppColors.kWhite,
                      radius: height / 18,
                      backgroundImage:
                          const AssetImage("assets/images/logo.jpeg"),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: height / 60,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    FirebaseAuth.instance.currentUser != null
                        ? Row(
                            children: [
                              Text(
                                "${S.of(context).balance} ",
                                style: TextStyle(
                                  fontSize: width / 25,
                                  fontFamily: AppFonts.poppins,
                                  color: AppColors.kWhite,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              BlocBuilder<BalanceCubit, double>(
                                builder: (context, state) {
                                  return Text(
                                    "${state.toStringAsFixed(2)} ${S.of(context).kwd}",
                                    style: TextStyle(
                                      fontSize: width / 22,
                                      fontFamily: AppFonts.poppins,
                                      color: AppColors.kWhite,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  );
                                },
                              ),
                            ],
                          )
                        : const SizedBox(),
                  ],
                ),
              ),
              SizedBox(
                height: height / 40,
              ),
            ],
          ),
        ),
        Expanded(
          child: Column(
            children: [
              SizedBox(
                height: height / 40,
              ),
              ...basicRoutes.map((e) {
                return GestureDetector(
                  onTap: () async {
                    Navigator.pop(context);
                    if (e["title"] == S.of(context).home) {
                      setState(() {
                        currentIndex = basicRoutes.indexWhere((ev) => ev == e);
                      });
                      BlocProvider.of<NavigationCubit>(context).navigate(0);
                    } else if (e["title"] == S.of(context).myNotifs) {
                      if (FirebaseAuth.instance.currentUser != null) {
                        Navigator.of(context).pushNamed(AppRoutes.myNotifs);
                      } else {
                        showDialog(
                          context: context,
                          builder: (context) => const SignInDialog(),
                        );
                      }
                    } else if (e["title"] == S.of(context).cart) {
                      if (FirebaseAuth.instance.currentUser != null) {
                        Navigator.of(context).pushNamed(AppRoutes.cart);
                      } else {
                        showDialog(
                          context: context,
                          builder: (context) => const SignInDialog(),
                        );
                      }
                    } else if (e["title"] == S.of(context).cart) {
                      Navigator.of(context).pushNamed(AppRoutes.cart);
                    } else if (e["title"] == S.of(context).settings) {
                      Navigator.of(context).pushNamed(AppRoutes.acc);
                    }
                  },
                  child: DrawerTile(
                    image: e["icon"],
                    isActive:
                        currentIndex == basicRoutes.indexWhere((ev) => ev == e),
                    title: e["title"],
                  ),
                );
              }).toList(),
              BlocBuilder<LanguageCubit, String>(
                builder: (context, state) {
                  return GestureDetector(
                    onTap: () {
                      if (currentLanguage == "ar") {
                        currentLanguage = "en";
                      } else {
                        currentLanguage = "ar";
                      }
                      BlocProvider.of<LanguageCubit>(context)
                          .chooseLanguage(currentLanguage);
                    },
                    child: DrawerTile(
                      image: Ionicons.language_outline,
                      isActive: false,
                      title: state == "ar" ? "English" : "العربية",
                    ),
                  );
                },
              ),
              const Divider(
                color: AppColors.kGrey,
              ),
              ...additionalRoutes.map((e) {
                return GestureDetector(
                  onTap: () async {
                    Navigator.pop(context);
                    if (e["title"] == S.of(context).sign_in) {
                      Navigator.of(context).pushNamed(AppRoutes.login);
                    } else if (e["title"] == S.of(context).logout) {
                      final isDone =
                          await BlocProvider.of<PhoneAuthCubit>(context)
                              .logout();
                      if (isDone) {
                        CustomSnackBar.show(
                            context, S.of(context).logoutSuc, AppColors.kGreen);
                      }
                    } else if (e["title"] == S.of(context).termsAndConditions) {
                      Navigator.of(context).pushNamed(AppRoutes.terms);
                    } else if (e["title"] == S.of(context).privacyP) {
                      Navigator.of(context).pushNamed(AppRoutes.privacy);
                    }
                  },
                  child: DrawerTile(
                    image: e["icon"],
                    isActive: currentIndex ==
                        additionalRoutes.indexWhere((ev) => ev == e) +
                            basicRoutes.length,
                    title: e["title"],
                  ),
                );
              })
            ],
          ),
        ),
      ],
    );
  }
}

class DrawerTile extends StatelessWidget {
  final IconData image;
  final String title;
  bool isActive;
  DrawerTile({
    super.key,
    required this.title,
    required this.isActive,
    required this.image,
    required,
  });

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Padding(
      padding: EdgeInsets.symmetric(vertical: width / 40, horizontal: 0),
      child: BlocBuilder<ThemeCubit, bool>(
        builder: (context, isDark) {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              BlocBuilder<LanguageCubit, String>(
                builder: (context, state) {
                  return Container(
                    height: height / 28,
                    width: 8,
                    decoration: isActive
                        ? BoxDecoration(
                            color: AppColors.kBlueLight,
                            borderRadius: BorderRadius.only(
                              bottomLeft:
                                  Radius.circular(state == "ar" ? 5 : 0),
                              topLeft: Radius.circular(state == "ar" ? 5 : 0),
                              bottomRight:
                                  Radius.circular(state == "ar" ? 0 : 5),
                              topRight: Radius.circular(state == "ar" ? 0 : 5),
                            ),
                          )
                        : null,
                  );
                },
              ),
              SizedBox(
                width: width / 25,
              ),
              Icon(
                image,
                color: isDark
                    ? isActive
                        ? AppColors.kBlueLight
                        : AppColors.kWhite
                    : isActive
                        ? AppColors.kBlueLight
                        : AppColors.kBlack,
                size: isActive ? width / 16 : width / 18,
              ),
              SizedBox(
                width: width / 25,
              ),
              Text(
                title,
                style: TextStyle(
                  fontSize: isActive ? width / 24 : width / 27,
                  color: isDark
                      ? isActive
                          ? AppColors.kBlueLight
                          : AppColors.kWhite
                      : isActive
                          ? AppColors.kBlueLight
                          : AppColors.kBlack,
                  fontFamily: AppFonts.poppins,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
