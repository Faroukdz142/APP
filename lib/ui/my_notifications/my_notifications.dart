import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:confirm_dialog/confirm_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../../logic/language/language_cubit.dart';
import '../../widgets/snack_bar.dart';
import '../../constants/colors.dart';
import '../../constants/fonts.dart';
import '../../generated/l10n.dart';
import '../../logic/theme/theme_cubit.dart';
import '../../models/notification.dart';
import '../../models/request.dart';

class MyNotifications extends StatefulWidget {
  const MyNotifications({super.key});

  @override
  State<MyNotifications> createState() => _MyNotificationsState();
}

class _MyNotificationsState extends State<MyNotifications> {
  List<MyNotification> myNotifs = [];
  bool isLoading = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    getNotifications().then((v) {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        setState(() {
          startAnimation = true;
        });
      });
    });
  }

  bool startAnimation = false;

  Future<void> getNotifications() async {
    isLoading = true;

    try {
      final notifications = FirebaseFirestore.instance
          .collection("users")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection("notifications");

      final data = await notifications.get();
      for (var x in data.docs) {
        myNotifs.add(MyNotification.fromJson(x.data()));
      }

      final allNotifs = FirebaseFirestore.instance.collection("notifications");
      final allNotifsData = await allNotifs.get();
      for (var x in allNotifsData.docs) {
        myNotifs.add(MyNotification.fromJson(x.data()));
      }
      myNotifs.sort(
        (a, b) => b.timeStamp.compareTo(a.timeStamp),
      );
      isLoading = false;
      setState(() {});
    } catch (e) {
      print(e.toString());
      CustomSnackBar.show(context, S.of(context).tryAgain, AppColors.kRed);
    }
  }

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
            S.of(context).myNotifs,
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
            width: width / 6,
          ),
        ],
      ),
      body: isLoading
          ? Skeletonizer(
              child: ListView.builder(
              itemCount: 8,
              padding: const EdgeInsets.only(top: 8),
              itemBuilder: (context, index) {
                return Container(
                  width: width,
                  margin: EdgeInsets.symmetric(
                      horizontal: width / 30, vertical: height / 120),
                  padding: EdgeInsets.all(width / 30),
                  color: AppColors.kGreyForPin,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Text(
                            "1",
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
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "daafefeazf",
                                style: TextStyle(
                                  fontSize: width / 30,
                                  fontFamily: AppFonts.poppins,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                "zzpngzngzgzgezgzeg",
                                style: TextStyle(
                                  fontSize: width / 32,
                                  fontFamily: AppFonts.poppins,
                                ),
                              ),
                              Text(
                                ",zpoingizgnizrngirginin",
                                style: TextStyle(
                                  fontSize: width / 32,
                                  color: AppColors.kGreyForPin,
                                  fontFamily: AppFonts.poppins,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ))
          : myNotifs.isEmpty
              ? Center(
                  child: Text(
                    S.of(context).noNotifs,
                    style: TextStyle(
                      fontSize: width / 30,
                      color: AppColors.kBlack,
                      fontFamily: AppFonts.poppins,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )
              : AnimationLimiter(
                  child: ListView.builder(
                    itemCount: myNotifs.length,
                    padding: const EdgeInsets.only(top: 8),
                    itemBuilder: (context, index) {
                      return BlocBuilder<ThemeCubit, bool>(
                        builder: (context, isDark) {
                          return AnimationConfiguration.staggeredList(
                            position: index,
                            duration: const Duration(milliseconds: 375),
                            child: FadeInAnimation(
                              child: ScaleAnimation(
                                child: Container(
                                  width: width,
                                  margin: EdgeInsets.symmetric(
                                      horizontal: width / 30,
                                      vertical: height / 120),
                                  padding: EdgeInsets.all(width / 30),
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
                                          BlocBuilder<LanguageCubit,
                                              String>(
                                            builder: (context, state) {
                                              return Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    state=="ar" ? myNotifs[index].titleAr:myNotifs[index].titleEn,
                                                    style: TextStyle(
                                                      fontSize: width / 30,
                                                      fontFamily:
                                                          AppFonts.poppins,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                  Text(
                                                   state=="ar" ?  myNotifs[index].contentAr:myNotifs[index].contentEn,
                                                    style: TextStyle(
                                                      fontSize: width / 32,
                                                      fontFamily:
                                                          AppFonts.poppins,
                                                    ),
                                                  ),
                                                  // myNotifs[index].orderId!=null?  Text(
                                                  //     myNotifs[index].orderId!,
                                                  //     style: TextStyle(
                                                  //       fontSize: width / 32,
                                                  //       color: AppColors.kBlack,
                                                  //       fontFamily: AppFonts.poppins,
                                                  //     ),
                                                  //   ):const SizedBox(),
                                                  Text(
                                                    myNotifs[index]
                                                        .timeStamp
                                                        .toDate()
                                                        .toString()
                                                        .substring(0, 16),
                                                    style: TextStyle(
                                                      fontSize: width / 32,
                                                      color: isDark
                                                          ? AppColors
                                                              .kGreyForPin
                                                          : AppColors
                                                              .kGreyForTexts,
                                                      fontFamily:
                                                          AppFonts.poppins,
                                                    ),
                                                  ),
                                                ],
                                              );
                                            },
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
    );
  }
}
