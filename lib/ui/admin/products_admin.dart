import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_svg/svg.dart';
import 'package:ionicons/ionicons.dart';
import '../../logic/theme/theme_cubit.dart';

import '../../../constants/colors.dart';
import '../../../constants/fonts.dart';
import '../../../generated/l10n.dart';
import '../../../models/product.dart';
import '../../logic/language/language_cubit.dart';
import 'add_product.dart';
import 'product_dialog.dart';

class ProductsAdmin extends StatefulWidget {
  const ProductsAdmin({super.key});

  @override
  State<ProductsAdmin> createState() => _ProductsAdminState();
}

class _ProductsAdminState extends State<ProductsAdmin> {
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

  Future<bool> deleteProduct(String id) async {
    try {
      await FirebaseFirestore.instance.collection("products").doc(id).delete();
      return true;
    } catch (e) {
      return false;
    }
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
                fontSize: width / 18,
                color: AppColors.kWhite,
                fontFamily: AppFonts.poppins,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          actions: [
            SizedBox(
              width: width / 10,
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          SizedBox(
            height: height / 60,
          ),
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: width / 30,
            ),
            width: width,
            height: height / 17,
            child: ElevatedButton(
              onPressed: () async {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  builder: (context) {
                    return AddProduct(getProducts: getProducts);
                  },
                );
              },
              style: Theme.of(context).elevatedButtonTheme.style!.copyWith(
                    shape: WidgetStatePropertyAll(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                        side: const BorderSide(color: AppColors.kBlueLight),
                      ),
                    ),
                    backgroundColor: const WidgetStatePropertyAll(
                      AppColors.kWhite,
                    ),
                  ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Ionicons.add,
                    color: AppColors.kBlueLight,
                    size: width / 18,
                  ),
                  Text(
                    S.of(context).addProduct,
                    style: TextStyle(
                      fontSize: width / 26,
                      color: AppColors.kBlueLight,
                      fontFamily: AppFonts.poppins,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
          ProductsGridView(
            products: myProducts,
            deleteProduct: deleteProduct,
            getProducts: getProducts,
          ),
        ],
      ),
    );
  }
}

class ProductsGridView extends StatelessWidget {
  final List<MyProduct> products;
  final Function getProducts;
  final Function deleteProduct;
  const ProductsGridView({
    super.key,
    required this.products,
    required this.deleteProduct,
    required this.getProducts,
  });

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return MasonryGridView.builder(
      shrinkWrap: true,
      padding: const EdgeInsets.all(10),
      itemCount: products.length,
      mainAxisSpacing: 10,
      crossAxisSpacing: 10,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverSimpleGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: width > 500 ? 3 : 2,
      ),
      itemBuilder: (context, index) => OneProduct(
        product: products[index],
        deleteProduct: deleteProduct,
        getProducts: getProducts,
      ),
    );
  }
}

class OneProduct extends StatelessWidget {
  final MyProduct product;
  final Function getProducts;
  final Function deleteProduct;
  const OneProduct({
    super.key,
    required this.product,
    required this.deleteProduct,
    required this.getProducts,
  });

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return GestureDetector(
      onLongPress: () {
        showDialog(
          context: context,
          // Optional: avoid overflow in certain cases

          builder: (context) {
            return ProductDialog(
              myProduct: product,
              getProducts: getProducts,
              deleteProduct: deleteProduct,
            );
          },
        );
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
                  CachedNetworkImage(
                    imageUrl: product.image,
                    placeholder: (context, url) => Container(
                      color: Colors.transparent,
                      height: height / 20,
                      width: width / 10,
                    ),
                  ),
                  ProductInfo(
                    priceAfterDiscount: product.priceAfterDiscount,
                    price: product.price,
                    name: product.titleAr,
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
          ),
        ),
        Row(
          children: [
            Text(
              "$priceAfterDiscount ${S.of(context).kwd}",
              style: TextStyle(
                  fontFamily: AppFonts.poppins,
                  fontSize: width / 22,
                  fontWeight: FontWeight.bold),
              textAlign: TextAlign.start,
            ),
            const SizedBox(
              width: 5,
            ),
            price != priceAfterDiscount? Text(
              "$price ${S.of(context).kwd}",
              style: TextStyle(
                fontFamily: AppFonts.poppins,
                decoration: priceAfterDiscount != price
                    ? TextDecoration.lineThrough
                    : null,
                fontSize: priceAfterDiscount != price ? width / 24 : width / 22,
                fontWeight: priceAfterDiscount != price
                    ? FontWeight.w400
                    : FontWeight.bold,
              ),
              textAlign: TextAlign.start,
            ):const SizedBox(),
          ],
        )
      ],
    );
  }
}
