import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ionicons/ionicons.dart';
import '../../../config/routes.dart';
import '../../../logic/phone_auth/phone_auth_cubit.dart';
import '../../address/address.dart';
import 'settings_tile.dart';
import '../../../widgets/snack_bar.dart';

import '../../../constants/colors.dart';
import '../../../constants/fonts.dart';
import '../../../generated/l10n.dart';
import '../../../logic/language/language_cubit.dart';
import '../../../logic/navigation_cubit/navigation_cubit.dart';
import '../../../logic/theme/theme_cubit.dart';
import '../../../logic/user/user_cubit.dart';

class MyAccountScreen extends StatefulWidget {
  //final Function updateUi;
  const MyAccountScreen();
  //required this.updateUi);

  @override
  State<MyAccountScreen> createState() => _MyAccountScreenState();
}

class _MyAccountScreenState extends State<MyAccountScreen> {
  late String currentLanguage;
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: AppColors.kBlueLight,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(20),
            bottomRight: Radius.circular(20),
          ),
        ),
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(
            Icons.arrow_back_ios,
            color: AppColors.kWhite,
            size: width / 18,
          ),
        ),
        title: Center(
          child: Text(
            S.of(context).settings,
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
            width: width / 5,
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.only(
          top: height / 60,
          left: width / 20,
          right: width / 12,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FirebaseAuth.instance.currentUser != null
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        S.of(context).accSettings,
                        style: TextStyle(
                          fontSize: width / 24,
                          fontFamily: AppFonts.poppins,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      SizedBox(
                        height: height / 100,
                      ),
                      SettingsTile(
                        image: "assets/images/orders.png",
                        title: S.of(context).myOrders,
                        onTap: () {
                          Navigator.pop(context);
                          BlocProvider.of<NavigationCubit>(context).navigate(2);
                        },
                      ),
                      SizedBox(
                        height: height / 100,
                      ),
                      SettingsTile(
                        image: "assets/images/subscription.png",
                        title: S.of(context).subs,
                        onTap: () {
                          Navigator.of(context).pushNamed(AppRoutes.subHistory);
                        },
                      ),
                      SizedBox(
                        height: height / 100,
                      ),
                      SettingsTile(
                        image: "assets/images/notifications.png",
                        title: S.of(context).notifs,
                        onTap: () {
                          Navigator.of(context).pushNamed(AppRoutes.myNotifs);
                        },
                      ),
                      SizedBox(
                        height: height / 100,
                      ),
                      SettingsTile(
                        image: "assets/images/address.png",
                        title: S.of(context).addressSet,
                        onTap: () {
                          Navigator.of(context).pushNamed(
                            AppRoutes.address,
                            arguments: NavigationFromSettingsTo.myaccount,
                          );
                        },
                      ),
                      //   SizedBox(
                      //   height: height / 100,
                      // ),
                      // SettingsTile(
                      //   image: "assets/images/notifications.png",
                      //   title: S.of(context).managePwd,
                      //   onTap: () {
                      //     Navigator.of(context).pushNamed(AppRoutes.manage);
                      //   },
                      // ),
                      const SizedBox(
                        height: 14,
                      ),
                    ],
                  )
                : Column(
                    children: [
                      Text(
                        S.of(context).needLogin,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: width / 24,
                          fontFamily: AppFonts.poppins,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      SizedBox(
                        height: height / 40,
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          Navigator.of(context).pushNamed(AppRoutes.login);
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Ionicons.log_in,
                              size: width / 16,
                              color: AppColors.kWhite,
                            ),
                            Text(
                              S.of(context).sign_in,
                              style: TextStyle(
                                fontSize: width / 30,
                                fontFamily: AppFonts.poppins,
                                color: AppColors.kWhite,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: height / 40,
                      ),
                    ],
                  ),
            Text(
              S.of(context).appS,
              style: TextStyle(
                fontSize: width / 24,
                fontFamily: AppFonts.poppins,
                fontWeight: FontWeight.w900,
              ),
            ),
            SizedBox(
              height: height / 100,
            ),
            FirebaseAuth.instance.currentUser != null? BlocBuilder<UserCubit, UserState>(
              builder: (context, state) {
          
                if (state is UserSuccess) {
                  return state.user.role == "admin"
                      ? SettingsTile(
                          image: "assets/images/admin.png",
                          title: S.of(context).adminPanel,
                          onTap: () {
                            Navigator.of(context).pushNamed(
                              AppRoutes.admin,
                            );
                          },
                        )
                      : const SizedBox();
                } else {
                  return const Text("Hiiii");
                }
              },
            ):const SizedBox(),
            SizedBox(
              height: width / 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                BlocBuilder<ThemeCubit, bool>(
                  builder: (context, isDark) {
                    return BlocBuilder<LanguageCubit, String>(
                      builder: (context, state) {
                        currentLanguage = state;
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
                          child: Container(
                            width: width / 6,
                            height: width / 6,
                            padding: EdgeInsets.all(width / 60),
                            decoration: BoxDecoration(
                              color: isDark
                                  ? AppColors.kBlueLight
                                  : AppColors.kWhite,
                              boxShadow: isDark
                                  ? []
                                  : const [
                                      BoxShadow(
                                        color: AppColors.kGreyForDivider,
                                        blurRadius: 10,
                                        spreadRadius: 0,
                                      ),
                                    ],
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Center(
                              child: Stack(
                                alignment: Alignment.bottomRight,
                                children: [
                                  SvgPicture.asset(state == "ar"
                                      ? "assets/vectors/arab.svg"
                                      : "assets/vectors/english.svg"),
                                  Icon(
                                    Icons.change_circle_outlined,
                                    color: AppColors.kBlueLight,
                                    size: height / 50,
                                  )
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
                BlocBuilder<ThemeCubit, bool>(
                  builder: (context, isDark) {
                    return GestureDetector(
                      onTap: () {
                        BlocProvider.of<ThemeCubit>(context)
                            .chooseTheme(!isDark);
                      },
                      child: Container(
                        width: width / 6,
                        height: width / 6,
                        padding: EdgeInsets.all(width / 30),
                        decoration: BoxDecoration(
                          color:
                              isDark ? AppColors.kBlueLight : AppColors.kWhite,
                          boxShadow: isDark
                              ? []
                              : const [
                                  BoxShadow(
                                    color: AppColors.kGreyForDivider,
                                    blurRadius: 10,
                                    spreadRadius: 0,
                                  ),
                                ],
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Center(
                          child: Stack(
                            alignment: Alignment.bottomRight,
                            children: [
                              Image.asset("assets/images/theme.png"),
                              Icon(
                                Icons.change_circle_outlined,
                                color: AppColors.kBlueLight,
                                size: height / 50,
                              )
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                )
              ],
            ),
            SizedBox(
              height: height / 60,
            ),
            FirebaseAuth.instance.currentUser != null
                ? Center(
                    child: ElevatedButton(
                      onPressed: () async {
                        final logout =
                            await BlocProvider.of<PhoneAuthCubit>(context)
                                .logout();
                        if (logout) {
                          setState(() {});
                          //     widget.updateUi();
                        } else {
                          CustomSnackBar.show(
                              context, "There is an error", AppColors.kRed);
                        }
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Ionicons.log_out,
                            size: width / 16,
                            color: AppColors.kWhite,
                          ),
                          Text(
                            S.of(context).logout,
                            style: TextStyle(
                              fontSize: width / 30,
                              fontFamily: AppFonts.poppins,
                              color: AppColors.kWhite,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                : const SizedBox(),
          ],
        ),
      ),
    );
  }
}
