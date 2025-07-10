import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:confirm_dialog/confirm_dialog.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import '../../models/mySection.dart';
import '../../models/product.dart';

import '../../../../constants/colors.dart';
import '../../../../constants/fonts.dart';
import '../../../../generated/l10n.dart';
import '../../../../widgets/snack_bar.dart';
import '../../../../widgets/text_field.dart';

class ProductDialog extends StatefulWidget {
  final MyProduct myProduct;
  final Function getProducts;
  final Function deleteProduct;
  const ProductDialog(
      {super.key,
      required this.myProduct,
      required this.getProducts,
      required this.deleteProduct});

  @override
  State<ProductDialog> createState() => _ProductDialogState();
}

class _ProductDialogState extends State<ProductDialog> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    titleAr.text = widget.myProduct.titleAr;
    titleEn.text = widget.myProduct.titleEn;
    price.text = widget.myProduct.price.toString();
    priceAfterDiscount.text = widget.myProduct.priceAfterDiscount.toString();
    description.text = widget.myProduct.description.toString();
  }

  final titleAr = TextEditingController();
  final titleEn = TextEditingController();
  final price = TextEditingController();
  final priceAfterDiscount = TextEditingController();
  final description = TextEditingController();

  bool isSecLoading = false;
  bool isDeleteLoading = false;
  Uint8List? image;
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return AlertDialog(
      contentPadding: EdgeInsets.symmetric(horizontal: width / 18),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            contentPadding: EdgeInsets.only(top: width / 80, left: 5),
            trailing: const SizedBox(),
            leading: GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Icon(
                Icons.arrow_back_ios,
                size: width / 16,
                color: AppColors.kBlack,
              ),
            ),
            title: Text(
              S.of(context).productDetails,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: width / 30,
                color: AppColors.kBlack,
                fontFamily: AppFonts.poppins,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Row(
            children: [
              Expanded(
                child: CustomTextField(
                  validator: (v) {},
                  controller: titleAr,
                  hintText: S.of(context).productAr,
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              Expanded(
                child: CustomTextField(
                  validator: (v) {},
                  controller: titleEn,
                  hintText: S.of(context).productEn,
                ),
              ),
            ],
          ),
          SizedBox(
            height: height / 70,
          ),
          Row(
            children: [
              Expanded(
                  child: CustomTextField(
                      validator: (v) {},
                      controller: price,
                      hintText: S.of(context).price)),
              SizedBox(
                width: 10,
              ),
              Expanded(
                child: CustomTextField(
                    validator: (v) {},
                    controller: priceAfterDiscount,
                    hintText: S.of(context).priceAfterDiscount),
              )
            ],
          ),
          SizedBox(
            height: height / 90,
          ),
          SizedBox(
            height: height / 10,
            child: CustomTextField(
              validator: (v) {},
              controller: description,
              hintText: S.of(context).prDescription,
            ),
          ),
          SizedBox(
            height: height / 30,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                height: height / 8,
                width: height / 5,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: image != null
                    ? Image.memory(image!)
                    : Image.network(
                        widget.myProduct.image,
                        fit: BoxFit.contain,
                      ),
              ),
              SizedBox(
                height: height / 20,
              ),
              GestureDetector(
                onTap: () async {
                  image = await pickAnImage(ImageSource.gallery, context);
                  if (image != null) {
                    CustomSnackBar.show(
                        context, S.of(context).imagePicked, AppColors.kGreen);
                  } else {
                    CustomSnackBar.show(
                        context, S.of(context).pickImage, AppColors.kRed);
                  }
                  setState(() {});
                },
                child: Column(
                  children: [
                    Text(
                      S.of(context).updatedPic,
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        fontSize: width / 32,
                        color: AppColors.kBlueLight,
                        fontFamily: AppFonts.poppins,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Icon(
                      Icons.replay,
                      color: AppColors.kBlueLight,
                      size: width / 14,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          SizedBox(
            width: width,
            height: height / 17,
            child: ElevatedButton(
              onPressed: () async {
                if (titleEn.text.isNotEmpty &&
                    titleEn.text.isNotEmpty &&
                    price.text.isNotEmpty &&
                    description.text.isNotEmpty &&
                    priceAfterDiscount.text.isNotEmpty) {
                  setState(() {
                    isSecLoading = true;
                  });

                  final isDone = await modifyProduct(context, titleAr.text,
                      titleEn.text, widget.myProduct.id, price.text,priceAfterDiscount.text,description.text ,image);
                  if (isDone) {
                    CustomSnackBar.show(
                        context, S.of(context).modifedSec, AppColors.kGreen);

                    titleAr.clear();
                    titleEn.clear();

                    await widget.getProducts();
                  } else {
                    CustomSnackBar.show(
                        context, S.of(context).tryAgain, AppColors.kRed);
                  }
                  Navigator.pop(context);
                  setState(() {
                    isSecLoading = false;
                  });
                } else {
                  CustomSnackBar.show(
                    context,
                    S.of(context).tryAgain,
                    AppColors.kRed,
                  );
                }
              },
              style: Theme.of(context).elevatedButtonTheme.style!.copyWith(
                    backgroundColor: const WidgetStatePropertyAll(
                      AppColors.kBlueLight,
                    ),
                  ),
              child: isSecLoading
                  ? LoadingAnimationWidget.discreteCircle(
                      color: AppColors.kDarkBlue,
                      size: width / 18,
                    )
                  : Text(
                      S.of(context).save,
                      style: TextStyle(
                        fontSize: width / 26,
                        color: AppColors.kWhite,
                        fontFamily: AppFonts.poppins,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
            ),
          ),
          SizedBox(
            height: height / 70,
          ),
          SizedBox(
            width: width,
            height: height / 17,
            child: ElevatedButton(
              onPressed: () async {
                if (titleAr.text.isNotEmpty &&
                    titleEn.text.isNotEmpty &&
                    price.text.isNotEmpty &&
                    priceAfterDiscount.text.isNotEmpty &&
                    description.text.isNotEmpty) {
                  if (await confirm(context,
                      content: Text(S.of(context).sureDeleteProduct))) {
                    setState(() {
                      isDeleteLoading = true;
                    });

                    final isDone =
                        await widget.deleteProduct(widget.myProduct.id);
                    if (isDone) {
                      CustomSnackBar.show(
                          context, S.of(context).deleteSec, AppColors.kGreen);
                      image = null;

                      titleAr.clear();
                      titleEn.clear();
                      await widget.getProducts();
                    } else {
                      CustomSnackBar.show(
                          context, S.of(context).tryAgain, AppColors.kRed);
                    }
                    Navigator.pop(context);
                    setState(() {
                      isDeleteLoading = false;
                    });
                  }
                } else {
                  CustomSnackBar.show(
                      context, S.of(context).tryAgain, AppColors.kRed);
                }
              },
              style: Theme.of(context).elevatedButtonTheme.style!.copyWith(
                    backgroundColor: const WidgetStatePropertyAll(
                      AppColors.kRed,
                    ),
                  ),
              child: isDeleteLoading
                  ? LoadingAnimationWidget.discreteCircle(
                      color: AppColors.kDarkBlue,
                      size: width / 18,
                    )
                  : Text(
                      S.of(context).delete,
                      style: TextStyle(
                        fontSize: width / 26,
                        color: AppColors.kWhite,
                        fontFamily: AppFonts.poppins,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
            ),
          ),
          SizedBox(
            height: height / 40,
          ),
        ],
      ),
    );
  }

  Future<String> uploadImageToStorage(Uint8List file) async {
    Reference ref = FirebaseStorage.instance
        .ref('products')
        .child(DateTime.now().millisecondsSinceEpoch.toString());
    UploadTask uploadTask = ref.putData(file);
    TaskSnapshot snapshot = await uploadTask;
    String downloadUrl = await snapshot.ref.getDownloadURL();
    return downloadUrl;
  }

  Future<Uint8List?> pickAnImage(
      ImageSource source, BuildContext context) async {
    XFile? file = await ImagePicker().pickImage(source: source);
    if (file != null) {
      return await file.readAsBytes();
    } else {
      return null;
    }
  }

  Future<bool> modifyProduct(
      BuildContext context,
      String titleAr,
      String titleEn,
      String id,
      String price,
      String priceAfterDiscount,
      String description,
      Uint8List? image) async {
    try {
      final doc = FirebaseFirestore.instance.collection("products").doc(id);

      if (image != null) {
        final imageUrl = await uploadImageToStorage(image);
        await doc.update({
          "titleAr": titleAr,
          "titleEn": titleEn,
          "price": double.parse(price),
          "priceAfterDiscount": double.parse(priceAfterDiscount),
          "description": description,
          "image": imageUrl,
        });
      } else {
        await doc.update({
          "titleAr": titleAr,
          "titleEn": titleEn,
          "price": double.parse(price),
          "priceAfterDiscount": double.parse(priceAfterDiscount),
          "description": description,
          
        });
      }

      return true;
    } catch (e) {
      return false;
    }
  }
}
