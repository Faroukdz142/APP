import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:confirm_dialog/confirm_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ionicons/ionicons.dart';
import '../../constants/strings.dart';
import '../../logic/admin_orders/admin_orders_cubit.dart';
import '../../logic/language/language_cubit.dart';
import '../../logic/theme/theme_cubit.dart';
import '../../models/app_user.dart';
import '../../models/my_address.dart';
import '../../models/order.dart';
import 'manage_items/laundry_admin.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../constants/colors.dart';
import '../../constants/fonts.dart';
import '../../generated/l10n.dart';
import '../../logic/pdf/pdf.dart';
import '../../widgets/snack_bar.dart';

class OrderTile extends StatefulWidget {
  final UserOrder order;
  final int index;
  const OrderTile({super.key, required this.order, required this.index});

  @override
  State<OrderTile> createState() => _OrderTileState();
}

class _OrderTileState extends State<OrderTile> {
  late String _currentStatus;

  // List of order statuses
  final List<String> _statuses = [
    'Placed',
    'In Progress',
    'Out for delivery',
    "Done",
  ];

  @override
  void initState() {
    super.initState();
    // Initialize the current status with the initial status
    _currentStatus = widget.order.status;
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              contentPadding: EdgeInsets.zero,
              title: Text(
                S.of(context).items,
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
                  itemCount: widget.order.subItems.length,
                  itemBuilder: (context, indexForSubItems) {
                    final subItem = widget.order.subItems[indexForSubItems];
                    return ListTile(
                      title: BlocBuilder<LanguageCubit, String>(
                        builder: (context, state) {
                          return Text(
                            "${indexForSubItems + 1}- ${state == "ar" ? subItem.titleAr : subItem.titleEn}",
                            style: TextStyle(
                              fontSize: width / 30,
                              fontFamily: AppFonts.poppins,
                              fontWeight: FontWeight.bold,
                            ),
                          );
                        },
                      ), // Display Arabic title
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '    ${S.of(context).price}: ${subItem.price.toStringAsFixed(2)} ${S.of(context).kwd} * ',
                            style: TextStyle(
                              fontSize: width / 30,
                              fontFamily: AppFonts.poppins,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            '    ${S.of(context).quantity}: ${subItem.quantity}',
                            style: TextStyle(
                              fontSize: width / 30,
                              fontFamily: AppFonts.poppins,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          BlocBuilder<LanguageCubit, String>(
                            builder: (context, state) {
                              return Text(
                                '    ${S.of(context).service} ${state == "ar" ? subItem.laundryTypeAr : subItem.laundryTypeEn}',
                                style: TextStyle(
                                  fontSize: width / 30,
                                  fontFamily: AppFonts.poppins,
                                  fontWeight: FontWeight.bold,
                                ),
                              );
                            },
                          )
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
      child: BlocBuilder<ThemeCubit, bool>(
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
                        blurRadius: 2,
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
                    SizedBox(
                      width: width * .7,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: S.of(context).orderId,
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
                                  text: "#",
                                  style: TextStyle(
                                    fontSize: width / 32,
                                    color: isDark
                                        ? AppColors.kWhite
                                        : AppColors.kBlack,
                                    fontFamily: AppFonts.poppins,
                                  ),
                                ),
                                TextSpan(
                                  text: widget.order.id,
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
                          const SizedBox(
                            height: 5,
                          ),
                          RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: S.of(context).paymentStatus,
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
                                      "${widget.order.didPay ? S.of(context).done : S.of(context).notPayed} (${widget.order.paymentMethod.toString().split(".").last})",
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
                          widget.order.paymentId != null
                              ? RichText(
                                  text: TextSpan(
                                    children: [
                                      TextSpan(
                                        text: S.of(context).paymentId,
                                        style: TextStyle(
                                          fontSize: width / 32,
                                          fontFamily: AppFonts.poppins,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      TextSpan(
                                        text: "#${widget.order.paymentId}",
                                        style: TextStyle(
                                          fontSize: width / 32,
                                          fontFamily: AppFonts.poppins,
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              : const SizedBox(),
                          RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: S.of(context).amount,
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
                                      "${widget.order.price.toStringAsFixed(2)} ${S.of(context).kwd}",
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
                                  text: S.of(context).orderDateAndTime,
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
                                      "${widget.order.timeStamp.toDate().toString().substring(0, 10)} ${S.of(context).at} ${widget.order.timeStamp.toDate().toString().substring(11, 16)}",
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
                                  text: S.of(context).numberOfItems,
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
                                      "${widget.order.subItems.length} ${S.of(context).item}",
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
                          // Check if the address is exact (latitude and longitude provided)
                          if (widget.order.address!.isExact) ...[
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
                                        widget.order.address!.lat?.toString() ??
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
                                        widget.order.address!.lng?.toString() ??
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
                                    text: widget.order.address!.addressTitle,
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
                            if (widget.order.address!.area != null)
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
                                      text: widget.order.address!.area!,
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
                            if (widget.order.address!.street != null)
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
                                      text: widget.order.address!.street!,
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
                            if (widget.order.address!.building != null)
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
                                      text: widget.order.address!.building!,
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
                            if (widget.order.address!.apartmentNum != null)
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
                                      text: widget.order.address!.apartmentNum!,
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
                          const SizedBox(
                            height: 5,
                          ),
                          RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: "${S.of(context).specialInstructions}:",
                                  style: TextStyle(
                                    fontSize: width / 32,
                                    color: isDark
                                        ? AppColors.kWhite
                                        : AppColors.kBlack,
                                    fontFamily: AppFonts.poppins,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            width: width * .75,
                            child: Text(
                              "    -> ${widget.order.instructions}",
                              style: TextStyle(
                                fontSize: width / 32,
                                fontFamily: AppFonts.poppins,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: height / 120,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              GestureDetector(
                                onTap: () async {
                                  if (widget.order.address!.isExact) {
                                    Clipboard.setData(ClipboardData(
                                        text:
                                            'https://www.google.com/maps/dir/?api=1&destination=${widget.order.address!.lat},${widget.order.address!.lng}'));
                                  } else {
                                    String phone = "";
                                    final data = await FirebaseFirestore
                                        .instance
                                        .collection("users")
                                        .doc(FirebaseAuth
                                            .instance.currentUser!.uid)
                                        .get();
                                    phone = data.data()!["phoneNumber"];
                                    Clipboard.setData(
                                      ClipboardData(text: '''
Title: ${widget.order.address!.addressTitle}
Area: ${widget.order.address!.area ?? "Not Available"}
Street: ${widget.order.address!.street ?? "Not Available"}
Building: ${widget.order.address!.building ?? "Not Available"}
Apartment Number: ${widget.order.address!.apartmentNum ?? "Not Available"}
Phone Number: +965$phone"}
'''),
                                    );
                                  }
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
                              GestureDetector(
                                onTap: () async {
                                  final data = await FirebaseFirestore.instance
                                      .collection("users")
                                      .doc(widget.order.userId)
                                      .get();
                                  final phoneNumber =
                                      data.data()!["phoneNumber"];
                                  await launchUrl(
                                    Uri.parse("tel:$kuwait$phoneNumber"),
                                  );
                                },
                                child: Icon(
                                  Ionicons.call,
                                  size: width / 18,
                                  color: isDark
                                      ? AppColors.kWhite
                                      : AppColors.kBlueLight,
                                ),
                              ),
                              DropdownButton<String>(
                                value: _currentStatus,
                                icon: Icon(
                                  Icons.arrow_downward,
                                  size: width / 18,
                                  color: isDark
                                      ? AppColors.kWhite
                                      : AppColors.kBlueLight,
                                ),
                                elevation: 16,
                                style: TextStyle(
                                  fontSize: width / 32,
                                  fontFamily: AppFonts.poppins,
                                  color: isDark
                                      ? AppColors.kWhite
                                      : AppColors.kBlueLight,
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
                                    BlocProvider.of<AdminOrdersCubit>(context)
                                        .getUpdatedOrders();
                                    setState(() {
                                      widget.order.status = newValue!;
                                      _currentStatus = newValue;
                                    });
                                    // Trigger the callback function to handle the status change
                                    await FirebaseFirestore.instance
                                        .collection("orders")
                                        .doc(widget.order.id)
                                        .update({"status": newValue});

                                    final doc = await FirebaseFirestore.instance
                                        .collection("users")
                                        .doc(widget.order.userId)
                                        .collection("notifications")
                                        .add({
                                      "titleEn": "$newValue",
                                      "titleAr": getString(_currentStatus),
                                      "contentEn":
                                          "Congrats your order  ${widget.order.id} is $newValue ",
                                      "contentAr":
                                          "${getString(_currentStatus)} ${widget.order.id}",
                                      "receipientId": widget.order.userId,
                                      "timeStamp": Timestamp.now()
                                    });
                                    await FirebaseFirestore.instance
                                        .collection("users")
                                        .doc(widget.order.userId)
                                        .collection("notifications")
                                        .doc(doc.id)
                                        .update({
                                      "id": doc.id,
                                    });
                                    CustomSnackBar.show(
                                      context,
                                      S.of(context).notifSent,
                                      AppColors.kGreen,
                                    );
                                  }
                                },
                                items: _statuses.map<DropdownMenuItem<String>>(
                                    (String status) {
                                  return DropdownMenuItem<String>(
                                    value: status,
                                    child: Text(getString(status)),
                                  );
                                }).toList(),
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
    ;
  }

  String getString(String string) {
    if (string == "Placed") {
      return S.of(context).placed;
    } else if (string == "In Progress") {
      return S.of(context).inProg;
    } else if (string == "Out for delivery") {
      return S.of(context).outForDelivery;
    } else if (string == "Done") {
      return S.of(context).done;
    }
    return string;
  }
}
