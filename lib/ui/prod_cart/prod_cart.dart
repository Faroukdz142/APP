import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ionicons/ionicons.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:lottie/lottie.dart';
import 'package:trustlaundry/logic/balance/balance_cubit.dart';
import 'package:trustlaundry/logic/cubit/prod_cart_cubit.dart';
import 'package:trustlaundry/logic/payment.dart';
import 'package:trustlaundry/models/my_address.dart';
import 'package:trustlaundry/ui/address/address.dart';
import 'package:trustlaundry/ui/laundry/widgets/sub_item.dart';
import 'package:trustlaundry/ui/order/order.dart';
import 'package:trustlaundry/ui/payment/payment_webview.dart';
import 'package:trustlaundry/widgets/snack_bar.dart';
import '../../../config/routes.dart';
import '../../../logic/cart/cart_cubit.dart';
import '../../../logic/theme/theme_cubit.dart';

import '../../../constants/colors.dart';
import '../../../constants/fonts.dart';
import '../../../generated/l10n.dart';
import '../../../models/cart.dart';
import '../../../widgets/sign_in_dialog.dart';

enum UserPaymentMethod2 { cash, online, credit }

class ProdCartScreen extends StatefulWidget {
  const ProdCartScreen({super.key});

  @override
  State<ProdCartScreen> createState() => _ProdCartScreenState();
}

