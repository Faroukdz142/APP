import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:confirm_dialog/confirm_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import '../../logic/language/language_cubit.dart';

import '../../constants/colors.dart';
import '../../constants/fonts.dart';
import '../../generated/l10n.dart';
import '../../widgets/snack_bar.dart';
import '../../widgets/text_field.dart';
import '../address/widgets/necessary.dart';

class NotificationsCenter extends StatefulWidget {
  const NotificationsCenter({super.key});

  @override
  State<NotificationsCenter> createState() => _NotificationsCenterState();
}

class _NotificationsCenterState extends State<NotificationsCenter> {
  final titleAr = TextEditingController();
  bool isLoading = false;
  final contentAr = TextEditingController();
  final contentEn = TextEditingController();
  final titleEn = TextEditingController();
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
              S.of(context).notifCenter,
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
      body: Padding(
        padding: EdgeInsets.only(
          top: height / 70,
          left: width / 20,
          right: width / 20,
        ),
        child: Column(
          children: [
            Text(
              S.of(context).sendNotifToAllUsers,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: width / 30,
                fontFamily: AppFonts.poppins,
                fontWeight: FontWeight.bold,
              ),
            ),
            Row(
              children: [
                Text(
                  S.of(context).titleAr,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: width / 36,
                    fontFamily: AppFonts.poppins,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const NecessaryWidget()
              ],
            ),
            const SizedBox(
              height: 2,
            ),
            CustomTextField(
              validator: (value) {
                if (value.isEmpty) {
                  CustomSnackBar.show(
                    context,
                    S.of(context).usernameEmpty,
                    AppColors.kRed,
                  );
                  return '';
                } else {
                  return null;
                }
              },
              controller: titleAr,
              hintText: S.of(context).title,
            ),
            const SizedBox(
              height: 2,
            ),
            Row(
              children: [
                Text(
                  S.of(context).contentAr,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: width / 36,
                    fontFamily: AppFonts.poppins,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const NecessaryWidget()
              ],
            ),
            const SizedBox(
              height: 2,
            ),
            CustomTextField(
              validator: (value) {
                if (value.isEmpty) {
                  CustomSnackBar.show(
                    context,
                    S.of(context).usernameEmpty,
                    AppColors.kRed,
                  );
                  return '';
                } else {
                  return null;
                }
              },
              controller: contentAr,
              hintText: S.of(context).content,
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              children: [
                Text(
                  S.of(context).titleEn,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: width / 36,
                    fontFamily: AppFonts.poppins,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const NecessaryWidget()
              ],
            ),
            const SizedBox(
              height: 2,
            ),
            CustomTextField(
              validator: (value) {
                if (value.isEmpty) {
                  CustomSnackBar.show(
                    context,
                    S.of(context).usernameEmpty,
                    AppColors.kRed,
                  );
                  return '';
                } else {
                  return null;
                }
              },
              controller: titleEn,
              hintText: S.of(context).titleEn,
            ),
            Row(
              children: [
                Text(
                  S.of(context).contentEn,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: width / 36,
                    fontFamily: AppFonts.poppins,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const NecessaryWidget()
              ],
            ),
            const SizedBox(
              height: 2,
            ),
            CustomTextField(
              validator: (value) {
                if (value.isEmpty) {
                  CustomSnackBar.show(
                    context,
                    S.of(context).usernameEmpty,
                    AppColors.kRed,
                  );
                  return '';
                } else {
                  return null;
                }
              },
              controller: contentEn,
              hintText: S.of(context).contentEn,
            ),
            SizedBox(
              height: height / 60,
            ),
            SizedBox(
              width: width,
              height: height / 17,
              child: BlocBuilder<LanguageCubit, String>(
                builder: (context, state) {
                  return ElevatedButton(
                    onPressed: titleAr.text.isEmpty &&
                            contentAr.text.isEmpty &&
                            titleEn.text.isEmpty &&
                            contentEn.text.isEmpty
                        ? () {
                            CustomSnackBar.show(
                              context,
                              S.of(context).tryAgain,
                              AppColors.kRed,
                            );
                          }
                        : () async {
                            if (await confirm(context,
                                content: Text(S.of(context).sureContinue))) {
                              //send notification that driver sent
                              try {
                                setState(() {
                                  isLoading = true;
                                });

                                if (titleAr.text.isNotEmpty &&
                                    contentAr.text.isNotEmpty &&
                                    titleEn.text.isNotEmpty &&
                                    contentEn.text.isNotEmpty) {
                                  final doc = await FirebaseFirestore.instance
                                      .collection("notifications")
                                      .add({
                                    "titleAr": titleAr.text.trim(),
                                    "contentAr": contentAr.text.trim(),
                                    "titleEn": titleEn.text.trim(),
                                    "contentEn": contentEn.text.trim(),
                                    "receipientId": "#all",
                                    "lang": state,
                                    "timeStamp": DateTime.now()
                                  });
                                  titleAr.clear();
                                  contentAr.clear();
                                  titleEn.clear();
                                  contentEn.clear();
                                  await FirebaseFirestore.instance
                                      .collection("notifications")
                                      .doc(doc.id)
                                      .update({
                                    "id": doc.id,
                                  });

                                  setState(() {
                                    isLoading = false;
                                  });
                                  CustomSnackBar.show(
                                    context,
                                    S.of(context).notifSent,
                                    AppColors.kGreen,
                                  );
                                }
                              } catch (e) {
                                print(e.toString());
                                CustomSnackBar.show(
                                  context,
                                  S.of(context).tryAgain,
                                  AppColors.kRed,
                                );
                              }
                            } else {}
                          },
                    child: isLoading
                        ? LoadingAnimationWidget.discreteCircle(
                            color: AppColors.kWhite,
                            size: height / 40,
                          )
                        : Text(
                            S.of(context).send,
                            style: TextStyle(
                              fontSize: width / 32,
                              color: AppColors.kWhite,
                              fontFamily: AppFonts.poppins,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
