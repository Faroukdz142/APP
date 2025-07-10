import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:confirm_dialog/confirm_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ionicons/ionicons.dart';
import 'package:trustlaundry/models/my_address.dart';
import 'package:trustlaundry/ui/address/address.dart';
import '../../config/routes.dart';
import '../../logic/language/language_cubit.dart';
import '../../logic/theme/theme_cubit.dart';
import '../../widgets/snack_bar.dart';

import '../../constants/colors.dart';
import '../../constants/fonts.dart';
import '../../generated/l10n.dart';
import '../../widgets/sign_in_dialog.dart';

class RequestDriverScreen extends StatefulWidget {
  const RequestDriverScreen({super.key});

  @override
  State<RequestDriverScreen> createState() => _RequestDriverScreenState();
}

class _RequestDriverScreenState extends State<RequestDriverScreen> {
  bool myBoolean = false;
  String deliveryDate = "";
  MyAddress? address;
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
              S.of(context).req,
              style: TextStyle(
                fontSize: width / 18,
                color: AppColors.kWhite,
                fontFamily: AppFonts.poppins,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          actions: [
            GestureDetector(
              onTap: () {
                Navigator.of(context).pushNamed(AppRoutes.myRequests);
              },
              child: Icon(
                Ionicons.list,
                color: AppColors.kWhite,
                size: width / 18,
              ),
            ),
            SizedBox(
              width: width / 20,
            ),
          ],
        ),
      ),
      body: BlocBuilder<ThemeCubit, bool>(
        builder: (context, isDark) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: height / 30,
              ),
              Text(
                S.of(context).date,
                style: TextStyle(
                  fontSize: width / 22,
                  color: isDark ? AppColors.kWhite : AppColors.kGreyForTexts,
                  fontFamily: AppFonts.poppins,
                  fontWeight: FontWeight.bold,
                ),
              ),
              BlocBuilder<LanguageCubit, String>(
                builder: (context, state) {
                  return GestureDetector(
                    onTap: () async {
                      DateTime? date = await showDatePicker(
                        locale: Locale(state),
                        context: context,
                        initialDate:
                            DateTime.now().add(const Duration(days: 1)),
                        firstDate: DateTime.now().add(Duration(
                            days: 1)), // Ensures the date is after today
                        lastDate: DateTime(2100),
                      );

                      if (date != null) {
                        setState(() {
                          deliveryDate = date.toString().substring(0, 10);
                        });
                      }
                    },
                    child: Container(
                      width: width / 2,
                      padding: EdgeInsets.all(width / 30),
                      margin: EdgeInsets.symmetric(
                          horizontal: width / 30, vertical: height / 120),
                      decoration: BoxDecoration(
                        color:
                            !isDark ? AppColors.kWhite : AppColors.kBlueLight,
                        border: Border.all(
                            color: isDark
                                ? AppColors.kWhite
                                : AppColors.kBlueLight,
                            width: 2),
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
                        child: deliveryDate.isEmpty
                            ? Icon(
                                Icons.date_range_outlined,
                                size: width / 20,
                              )
                            : Text(
                                deliveryDate,
                                style: TextStyle(
                                  fontSize: width / 26,
                                  fontFamily: AppFonts.poppins,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                      ),
                    ),
                  );
                },
              ),
              SizedBox(
                height: height / 30,
              ),
              Text(
                S.of(context).time,
                style: TextStyle(
                  fontSize: width / 22,
                  color: isDark ? AppColors.kWhite : AppColors.kGreyForTexts,
                  fontFamily: AppFonts.poppins,
                  fontWeight: FontWeight.bold,
                ),
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    myBoolean = !myBoolean;
                  });
                },
                child: Container(
                  width: width,
                  margin: EdgeInsets.symmetric(
                      horizontal: width / 30, vertical: height / 120),
                  padding: EdgeInsets.all(width / 30),
                  decoration: BoxDecoration(
                    border: !myBoolean
                        ? Border.all(
                            color: isDark
                                ? AppColors.kWhite
                                : AppColors.kBlueLight,
                            width: 2)
                        : null,
                    color: !isDark ? AppColors.kWhite : AppColors.kBlueLight,
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
                  child: Text(
                    S.of(context).morning,
                    style: TextStyle(
                      fontSize: width / 26,
                      fontFamily: AppFonts.poppins,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    myBoolean = !myBoolean;
                  });
                },
                child: Container(
                  width: width,
                  padding: EdgeInsets.all(width / 30),
                  margin: EdgeInsets.symmetric(
                      horizontal: width / 30, vertical: height / 120),
                  decoration: BoxDecoration(
                    color: !isDark ? AppColors.kWhite : AppColors.kBlueLight,
                    border: myBoolean
                        ? Border.all(
                            color: isDark
                                ? AppColors.kWhite
                                : AppColors.kBlueLight,
                            width: 2)
                        : null,
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
                  child: Text(
                    S.of(context).evening,
                    style: TextStyle(
                      fontSize: width / 26,
                      fontFamily: AppFonts.poppins,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: height / 30,
              ),
              Text(
                S.of(context).deliveryAddress,
                style: TextStyle(
                  fontSize: width / 22,
                  color: isDark ? AppColors.kWhite : AppColors.kGreyForTexts,
                  fontFamily: AppFonts.poppins,
                  fontWeight: FontWeight.bold,
                ),
              ),
              GestureDetector(
                onTap: () async {
                  address = await Navigator.of(context).pushNamed(
                      AppRoutes.address,
                      arguments: NavigationFromSettingsTo.order) as MyAddress;

                  setState(() {});
                },
                child: Container(
                  width: width,
                  //   height: height / 13,
                  margin: EdgeInsets.symmetric(
                      horizontal: width / 30, vertical: height / 120),
                  padding: EdgeInsets.symmetric(
                    horizontal: width / 30,
                    vertical: address == null ? height / 50 : height / 120,
                  ),
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.kBlueLight : AppColors.kWhite,
                    border: Border.all(
                        color: address == null
                            ? AppColors.kGreyForDivider
                            : AppColors.kBlueLight,
                        width: 1),
                    boxShadow: isDark
                        ? []
                        : const [
                            BoxShadow(
                              color: AppColors.kGreyForDivider,
                              blurRadius: 10,
                              spreadRadius: 0,
                            ),
                          ],
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      address == null
                          ? Row(
                              children: [
                                Icon(
                                  Icons.location_on_rounded,
                                  color: address == null
                                      ? AppColors.kGreyForDivider
                                      : AppColors.kBlueLight,
                                  size: width / 18,
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  S.of(context).deliveryAddress,
                                  style: TextStyle(
                                    fontSize: width / 28,
                                    fontFamily: AppFonts.poppins,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            )
                          : Column(
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      Icons.location_on_rounded,
                                      color: address == null
                                          ? AppColors.kBlueLight
                                          : AppColors.kBlueLight,
                                      size: width / 18,
                                    ),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    Text(
                                      S.of(context).deliveryAddress,
                                      style: TextStyle(
                                        fontSize: width / 28,
                                        fontFamily: AppFonts.poppins,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "${S.of(context).title} ${address!.addressTitle}",
                                      style: TextStyle(
                                        fontSize: width / 30,
                                        color: isDark
                                            ? AppColors.kGreyForPin
                                            : AppColors.kGreyForTexts,
                                        fontFamily: AppFonts.poppins,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    address!.street != null
                                        ? Text(
                                            "${S.of(context).street}: ${address!.street}",
                                            style: TextStyle(
                                              fontSize: width / 30,
                                              color: isDark
                                                  ? AppColors.kGreyForPin
                                                  : AppColors.kGreyForTexts,
                                              fontFamily: AppFonts.poppins,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          )
                                        : const SizedBox(),
                                  ],
                                ),
                              ],
                            ),
                      Icon(
                        Icons.arrow_forward_ios,
                        size: width / 18,
                      )
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: height / 18,
              ),
              Center(
                child: SizedBox(
                  width: width / 2,
                  child: ElevatedButton(
                    onPressed: () async {
                      if (FirebaseAuth.instance.currentUser != null) {
                        if (deliveryDate.isNotEmpty && address != null) {
                          if (await confirm(
                            context,
                            canPop: true,
                            content: Text(
                              S.of(context).sureReq,
                              style: TextStyle(
                                fontSize: width / 30,
                                fontFamily: AppFonts.poppins,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          )) {
                            String userId =
                                FirebaseAuth.instance.currentUser!.uid;

                            // Query Firestore to check the user's last request
                            final QuerySnapshot lastRequest =
                                await FirebaseFirestore.instance
                                    .collection("driverRequests")
                                    .where("userId", isEqualTo: userId)
                                    .orderBy("timeStamp", descending: true)
                                    .limit(1)
                                    .get();

                            // Check if the user has made a request before
                            if (lastRequest.docs.isNotEmpty) {
                              // Get the timestamp of the last request
                              Timestamp lastRequestTimestamp =
                                  lastRequest.docs.first["timeStamp"];
                              DateTime lastRequestTime =
                                  lastRequestTimestamp.toDate();
                              DateTime currentTime = DateTime.now();

                              // Calculate the difference in hours between the last request and now
                              Duration timeDifference =
                                  currentTime.difference(lastRequestTime);

                              // Check if 24 hours have passed
                              if (timeDifference.inHours < 24) {
                                CustomSnackBar.show(
                                    context,
                                    S.of(context).errorDriverReq,
                                    AppColors.kRed);
                                return;
                              }
                            }

                            // If 24 hours have passed or no previous request exists, add the new request

                            final doc = await FirebaseFirestore.instance
                                .collection("driverRequests")
                                .add({
                              "userId": userId,
                              "date": deliveryDate,
                              "status": "Placed",
                              "address":address!.toJson(),
                              "timeStamp": Timestamp.now(),
                              "period": myBoolean
                                  ? "From 3pm to 8pm"
                                  : "From 10am to 2pm",
                            });

                            await FirebaseFirestore.instance
                                .collection("driverRequests")
                                .doc(doc.id)
                                .update({
                              "id": doc.id,
                            });

                            CustomSnackBar.show(context, S.of(context).reqAdded,
                                AppColors.kGreen);
                            Navigator.pop(context);
                          }
                        }else {
                          CustomSnackBar.show(context, S.of(context).tryAgain, AppColors.kRed);
                        }
                      } else {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return const SignInDialog();
                          },
                        );
                      }
                    },
                    child: Text(
                      S.of(context).next,
                      style: TextStyle(
                        fontSize: width / 28,
                        color: AppColors.kWhite,
                        fontFamily: AppFonts.poppins,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
