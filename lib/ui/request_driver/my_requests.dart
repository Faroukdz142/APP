import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:confirm_dialog/confirm_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../logic/language/language_cubit.dart';
import '../../logic/theme/theme_cubit.dart';
import '../../widgets/snack_bar.dart';
import '../../constants/colors.dart';
import '../../constants/fonts.dart';
import '../../generated/l10n.dart';
import '../../models/request.dart';

class MyRequests extends StatefulWidget {
  const MyRequests({super.key});

  @override
  State<MyRequests> createState() => _MyRequestsState();
}

class _MyRequestsState extends State<MyRequests> {
  List<Request> myRequests = [];
  bool isLoading = false;
  @override
  void initState() {
    super.initState();
    getMyRequests().then((v) {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        setState(() {
          startAnimation = true;
        });
      });
    });
  }

  Future<void> getMyRequests() async {
    isLoading = true;
    try {
      final requests = FirebaseFirestore.instance
          .collection("driverRequests")
          .where('userId', isEqualTo: FirebaseAuth.instance.currentUser!.uid);
      final data = await requests.get();
      for (var x in data.docs) {
        myRequests.add(Request.fromJson(x.data()));
      }
      isLoading = false;
      setState(() {});
    } catch (e) {
      CustomSnackBar.show(context, S.of(context).tryAgain, AppColors.kRed);
    }
  }

  bool startAnimation = false;

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
              S.of(context).myRequests,
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
              width: width / 20,
            ),
          ],
        ),
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : myRequests.isEmpty
              ? Center(
                  child: Text(
                    S.of(context).noDriverRequests,
                    style: TextStyle(
                      fontSize: width / 30,
                      fontFamily: AppFonts.poppins,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.only(top: 8),
                  itemCount: myRequests.length,
                  itemBuilder: (context, index) {
                    return StreamBuilder<DocumentSnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection("driverRequests")
                            .doc(myRequests[index].id)
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return BlocBuilder<ThemeCubit, bool>(
                              builder: (context, isDark) {
                                return AnimatedContainer(
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
                                  curve: Curves.easeInToLinear,
                                  duration: Duration(
                                      milliseconds: 100 + (index * 100)),
                                  transform: Matrix4.translationValues(
                                      startAnimation ? 0 : width, 0, 0),
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
                                                          "${S.of(context).reqId} ",
                                                      style: TextStyle(
                                                        fontSize: width / 32,
                                                        color: isDark
                                                            ? AppColors.kWhite
                                                            : AppColors.kBlack,
                                                        fontFamily:
                                                            AppFonts.poppins,
                                                        fontWeight: FontWeight
                                                            .bold, // Bold for the label
                                                      ),
                                                    ),
                                                    TextSpan(
                                                      text:
                                                          "${myRequests[index].id}",
                                                      style: TextStyle(
                                                        fontSize: width / 32,
                                                        color: isDark
                                                            ? AppColors.kWhite
                                                            : AppColors.kBlack,
                                                        fontFamily:
                                                            AppFonts.poppins,
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
                                                          "${S.of(context).date2} ",
                                                      style: TextStyle(
                                                        fontSize: width / 32,
                                                        color: isDark
                                                            ? AppColors.kWhite
                                                            : AppColors.kBlack,
                                                        fontFamily:
                                                            AppFonts.poppins,
                                                        fontWeight: FontWeight
                                                            .bold, // Bold for the label
                                                      ),
                                                    ),
                                                    TextSpan(
                                                      text: myRequests[index]
                                                          .date,
                                                      style: TextStyle(
                                                        fontSize: width / 32,
                                                        color: isDark
                                                            ? AppColors.kWhite
                                                            : AppColors.kBlack,
                                                        fontFamily:
                                                            AppFonts.poppins,
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
                                                          "${S.of(context).period} ",
                                                      style: TextStyle(
                                                        fontSize: width / 32,
                                                        color: isDark
                                                            ? AppColors.kWhite
                                                            : AppColors.kBlack,
                                                        fontFamily:
                                                            AppFonts.poppins,
                                                        fontWeight: FontWeight
                                                            .bold, // Bold for the label
                                                      ),
                                                    ),
                                                    TextSpan(
                                                      text: myRequests[index]
                                                          .period,
                                                      style: TextStyle(
                                                        fontSize: width / 32,
                                                        color: isDark
                                                            ? AppColors.kWhite
                                                            : AppColors.kBlack,
                                                        fontFamily:
                                                            AppFonts.poppins,
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
                                                          "${S.of(context).status} ",
                                                      style: TextStyle(
                                                        fontSize: width / 32,
                                                        color: isDark
                                                            ? AppColors.kWhite
                                                            : AppColors.kBlack,
                                                        fontFamily:
                                                            AppFonts.poppins,
                                                        fontWeight: FontWeight
                                                            .bold, // Bold for the label
                                                      ),
                                                    ),
                                                    TextSpan(
                                                      text: getString(
                                                          myRequests[index]
                                                              .status),
                                                      style: TextStyle(
                                                        fontSize: width / 32,
                                                        color: isDark
                                                            ? AppColors.kWhite
                                                            : AppColors.kBlack,
                                                        fontFamily:
                                                            AppFonts.poppins,
                                                        fontWeight: FontWeight
                                                            .w400, // Regular weight for the value
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                               if (myRequests[index].address.isExact) ...[
      RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: S.of(context).latitude,
              style: TextStyle(
                fontSize: width / 32,
                color: isDark ? AppColors.kWhite : AppColors.kBlack,
                fontFamily: AppFonts.poppins,
                fontWeight: FontWeight.bold,
              ),
            ),
            TextSpan(
              text: myRequests[index].address.lat?.toString() ?? S.of(context).notAvailable,
              style: TextStyle(
                fontSize: width / 32,
                color: isDark ? AppColors.kWhite : AppColors.kBlack,
                fontFamily: AppFonts.poppins,
              ),
            ),
          ],
        ),
      ),
      RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: S.of(context).longitude,
              style: TextStyle(
                fontSize: width / 32,
                color: isDark ? AppColors.kWhite : AppColors.kBlack,
                fontFamily: AppFonts.poppins,
                fontWeight: FontWeight.bold,
              ),
            ),
            TextSpan(
              text: myRequests[index].address.lng?.toString() ?? S.of(context).notAvailable,
              style: TextStyle(
                fontSize: width / 32,
                color: isDark ? AppColors.kWhite : AppColors.kBlack,
                fontFamily: AppFonts.poppins,
              ),
            ),
          ],
        ),
      ),
    ] else ...[
      // Address details case (apartment, building, street, etc.)
      RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: S.of(context).addressTitle,
              style: TextStyle(
                fontSize: width / 32,
                color: isDark ? AppColors.kWhite : AppColors.kBlack,
                fontFamily: AppFonts.poppins,
                fontWeight: FontWeight.bold,
              ),
            ),
            TextSpan(
              text: myRequests[index].address.addressTitle,
              style: TextStyle(
                fontSize: width / 32,
                color: isDark ? AppColors.kWhite : AppColors.kBlack,
                fontFamily: AppFonts.poppins,
              ),
            ),
          ],
        ),
      ),
      if (myRequests[index].address.area != null)
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: S.of(context).area,
                style: TextStyle(
                  fontSize: width / 32,
                  color: isDark ? AppColors.kWhite : AppColors.kBlack,
                  fontFamily: AppFonts.poppins,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextSpan(
                text: myRequests[index].address.area!,
                style: TextStyle(
                  fontSize: width / 32,
                  color: isDark ? AppColors.kWhite : AppColors.kBlack,
                  fontFamily: AppFonts.poppins,
                ),
              ),
            ],
          ),
        ),
      if (myRequests[index].address.street != null)
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: S.of(context).street,
                style: TextStyle(
                  fontSize: width / 32,
                  color: isDark ? AppColors.kWhite : AppColors.kBlack,
                  fontFamily: AppFonts.poppins,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextSpan(
                text: myRequests[index].address.street!,
                style: TextStyle(
                  fontSize: width / 32,
                  color: isDark ? AppColors.kWhite : AppColors.kBlack,
                  fontFamily: AppFonts.poppins,
                ),
              ),
            ],
          ),
        ),
      if (myRequests[index].address.building != null)
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: S.of(context).building,
                style: TextStyle(
                  fontSize: width / 32,
                  color: isDark ? AppColors.kWhite : AppColors.kBlack,
                  fontFamily: AppFonts.poppins,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextSpan(
                text: myRequests[index].address.building!,
                style: TextStyle(
                  fontSize: width / 32,
                  color: isDark ? AppColors.kWhite : AppColors.kBlack,
                  fontFamily: AppFonts.poppins,
                ),
              ),
            ],
          ),
        ),
      if (myRequests[index].address.apartmentNum != null)
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: S.of(context).apartmentNum,
                style: TextStyle(
                  fontSize: width / 32,
                  color: isDark ? AppColors.kWhite : AppColors.kBlack,
                  fontFamily: AppFonts.poppins,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextSpan(
                text: myRequests[index].address.apartmentNum!,
                style: TextStyle(
                  fontSize: width / 32,
                  color: isDark ? AppColors.kWhite : AppColors.kBlack,
                  fontFamily: AppFonts.poppins,
                ),
              ),
            ],
          ),
        ),
    ],
                                            ],
                                          ),
                                        ],
                                      ),
                                      GestureDetector(
                                        onTap: () async {
                                          if (await confirm(
                                            context,
                                            canPop: true,
                                            content: Text(
                                              S.of(context).cancelRequestSure,
                                              style: TextStyle(
                                                fontSize: width / 30,
                                                fontFamily: AppFonts.poppins,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          )) {
                                            cancelRequest(
                                                id: myRequests[index].id);
                                          }
                                        },
                                        child: Icon(
                                          Icons.close,
                                          size: width / 16,
                                          color: AppColors.kRed,
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            );
                          } else {
                            return const SizedBox();
                          }
                        });
                  },
                ),
    );
  }

  String getString(String string) {
    if (string == "Placed") {
      return S.of(context).placed;
    } else if (string == "In Progress") {
      return S.of(context).inProg;
    } else if (string == "Done") {
      return S.of(context).done;
    }
    return string;
  }

  Future<bool> cancelRequest({
    required String id,
  }) async {
    try {
      await FirebaseFirestore.instance
          .collection("driverRequests")
          .doc(id)
          .delete();
      setState(() {
        myRequests.removeWhere(
          (element) => element.id == id,
        );
      });
      CustomSnackBar.show(
          context, S.of(context).reqCancelled, AppColors.kGreen);
      return true;
    } catch (e) {
      CustomSnackBar.show(context, S.of(context).tryAgain, AppColors.kRed);
      return false;
    }
  }
}
