import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:encrypt/encrypt.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ionicons/ionicons.dart';
import 'package:trustlaundry/main.dart';
import '../../config/routes.dart';
import '../../constants/colors.dart';
import '../../constants/strings.dart';
import '../../logic/balance/balance_cubit.dart';
import '../../logic/theme/theme_cubit.dart';
import '../../logic/user/user_cubit.dart';
import 'widgets/drawer.dart';
import 'widgets/home.dart';
import 'widgets/orders.dart';
import 'widgets/subs.dart';

import '../../constants/fonts.dart';
import '../../generated/l10n.dart';
import '../../logic/navigation_cubit/navigation_cubit.dart';
import '../../widgets/sign_in_dialog.dart';

import 'package:encrypt/encrypt.dart' as encrypt;

class ApiKeyManager {
  // Key and IV used to encrypt the API keys (should match the ones used for encryption)

  // Decrypt the API key
  static Future<String> decryptKey(String encryptedKey) async {
    final code = await FirebaseFirestore.instance
        .collection("keys")
        .doc("l9pgPvjXDamoD84YsE2X")
        .get();
    return Encrypter(AES(encrypt.Key.fromUtf8(code.data()!["key"]))).decrypt(
        Encrypted.fromBase64(encryptedKey),
        iv: IV.fromUtf8(code.data()!["iv"]));
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  void initState() {
    super.initState();
    if (FirebaseAuth.instance.currentUser != null) {
      BlocProvider.of<UserCubit>(context).getUserInfo();
      BlocProvider.of<BalanceCubit>(context).getBalance();
    }
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    List widgets = [
      {"title": S.of(context).home, "widget": const HomeWidget()},
      {"title": S.of(context).subs, "widget": const SubscriptionsScreen()},
      {"title": S.of(context).myOrders, "widget": const OrdersWidget()},
      // {"title": S.of(context).cart, "widget": const CartWidget()},
      // {
      //   "title": S.of(context).acc,
      //   "widget": MyAccountWidget(
      //     updateUi: () {
      //       setState(() {});
      //     },
      //   )
      // },
    ];

    return BlocBuilder<NavigationCubit, int>(
      builder: (context, state) {
        return BlocBuilder<ThemeCubit, bool>(
          builder: (context, isDark) {
            return Scaffold(
              key: scaffoldKey,
              resizeToAvoidBottomInset: false,
              backgroundColor: AppColors.kBlueLight,
              drawer: Drawer(
                width: width / 1.4,
                child: const DrawerBody(),
              ),
              bottomNavigationBar: BottomNavigationBar(
                iconSize: 20,
                selectedLabelStyle: TextStyle(
                    fontWeight: FontWeight.bold, fontFamily: AppFonts.poppins),
                unselectedLabelStyle: TextStyle(
                    fontWeight: FontWeight.bold, fontFamily: AppFonts.poppins),
                backgroundColor: AppColors.kBlueLight,
                items: [
                  BottomNavigationBarItem(
                    backgroundColor: AppColors.kBlueLight,
                    icon: Icon(
                      Ionicons.home,
                      size: width / 18,
                    ),
                    label: S.of(context).home,
                  ),
                  BottomNavigationBarItem(
                    backgroundColor: AppColors.kBlueLight,
                    icon: Icon(
                      Ionicons.cash,
                      size: width / 18,
                    ),
                    label: S.of(context).subs,
                  ),
                  BottomNavigationBarItem(
                    backgroundColor: AppColors.kBlueLight,
                    icon: Icon(
                      Ionicons.list,
                      size: width / 18,
                    ),
                    label: S.of(context).myOrders,
                  ),
                ],
                selectedItemColor: AppColors.kWhite,
                unselectedItemColor: AppColors.kGreyForDivider,
                type: BottomNavigationBarType.fixed,
                currentIndex: state,
                enableFeedback: false,
                elevation: 0,
                unselectedFontSize: width / 38,
                selectedFontSize: width / 34,
                onTap: (index) {
                  if (FirebaseAuth.instance.currentUser != null ||
                      index == 0 ||
                      index == 1 ||
                      index == 4) {
                    BlocProvider.of<NavigationCubit>(context).navigate(index);
                  } else {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return const SignInDialog();
                      },
                    );
                  }
                },
              ),
              body: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                      top: height / 20,
                      left: width / 20,
                      right: width / 20,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: () {
                            scaffoldKey.currentState!.openDrawer();
                          },
                          child: Icon(
                            Ionicons.menu,
                            color: AppColors.kWhite,
                            size: width / 14,
                          ),
                        ),
                        GestureDetector(
                          onTap: () async {},
                          child: CircleAvatar(
                            backgroundColor: AppColors.kWhite,
                            radius: height / 24,
                            child: CircleAvatar(
                              radius: height / 25,
                              backgroundColor: AppColors.kBlueLight,
                              child: CircleAvatar(
                                backgroundColor: AppColors.kWhite,
                                radius: height / 26,
                                backgroundImage:
                                    const AssetImage("assets/images/logo.jpeg"),
                              ),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            if (FirebaseAuth.instance.currentUser != null) {
                              Navigator.of(context)
                                  .pushNamed(AppRoutes.myNotifs);
                            } else {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return const SignInDialog();
                                },
                              );
                            }
                          },
                          child: Icon(
                            Ionicons.notifications,
                            color: AppColors.kWhite,
                            size: width / 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: height / 60,
                  ),
                  Expanded(
                    child: BlocBuilder<ThemeCubit, bool>(
                      builder: (context, isDark) {
                        return Container(
                            decoration: BoxDecoration(
                              color: isDark
                                  ? AppColors.kDarkBlueLight
                                  : const Color.fromARGB(255, 247, 245, 245),
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(20),
                                topRight: Radius.circular(20),
                              ),
                            ),
                            width: width,
                            child: widgets[state]["widget"]);
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
