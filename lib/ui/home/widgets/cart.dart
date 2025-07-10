import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ionicons/ionicons.dart';
import 'package:lottie/lottie.dart';
import '../../../config/routes.dart';
import '../../../logic/cart/cart_cubit.dart';
import '../../../logic/theme/theme_cubit.dart';
import '../../laundry/widgets/sub_item.dart';

import '../../../constants/colors.dart';
import '../../../constants/fonts.dart';
import '../../../generated/l10n.dart';
import '../../../models/cart.dart';
import '../../../widgets/sign_in_dialog.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

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
            S.of(context).cart,
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
      body: BlocBuilder<CartCubit, Cart>(
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
                              BlocProvider.of<CartCubit>(context)
                                  .delete(id: state.itemsToPayFor[index].id);
                            },
                            child: SubItemWidget(
                              isInCart: true,
                              add: (double v, double e) {
                                BlocProvider.of<CartCubit>(context).increase(
                                    id: state.itemsToPayFor[index].id);
                              },
                              remove: (double v, double e) {
                                BlocProvider.of<CartCubit>(context).decrease(
                                    id: state.itemsToPayFor[index].id);
                              },
                              subItem: state.itemsToPayFor[index],
                              index: index,
                            ),
                          );
                        },
                        itemCount: state.itemsToPayFor.length,
                      ),
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
                    state.totalFastPriceToPay != state.priceToPay
                        ? Padding(
                            padding:
                                EdgeInsets.symmetric(horizontal: width / 30),
                            child: Text(
                              "${S.of(context).fastPrice}:  ${state.totalFastPriceToPay.toStringAsFixed(2)} ${S.of(context).kwd}",
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                fontSize: width / 22,
                                fontFamily: AppFonts.poppins,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          )
                        : const SizedBox(),
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
                        onPressed: () {
                          if (FirebaseAuth.instance.currentUser != null) {
                            Navigator.of(context).pushNamed(AppRoutes.order,
                                arguments: state.itemsToPayFor);
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
                        child: Text(
                          S.of(context).okContinue,
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
