import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ionicons/ionicons.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../../../../constants/colors.dart';
import '../../../../constants/fonts.dart';
import '../../../../generated/l10n.dart';
import '../../../../widgets/snack_bar.dart';
import '../../../../widgets/text_field.dart';

class SectionDetailsWidget extends StatefulWidget {
  final Function getSections;
  const SectionDetailsWidget({super.key, required this.getSections});

  @override
  State<SectionDetailsWidget> createState() => _SectionDetailsWidgetState();
}

class _SectionDetailsWidgetState extends State<SectionDetailsWidget> {
  final titleAr = TextEditingController();
  final titleEn = TextEditingController();
  bool isSubmitLoading = false;
  Uint8List? image;
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
              height: height / 120,
            ),
            ListTile(
              trailing: const SizedBox(),
              leading: Icon(
                Icons.arrow_back_ios,
                size: width / 16,
              
              ),
              title: Text(
                S.of(context).secDetails,
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
              hintText: S.of(context).secTitleArabic,
            ),
            SizedBox(
              height: height / 90,
            ),
            CustomTextField(
              validator: (v) {},
              controller: titleEn,
              hintText: S.of(context).secTitleEnglish,
            ),
            SizedBox(
              height: height / 40,
            ),
            SizedBox(
              width: width,
              height: height / 17,
              child: ElevatedButton(
                onPressed: () async {
                  image = await pickAnImage(ImageSource.gallery, context);
                  setState(() {});
                },
                style: Theme.of(context).elevatedButtonTheme.style!.copyWith(
                      shape: WidgetStatePropertyAll(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                          side: BorderSide(
                              color: image != null
                                  ? AppColors.kGreen
                                  : AppColors.kBlueLight),
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
                      image != null ? Ionicons.checkmark : Ionicons.add,
                      color: image != null
                          ? AppColors.kGreen
                          : AppColors.kBlueLight,
                      size: width / 18,
                    ),
                    Text(
                      image != null
                          ? S.of(context).imagePicked
                          : S.of(context).pickImage,
                      style: TextStyle(
                        fontSize: width / 26,
                        color: image != null
                            ? AppColors.kGreen
                            : AppColors.kBlueLight,
                        fontFamily: AppFonts.poppins,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const Spacer(),
            Container(
              margin: EdgeInsets.only(
                bottom: height / 120,
              ),
              width: width * .4,
              height: height / 17,
              child: ElevatedButton(
                onPressed: () async {
                  if (titleAr.text.isNotEmpty && titleEn.text.isNotEmpty && image!= null) {
                    setState(() {
                      isSubmitLoading = true;
                    });

                    final isDone = await submit(
                        context, image!, titleAr.text, titleEn.text);
                    if (isDone) {
                      CustomSnackBar.show(
                          context, S.of(context).secAdded, AppColors.kGreen);
                      image = null;
                      titleAr.clear();
                      titleEn.clear();
                      widget.getSections();
                    } else {
                      CustomSnackBar.show(
                          context, S.of(context).tryAgain, AppColors.kRed);
                    }
                    Navigator.pop(context);
                    setState(() {
                      isSubmitLoading = false;
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
                child: isSubmitLoading
                    ? LoadingAnimationWidget.discreteCircle(
                        color: AppColors.kDarkBlue,
                        size: width / 18,
                      )
                    : Text(
                        S.of(context).save,
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
        ),
      ),
    );
  }

  Future<bool> submit(BuildContext context, Uint8List image, String titleAr,
      String titleEn) async {
    try {
      //Uint8List? profilePic = await pickAnImage(ImageSource.gallery, context);

      final imageUrl = await uploadImageToStorage(image);

      final doc = await FirebaseFirestore.instance
          .collection("itemz")
          .add({"image": imageUrl, "titleAr": titleAr, "titleEn": titleEn});

      await FirebaseFirestore.instance.collection("itemz").doc(doc.id).update({
        "id": doc.id,
      });
      return true;
    } catch (e) {
      return false;
    }
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
