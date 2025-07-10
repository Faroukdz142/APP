import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:confirm_dialog/confirm_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_svg/svg.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:trustlaundry/models/my_address.dart';
import 'package:trustlaundry/widgets/snack_bar.dart';
import 'package:widget_and_text_animator/widget_and_text_animator.dart';
import '../../logic/balance/balance_cubit.dart';
import '../../logic/language/language_cubit.dart';
import '../../../constants/colors.dart';
import '../../../constants/fonts.dart';
import '../../../generated/l10n.dart';
import '../../../logic/theme/theme_cubit.dart';
import '../../../models/product.dart';

class MyProdOrder {
  final String uid;
  final List<MyProduct> prods;
  final String paymentMethod;
  final String docId;
  final String phoneNum;
  final MyAddress address;
  MyProdOrder(
      {required this.prods,
      required this.address,
      required this.docId,
      required this.phoneNum,
      required this.uid,
      required this.paymentMethod});
  factory MyProdOrder.fromJson(data) {
    return MyProdOrder(
      address:MyAddress.fromJson( data["address"]),
      phoneNum: data["phone"],
        docId: data["docId"],
        prods:
            (data["orders"] as List).map((e) => MyProduct.fromJson(e)).toList(),
        uid: data["uid"],
        paymentMethod: data["payment"]);
  }

  double getPrice() {
    double price = 0;
    for (var x in prods) {
      price += x.priceAfterDiscount*x.quantity;
    }
    return price;
  }
}

class ProductsOrders extends StatefulWidget {
  const ProductsOrders({super.key});

  @override
  State<ProductsOrders> createState() => _ProductsOrdersState();
}

class _ProductsOrdersState extends State<ProductsOrders> {
  bool isLoading = true;
  List<MyProdOrder> prodOrders = [];
  @override
  void initState() {
    super.initState();
    getProductsOrders();
  }

