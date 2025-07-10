import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import '../../config/routes.dart';
import '../../constants/fonts.dart';
import '../../generated/l10n.dart';
import 'widgets/productImage.dart';
import 'package:widget_and_text_animator/widget_and_text_animator.dart';

import '../../../models/product.dart';
import '../../constants/colors.dart';
import 'widgets/productDetailsWidget.dart';
enum FromWhere{
  orders,ourProducts
}
class ProductDetails extends StatelessWidget {
  final FromWhere from;
  final MyProduct product;
  const ProductDetails({super.key, required this.product,required this.from});

  @override
  Widget build(BuildContext context) {
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
            S.of(context).productDetails,
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
            width: width / 20,
          ),
        ],
      ),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: ProductImage(
                image: product.image,
                id: product.id,
              ),
            ),
            SliverFillRemaining(
              child: ProductDetailsWidget(product: product,from: from),
            )
          ],
        ),
      ),
    );
  }
}
