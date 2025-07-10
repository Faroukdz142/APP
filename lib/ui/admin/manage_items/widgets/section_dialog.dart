import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:confirm_dialog/confirm_dialog.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import '../../../../logic/theme/theme_cubit.dart';
import '../../../../models/mySection.dart';

import '../../../../constants/colors.dart';
import '../../../../constants/fonts.dart';
import '../../../../generated/l10n.dart';
import '../../../../widgets/snack_bar.dart';
import '../../../../widgets/text_field.dart';

class SectionDialog extends StatefulWidget {
  final MySection mySection;
  final Function getSections;
  final Function deleteSection;
  const SectionDialog(
      {super.key,
      required this.mySection,
      required this.getSections,
      required this.deleteSection});

  @override
  State<SectionDialog> createState() => _SectionDialogState();
}

class _SectionDialogState extends State<SectionDialog> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    titleAr.text = widget.mySection.titleAr;
    titleEn.text = widget.mySection.titleEn;
  }

  final titleAr = TextEditingController();
  final titleEn = TextEditingController();

  bool isSecLoading = false;
  bool isDeleteLoading = false;
  Uint8List? image;
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return AlertDialog(
      contentPadding: EdgeInsets.symmetric(horizontal: width / 18),
      content: SizedBox(
        height: height / 1.6,
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
                S.of(context).secDetails,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: width / 30,
                  fontFamily: AppFonts.poppins,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Text(
              S.of(context).secTitleArabic,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: width / 34,
                fontFamily: AppFonts.poppins,
                fontWeight: FontWeight.bold,
              ),
            ),
            CustomTextField(
                validator: (v) {},
                controller: titleAr,
                hintText: S.of(context).secTitleArabic),
            SizedBox(
              height: height / 70,
            ),
            Text(
              S.of(context).secTitleEnglish,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: width / 34,
                fontFamily: AppFonts.poppins,
                fontWeight: FontWeight.bold,
              ),
            ),
            CustomTextField(
                validator: (v) {},
                controller: titleEn,
                hintText: S.of(context).secTitleEnglish),
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
                          widget.mySection.image,
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
                  child: BlocBuilder<ThemeCubit, bool>(
                    builder: (context, isDark) {
                      return Column(
                        children: [
                          Text(
                            S.of(context).updatedPic,
                            textAlign: TextAlign.start,
                            style: TextStyle(
                              fontSize: width / 32,
                              color: isDark
                                  ? AppColors.kWhite
                                  : AppColors.kBlueLight,
                              fontFamily: AppFonts.poppins,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Icon(
                            Icons.replay,
                            color: isDark
                                ? AppColors.kWhite
                                : AppColors.kBlueLight,
                            size: width / 14,
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),
            const Spacer(),
            SizedBox(
              width: width,
              height: height / 17,
              child: ElevatedButton(
                onPressed: () async {
                  if (titleEn.text.isNotEmpty && titleEn.text.isNotEmpty) {
                    setState(() {
                      isSecLoading = true;
                    });

                    final isDone = await modifySec(context, titleAr.text,
                        titleEn.text, widget.mySection.id, image);
                    if (isDone) {
                      CustomSnackBar.show(
                          context, S.of(context).modifedSec, AppColors.kGreen);

                      titleAr.clear();
                      titleEn.clear();

                      await widget.getSections();
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
                  if (titleAr.text.isNotEmpty && titleEn.text.isNotEmpty) {
                    if (await confirm(context,
                        content: Text(S.of(context).sureDeleteSec))) {
                      setState(() {
                        isDeleteLoading = true;
                      });

                      final isDone =
                          await widget.deleteSection(widget.mySection.id);
                      if (isDone) {
                        CustomSnackBar.show(
                            context, S.of(context).deleteSec, AppColors.kGreen);
                        image = null;

                        titleAr.clear();
                        titleEn.clear();
                        await widget.getSections();
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

  Future<Uint8List?> pickAnImage(
      ImageSource source, BuildContext context) async {
    XFile? file = await ImagePicker().pickImage(source: source);
    if (file != null) {
      return await file.readAsBytes();
    } else {
      return null;
    }
  }

  Future<bool> modifySec(BuildContext context, String titleAr, String titleEn,
      String secId, Uint8List? image) async {
    try {
      final doc = FirebaseFirestore.instance.collection("itemz").doc(secId);

      if (image != null) {
        final imageUrl = await uploadImageToStorage(image);
        await doc.update({
          "titleAr": titleAr,
          "titleEn": titleEn,
          "image": imageUrl,
        });
      } else {
        await doc.update({
          "titleAr": titleAr,
          "titleEn": titleEn,
        });
      }

      return true;
    } catch (e) {
      return false;
    }
  }
}
