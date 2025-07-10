import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trustlaundry/models/app_user.dart';

import '../../constants/colors.dart';
import '../../constants/fonts.dart';
import '../../generated/l10n.dart';
import '../../logic/pdf/pdf.dart';
import '../../logic/sub_history/sub_history_cubit.dart';

class SubHistory extends StatefulWidget {
  const SubHistory({super.key});

  @override
  State<SubHistory> createState() => _SubHistoryState();
}

class _SubHistoryState extends State<SubHistory> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    BlocProvider.of<SubHistoryCubit>(context).getMySubs();
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
            S.of(context).mySubs,
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
      body: BlocBuilder<SubHistoryCubit, SubHistoryState>(
        builder: (context, state) {
          if (state is SubHistorySuccess) {
            return state.sub.isEmpty
                ? Center(
                    child: Text(
                      S.of(context).noSubs,
                      style: TextStyle(
                        fontSize: width / 30,
                        color: AppColors.kBlack,
                        fontFamily: AppFonts.poppins,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )
                : ListView.builder(
                    itemCount: state.sub.length,
                    itemBuilder: (context, index) {
                      return Container(
                        width: width,
                        margin: EdgeInsets.symmetric(
                            horizontal: width / 30, vertical: height / 120),
                        padding: EdgeInsets.all(width / 30),
                        decoration: BoxDecoration(
                          color: AppColors.kWhite,
                          boxShadow: const [
                            BoxShadow(
                              color: AppColors.kGreyForDivider,
                              blurRadius: 10,
                              spreadRadius: 0,
                            ),
                          ],
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Row(
                          
                          children: [
                            Text(
                              "${index + 1}",
                              style: TextStyle(
                                fontSize: width / 26,
                                color: AppColors.kBlack,
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
                                RichText(
                                  text: TextSpan(
                                    children: [
                                      TextSpan(
                                        text: "${S.of(context).date2} ",
                                        style: TextStyle(
                                          fontSize: width / 32,
                                          color: AppColors.kBlack,
                                          fontFamily: AppFonts.poppins,
                                          fontWeight: FontWeight
                                              .bold, // Bold for the label
                                        ),
                                      ),
                                      TextSpan(
                                        text: state.sub[index].timeStamp
                                            .toDate()
                                            .toString()
                                            .substring(0, 16),
                                        style: TextStyle(
                                          fontSize: width / 32,
                                          color: AppColors.kBlack,
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
                                        text: "${S.of(context).pay}: ",
                                        style: TextStyle(
                                          fontSize: width / 32,
                                          color: AppColors.kBlack,
                                          fontFamily: AppFonts.poppins,
                                          fontWeight: FontWeight
                                              .bold, // Bold for the label
                                        ),
                                      ),
                                      TextSpan(
                                        text:
                                            "${state.sub[index].pay.toString()} ${S.of(context).kwd}",
                                        style: TextStyle(
                                          fontSize: width / 32,
                                          color: AppColors.kBlack,
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
                                        text: "${S.of(context).get}: ",
                                        style: TextStyle(
                                          fontSize: width / 32,
                                          color: AppColors.kBlack,
                                          fontFamily: AppFonts.poppins,
                                          fontWeight: FontWeight
                                              .bold, // Bold for the label
                                        ),
                                      ),
                                      TextSpan(
                                        text:
                                            "${state.sub[index].get.toString()} ${S.of(context).kwd}",
                                        style: TextStyle(
                                          fontSize: width / 32,
                                          color: AppColors.kBlack,
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
                          //  Spacer(),
                            // GestureDetector(
                            //   onTap: () async {
                            //     // final data2 = await FirebaseFirestore.instance
                            //     //     .collection("users")
                            //     //     .doc(FirebaseAuth.instance.currentUser!.uid)
                            //     //     .get();

                            //  //   final user = AppUser.fromJson(data2.data()!);
                            //     // final pdf = await generateSubPdf(
                            //     //     state.sub[index], user);
                            //     // await sendEmailWithPDF(user.email, pdf);
                            //   },
                            //   child: Icon(
                            //     Icons.save,
                            //     size: width / 18,
                            //     color: AppColors.kPrimaryColor,
                            //   ),
                            // )
                          ],
                        ),
                      );
                    },
                  );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
