import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ionicons/ionicons.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../../../logic/language/language_cubit.dart';
import 'widgets/section_details.dart';
import '../../../config/routes.dart';
import '../../../constants/colors.dart';
import '../../../constants/fonts.dart';
import '../../../generated/l10n.dart';
import '../../../models/mySection.dart';
import 'widgets/section_dialog.dart';

class AddSection extends StatefulWidget {
  const AddSection({super.key});

  @override
  AddSectionState createState() => AddSectionState();
}

class AddSectionState extends State<AddSection> {
  List<MySection> mySections = [];
  @override
  void initState() {
    super.initState();
    getSections();
  }

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: PreferredSize(
        preferredSize: MediaQuery.of(context).size / 16,
        child: AppBar(
          toolbarHeight: height / 20,
          backgroundColor: AppColors.kBlueLight,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(20),
            ),
          ),
          leading: BlocBuilder<LanguageCubit, String>(
            builder: (context, state) {
              return Padding(
                padding: EdgeInsets.only(
                    right: state == "ar" ? width / 30 : 0,
                    left: state == "en" ? width / 30 : 0),
                child: GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Icon(
                    Icons.arrow_back_ios,
                    color: AppColors.kWhite,
                    size: width / 18,
                  ),
                ),
              );
            },
          ),
          title: Center(
            child: Text(
              S.of(context).manageSections,
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
              width: width / 10,
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Skeletonizer(
              enabled: isLoading,
              child: GridView.builder(
                shrinkWrap: true,
                padding: EdgeInsets.zero,
                itemCount: mySections.length,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: width / 200,
                ),
                itemBuilder: (context, index) => GestureDetector(
                  onLongPress: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return SectionDialog(
                          mySection: mySections[index],
                          deleteSection: deleteSection,
                          getSections: getSections,
                        );
                      },
                    );
                  },
                  onTap: () {
                    Navigator.of(context).pushNamed(AppRoutes.laundryAdmin,
                        arguments: mySections[index]);
                  },
                  child: Container(
                    padding: EdgeInsets.all(width / 60),
                    margin: EdgeInsets.all(width / 60),
                    decoration: BoxDecoration(
                      color: AppColors.kWhite,
                      boxShadow: const [
                        BoxShadow(
                          color: AppColors.kGreyForDivider,
                          blurRadius: 5,
                          spreadRadius: 0,
                        ),
                      ],
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Expanded(
                          child: SizedBox(
                            // height: height / 6,
                            width: width / 2,
                            child: CachedNetworkImage(
                              imageUrl: mySections[index].image,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: height / 60,
                        ),
                        BlocBuilder<LanguageCubit, String>(
                          builder: (context, state) {
                            return Text(
                              state == "ar"
                                  ? mySections[index].titleAr
                                  : mySections[index].titleEn,
                              style: TextStyle(
                                fontSize: width / 32,
                                color: AppColors.kBlack,
                                fontFamily: AppFonts.poppins,
                                fontWeight: FontWeight.bold,
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: height / 80,
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: width / 30),
              width: width,
              height: height / 17,
              child: ElevatedButton(
                onPressed: () async {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    builder: (context) {
                      return SectionDetailsWidget(
                        getSections: getSections,
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
                      Ionicons.add,
                      color: AppColors.kBlueLight,
                      size: width / 18,
                    ),
                    Text(
                      S.of(context).addSec,
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
      ),
    );
  }

  Future<bool> deleteSection(String id) async {
    try {
      setState(() {
        mySections.removeWhere((e) => e.id == id);
      });

      await FirebaseFirestore.instance.collection("itemz").doc(id).delete();
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<void> getSections() async {
    mySections = [];
    setState(() {
      isLoading = true;
    });
    final doc = await FirebaseFirestore.instance.collection("itemz").get();
    for (var x in doc.docs) {
      mySections.add(MySection.fromJson(x));
    }
    setState(() {
      isLoading = false;
    });
  }
}
