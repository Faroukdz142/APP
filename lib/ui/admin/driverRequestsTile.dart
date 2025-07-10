import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:confirm_dialog/confirm_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ionicons/ionicons.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:trustlaundry/logic/pdf/pdf.dart';
import 'package:trustlaundry/models/app_user.dart';
import '../../constants/strings.dart';
import '../../logic/theme/theme_cubit.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../constants/colors.dart';
import '../../constants/fonts.dart';
import '../../generated/l10n.dart';
import '../../logic/admin_orders/admin_orders_cubit.dart';
import '../../models/request.dart';
import '../../widgets/snack_bar.dart';

class DriverRequestsTile extends StatefulWidget {
  final int index;
  final Function cancel;
  final Function updateUi;
  final Request myRequest;
  const DriverRequestsTile(
      {super.key,
      required this.updateUi,
      required this.cancel,
      required this.myRequest,
      required this.index});

  @override
  State<DriverRequestsTile> createState() => _DriverRequestsTileState();
}

class _DriverRequestsTileState extends State<DriverRequestsTile> {
  bool isLoading2 = false;
  String email = "";
  String phoneNum = "";
  final List<String> _statuses = ['Placed', 'In Progress', "Done"];
  late String currentStatus;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getInfo();
    currentStatus = widget.myRequest.status;
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return BlocBuilder<ThemeCubit, bool>(
      builder: (context, isDark) {
        return Container(
          width: width,
          margin: EdgeInsets.symmetric(
              horizontal: width / 30, vertical: height / 120),
          padding: EdgeInsets.all(width / 30),
          decoration: BoxDecoration(
            color: isDark ? AppColors.kBlueLight : AppColors.kWhite,
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
                    "${widget.index + 1}",
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
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: "${S.of(context).email}:  ",
                              style: TextStyle(
                                fontSize: width / 32,
                                color: isDark
                                    ? AppColors.kWhite
                                    : AppColors.kBlack,
                                fontFamily: AppFonts.poppins,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            TextSpan(
                              text: email,
                              style: TextStyle(
                                fontSize: width / 32,
                                color: isDark
                                    ? AppColors.kWhite
                                    : AppColors.kBlack,
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
                              text: "${S.of(context).phoneNumber}:         ",
                              style: TextStyle(
                                fontSize: width / 32,
                                color: isDark
                                    ? AppColors.kWhite
                                    : AppColors.kBlack,
                                fontFamily: AppFonts.poppins,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            TextSpan(
                              text: "965$phoneNum+",
                              style: TextStyle(
                                fontSize: width / 32,
                                color: isDark
                                    ? AppColors.kWhite
                                    : AppColors.kBlack,
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
                              text: S.of(context).reqDT,
                              style: TextStyle(
                                fontSize: width / 32,
                                color: isDark
                                    ? AppColors.kWhite
                                    : AppColors.kBlack,
                                fontFamily: AppFonts.poppins,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            TextSpan(
                              text:
                                  "${widget.myRequest.timeStamp.toDate().toString().substring(0, 10)} ${S.of(context).at}${widget.myRequest.timeStamp.toDate().toString().substring(11, 16)}",
                              style: TextStyle(
                                fontSize: width / 32,
                                color: isDark
                                    ? AppColors.kWhite
                                    : AppColors.kBlack,
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
                              text: S.of(context).date2,
                              style: TextStyle(
                                fontSize: width / 32,
                                color: isDark
                                    ? AppColors.kWhite
                                    : AppColors.kBlack,
                                fontFamily: AppFonts.poppins,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            TextSpan(
                              text: widget.myRequest.date,
                              style: TextStyle(
                                fontSize: width / 32,
                                color: isDark
                                    ? AppColors.kWhite
                                    : AppColors.kBlack,
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
                              text: S.of(context).period,
                              style: TextStyle(
                                fontSize: width / 32,
                                color: isDark
                                    ? AppColors.kWhite
                                    : AppColors.kBlack,
                                fontFamily: AppFonts.poppins,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            TextSpan(
                              text: widget.myRequest.period,
                              style: TextStyle(
                                fontSize: width / 32,
                                color: isDark
                                    ? AppColors.kWhite
                                    : AppColors.kBlack,
                                fontFamily: AppFonts.poppins,
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (widget.myRequest.address.isExact) ...[
                        RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: S.of(context).latitude,
                                style: TextStyle(
                                  fontSize: width / 32,
                                  color: isDark
                                      ? AppColors.kWhite
                                      : AppColors.kBlack,
                                  fontFamily: AppFonts.poppins,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              TextSpan(
                                text:
                                    widget.myRequest.address.lat?.toString() ??
                                        S.of(context).notAvailable,
                                style: TextStyle(
                                  fontSize: width / 32,
                                  color: isDark
                                      ? AppColors.kWhite
                                      : AppColors.kBlack,
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
                                  color: isDark
                                      ? AppColors.kWhite
                                      : AppColors.kBlack,
                                  fontFamily: AppFonts.poppins,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              TextSpan(
                                text:
                                    widget.myRequest.address.lng?.toString() ??
                                        S.of(context).notAvailable,
                                style: TextStyle(
                                  fontSize: width / 32,
                                  color: isDark
                                      ? AppColors.kWhite
                                      : AppColors.kBlack,
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
                                  color: isDark
                                      ? AppColors.kWhite
                                      : AppColors.kBlack,
                                  fontFamily: AppFonts.poppins,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              TextSpan(
                                text: widget.myRequest.address.addressTitle,
                                style: TextStyle(
                                  fontSize: width / 32,
                                  color: isDark
                                      ? AppColors.kWhite
                                      : AppColors.kBlack,
                                  fontFamily: AppFonts.poppins,
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (widget.myRequest.address.area != null)
                          RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: S.of(context).area,
                                  style: TextStyle(
                                    fontSize: width / 32,
                                    color: isDark
                                        ? AppColors.kWhite
                                        : AppColors.kBlack,
                                    fontFamily: AppFonts.poppins,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                TextSpan(
                                  text: widget.myRequest.address.area!,
                                  style: TextStyle(
                                    fontSize: width / 32,
                                    color: isDark
                                        ? AppColors.kWhite
                                        : AppColors.kBlack,
                                    fontFamily: AppFonts.poppins,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        if (widget.myRequest.address.street != null)
                          RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: S.of(context).street,
                                  style: TextStyle(
                                    fontSize: width / 32,
                                    color: isDark
                                        ? AppColors.kWhite
                                        : AppColors.kBlack,
                                    fontFamily: AppFonts.poppins,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                TextSpan(
                                  text: widget.myRequest.address.street!,
                                  style: TextStyle(
                                    fontSize: width / 32,
                                    color: isDark
                                        ? AppColors.kWhite
                                        : AppColors.kBlack,
                                    fontFamily: AppFonts.poppins,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        if (widget.myRequest.address.building != null)
                          RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: S.of(context).building,
                                  style: TextStyle(
                                    fontSize: width / 32,
                                    color: isDark
                                        ? AppColors.kWhite
                                        : AppColors.kBlack,
                                    fontFamily: AppFonts.poppins,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                TextSpan(
                                  text: widget.myRequest.address.building!,
                                  style: TextStyle(
                                    fontSize: width / 32,
                                    color: isDark
                                        ? AppColors.kWhite
                                        : AppColors.kBlack,
                                    fontFamily: AppFonts.poppins,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        if (widget.myRequest.address.apartmentNum != null)
                          RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: S.of(context).apartmentNum,
                                  style: TextStyle(
                                    fontSize: width / 32,
                                    color: isDark
                                        ? AppColors.kWhite
                                        : AppColors.kBlack,
                                    fontFamily: AppFonts.poppins,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                TextSpan(
                                  text: widget.myRequest.address.apartmentNum!,
                                  style: TextStyle(
                                    fontSize: width / 32,
                                    color: isDark
                                        ? AppColors.kWhite
                                        : AppColors.kBlack,
                                    fontFamily: AppFonts.poppins,
                                  ),
                                ),
                              ],
                            ),
                          ),
                      ],
                      SizedBox(
                        height: height / 60,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          GestureDetector(
                              onTap: () async {
                                if (await confirm(
                                  context,
                                  canPop: true,
                                  content: Text(
                                    S.of(context).sureContinue,
                                    style: TextStyle(
                                      fontSize: width / 30,
                                      fontFamily: AppFonts.poppins,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                )) {
                                  //send notification that driver sent
                                  final isDone = await widget.cancel(
                                      id: widget.myRequest.id);
                                  if (isDone) {
                                    CustomSnackBar.show(
                                        context,
                                        S.of(context).reqCancelled,
                                        AppColors.kGreen);
                                  } else {
                                    CustomSnackBar.show(context,
                                        S.of(context).tryAgain, AppColors.kRed);
                                  }
                                } else {}
                              },
                              child: Icon(
                                Ionicons.close,
                                color: AppColors.kRed,
                                size: width / 18,
                              )),
                          SizedBox(
                            width: width / 30,
                          ),
                          DropdownButton<String>(
                            value: currentStatus,
                            icon: Icon(
                              Icons.arrow_downward,
                              color: isDark
                                  ? AppColors.kWhite
                                  : AppColors.kBlueLight,
                              size: width / 18,
                            ),
                            elevation: 16,
                            style: TextStyle(
                              fontSize: width / 32,
                              color: isDark
                                  ? AppColors.kWhite
                                  : AppColors.kBlueLight,
                              fontFamily: AppFonts.poppins,
                              fontWeight: FontWeight.bold,
                            ),
                            underline: Container(
                              height: 2,
                              color: isDark
                                  ? AppColors.kWhite
                                  : AppColors.kBlueLight,
                            ),
                            onChanged: (String? newValue) async {
                              if (await confirm(
                                context,
                                canPop: true,
                                content: Text(
                                  S.of(context).sureContinue,
                                  style: TextStyle(
                                    fontSize: width / 30,
                                    fontFamily: AppFonts.poppins,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              )) {
                                //send notification that driver sent
                                try {
                                  setState(() {
                                    isLoading2 = true;
                                  });
                                  await FirebaseFirestore.instance
                                      .collection("driverRequests")
                                      .doc(widget.myRequest.id)
                                      .update({
                                    "status": newValue,
                                  });
                                  currentStatus = newValue!;
                                  widget.updateUi();
                                  widget.myRequest.status = newValue;
                                  final doc = await FirebaseFirestore.instance
                                      .collection("users")
                                      .doc(widget.myRequest.userId)
                                      .collection("notifications")
                                      .add({
                                    "titleEn": widget.myRequest.status ==
                                            "In Progress"
                                        ? "Driver sent ${widget.myRequest.id} "
                                        : "Done ${widget.myRequest.id}",
                                    "contentEn":
                                        widget.myRequest.status == "In Progress"
                                            ? "The driver will arrive soon"
                                            : "Your order will arrive soon",
                                    "titleAr": widget.myRequest.status ==
                                            "In Progress"
                                        ? "${widget.myRequest.id} طلبك قيد الاجراء"
                                        : "${widget.myRequest.id} تم اجراء طلبك",
                                    "contentAr":
                                        widget.myRequest.status == "In Progress"
                                            ? "سيتم ارسال سائق قريبا"
                                            : "سيتم توصيل طلبك قريبا",
                                    "receipientId": widget.myRequest.userId,
                                    "timeStamp": DateTime.now()
                                  });

                                  await FirebaseFirestore.instance
                                      .collection("users")
                                      .doc(widget.myRequest.userId)
                                      .collection("notifications")
                                      .doc(doc.id)
                                      .update({
                                    "id": doc.id,
                                  });

                                  setState(() {
                                    isLoading2 = false;
                                  });
                                  CustomSnackBar.show(
                                    context,
                                    S.of(context).notifSent,
                                    AppColors.kGreen,
                                  );
                                } catch (e) {
                                  print(e.toString());
                                  CustomSnackBar.show(
                                    context,
                                    S.of(context).tryAgain,
                                    AppColors.kRed,
                                  );
                                }
                              }
                            },
                            items: _statuses
                                .map<DropdownMenuItem<String>>((String status) {
                              return DropdownMenuItem<String>(
                                value: status,
                                child: Text(getString(status)),
                              );
                            }).toList(),
                          ),
                          SizedBox(
                            width: width / 10,
                          ),
                          GestureDetector(
                            onTap: () async {
                              await launchUrl(
                                Uri.parse("tel:$kuwait$phoneNum"),
                              );
                            },
                            child: Icon(
                              Ionicons.call,
                              size: width / 14,
                              color: AppColors.kBlueLight,
                            ),
                          ),
                          SizedBox(
                            width: width / 15,
                          ),
                          GestureDetector(
                            onTap: () async {
                              String phone = "";
                              final data = await FirebaseFirestore.instance
                                  .collection("users")
                                  .doc(FirebaseAuth.instance.currentUser!.uid)
                                  .get();
                              phone = data.data()!["phoneNumber"];
                              Clipboard.setData(
                                ClipboardData(text: '''
Title: ${widget.myRequest.address.addressTitle}
Area: ${widget.myRequest.address.area ?? "Not Available"}
Street: ${widget.myRequest.address.street ?? "Not Available"}
Building: ${widget.myRequest.address.building ?? "Not Available"}
Apartment Number: ${widget.myRequest.address.apartmentNum ?? "Not Available"}
Phone Number: +965$phone"}
'''),
                              );

                              CustomSnackBar.show(
                                  context,
                                  S.of(context).copiedToClipboard,
                                  AppColors.kGreen);
                            },
                            child: Icon(
                              Ionicons.locate,
                              size: width / 14,
                              color: AppColors.kBlueLight,
                            ),
                          ),
                          SizedBox(
                            width: width / 30,
                          ),
                          // GestureDetector(
                          //   onTap: () async {
                          //     final data = await FirebaseFirestore.instance
                          //         .collection("users")
                          //         .doc(widget.myRequest.userId)
                          //         .get();
                          //     final user = AppUser.fromJson(data.data()!);
                          //     handleDriverOrderSharing(
                          //         widget.myRequest, user);
                          //   },
                          //   child: Icon(
                          //     Ionicons.share_social,
                          //     size: width / 14,
                          //     color: AppColors.kBlueLight,
                          //   ),
                          // ),
                        ],
                      )
                    ],
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> getInfo() async {
    final doc = await FirebaseFirestore.instance
        .collection("users")
        .doc(widget.myRequest.userId)
        .get();
    setState(() {
      phoneNum = doc.data()!["phoneNumber"];
      email = doc.data()!["email"];
    });
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
}
