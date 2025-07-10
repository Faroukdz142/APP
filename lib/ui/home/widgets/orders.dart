import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:confirm_dialog/confirm_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:trustlaundry/logic/balance/balance_cubit.dart';
import 'package:trustlaundry/ui/order/order.dart';
import '../../../logic/language/language_cubit.dart';
import '../../../logic/order/order_cubit.dart';
import '../../../logic/theme/theme_cubit.dart';
import '../../admin/manage_items/laundry_admin.dart';
import '../../laundry/func.dart';
import '../../../widgets/snack_bar.dart';
import 'package:widget_and_text_animator/widget_and_text_animator.dart';

import '../../../constants/colors.dart';
import '../../../constants/fonts.dart';
import '../../../generated/l10n.dart';

class OrdersWidget extends StatefulWidget {
  const OrdersWidget({super.key});

  @override
  State<OrdersWidget> createState() => _OrdersWidgetState();
}

class _OrdersWidgetState extends State<OrdersWidget> {
  bool startAnimation = false;
  @override
  void initState() {
    super.initState();
    BlocProvider.of<OrderCubit>(context).getMyOrders().then((v) {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        setState(() {
          startAnimation = true;
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return BlocBuilder<OrderCubit, OrderState>(
      builder: (context, state) {
        if (state is OrderSuccess) {
          return state.orders.isEmpty
              ? Center(
                  child: Text(
                    S.of(context).noOrders,
                    style: TextStyle(
                      fontSize: width / 30,
                      color: AppColors.kBlack,
                      fontFamily: AppFonts.poppins,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.only(top: 8),
                  itemCount: state.orders.length,
                  itemBuilder: (context, indexForOrders) {
                    return StreamBuilder<DocumentSnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection("orders")
                            .doc(state.orders[indexForOrders].id)
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            final status = snapshot.data!.data();

                            return BlocBuilder<ThemeCubit, bool>(
                              builder: (context, isDark) {
                                return GestureAnimator(
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
                                              itemCount: state
                                                  .orders[indexForOrders]
                                                  .subItems
                                                  .length,
                                              itemBuilder:
                                                  (context, indexForSubItems) {
                                                final subItem = state
                                                    .orders[indexForOrders]
                                                    .subItems[indexForSubItems];
                                                return ListTile(
                                                  title: BlocBuilder<
                                                      LanguageCubit, String>(
                                                    builder: (context, state) {
                                                      return Text(
                                                        "${indexForSubItems + 1}- ${state == "ar" ? subItem.titleAr : subItem.titleEn}",
                                                        style: TextStyle(
                                                          fontSize: width / 30,
                                                          fontFamily:
                                                              AppFonts.poppins,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      );
                                                    },
                                                  ), // Display Arabic title
                                                  subtitle: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        '    ${S.of(context).price}: ${subItem.price.toStringAsFixed(2)} ${S.of(context).kwd}',
                                                        style: TextStyle(
                                                          fontSize: width / 30,
                                                          fontFamily:
                                                              AppFonts.poppins,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                      Text(
                                                        '    ${S.of(context).quantity}: ${subItem.quantity}',
                                                        style: TextStyle(
                                                          fontSize: width / 30,
                                                          fontFamily:
                                                              AppFonts.poppins,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                      BlocBuilder<LanguageCubit,
                                                          String>(
                                                        builder:
                                                            (context, state) {
                                                          return Text(
                                                            '    ${S.of(context).service} ${state == "ar" ? subItem.laundryTypeAr : subItem.laundryTypeEn}',
                                                            style: TextStyle(
                                                              fontSize:
                                                                  width / 30,
                                                              fontFamily:
                                                                  AppFonts
                                                                      .poppins,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
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
                                                color:
                                                    AppColors.kGreyForDivider,
                                                blurRadius: 10,
                                                spreadRadius: 0,
                                              ),
                                            ],
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    child: BlocBuilder<LanguageCubit, String>(
                                      builder: (context, language) {
                                        return Stack(
                                          alignment: language == "en"
                                              ? Alignment.centerRight
                                              : Alignment.centerLeft,
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Row(
                                                  children: [
                                                    Text(
                                                      "${indexForOrders + 1}",
                                                      style: TextStyle(
                                                        fontSize: width / 26,
                                                        fontFamily:
                                                            AppFonts.poppins,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width: width / 20,
                                                    ),
                                                    Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        // RichText(
                                                        //   text: TextSpan(
                                                        //     children: [
                                                        //       TextSpan(
                                                        //         text: S
                                                        //             .of(context)
                                                        //             .orderId,
                                                        //         style: TextStyle(
                                                        //           fontSize:
                                                        //               width / 32,
                                                        //           color: isDark
                                                        //               ? AppColors
                                                        //                   .kWhite
                                                        //               : AppColors
                                                        //                   .kBlack,
                                                        //           fontFamily:
                                                        //               AppFonts
                                                        //                   .poppins,
                                                        //           fontWeight:
                                                        //               FontWeight
                                                        //                   .bold,
                                                        //         ),
                                                        //       ),
                                                        //       TextSpan(
                                                        //         text: "#",
                                                        //         style: TextStyle(
                                                        //           fontSize:
                                                        //               width / 32,
                                                        //           color: AppColors
                                                        //               .kRed,
                                                        //           fontFamily:
                                                        //               AppFonts
                                                        //                   .poppins,
                                                        //         ),
                                                        //       ),
                                                        //       TextSpan(
                                                        //         text: state
                                                        //             .orders[index]
                                                        //             .id,
                                                        //         style: TextStyle(
                                                        //           fontSize:
                                                        //               width / 32,
                                                        //           color: isDark
                                                        //               ? AppColors
                                                        //                   .kWhite
                                                        //               : AppColors
                                                        //                   .kBlack,
                                                        //           fontFamily:
                                                        //               AppFonts
                                                        //                   .poppins,
                                                        //         ),
                                                        //       ),
                                                        //     ],
                                                        //   ),
                                                        // ),
                                                        RichText(
                                                          text: TextSpan(
                                                            children: [
                                                              TextSpan(
                                                                text: S
                                                                    .of(context)
                                                                    .numberOfItems,
                                                                style:
                                                                    TextStyle(
                                                                  fontSize:
                                                                      width /
                                                                          32,
                                                                  color: isDark
                                                                      ? AppColors
                                                                          .kWhite
                                                                      : AppColors
                                                                          .kBlack,
                                                                  fontFamily:
                                                                      AppFonts
                                                                          .poppins,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                ),
                                                              ),
                                                              TextSpan(
                                                                text:
                                                                    "${state.orders[indexForOrders].subItems.length} ${S.of(context).item}",
                                                                style:
                                                                    TextStyle(
                                                                  fontSize:
                                                                      width /
                                                                          32,
                                                                  color: isDark
                                                                      ? AppColors
                                                                          .kWhite
                                                                      : AppColors
                                                                          .kBlack,
                                                                  fontFamily:
                                                                      AppFonts
                                                                          .poppins,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        RichText(
                                                          text: TextSpan(
                                                            children: [
                                                              TextSpan(
                                                                text: S
                                                                    .of(context)
                                                                    .orderDateAndTime,
                                                                style:
                                                                    TextStyle(
                                                                  fontSize:
                                                                      width /
                                                                          32,
                                                                  color: isDark
                                                                      ? AppColors
                                                                          .kWhite
                                                                      : AppColors
                                                                          .kBlack,
                                                                  fontFamily:
                                                                      AppFonts
                                                                          .poppins,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                ),
                                                              ),
                                                              TextSpan(
                                                                text: state
                                                                    .orders[
                                                                        indexForOrders]
                                                                    .pickUpDateAndTime,
                                                                style:
                                                                    TextStyle(
                                                                  fontSize:
                                                                      width /
                                                                          32,
                                                                  color: isDark
                                                                      ? AppColors
                                                                          .kWhite
                                                                      : AppColors
                                                                          .kBlack,
                                                                  fontFamily:
                                                                      AppFonts
                                                                          .poppins,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        RichText(
                                                          text: TextSpan(
                                                            children: [
                                                              TextSpan(
                                                                text: S
                                                                    .of(context)
                                                                    .status,
                                                                style:
                                                                    TextStyle(
                                                                  fontSize:
                                                                      width /
                                                                          32,
                                                                  color: isDark
                                                                      ? AppColors
                                                                          .kWhite
                                                                      : AppColors
                                                                          .kBlack,
                                                                  fontFamily:
                                                                      AppFonts
                                                                          .poppins,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                ),
                                                              ),
                                                              TextSpan(
                                                                text: getString(
                                                                    "${(status as Map)["status"]}"),
                                                                style:
                                                                    TextStyle(
                                                                  fontSize:
                                                                      width /
                                                                          32,
                                                                  color: isDark
                                                                      ? AppColors
                                                                          .kWhite
                                                                      : AppColors
                                                                          .kBlack,
                                                                  fontFamily:
                                                                      AppFonts
                                                                          .poppins,
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
                                                                text: S
                                                                    .of(context)
                                                                    .paymentStatus,
                                                                style:
                                                                    TextStyle(
                                                                  fontSize:
                                                                      width /
                                                                          32,
                                                                  color: isDark
                                                                      ? AppColors
                                                                          .kWhite
                                                                      : AppColors
                                                                          .kBlack,
                                                                  fontFamily:
                                                                      AppFonts
                                                                          .poppins,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                ),
                                                              ),
                                                              TextSpan(
                                                                text:
                                                                    "${state.orders[indexForOrders].didPay ? S.of(context).done : S.of(context).notPayed} (${state.orders[indexForOrders].paymentMethod.toString().split(".").last})",
                                                                style:
                                                                    TextStyle(
                                                                  fontSize:
                                                                      width /
                                                                          32,
                                                                  color: isDark
                                                                      ? AppColors
                                                                          .kWhite
                                                                      : AppColors
                                                                          .kBlack,
                                                                  fontFamily:
                                                                      AppFonts
                                                                          .poppins,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        state
                                                                .orders[
                                                                    indexForOrders]
                                                                .didPay
                                                            ? RichText(
                                                                text: TextSpan(
                                                                  children: [
                                                                    TextSpan(
                                                                      text: S
                                                                          .of(context)
                                                                          .paymentId,
                                                                      style:
                                                                          TextStyle(
                                                                        fontSize:
                                                                            width /
                                                                                32,
                                                                        color: isDark
                                                                            ? AppColors.kWhite
                                                                            : AppColors.kBlack,
                                                                        fontFamily:
                                                                            AppFonts.poppins,
                                                                        fontWeight:
                                                                            FontWeight.bold,
                                                                      ),
                                                                    ),
                                                                    TextSpan(
                                                                      text:
                                                                          "#${state.orders[indexForOrders].paymentId}",
                                                                      style:
                                                                          TextStyle(
                                                                        fontSize:
                                                                            width /
                                                                                32,
                                                                        color: isDark
                                                                            ? AppColors.kWhite
                                                                            : AppColors.kBlack,
                                                                        fontFamily:
                                                                            AppFonts.poppins,
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
                                                                text: S
                                                                    .of(context)
                                                                    .amount,
                                                                style:
                                                                    TextStyle(
                                                                  fontSize:
                                                                      width /
                                                                          32,
                                                                  color: isDark
                                                                      ? AppColors
                                                                          .kWhite
                                                                      : AppColors
                                                                          .kBlack,
                                                                  fontFamily:
                                                                      AppFonts
                                                                          .poppins,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                ),
                                                              ),
                                                              TextSpan(
                                                                text:
                                                                    "${state.orders[indexForOrders].price.toStringAsFixed(2)} ${S.of(context).kwd}",
                                                                style:
                                                                    TextStyle(
                                                                  fontSize:
                                                                      width /
                                                                          32,
                                                                  color: isDark
                                                                      ? AppColors
                                                                          .kWhite
                                                                      : AppColors
                                                                          .kBlack,
                                                                  fontFamily:
                                                                      AppFonts
                                                                          .poppins,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                          // Check if the address is exact (latitude and longitude provided)
    if (state.orders[indexForOrders].address!.isExact) ...[
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
              text: state.orders[indexForOrders].address!.lat?.toString() ?? S.of(context).notAvailable,
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
              text: state.orders[indexForOrders].address!.lng?.toString() ?? S.of(context).notAvailable,
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
              text: state.orders[indexForOrders].address!.addressTitle,
              style: TextStyle(
                fontSize: width / 32,
                color: isDark ? AppColors.kWhite : AppColors.kBlack,
                fontFamily: AppFonts.poppins,
              ),
            ),
          ],
        ),
      ),
      if (state.orders[indexForOrders].address!.area != null)
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
                text: state.orders[indexForOrders].address!.area!,
                style: TextStyle(
                  fontSize: width / 32,
                  color: isDark ? AppColors.kWhite : AppColors.kBlack,
                  fontFamily: AppFonts.poppins,
                ),
              ),
            ],
          ),
        ),
      if (state.orders[indexForOrders].address!.street != null)
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
                text: state.orders[indexForOrders].address!.street!,
                style: TextStyle(
                  fontSize: width / 32,
                  color: isDark ? AppColors.kWhite : AppColors.kBlack,
                  fontFamily: AppFonts.poppins,
                ),
              ),
            ],
          ),
        ),
      if (state.orders[indexForOrders].address!.building != null)
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
                text: state.orders[indexForOrders].address!.building!,
                style: TextStyle(
                  fontSize: width / 32,
                  color: isDark ? AppColors.kWhite : AppColors.kBlack,
                  fontFamily: AppFonts.poppins,
                ),
              ),
            ],
          ),
        ),
      if (state.orders[indexForOrders].address!.apartmentNum != null)
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
                text: state.orders[indexForOrders].address!.apartmentNum!,
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
                                                        const SizedBox(
                                                          height: 5,
                                                        ),
                                                        Text(
                                                          S
                                                              .of(context)
                                                              .specialInstructions,
                                                          style: TextStyle(
                                                            fontSize:
                                                                width / 32,
                                                            color: isDark
                                                                ? AppColors
                                                                    .kWhite
                                                                : AppColors
                                                                    .kBlack,
                                                            fontFamily: AppFonts
                                                                .poppins,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          width: width * .75,
                                                          child: Text(
                                                            "    -> ${getLanguage(name: state.orders[indexForOrders].instructions, context: context)}",
                                                            style: TextStyle(
                                                              fontSize:
                                                                  width / 32,
                                                              color: isDark
                                                                  ? AppColors
                                                                      .kWhite
                                                                  : AppColors
                                                                      .kBlack,
                                                              fontFamily:
                                                                  AppFonts
                                                                      .poppins,
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                            GestureDetector(
                                                onTap: () async {
                                                  if (await confirm(
                                                    context,
                                                    content: Text(
                                                      S
                                                          .of(context)
                                                          .sureContinue,
                                                      style: TextStyle(
                                                        fontSize: width / 32,
                                                        color: isDark
                                                            ? AppColors.kWhite
                                                            : AppColors.kBlack,
                                                        fontFamily:
                                                            AppFonts.poppins,
                                                      ),
                                                    ),
                                                  )) {
                                                    // Safely retrieve the order and its properties
                                                    final order = state
                                                        .orders[indexForOrders];
                                                    final id = order.id;
                                                    final price = order.fast
                                                        ? order.fastPrice
                                                        : order.price;
                                                    final paymentMethod =
                                                        order.paymentMethod;

                                                    // Remove the order from the list
                                                    state.orders.removeAt(
                                                        indexForOrders);

                                                    // Delete the order from Firestore
                                                    await FirebaseFirestore
                                                        .instance
                                                        .collection("orders")
                                                        .doc(id)
                                                        .delete();

                                                    // Check and update the balance if the payment method is online
                                                    if (paymentMethod ==
                                                        UserPaymentMethod
                                                            .online) {
                                                      BlocProvider.of<
                                                                  BalanceCubit>(
                                                              context)
                                                          .increaseBalance(
                                                              price);
                                                    }

                                                    // Update the UI
                                                    setState(() {});

                                                    // Show a success message
                                                    CustomSnackBar.show(
                                                        context,
                                                        S.of(context).deleteSec,
                                                        AppColors.kGreen);
                                                  }
                                                },
                                                child: Icon(
                                                  Icons.close,
                                                  color: AppColors.kRed,
                                                  size: width / 18,
                                                ))
                                          ],
                                        );
                                      },
                                    ),
                                  ),
                                );
                              },
                            );
                          } else {
                            return const SizedBox();
                          }
                        });
                  },
                );
        } else if (state is OrderLoading) {
          return Skeletonizer(
            enabled: true,
            child: ListView.builder(
              padding: const EdgeInsets.only(top: 8),
              itemCount: 5,
              itemBuilder: (context, indexForOrders) {
                return Container(
                  width: width,
                  margin: EdgeInsets.symmetric(
                      horizontal: width / 30, vertical: height / 120),
                  padding: EdgeInsets.all(width / 30),
                  decoration: BoxDecoration(
                    color: AppColors.kWhite,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Text(
                            "${indexForOrders + 1}",
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
                                      text: S.of(context).orderId,
                                      style: TextStyle(
                                        fontSize: width / 32,
                                        fontFamily: AppFonts.poppins,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    TextSpan(
                                      text: "#",
                                      style: TextStyle(
                                        fontSize: width / 32,
                                        color: AppColors.kRed,
                                        fontFamily: AppFonts.poppins,
                                      ),
                                    ),
                                    TextSpan(
                                      text: "state.orders[index].id",
                                      style: TextStyle(
                                        fontSize: width / 32,
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
                                        fontFamily: AppFonts.poppins,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    TextSpan(
                                      text:
                                          ".subItems.length} {S.of(context).item}",
                                      style: TextStyle(
                                        fontSize: width / 32,
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
                                        fontFamily: AppFonts.poppins,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    TextSpan(
                                      text: "{state.orders[string(11, 16)}",
                                      style: TextStyle(
                                        fontSize: width / 32,
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
                                      text: S.of(context).status,
                                      style: TextStyle(
                                        fontSize: width / 32,
                                        fontFamily: AppFonts.poppins,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    TextSpan(
                                      text: getString("{(status as M"),
                                      style: TextStyle(
                                        fontSize: width / 32,
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
                                        fontFamily: AppFonts.poppins,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    TextSpan(
                                      text: "nteString().split",
                                      style: TextStyle(
                                        fontSize: width / 32,
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
                                      text: S.of(context).amount,
                                      style: TextStyle(
                                        fontSize: width / 32,
                                        fontFamily: AppFonts.poppins,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    TextSpan(
                                      text: ".kwd}",
                                      style: TextStyle(
                                        fontSize: width / 32,
                                        fontFamily: AppFonts.poppins,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Text(
                                S.of(context).specialInstructions,
                                style: TextStyle(
                                  fontSize: width / 32,
                                  fontFamily: AppFonts.poppins,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(
                                width: width * .75,
                                child: Text(
                                  "ions, context: context)}",
                                  style: TextStyle(
                                    fontSize: width / 32,
                                    fontFamily: AppFonts.poppins,
                                  ),
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
            ),
          );
        } else {
          return Center(
            child: Text(
              S.of(context).tryAgain,
              style: TextStyle(
                fontSize: width / 30,
                color: AppColors.kBlack,
                fontFamily: AppFonts.poppins,
                fontWeight: FontWeight.bold,
              ),
            ),
          );
        }
      },
    );
  }

  String getString(String string) {
    if (string == "Placed") {
      return S.of(context).placed;
    } else if (string == "In Progress") {
      return S.of(context).inProg;
    } else if (string == "Out for delivery") {
      return S.of(context).outForDelivery;
    }
    return string;
  }
}