  Future<void> getProductsOrders() async {
    prodOrders = [];
    try {
      final products = await FirebaseFirestore.instance
          .collection("prodOrders")
          .where("uid", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
          .get();
      for (var x in products.docs) {
        prodOrders.add(MyProdOrder.fromJson(x.data()));
      }
    } catch (e) {
      print(e.toString());
    }

    setState(() {
      isLoading = false;
    });
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
                    // Navigator.pushNamedAndRemoveUntil(
                    //   context,
                    //   AppRoutes.home,
                    //   (route) => false,
                    // );
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
              S.of(context).reqProd,
              style: TextStyle(
                fontSize: width / 22,
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
      ),
      body: prodOrders.isEmpty
          ? Column(
              children: [
                SizedBox(
                  height: height / 4,
                ),
                Center(
                  child: Text(
                    S.of(context).noReqProd,
                    style: TextStyle(
                        fontFamily: AppFonts.poppins,
                        fontSize: width / 30,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            )
          : Skeletonizer(
              enabled: isLoading,
              child: ListView.builder(
                padding: const EdgeInsets.only(top: 8),
                itemCount: prodOrders.length,
                itemBuilder: (context, indexForOrders) {
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
                                    itemCount:
                                        prodOrders[indexForOrders].prods.length,
                                    itemBuilder: (context, indexForSubItems) {
                                      final prod = prodOrders[indexForOrders]
                                          .prods[indexForSubItems];
                                      return ListTile(
                                        title:
                                            BlocBuilder<LanguageCubit, String>(
                                          builder: (context, state) {
                                            return Text(
                                              "${indexForSubItems + 1}- ${state == "ar" ? prod.titleAr : prod.titleEn}",
                                              style: TextStyle(
                                                fontSize: width / 30,
                                                fontFamily: AppFonts.poppins,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            );
                                          },
                                        ), // Display Arabic title
                                        subtitle: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              '    ${S.of(context).price}: ${prod.price.toStringAsFixed(2)} ${S.of(context).kwd}',
                                              style: TextStyle(
                                                fontSize: width / 30,
                                                fontFamily: AppFonts.poppins,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            Text(
                                              '    ${S.of(context).quantity}: ${prod.quantity}',
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
                          child: BlocBuilder<LanguageCubit, String>(
                            builder: (context, language) {
                              return Stack(
                                alignment: language == "en"
                                    ? Alignment.centerRight
                                    : Alignment.centerLeft,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
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
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              RichText(
                                                text: TextSpan(
                                                  children: [
                                                    TextSpan(
                                                      text: S
                                                          .of(context)
                                                          .numberOfItems,
                                                      style: TextStyle(
                                                        fontSize: width / 32,
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
                                                          "${prodOrders[indexForOrders].prods.length} ${S.of(context).item}",
                                                      style: TextStyle(
                                                        fontSize: width / 32,
                                                        color: isDark
                                                            ? AppColors.kWhite
                                                            : AppColors.kBlack,
                                                        fontFamily:
                                                            AppFonts.poppins,
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
                                                          .paymentStatus,
                                                      style: TextStyle(
                                                        fontSize: width / 32,
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
                                                      text: prodOrders[
                                                                      indexForOrders]
                                                                  .paymentMethod ==
                                                              "cash"
                                                          ? S
                                                              .of(context)
                                                              .notPayed
                                                          : S.of(context).done,
                                                      style: TextStyle(
                                                        fontSize: width / 32,
                                                        color: isDark
                                                            ? AppColors.kWhite
                                                            : AppColors.kBlack,
                                                        fontFamily:
                                                            AppFonts.poppins,
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
                                                          S.of(context).amount,
                                                      style: TextStyle(
                                                        fontSize: width / 32,
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
                                                          "${prodOrders[indexForOrders].getPrice().toStringAsFixed(2)} ${S.of(context).kwd}",
                                                      style: TextStyle(
                                                        fontSize: width / 32,
                                                        color: isDark
                                                            ? AppColors.kWhite
                                                            : AppColors.kBlack,
                                                        fontFamily:
                                                            AppFonts.poppins,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                                // Check if the address is exact (latitude and longitude provided)
    if (prodOrders[indexForOrders].address.isExact) ...[
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
              text: prodOrders[indexForOrders].address.lat?.toString() ?? S.of(context).notAvailable,
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
              text: prodOrders[indexForOrders].address.lng?.toString() ?? S.of(context).notAvailable,
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
              text: prodOrders[indexForOrders].address.addressTitle,
              style: TextStyle(
                fontSize: width / 32,
                color: isDark ? AppColors.kWhite : AppColors.kBlack,
                fontFamily: AppFonts.poppins,
              ),
            ),
          ],
        ),
      ),
      if (prodOrders[indexForOrders].address.area != null)
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
                text: prodOrders[indexForOrders].address.area!,
                style: TextStyle(
                  fontSize: width / 32,
                  color: isDark ? AppColors.kWhite : AppColors.kBlack,
                  fontFamily: AppFonts.poppins,
                ),
              ),
            ],
          ),
        ),
      if (prodOrders[indexForOrders].address.street != null)
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
                text: prodOrders[indexForOrders].address.street!,
                style: TextStyle(
                  fontSize: width / 32,
                  color: isDark ? AppColors.kWhite : AppColors.kBlack,
                  fontFamily: AppFonts.poppins,
                ),
              ),
            ],
          ),
        ),
      if (prodOrders[indexForOrders].address.building != null)
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
                text: prodOrders[indexForOrders].address.building!,
                style: TextStyle(
                  fontSize: width / 32,
                  color: isDark ? AppColors.kWhite : AppColors.kBlack,
                  fontFamily: AppFonts.poppins,
                ),
              ),
            ],
          ),
        ),
      if (prodOrders[indexForOrders].address.apartmentNum != null)
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
                text: prodOrders[indexForOrders].address.apartmentNum!,
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
                                    ],
                                  ),
                                  GestureDetector(
                                      onTap: () async {
                                        if (await confirm(
                                          context,
                                          content: Text(
                                            S.of(context).sureContinue,
                                            style: TextStyle(
                                              fontSize: width / 32,
                                              color: isDark
                                                  ? AppColors.kWhite
                                                  : AppColors.kBlack,
                                              fontFamily: AppFonts.poppins,
                                            ),
                                          ),
                                        )) {
                                          final docId =
                                              prodOrders[indexForOrders].docId;
                                          final payment =
                                              prodOrders[indexForOrders]
                                                  .paymentMethod;
                                          final prodPrice =
                                              prodOrders[indexForOrders]
                                                  .getPrice();
                                                 
                                          // Remove the order from the list
                                          prodOrders.removeAt(indexForOrders);

                                          // Delete the order from Firestore
                                          await FirebaseFirestore.instance
                                              .collection("prodOrders")
                                              .doc(docId)
                                              .delete();

                                          // Check and update the balance if the payment method is online
                                          if (payment == "credit") {
                                            BlocProvider.of<BalanceCubit>(
                                                    context)
                                                .increaseBalance(prodPrice);
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
                },
              ),
            ),
    );
  }
}

class ProductsGridView extends StatefulWidget {
  final List<MyProduct> products;
  const ProductsGridView({super.key, required this.products});

  @override
  State<ProductsGridView> createState() => _ProductsGridViewState();
}

class _ProductsGridViewState extends State<ProductsGridView> {
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return AnimationLimiter(
      child: MasonryGridView.builder(
        shrinkWrap: true,
        padding: const EdgeInsets.all(10),
        itemCount: widget.products.length,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: SliverSimpleGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: width > 500 ? 3 : 2,
        ),
        itemBuilder: (context, index) => AnimationConfiguration.staggeredGrid(
          position: index,
          duration: const Duration(milliseconds: 375),
          columnCount: 4,
          child: FadeInAnimation(
            child: ScaleAnimation(
              child: OneProduct(
                product: widget.products[index],
                deleteOrder: deleteOrder,
              ),
            ),
          ),
        ),
      ),
    );
  }

  void deleteOrder(String id) {
    setState(() {
      widget.products.removeWhere((e) => e.docId == id);
    });
  }
}

class OneProduct extends StatelessWidget {
  final MyProduct product;
  final Function deleteOrder;
  const OneProduct(
      {super.key, required this.product, required this.deleteOrder});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: () {
        // Navigator.of(context).pushNamed(AppRoutes.details, arguments:  {"product":product,"from":FromWhere.orders});
      },
      child: Stack(children: [
        BlocBuilder<ThemeCubit, bool>(
          builder: (context, isDark) {
            return Container(
              padding: EdgeInsets.all(width / 60),
              decoration: BoxDecoration(
                color: isDark ? AppColors.kBlueLight : AppColors.kGreyForPin,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Hero(
                    tag: product.id,
                    child: CachedNetworkImage(
                      cacheKey: product.id,
                      imageUrl: product.image,
                      placeholder: (context, url) =>
                          Image.asset("assets/images/loading.gif"),
                    ),
                  ),
                  BlocBuilder<LanguageCubit, String>(
                    builder: (context, state) {
                      return ProductInfo(
                        id: product.docId!,
                        deleteOrder: deleteOrder,
                        quantity: product.quantity,
                        priceAfterDiscount: product.priceAfterDiscount,
                        price: product.price,
                        name: state == "ar" ? product.titleAr : product.titleEn,
                      );
                    },
                  ),
                ],
              ),
            );
          },
        ),
        Visibility(
          visible: true,
          child: Align(
            alignment: Alignment.topLeft,
            child: SizedBox(
              height: width * .09,
              width: width * .09,
              child: SvgPicture.asset('assets/vectors/new.svg'),
            ),
          ),
        ),
      ]),
    );
  }
}

class ProductInfo extends StatelessWidget {
  final String name;
  final double price;
  final int quantity;
  final double priceAfterDiscount;
  final String id;
  final Function deleteOrder;
  const ProductInfo({
    super.key,
    required this.id,
    required this.deleteOrder,
    required this.quantity,
    required this.priceAfterDiscount,
    required this.price,
    required this.name,
  });

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          name,
          textAlign: TextAlign.start,
          style: TextStyle(
              fontFamily: AppFonts.poppins,
              fontSize: width / 26,
              fontWeight: FontWeight.bold),
        ),
        Row(
          children: [
            Text(
              "$priceAfterDiscount ${S.of(context).kwd}",
              style: TextStyle(
                  fontFamily: AppFonts.poppins,
                  fontSize: width / 20,
                  fontWeight: FontWeight.bold),
              textAlign: TextAlign.start,
            ),
            const SizedBox(
              width: 5,
            ),
            price != priceAfterDiscount
                ? Text(
                    "$price ${S.of(context).kwd}",
                    style: TextStyle(
                      fontFamily: AppFonts.poppins,
                      decoration: priceAfterDiscount != price
                          ? TextDecoration.lineThrough
                          : null,
                      fontSize:
                          priceAfterDiscount != price ? width / 24 : width / 22,
                      fontWeight: priceAfterDiscount != price
                          ? FontWeight.w400
                          : FontWeight.bold,
                    ),
                    textAlign: TextAlign.start,
                  )
                : const SizedBox(),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "${S.of(context).quantity}$quantity",
              style: TextStyle(
                  fontFamily: AppFonts.poppins,
                  fontSize: width / 20,
                  fontWeight: FontWeight.bold),
              textAlign: TextAlign.start,
            ),
            BlocBuilder<ThemeCubit, bool>(
              builder: (context, isDark) {
                return GestureDetector(
                    onTap: () async {
                      if (await confirm(context,
                          content: Text(
                            S.of(context).sureContinue,
                            style: TextStyle(
                              fontSize: width / 32,
                              color:
                                  isDark ? AppColors.kWhite : AppColors.kBlack,
                              fontFamily: AppFonts.poppins,
                            ),
                          ))) {
                        await FirebaseFirestore.instance
                            .collection("prodOrders")
                            .doc(id)
                            .delete();

                        BlocProvider.of<BalanceCubit>(context)
                            .increaseBalance(priceAfterDiscount * quantity);
                        deleteOrder(id);
                        CustomSnackBar.show(
                            context, S.of(context).deleteSec, AppColors.kGreen);
                      }
                    },
                    child: Icon(
                      Icons.close,
                      color: AppColors.kRed,
                      size: width / 18,
                    ));
              },
            )
          ],
        )
      ],
    );
  }
}