class _ProdCartScreenState extends State<ProdCartScreen> {
  MyAddress? address;
  bool loading = false;
  UserPaymentMethod2 selectedMethod = UserPaymentMethod2.online;
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
            S.of(context).prodCart,
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
            width: width / 5,
          ),
        ],
      ),
      body: BlocBuilder<ProdCartCubit, ProdCart>(
        builder: (context, state) {
          return state.itemsToPayFor.isEmpty
              ? Center(
                  child: Column(
                    children: [
                      SizedBox(
                        height: height / 7,
                      ),
                      Lottie.network(
                          "https://lottie.host/62468689-f635-4196-bdb8-c5301b5a213d/5dPJDlvE3J.json",
                          height: height / 4),
                      BlocBuilder<ThemeCubit, bool>(
                        builder: (context, isDark) {
                          return Text(
                            S.of(context).cartEmpty,
                            style: TextStyle(
                              fontSize: width / 30,
                              color: isDark
                                  ? AppColors.kWhite
                                  : AppColors.kGreyForTexts,
                              fontFamily: AppFonts.poppins,
                              fontWeight: FontWeight.bold,
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: ListView.builder(
                        padding: EdgeInsets.zero,
                        itemBuilder: (context, index) {
                          return Dismissible(
                            key: ValueKey(state.itemsToPayFor[index]),
                            direction: DismissDirection.endToStart,
                            background: Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.circular(0),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  const Icon(
                                    Ionicons.trash_bin,
                                    color: AppColors.kWhite,
                                    size: 15,
                                  ),
                                  SizedBox(
                                    width: width / 30,
                                  ),
                                  Text(
                                    S.of(context).delete,
                                    style: TextStyle(
                                      fontSize: width / 30,
                                      color: AppColors.kWhite,
                                      fontFamily: AppFonts.poppins,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(
                                    width: width / 20,
                                  ),
                                ],
                              ),
                            ),
                            onDismissed: (direction) {
                              BlocProvider.of<ProdCartCubit>(context)
                                  .delete(id: state.itemsToPayFor[index].id);
                            },
                            child: ProductCartWidget(
                              isInCart: true,
                              add: (double v) {
                                BlocProvider.of<ProdCartCubit>(context)
                                    .increase(
                                        id: state.itemsToPayFor[index].id);
                              },
                              remove: (double v) {
                                BlocProvider.of<ProdCartCubit>(context)
                                    .decrease(
                                        id: state.itemsToPayFor[index].id);
                              },
                              prod: state.itemsToPayFor[index],
                              index: index,
                            ),
                          );
                        },
                        itemCount: state.itemsToPayFor.length,
                      ),
                    ),
                    SizedBox(
                      height: height / 30,
                    ),
                    BlocBuilder<ThemeCubit, bool>(
                      builder: (context, isDark) {
                        return Column(
                          children: [
                            Text(
                              S.of(context).paymentMethod,
                              style: TextStyle(
                                fontSize: width / 28,
                                fontFamily: AppFonts.poppins,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(
                              height: height / 60,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      selectedMethod =
                                          UserPaymentMethod2.credit;
                                    });
                                  },
                                  child: Container(
                                    height: height / 8,
                                    width: height / 8,
                                    padding: EdgeInsets.symmetric(
                                      vertical: height / 90,
                                      horizontal: width / 90,
                                    ),
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                          width: selectedMethod ==
                                                  UserPaymentMethod2.credit
                                              ? 3
                                              : 1,
                                          color: selectedMethod ==
                                                  UserPaymentMethod2.credit
                                              ? !isDark
                                                  ? AppColors.kBlueLight
                                                  : AppColors.kWhite
                                              : AppColors.kGreyForDivider),
                                      color: isDark
                                          ? AppColors.kBlueLight
                                          : AppColors.kWhite,
                                      borderRadius: BorderRadius.circular(10),
                                      boxShadow: isDark
                                          ? []
                                          : const [
                                              BoxShadow(
                                                color:
                                                    AppColors.kGreyForDivider,
                                                blurRadius: 3,
                                                spreadRadius: 0,
                                              ),
                                            ],
                                    ),
                                    child: Center(
                                      child: Text(
                                        S.of(context).credit,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: width / 28,
                                          fontFamily: AppFonts.poppins,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: width / 15,
                                ),
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      selectedMethod =
                                          UserPaymentMethod2.online;
                                    });
                                  },
                                  child: Container(
                                    height: height / 8,
                                    width: height / 8,
                                    padding: EdgeInsets.symmetric(
                                      vertical: height / 90,
                                      horizontal: width / 90,
                                    ),
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                          width: selectedMethod ==
                                                  UserPaymentMethod2.online
                                              ? 3
                                              : 1,
                                          color: selectedMethod ==
                                                  UserPaymentMethod2.online
                                              ? !isDark
                                                  ? AppColors.kBlueLight
                                                  : AppColors.kWhite
                                              : AppColors.kGreyForDivider),
                                      color: isDark
                                          ? AppColors.kBlueLight
                                          : AppColors.kWhite,
                                      borderRadius: BorderRadius.circular(10),
                                      boxShadow: isDark
                                          ? []
                                          : const [
                                              BoxShadow(
                                                color:
                                                    AppColors.kGreyForDivider,
                                                blurRadius: 3,
                                                spreadRadius: 0,
                                              ),
                                            ],
                                    ),
                                    child: Center(
                                      child: Text(
                                        S.of(context).online,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: width / 28,
                                          fontFamily: AppFonts.poppins,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: width / 15,
                                ),
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      selectedMethod = UserPaymentMethod2.cash;
                                    });
                                  },
                                  child: Container(
                                    height: height / 8,
                                    width: height / 8,
                                    padding: EdgeInsets.symmetric(
                                        vertical: height / 90,
                                        horizontal: width / 40),
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                          width: selectedMethod ==
                                                  UserPaymentMethod2.cash
                                              ? 3
                                              : 1,
                                          color: selectedMethod ==
                                                  UserPaymentMethod2.cash
                                              ? !isDark
                                                  ? AppColors.kBlueLight
                                                  : AppColors.kWhite
                                              : AppColors.kGreyForDivider),
                                      color: isDark
                                          ? AppColors.kBlueLight
                                          : AppColors.kWhite,
                                      borderRadius: BorderRadius.circular(10),
                                      boxShadow: isDark
                                          ? []
                                          : const [
                                              BoxShadow(
                                                color:
                                                    AppColors.kGreyForDivider,
                                                blurRadius: 3,
                                                spreadRadius: 0,
                                              ),
                                            ],
                                    ),
                                    child: Center(
                                      child: Text(
                                        S.of(context).cash,
                                        style: TextStyle(
                                          fontSize: width / 28,
                                          fontFamily: AppFonts.poppins,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            )
                          ],
                        );
                      },
                    ),
                    SizedBox(
                      height: height / 30,
                    ),
                    BlocBuilder<ThemeCubit, bool>(
                      builder: (context, isDark) {
                        return GestureDetector(
                          onTap: () async {
                            address = await Navigator.of(context).pushNamed(
                                    AppRoutes.address,
                                    arguments: NavigationFromSettingsTo.order)
                                as MyAddress;

                            setState(() {});
                          },
                          child: Container(
                            width: width,
                            //   height: height / 13,
                            margin: EdgeInsets.symmetric(
                                horizontal: width / 30, vertical: height / 120),
                            padding: EdgeInsets.symmetric(
                              horizontal: width / 30,
                              vertical:
                                  address == null ? height / 50 : height / 120,
                            ),
                            decoration: BoxDecoration(
                              color: isDark
                                  ? AppColors.kBlueLight
                                  : AppColors.kWhite,
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
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
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
                                                            ? AppColors
                                                                .kGreyForPin
                                                            : AppColors
                                                                .kGreyForTexts,
                                                        fontFamily:
                                                            AppFonts.poppins,
                                                        fontWeight:
                                                            FontWeight.bold,
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
                        );
                      },
                    ),
                    SizedBox(
                      height: height / 30,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: width / 30),
                      child: Text(
                        "${S.of(context).totalPrice}  ${state.priceToPay.toStringAsFixed(2)} ${S.of(context).kwd}",
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          fontSize: width / 22,
                          fontFamily: AppFonts.poppins,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(
                        top: height / 90,
                        bottom: height / 80,
                        left: width / 20,
                        right: width / 20,
                      ),
                      width: width,
                      height: height / 17,
                      child: ElevatedButton(
                        onPressed: () async {
                          if (FirebaseAuth.instance.currentUser != null) {
                            if (address != null) {
                              String phone = "";
                              final data =await  FirebaseFirestore.instance
                                  .collection(
                                  "users")
                                  .doc(FirebaseAuth.instance.currentUser!.uid)
                                  .get();
                                phone = data.data()!["phoneNumber"];
                              if (selectedMethod == UserPaymentMethod2.cash) {
                                Navigator.pop(context);

                                final doc = await FirebaseFirestore.instance
                                    .collection('prodOrders')
                                    .add({
                                  "payment": "cash",
                                  "phone": phone,
                                  "address":address!.toJson(),
                                  "uid": FirebaseAuth.instance.currentUser!.uid,
                                  "orders": state.itemsToPayFor
                                      .map((e) => e.toJson())
                                      .toList()
                                });
                                await FirebaseFirestore.instance
                                    .collection('prodOrders')
                                    .doc(doc.id)
                                    .update({"docId": doc.id});
                                BlocProvider.of<ProdCartCubit>(context)
                                    .emptyCart();

                                CustomSnackBar.show(
                                    context,
                                    S.of(context).addedToCard,
                                    AppColors.kGreen);
                              } else if (selectedMethod ==
                                  UserPaymentMethod2.online) {
                                setState(() {
                                  loading = true;
                                });
                                await PaymentService.createCharge(
                                  paymentFor: PaymentFor.prod,
                                  amount: state.priceToPay,
                                  address:address!,
                                  currency: "KWD",
                                  description: "Payment for trust laundry",
                                  prods: state.itemsToPayFor,
                                  context: context,
                                );
                                setState(() {
                                  loading = false;
                                });
                              } else if (selectedMethod ==
                                  UserPaymentMethod2.credit) {
                                setState(() {
                                  loading = true;
                                });

                                final balance =
                                    BlocProvider.of<BalanceCubit>(context)
                                        .balance;

                                if (balance >= state.priceToPay) {
                                  final doc = await FirebaseFirestore.instance
                                      .collection('prodOrders')
                                      .add({
                                    "payment": "credit",
                                    "phone": phone,
                                    "address":address!.toJson(),
                                    "uid":
                                        FirebaseAuth.instance.currentUser!.uid,
                                    "orders": state.itemsToPayFor
                                        .map((e) => e.toJson())
                                        .toList()
                                  });
                                  await FirebaseFirestore.instance
                                      .collection('prodOrders')
                                      .doc(doc.id)
                                      .update({"docId": doc.id});

                                  BlocProvider.of<BalanceCubit>(context)
                                      .decreaseBalance(state.priceToPay);
                                  Navigator.pop(context);
                                  BlocProvider.of<ProdCartCubit>(context)
                                      .emptyCart();
                                  CustomSnackBar.show(
                                      context,
                                      S.of(context).addedToCard,
                                      AppColors.kGreen);
                                } else {
                                  CustomSnackBar.show(context,
                                      S.of(context).balanceLow, AppColors.kRed);
                                  setState(() {
                                    loading = false;
                                  });
                                  return;
                                }
                                setState(() {
                                  loading = false;
                                });
                              }
                            } else {
                              CustomSnackBar.show(context,
                                  S.of(context).tryAgain, AppColors.kRed);
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
                        style: Theme.of(context)
                            .elevatedButtonTheme
                            .style!
                            .copyWith(
                              backgroundColor: const WidgetStatePropertyAll(
                                AppColors.kBlueLight,
                              ),
                            ),
                        child: loading
                            ? LoadingAnimationWidget.discreteCircle(
                                color: AppColors.kWhite, size: width / 18)
                            : Text(
                                S.of(context).confirm,
                                style: TextStyle(
                                  fontSize: width / 32,
                                  color: AppColors.kWhite,
                                  fontFamily: AppFonts.poppins,
                                  fontWeight: FontWeight.bold,
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
