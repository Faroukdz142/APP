import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:confirm_dialog/confirm_dialog.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import '../../../../logic/language/language_cubit.dart';
import '../../../../logic/theme/theme_cubit.dart';
import '../../../../models/items.dart';
import '../../../../models/mySection.dart';
import '../../../../widgets/snack_bar.dart';

import '../../../../constants/colors.dart';
import '../../../../constants/fonts.dart';
import '../../../../generated/l10n.dart';
import '../../../../widgets/text_field.dart';

class ItemDetails extends StatefulWidget {
  final Item item;
  final MySection section;
  final MyCategory category;
  final Function fetchItems;
  const ItemDetails(
      {super.key,
      required this.item,
      required this.category,
      required this.section,
      required this.fetchItems});

  @override
  State<ItemDetails> createState() => _ItemDetailsState();
}

class _ItemDetailsState extends State<ItemDetails> {
  Uint8List? image;
  bool isLoading = false;
  bool isDeleteLoading = false;
  final titleAr = TextEditingController();
  final titleEn = TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    titleAr.text = widget.item.titleAr;
    titleEn.text = widget.item.titleEn;
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return BlocBuilder<LanguageCubit, String>(
      builder: (context, language) {
        return Padding(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Container(
            height: height / 1.6,
            padding: EdgeInsets.only(
              left: width / 20,
              right: width / 20,
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
                    language == "ar"
                        ? widget.item.titleAr
                        : widget.item.titleEn,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: width / 26,
                      fontFamily: AppFonts.poppins,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Text(
                  S.of(context).itemAr,
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    fontSize: width / 32,
                    fontFamily: AppFonts.poppins,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                CustomTextField(
                  validator: (v) {},
                  controller: titleAr,
                  hintText: S.of(context).itemAr,
                ),
                Text(
                  S.of(context).itemEn,
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    fontSize: width / 32,
                    fontFamily: AppFonts.poppins,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                CustomTextField(
                  validator: (v) {},
                  controller: titleEn,
                  hintText: S.of(context).itemEn,
                ),
                SizedBox(
                  height: height / 50,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      height: height / 9,
                      width: width / 5,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: image != null
                          ? Image.memory(image!)
                          : Image.network(
                              widget.item.image,
                              fit: BoxFit.contain,
                            ),
                    ),
                    GestureDetector(
                      onTap: () async {
                        image = await pickAnImage(ImageSource.gallery, context);
                        if (image != null) {
                          CustomSnackBar.show(context,
                              S.of(context).imagePicked, AppColors.kGreen);
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
                                  color:isDark?AppColors.kWhite: AppColors.kBlueLight,
                                  fontFamily: AppFonts.poppins,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Icon(
                                Icons.replay,
                                 color:isDark?AppColors.kWhite: AppColors.kBlueLight,
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
                  width: width * .4,
                  height: height / 17,
                  child: ElevatedButton(
                    onPressed: () async {
                      if (titleAr.text.isNotEmpty && titleEn.text.isNotEmpty) {
                        setState(() {
                          isLoading = true;
                        });
                        final isDone =
                            await submit(titleAr.text, titleEn.text, image);
                        if (isDone) {
                          CustomSnackBar.show(context,
                              S.of(context).itemUpdated, AppColors.kGreen);
                          widget.fetchItems();
                        } else {
                          CustomSnackBar.show(
                              context, S.of(context).tryAgain, AppColors.kRed);
                        }
                        setState(() {
                          isLoading = false;
                        });
                        Navigator.pop(context);
                      } else {
                        CustomSnackBar.show(
                          context,
                          S.of(context).tryAgain,
                          AppColors.kRed,
                        );
                      }
                    },
                    style:
                        Theme.of(context).elevatedButtonTheme.style!.copyWith(
                              backgroundColor: const WidgetStatePropertyAll(
                                AppColors.kBlueLight,
                              ),
                            ),
                    child: isLoading
                        ? LoadingAnimationWidget.discreteCircle(
                            color: AppColors.kWhite, size: width / 18)
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
                SizedBox(
                  height: height / 120,
                ),
                Container(
                  margin: EdgeInsets.only(
                    bottom: height / 40,
                  ),
                  width: width,
                  height: height / 17,
                  child: ElevatedButton(
                    onPressed: () async {
                      if (await confirm(context,
                          content: Text(S.of(context).sureDeleteItem))) {
                        setState(() {
                          isDeleteLoading = true;
                        });

                        final isDone = await deleteItem();
                        if (isDone) {
                          CustomSnackBar.show(context, S.of(context).deleteItem,
                              AppColors.kGreen);
                          image = null;

                          titleAr.clear();
                          titleEn.clear();
                          await widget.fetchItems();
                        } else {
                          CustomSnackBar.show(
                              context, S.of(context).tryAgain, AppColors.kRed);
                        }
                        Navigator.pop(context);
                        setState(() {
                          isDeleteLoading = false;
                        });
                      }
                    },
                    style:
                        Theme.of(context).elevatedButtonTheme.style!.copyWith(
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
              ],
            ),
          ),
        );
      },
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

  Future<bool> submit(String titleAr, String titleEn, Uint8List? image) async {
    try {
      final doc = FirebaseFirestore.instance
          .collection("itemz")
          .doc(widget.section.id)
          .collection("categories")
          .doc(widget.category.id)
          .collection("items")
          .doc(widget.item.id);
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

  Future<bool> deleteItem() async {
    try {
      final doc = FirebaseFirestore.instance
          .collection("itemz")
          .doc(widget.section.id)
          .collection("categories")
          .doc(widget.category.id)
          .collection("items")
          .doc(widget.item.id);

      await doc.delete();

      return true;
    } catch (e) {
      return false;
    }
  }
}
