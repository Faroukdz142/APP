import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_svg/svg.dart';
import 'package:ionicons/ionicons.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../../../logic/cubit/prod_cart_cubit.dart';
import '../../../logic/language/language_cubit.dart';
import '../../../models/cart.dart';
import '../../product_details/product_detail.dart';
import 'package:widget_and_text_animator/widget_and_text_animator.dart';

import '../../../config/routes.dart';
import '../../../constants/colors.dart';
import '../../../constants/fonts.dart';
import '../../../generated/l10n.dart';
import '../../../logic/theme/theme_cubit.dart';
import '../../../models/product.dart';

class OurProducts extends StatefulWidget {
  const OurProducts({super.key});

  @override
  State<OurProducts> createState() => _OurProductsState();
}

class _OurProductsState extends State<OurProducts> {
  bool isLoading = true;
  List<MyProduct> myProducts = [];
  @override
  void initState() {
    super.initState();
    getProducts();
  }

  Future<void> getProducts() async {
    myProducts = [];
    try {
      final products =
          await FirebaseFirestore.instance.collection("products").get();
      for (var x in products.docs) {
        myProducts.add(MyProduct.fromJson(x.data()));
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
              S.of(context).ourProducts,
              style: TextStyle(
                fontSize: width / 22,
                color: AppColors.kWhite,
                fontFamily: AppFonts.poppins,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          actions: [
            FirebaseAuth.instance.currentUser == null
                ? SizedBox(
                    width: width / 10,
                  )
                : GestureAnimator(
                    onTap: () {
                      Navigator.of(context).pushNamed(AppRoutes.productsOrders);
                    },
                    child:  Icon(
                          Icons.checklist_sharp,
                          color: AppColors.kWhite,
                          size: width / 12,
                        ),
                       
                  ),
            SizedBox(
              width: width / 50,
            ),
            FirebaseAuth.instance.currentUser == null
                ? SizedBox(
                    width: width / 10,
                  )
                : FirebaseAuth.instance.currentUser == null
                    ? SizedBox(
                        width: width / 10,
                      )
                    : BlocBuilder<ProdCartCubit, ProdCart>(
                        builder: (context, state) {
                          return GestureAnimator(
                            onTap: () {
                              Navigator.of(context)
                                  .pushNamed(AppRoutes.productsCart);
                            },
                            child: Stack(
                              alignment: Alignment.bottomRight,
                              children: [
                                Icon(
                                  Ionicons.cart,
                                  color: AppColors.kWhite,
                                  size: width / 12,
                                ),
                                FirebaseAuth.instance.currentUser == null ||
                                        state.itemsToPayFor.isEmpty
                                    ? SizedBox(
                                        width: width / 12,
                                      )
                                    : CircleAvatar(
                                        backgroundColor: AppColors.kRed,
                                        radius: width / 50,
                                        child: Center(
                                          child: Text(
                                            state.itemsToPayFor.length
                                                .toString(),
                                            style: TextStyle(
                                              fontSize: width / 34,
                                              fontFamily: AppFonts.poppins,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                      )
                              ],
                            ),
                          );
                        },
                      ),
            SizedBox(
              width: width / 30,
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(children: [
          Skeletonizer(
            enabled: isLoading,
            child: ProductsGridView(
              products: myProducts,
            ),
          ),
        ]),
      ),
    );
  }
}

class ProductsGridView extends StatelessWidget {
  final List<MyProduct> products;
  const ProductsGridView({super.key, required this.products});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return AnimationLimiter(
      child: MasonryGridView.builder(
        shrinkWrap: true,
        padding: const EdgeInsets.all(10),
        itemCount: products.length,
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
                    child: OneProduct(product: products[index])))),
      ),
    );
  }
}

class OneProduct extends StatelessWidget {
  final MyProduct product;

  const OneProduct({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pushNamed(AppRoutes.details,
            arguments: {"product": product, "from": FromWhere.ourProducts});
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
  final double priceAfterDiscount;
  const ProductInfo({
    super.key,
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
      ],
    );
  }
}
