import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ionicons/ionicons.dart';
import 'package:trustlaundry/models/sub.dart';
import '../../logic/admin_orders/admin_orders_cubit.dart';
import '../../logic/language/language_cubit.dart';
import '../../logic/theme/theme_cubit.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../constants/colors.dart';
import '../../constants/fonts.dart';
import '../../constants/strings.dart';
import '../../generated/l10n.dart';
import '../../logic/users/users_cubit.dart';

class AllUsers extends StatefulWidget {
  const AllUsers({super.key});

  @override
  State<AllUsers> createState() => _AllUsersState();
}

class _AllUsersState extends State<AllUsers> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    BlocProvider.of<UsersCubit>(context).getAllUsers();
  }

  Future<List<MySub>> getSubs(String phoneNumber) async {
    List<MySub> subsHistory = [];
    final userQuery = await FirebaseFirestore.instance
        .collection("users")
        .where("phoneNumber", isEqualTo: phoneNumber)
        .get();

    if (userQuery.docs.isNotEmpty) {
      final userDoc = userQuery.docs.first;
      // Step 3: Access the SubscriptionHistory sub-collection.
      final subscriptionHistoryDocs = await FirebaseFirestore.instance
          .collection("users")
          .doc(userDoc.id) // Access the specific user document.
          .collection("subscriptionsHistory") // Access the sub-collection.
          .get();

      // Step 4: Process the documents in SubscriptionHistory.

      for (var x in subscriptionHistoryDocs.docs) {
        subsHistory.add(MySub.fromJson(x.data()));
      }
      subsHistory.sort(
        (a, b) => b.timeStamp.compareTo(a.timeStamp),
      );
      return subsHistory;
    }
    return [];
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
                S.of(context).users,
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
        body: BlocBuilder<UsersCubit, UsersState>(
          builder: (context, state) {
            if (state is UsersSuccess) {
              return ListView.builder(
                padding: const EdgeInsets.only(top: 8),
                itemCount: state.appUsers.length,
                itemBuilder: (context, index) {
                  return BlocBuilder<ThemeCubit, bool>(
                    builder: (context, isDark) {
                      return GestureDetector(
                        onTap: () async {
                          List<MySub> subs =
                              await getSubs(state.appUsers[index].phoneNumber);
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                contentPadding: EdgeInsets.zero,
                                title: Text(
                                  S.of(context).subs,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: width / 26,
                                    fontFamily: AppFonts.poppins,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                content: SizedBox(
                                  width: double.maxFinite,
                                  child: ListView.builder(
                                    shrinkWrap: true,
                                    itemCount: subs.length,
                                    itemBuilder: (context, indexForSubItems) {
                                      return ListTile(
                                        title:
                                            BlocBuilder<LanguageCubit, String>(
                                          builder: (context, state) {
                                            return Text(
                                              "${indexForSubItems + 1}",
                                              style: TextStyle(
                                                fontSize: width / 30,
                                                fontFamily: AppFonts.poppins,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            );
                                          },
                                        ), // Display Arabic title
                                        subtitle:subs.isEmpty? Text(
                                              S.of(context).noSubs,
                                              style: TextStyle(
                                                fontSize: width / 30,
                                                fontFamily: AppFonts.poppins,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ): Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              '  ${S.of(context).pay} ${subs[index].pay}',
                                              style: TextStyle(
                                                fontSize: width / 30,
                                                fontFamily: AppFonts.poppins,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            Text(
                                              '  ${S.of(context).get} ${subs[index].get}',
                                              style: TextStyle(
                                                fontSize: width / 30,
                                                fontFamily: AppFonts.poppins,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            Text(
                                              '  ${S.of(context).time} ${subs[index].timeStamp.toDate().toString().substring(0,16)}',
                                              style: TextStyle(
                                                fontSize: width / 30,
                                                fontFamily: AppFonts.poppins,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: Icon(
                                      Icons.close,
                                      size: width / 14,
                                    ),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        child: Container(
                          width: width,
                          margin: EdgeInsets.symmetric(
                              horizontal: width / 30, vertical: height / 120),
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
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                              text: "${S.of(context).email} ",
                                              style: TextStyle(
                                                fontSize: width / 32,
                                                color: isDark
                                                    ? AppColors.kWhite
                                                    : AppColors.kBlack,
                                                fontFamily: AppFonts.poppins,
                                                fontWeight: FontWeight
                                                    .bold, // Bold for the label
                                              ),
                                            ),
                                            TextSpan(
                                              text: state.appUsers[index].email,
                                              style: TextStyle(
                                                fontSize: width / 32,
                                                color: isDark
                                                    ? AppColors.kWhite
                                                    : AppColors.kBlack,
                                                fontFamily: AppFonts.poppins,
                                                fontWeight: FontWeight
                                                    .w400, // Regular weight for the value
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      RichText(
                                        text: TextSpan(
                                          children: [
                                            TextSpan(
                                              text:
                                                  "${S.of(context).phoneNumber} ",
                                              style: TextStyle(
                                                fontSize: width / 32,
                                                color: isDark
                                                    ? AppColors.kWhite
                                                    : AppColors.kBlack,
                                                fontFamily: AppFonts.poppins,
                                                fontWeight: FontWeight
                                                    .bold, // Bold for the label
                                              ),
                                            ),
                                            TextSpan(
                                              text:
                                                  "965${state.appUsers[index].phoneNumber}+",
                                              style: TextStyle(
                                                fontSize: width / 32,
                                                color: isDark
                                                    ? AppColors.kWhite
                                                    : AppColors.kBlack,
                                                fontFamily: AppFonts.poppins,
                                                fontWeight: FontWeight
                                                    .w400, // Regular weight for the value
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      RichText(
                                        text: TextSpan(
                                          children: [
                                            TextSpan(
                                              text: "${S.of(context).role}: ",
                                              style: TextStyle(
                                                fontSize: width / 32,
                                                color: isDark
                                                    ? AppColors.kWhite
                                                    : AppColors.kBlack,
                                                fontFamily: AppFonts.poppins,
                                                fontWeight: FontWeight
                                                    .bold, // Bold for the label
                                              ),
                                            ),
                                            TextSpan(
                                              text:
                                                  "#${state.appUsers[index].role}",
                                              style: TextStyle(
                                                fontSize: width / 32,
                                                color: isDark
                                                    ? AppColors.kWhite
                                                    : AppColors.kBlack,
                                                fontFamily: AppFonts.poppins,
                                                fontWeight: FontWeight
                                                    .w400, // Regular weight for the value
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      RichText(
                                        text: TextSpan(
                                          children: [
                                            TextSpan(
                                              text: "${S.of(context).balance} ",
                                              style: TextStyle(
                                                fontSize: width / 32,
                                                color: isDark
                                                    ? AppColors.kWhite
                                                    : AppColors.kBlack,
                                                fontFamily: AppFonts.poppins,
                                                fontWeight: FontWeight
                                                    .bold, // Bold for the label
                                              ),
                                            ),
                                            TextSpan(
                                              text: state
                                                  .appUsers[index].balance
                                                  .toString(),
                                              style: TextStyle(
                                                fontSize: width / 32,
                                                color: isDark
                                                    ? AppColors.kWhite
                                                    : AppColors.kBlack,
                                                fontFamily: AppFonts.poppins,
                                                fontWeight: FontWeight
                                                    .w400, // Regular weight for the value
                                              ),
                                            ),
                                          ],
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
                                        "tel:$kuwait${state.appUsers[index].phoneNumber}"),
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
                        ),
                      );
                    },
                  );
                },
              );
            } else if (state is UsersLoading) {
              return const CircularProgressIndicator();
            } else {
              return const SizedBox();
            }
          },
        ));
  }
}
