import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import '../../../../models/items.dart';
import '../../../../models/mySection.dart';

import '../../../../constants/colors.dart';
import '../../../../constants/fonts.dart';
import '../../../../generated/l10n.dart';
import '../../../../widgets/snack_bar.dart';
import '../../../../widgets/text_field.dart';

class CategoryDialog extends StatefulWidget {
  final MyCategory category;
  final MySection section;
  final Function fetchItems;
  const CategoryDialog(
      {super.key,
      required this.category,
      required this.section,
      required this.fetchItems});

  @override
  State<CategoryDialog> createState() => _CategoryDialogState();
}

class _CategoryDialogState extends State<CategoryDialog> {
  bool isCatLoading = false;
  bool isDeleteLoading = false;
  Uint8List? image;
  final catAr = TextEditingController();
  final catEn = TextEditingController();
  Uint8List? subitemImage;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    catAr.text = widget.category.titleAr;
    catEn.text = widget.category.titleEn;
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return AlertDialog(
      contentPadding: EdgeInsets.symmetric(horizontal: width / 18),
      content: SizedBox(
        height: height / 2.2,
        child: Column(
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
              
                ),
              ),
              title: Text(
                S.of(context).catDetails,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: width / 30,
              
                  fontFamily: AppFonts.poppins,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Text(
              S.of(context).catAr,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: width / 34,
            
                fontFamily: AppFonts.poppins,
                fontWeight: FontWeight.bold,
              ),
            ),
            CustomTextField(
                validator: (v) {},
                controller: catAr,
                hintText: S.of(context).catEn),
            SizedBox(
              height: height / 70,
            ),
            Text(
              S.of(context).catEn,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: width / 34,
            
                fontFamily: AppFonts.poppins,
                fontWeight: FontWeight.bold,
              ),
            ),
            CustomTextField(
                validator: (v) {},
                controller: catEn,
                hintText: S.of(context).catEn),
            const Spacer(),
            SizedBox(
              width: width,
              height: height / 17,
              child: ElevatedButton(
                onPressed: () async {
                  if (catEn.text.isNotEmpty && catEn.text.isNotEmpty) {
                    setState(() {
                      isCatLoading = true;
                    });

                    final isDone = await modifyCategory(
                        context, catAr.text, catEn.text, widget.category.id);

                    if (isDone) {
                      CustomSnackBar.show(
                          context, S.of(context).subAdded, AppColors.kGreen);

                      catAr.clear();
                      catEn.clear();

                      await widget.fetchItems();
                    } else {
                      CustomSnackBar.show(
                          context, S.of(context).tryAgain, AppColors.kRed);
                    }
                    Navigator.pop(context);
                    setState(() {
                      isCatLoading = false;
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
                child: isCatLoading
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
                  setState(() {
                    isDeleteLoading = true;
                  });

                  final isDone =
                      await deleteCategory(context, widget.category.id);

                  if (isDone) {
                    CustomSnackBar.show(
                        context, S.of(context).subAdded, AppColors.kGreen);
                    image = null;
                    subitemImage = null;
                    catAr.clear();
                    catEn.clear();
                    await widget.fetchItems();
                  } else {
                    CustomSnackBar.show(
                        context, S.of(context).tryAgain, AppColors.kRed);
                  }
                  Navigator.pop(context);
                  setState(() {
                    isDeleteLoading = false;
                  });
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
      ),
    );
  }

  Future<bool> modifyCategory(BuildContext context, String titleAr,
      String titleEn, String categoryId) async {
    try {
      await FirebaseFirestore.instance
          .collection("itemz")
          .doc(widget.section.id)
          .collection("categories")
          .doc(categoryId)
          .update({"titleAr": titleAr, "titleEn": titleEn});

      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> deleteCategory(BuildContext context, String categoryId) async {
    try {
      await FirebaseFirestore.instance
          .collection("itemz")
          .doc(widget.section.id)
          .collection("categories")
          .doc(categoryId)
          .delete();
      return true;
    } catch (e) {
      return false;
    }
  }
}
