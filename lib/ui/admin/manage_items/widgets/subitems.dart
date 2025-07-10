import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import '../../../../logic/language/language_cubit.dart';
import '../../../../models/mySection.dart';

import '../../../../constants/colors.dart';
import '../../../../constants/fonts.dart';
import '../../../../generated/l10n.dart';
import '../../../../models/items.dart';
import '../../../../widgets/snack_bar.dart';
import '../../../../widgets/text_field.dart';
import 'add_new_subItem.dart';
import 'sub_item_admin.dart';

class SubItems extends StatefulWidget {
  final Item item;
  final MyCategory category;
  final MySection section;
  final Function fetchItems;
  const SubItems(
      {super.key,
      required this.item,
      required this.category,
      required this.section,
      required this.fetchItems});

  @override
  State<SubItems> createState() => _SubItemsState();
}

class _SubItemsState extends State<SubItems> {
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Container(
      height: height / 1.5,
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
            leading: Icon(
              Icons.arrow_back_ios,
              size: width / 16,
             
            ),
            title: BlocBuilder<LanguageCubit, String>(
              builder: (context, state) {
                return Text(
                  state == "ar" ? widget.item.titleAr.split(".").length==2?  widget.item.titleAr.split(".")[1]: widget.item.titleAr: widget.item.titleEn,
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
          Expanded(
            child: ListView.builder(
              itemCount: widget.item.subItems.length,
              itemBuilder: (context, indexx) {
                final subItem = widget.item.subItems[indexx];
                return SubItemAdminWidget(
                  index: indexx,
                  category: widget.category,
                  fetchItems: widget.fetchItems,
                  item: widget.item,
                  section: widget.section,
                  subItem: subItem,
                );
              },
            ),
          ),
          SizedBox(
            width: width,
            height: height / 17,
            child: ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  builder: (context) {
                    return AddNewSubItem(
                      item: widget.item,
                      section: widget.section,
                      category: widget.category,
                      fetchItems: widget.fetchItems,
                    );
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
                    Icons.add,
                    color: AppColors.kBlueLight,
                    size: width / 18,
                  ),
                  Text(
                    S.of(context).addSub,
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
        ],
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
}
