import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ionicons/ionicons.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import '../../../../models/items.dart';
import '../../../../models/mySection.dart';

import '../../../../constants/colors.dart';
import '../../../../constants/fonts.dart';
import '../../../../generated/l10n.dart';
import '../../../../widgets/snack_bar.dart';
import '../../../../widgets/text_field.dart';

class AddNewSubItem extends StatefulWidget {
  final MySection section;
  final MyCategory category;
  final Item item;
  final Function fetchItems;
  const AddNewSubItem(
      {super.key,
      required this.item,
      required this.section,
      required this.category,
      required this.fetchItems});

  @override
  State<AddNewSubItem> createState() => _AddNewSubItemState();
}

class _AddNewSubItemState extends State<AddNewSubItem> {
  final titleAr = TextEditingController();
  final titleEn = TextEditingController();
  final price = TextEditingController();
  final fastPrice = TextEditingController();
  bool isSubitemLoading = false;
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Padding(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Container(
        height: height / 1.8,
        padding: EdgeInsets.only(
          left: width / 20,
          right: width / 20,
          bottom: height / 45,
        ),
        width: width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
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
                S.of(context).subitemDetails,
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
              hintText: S.of(context).subAr,
            ),
            SizedBox(
              height: height / 90,
            ),
            CustomTextField(
              validator: (v) {},
              controller: titleEn,
              hintText: S.of(context).subEn,
            ),
            SizedBox(
              height: height / 90,
            ),
            CustomTextField(
              validator: (v) {},
              controller: price,
              hintText: S.of(context).price,
            ),
            SizedBox(
              height: height / 90,
            ),
            CustomTextField(
              validator: (v) {},
              controller: fastPrice,
              hintText: S.of(context).fastPrice,
            ),
            SizedBox(
              height: height / 40,
            ),
            const Spacer(),
            SizedBox(
              width: width,
              height: height / 17,
              child: ElevatedButton(
                onPressed: () async {
                  if (price.text.isNotEmpty &&
                      fastPrice.text.isNotEmpty &&
                      titleAr.text.isNotEmpty &&
                      titleEn.text.isNotEmpty) {
                    setState(() {
                      isSubitemLoading = true;
                    });

                    final isDone = await submitSubitem(
                        context,
                        titleAr.text,
                        titleEn.text,
                        price.text,
                        fastPrice.text,
                        widget.category.id,
                        widget.item.id);
                    if (isDone) {
                      CustomSnackBar.show(
                          context, S.of(context).subAdded, AppColors.kGreen);

                      titleAr.clear();
                      titleEn.clear();
                      price.clear();
                      fastPrice.clear();
                      await widget.fetchItems();
                    } else {
                      CustomSnackBar.show(
                          context, S.of(context).tryAgain, AppColors.kRed);
                    }
                    Navigator.pop(context);
                    setState(() {
                      isSubitemLoading = false;
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
                child: isSubitemLoading
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
          ],
        ),
      ),
    );
  }

  Future<String> uploadImageToStorage(Uint8List file) async {
    Reference ref = FirebaseStorage.instance
        .ref('itemz')
        .child(DateTime.now().millisecondsSinceEpoch.toString());
    UploadTask uploadTask = ref.putData(file);
    TaskSnapshot snapshot = await uploadTask;
    String downloadUrl = await snapshot.ref.getDownloadURL();
    return downloadUrl;
  }

  Future<bool> submitSubitem(
      BuildContext context,
      String titleAr,
      String titleEn,
      String price,
      String fastPrice,
      String categoryId,
      String itemId) async {
    try {
      final doc = await FirebaseFirestore.instance
          .collection("itemz")
          .doc(widget.section.id)
          .collection("categories")
          .doc(categoryId)
          .collection("items")
          .doc(itemId)
          .collection("subItems")
          .add({
        "titleAr": titleAr,
        "titleEn": titleEn,
        "price": double.parse(price),
        "fastPrice": double.parse(fastPrice),
      });

      await FirebaseFirestore.instance
          .collection("itemz")
          .doc(widget.section.id)
          .collection("categories")
          .doc(categoryId)
          .collection("items")
          .doc(itemId)
          .collection("subItems")
          .doc(doc.id)
          .update({
        "id": doc.id,
      });
      return true;
    } catch (e) {
      return false;
    }
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
}
