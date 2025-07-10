import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ionicons/ionicons.dart';
import 'package:trustlaundry/models/product.dart';
import '../../../logic/language/language_cubit.dart';
import '../../../logic/theme/theme_cubit.dart';
import '../func.dart';

import '../../../constants/colors.dart';
import '../../../constants/fonts.dart';
import '../../../generated/l10n.dart';
import '../../../models/items.dart';

class SubItemWidget extends StatefulWidget {
  final SubItem subItem;
  final Function add;
  final Function remove;
  final bool isInCart;
  final int index;
  bool? dontShowPrice;
  SubItemWidget({
    super.key,
    required this.isInCart,
    this.dontShowPrice,
    required this.add,
    required this.remove,
    required this.subItem,
    required this.index,
  });

  @override
  State<SubItemWidget> createState() => _SubItemWidgetState();
}

class _SubItemWidgetState extends State<SubItemWidget> {
  int quantity = 0;
  @override
  void initState() {
    super.initState();
    if (widget.isInCart) {
      quantity = widget.subItem.quantity;
    }
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
                      BlocBuilder<LanguageCubit, String>(
                        builder: (context, state) {
                          return Text(
                            state == "ar"
                                ? widget.subItem.titleAr
                                : widget.subItem.titleEn,
                            style: TextStyle(
                              fontSize: width / 32,
                              fontFamily: AppFonts.poppins,
                              fontWeight: FontWeight.bold,
                            ),
                          );
                        },
                      ),
                      widget.dontShowPrice == null? Row(
                        children: [
                          Text(
                            "${widget.subItem.price} ${S.of(context).kwd}",
                            style: TextStyle(
                              fontSize: width / 32,
                              fontFamily: AppFonts.poppins,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          Text(
                            widget.subItem.priceFast != widget.subItem.price
                                ? " (${S.of(context).mousta3jil}: ${widget.subItem.priceFast} ${S.of(context).kwd})"
                                : " (${S.of(context).noMousta3jil})",
                            style: TextStyle(
                              fontSize: width / 36,
                              fontFamily: AppFonts.poppins,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ):const SizedBox(),
                    ],
                  ),
                ],
              ),
              SizedBox(
                width: width / 4,
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      InkWell(
                        onTap: () {
                          if (quantity > 0) {
                            setState(() {
                              quantity--;
                              print(quantity);
                              widget.remove(widget.subItem.price,
                                  widget.subItem.priceFast);
                            });
                          }
                        },
                        child: CircleAvatar(
                          backgroundColor: isDark
                              ? (quantity > 0
                                  ? AppColors.kWhite
                                  : AppColors.kRed)
                              : (quantity > 0
                                  ? AppColors.kBlueLight
                                  : AppColors.kGreyForDivider),
                          radius: width / 30,
                          child: Icon(
                            Ionicons.remove,
                            color: isDark
                                ? AppColors.kBlueLight
                                : AppColors.kWhite,
                          ),
                        ),
                      ),
                      Text(
                        quantity.toString(),
                        style: TextStyle(
                          fontSize: width / 26,
                          fontFamily: AppFonts.poppins,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          if (quantity < 25) {
                            setState(() {
                              quantity++;
                              widget.add(widget.subItem.price,
                                  widget.subItem.priceFast);
                            });
                          }
                        },
                        child: CircleAvatar(
                          backgroundColor: isDark
                              ? quantity < 25
                                  ? AppColors.kWhite
                                  : AppColors.kRed
                              : quantity < 25
                                  ? AppColors.kBlueLight
                                  : AppColors.kGreyForDivider,
                          radius: width / 30,
                          child: Icon(
                            Icons.add,
                            color: isDark
                                ? AppColors.kBlueLight
                                : AppColors.kWhite,
                          ),
                        ),
                      ),
                    ]),
              ),
            ],
          ),
        );
      },
    );
  }
}



class ProductCartWidget extends StatefulWidget {
  final MyProduct prod;
  final Function add;
  final Function remove;
  final bool isInCart;
  final int index;
  bool? dontShowPrice;
  ProductCartWidget({
    super.key,
    required this.isInCart,
    this.dontShowPrice,
    required this.add,
    required this.remove,
    required this.prod,
    required this.index,
  });

  @override
  State<ProductCartWidget> createState() => _ProductCartWidgetState();
}

class _ProductCartWidgetState extends State<ProductCartWidget> {
  int quantity = 0;
  @override
  void initState() {
    super.initState();
    if (widget.isInCart) {
      quantity = widget.prod.quantity;
    }
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
                      BlocBuilder<LanguageCubit, String>(
                        builder: (context, state) {
                          return Text(
                            state == "ar"
                                ? widget.prod.titleAr
                                : widget.prod.titleEn,
                            style: TextStyle(
                              fontSize: width / 32,
                              fontFamily: AppFonts.poppins,
                              fontWeight: FontWeight.bold,
                            ),
                          );
                        },
                      ),
                      widget.dontShowPrice == null? Row(
                        children: [
                          Text(
                            "${widget.prod.priceAfterDiscount} ${S.of(context).kwd}",
                            style: TextStyle(
                              fontSize: width / 32,
                              fontFamily: AppFonts.poppins,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                         
                        ],
                      ):const SizedBox(),
                    ],
                  ),
                ],
              ),
              SizedBox(
                width: width / 4,
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      InkWell(
                        onTap: () {
                          if (quantity > 0) {
                            setState(() {
                              quantity--;
                        
                              widget.remove(widget.prod.price,
                                 );
                            });
                          }
                        },
                        child: CircleAvatar(
                          backgroundColor: isDark
                              ? (quantity > 0
                                  ? AppColors.kWhite
                                  : AppColors.kRed)
                              : (quantity > 0
                                  ? AppColors.kBlueLight
                                  : AppColors.kGreyForDivider),
                          radius: width / 30,
                          child: Icon(
                            Ionicons.remove,
                            color: isDark
                                ? AppColors.kBlueLight
                                : AppColors.kWhite,
                          ),
                        ),
                      ),
                      Text(
                        quantity.toString(),
                        style: TextStyle(
                          fontSize: width / 26,
                          fontFamily: AppFonts.poppins,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          if (quantity < 25) {
                            setState(() {
                              quantity++;
                              widget.add(widget.prod.price,
                                  );
                            });
                          }
                        },
                        child: CircleAvatar(
                          backgroundColor: isDark
                              ? quantity < 25
                                  ? AppColors.kWhite
                                  : AppColors.kRed
                              : quantity < 25
                                  ? AppColors.kBlueLight
                                  : AppColors.kGreyForDivider,
                          radius: width / 30,
                          child: Icon(
                            Icons.add,
                            color: isDark
                                ? AppColors.kBlueLight
                                : AppColors.kWhite,
                          ),
                        ),
                      ),
                    ]),
              ),
            ],
          ),
        );
      },
    );
  }
}
