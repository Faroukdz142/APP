import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import '../../../../models/mySection.dart';

import '../../../../constants/colors.dart';
import '../../../../constants/fonts.dart';
import '../../../../generated/l10n.dart';
import '../../../../widgets/snack_bar.dart';
import '../../../../widgets/text_field.dart';

class AddCat extends StatefulWidget {
  final MySection section;
  final Function fetchItems;
  const AddCat({super.key, required this.section, required this.fetchItems});

  @override
  State<AddCat> createState() => _AddCatState();
}

class _AddCatState extends State<AddCat> {
  Uint8List? image;
  final titleAr = TextEditingController();
  final titleEn = TextEditingController();
  bool isAddCategoryLoading = false;
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Padding(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Container(
        height: height / 2.2,
        padding: EdgeInsets.only(
          left: width / 20,
          right: width / 20,
          bottom: height / 45,
        ),
        child:
            Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          const SizedBox(
            height: 5,
          ),
          Center(
            child: Center(
              child: Container(
                height: 5,
                width: 60,
                decoration: BoxDecoration(
                  color: AppColors.kGreyForDivider,
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
          ),
          SizedBox(
            height: height / 60,
          ),
          ListTile(
            trailing: const SizedBox(),
            leading: Icon(
              Icons.arrow_back_ios,
              size: width / 16,
          
            ),
            title: Text(
              S.of(context).catDetails,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: width / 26,
            
                fontFamily: AppFonts.poppins,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(
            height: height / 90,
          ),
          CustomTextField(
            validator: (v) {},
            controller: titleAr,
            hintText: S.of(context).catAr,
          ),
          SizedBox(
            height: height / 90,
          ),
          CustomTextField(
            validator: (v) {},
            controller: titleEn,
            hintText: S.of(context).catEn,
          ),
          const Spacer(),
          SizedBox(
            width: width,
            height: height / 17,
            child: ElevatedButton(
              onPressed: () async {
             if (titleAr.text.isNotEmpty && titleEn.text.isNotEmpty){
                 setState(
                  () {
                    isAddCategoryLoading = true;
                  },
                );
                final isDone = await addCategory();
                if (isDone) {
                  CustomSnackBar.show(
                      context, S.of(context).addedCat, AppColors.kGreen);
                  await widget.fetchItems();
                } else {
                  CustomSnackBar.show(
                      context, S.of(context).tryAgain, AppColors.kRed);
                }
                setState(
                  () {
                    isAddCategoryLoading = false;
                  },
                );
                Navigator.pop(context);
             }
              },
              style: Theme.of(context).elevatedButtonTheme.style!.copyWith(
                    backgroundColor: const WidgetStatePropertyAll(
                      AppColors.kBlueLight,
                    ),
                  ),
              child: isAddCategoryLoading
                  ? LoadingAnimationWidget.discreteCircle(
                      color: AppColors.kDarkBlue, size: width / 18)
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
        ]),
      ),
    );
  }

  Future<bool> addCategory() async {
    try {
      final doc = await FirebaseFirestore.instance
          .collection("itemz")
          .doc(widget.section.id)
          .collection("categories")
          .add({
        "titleAr": titleAr.text,
        "titleEn": titleEn.text,
      });
      await FirebaseFirestore.instance
          .collection("itemz")
          .doc(widget.section.id)
          .collection("categories")
          .doc(doc.id)
          .update({"id": doc.id});
      return true;
    } catch (e) {
      return false;
    }
  }
}
