import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:confirm_dialog/confirm_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import '../../../../logic/language/language_cubit.dart';
import '../../../../models/items.dart';
import '../../../../models/mySection.dart';

import '../../../../constants/colors.dart';
import '../../../../constants/fonts.dart';
import '../../../../generated/l10n.dart';
import '../../../../widgets/snack_bar.dart';
import '../../../../widgets/text_field.dart';

class SubItemDetails extends StatefulWidget {
  final SubItem subItem;
  final MySection section;
  final MyCategory category;
  final Function fetchItems;
  final Item item;

  const SubItemDetails(
      {super.key,
      required this.item,
      required this.subItem,
      required this.section,
      required this.category,
      required this.fetchItems});

  @override
  State<SubItemDetails> createState() => _SubItemDetailsState();
}

class _SubItemDetailsState extends State<SubItemDetails> {
  final titleAr = TextEditingController();
  final titleEn = TextEditingController();
  final price = TextEditingController();
  final fastPrice = TextEditingController();

  bool isDeleteLoading = false;
  bool isLoading = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    titleAr.text = widget.subItem.titleAr;
    titleEn.text = widget.subItem.titleEn;
    price.text = widget.subItem.price.toString();
    fastPrice.text = widget.subItem.priceFast.toString();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final price = TextEditingController(text: widget.subItem.price.toString());

    return Padding(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Container(
        height: height / 1.8,
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
              leading: GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Icon(
                  Icons.arrow_back_ios,
                  size: width / 16,
                ),
              ),
              title: BlocBuilder<LanguageCubit, String>(
                builder: (context, state) {
                  return Text(
                    state == "ar"
                        ? widget.subItem.titleAr
                        : widget.subItem.titleEn,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: width / 26,
                      fontFamily: AppFonts.poppins,
                      fontWeight: FontWeight.bold,
                    ),
                  );
                },
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        S.of(context).subAr,
                        textAlign: TextAlign.center,
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
                    ],
                  ),
                ),
                const SizedBox(
                  width: 5,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        S.of(context).subEn,
                        textAlign: TextAlign.center,
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
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(
              height: height / 90,
            ),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        S.of(context).price,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: width / 32,
                          fontFamily: AppFonts.poppins,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      CustomTextField(
                        validator: (v) {},
                        controller: price,
                        hintText: S.of(context).price,
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  width: 5,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        S.of(context).fastPrice,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: width / 32,
                          fontFamily: AppFonts.poppins,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      CustomTextField(
                        validator: (v) {},
                        controller: fastPrice,
                        hintText: S.of(context).fastPrice,
                      ),
                    ],
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
                      final isDone = await submit(titleAr.text, titleEn.text,
                          price.text, fastPrice.text);
                      if (isDone) {
                        CustomSnackBar.show(context, S.of(context).itemUpdated,
                            AppColors.kGreen);
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
                          context, S.of(context).tryAgain, AppColors.kRed);
                    }
                  },
                  style: Theme.of(context).elevatedButtonTheme.style!.copyWith(
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
                        )),
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
                      CustomSnackBar.show(
                          context, S.of(context).deleteItem, AppColors.kGreen);

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
          ],
        ),
      ),
    );
  }

  Future<bool> deleteItem() async {
    try {
      final doc = FirebaseFirestore.instance
          .collection("itemz")
          .doc(widget.section.id)
          .collection("categories")
          .doc(widget.category.id)
          .collection("items")
          .doc(widget.item.id)
          .collection("subItems")
          .doc(widget.subItem.id);

      await doc.delete();

      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> submit(
      String titleAr, String titleEn, String price, String fastPrice) async {
    try {
      final doc = FirebaseFirestore.instance
          .collection("itemz")
          .doc(widget.section.id)
          .collection("categories")
          .doc(widget.category.id)
          .collection("items")
          .doc(widget.item.id)
          .collection("subItems")
          .doc(widget.subItem.id);

      await doc.update({
        "titleAr": titleAr,
        "price": double.parse(price),
        "fastPrice": double.parse(fastPrice),
        "titleEn": titleEn,
      });

      return true;
    } catch (e) {
      return false;
    }
  }
}
