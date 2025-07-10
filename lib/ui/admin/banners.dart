import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider_plus/carousel_slider_plus.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ionicons/ionicons.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../../widgets/snack_bar.dart';

import '../../constants/colors.dart';
import '../../constants/fonts.dart';
import '../../generated/l10n.dart';
import '../../logic/indicator/page_indicator_cubit.dart';
import '../../logic/language/language_cubit.dart';
import '../../models/my_banner.dart';
import '../../widgets/pageIndicator.dart';

class Banners extends StatefulWidget {
  const Banners({super.key});

  @override
  State<Banners> createState() => _BannersState();
}

class _BannersState extends State<Banners> {
  bool isLoading = false;
  Uint8List? arabic;
  Uint8List? english;
  MyBanner? myBanner;
  List<MyBanner> carouselImages = [];
  @override
  void initState() {
    super.initState();
    getBanners();
  }

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
                padding: EdgeInsets.only(right: state=="ar"? width/30:0,left: state=="en"? width/30:0),
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
              S.of(context).banners,
              style: TextStyle(
                fontSize: width / 23,
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
      body: Column(
        children: [
          carouselImages.isEmpty
              ? const SizedBox()
              : SizedBox(
                  height: height / 30,
                ),
          Skeletonizer(
            enabled: isLoading,
            child: CarouselSlider(
              options: CarouselOptions(
                height: height / 4.5,
                aspectRatio: 16 / 9,
                viewportFraction: 0.9,
                initialPage: 0,
                enableInfiniteScroll: false,
                reverse: false,
                onPageChanged: (index, reason) {
                  myBanner = carouselImages[index];
                  BlocProvider.of<PageIndicatorCubit>(context)
                      .onPageChanged(currentIndex: index);
                },
                autoPlay: false,
                autoPlayInterval: const Duration(seconds: 3),
                autoPlayAnimationDuration: const Duration(milliseconds: 800),
                autoPlayCurve: Curves.fastOutSlowIn,
                enlargeCenterPage: true,
                enlargeFactor: 0.3,
                scrollDirection: Axis.horizontal,
              ),
              items: carouselImages.map((i) {
                return BlocBuilder<LanguageCubit, String>(
                  builder: (context, state) {
                    return SizedBox(
                      width: width,
                      child: CachedNetworkImage(
                        imageUrl: state == "ar" ? i.ar : i.en,
                        fit: BoxFit.cover,
                      ),
                    );
                  },
                );
              }).toList(),
            ),
          ),
          carouselImages.isEmpty
              ? const SizedBox()
              : BlocBuilder<PageIndicatorCubit, int>(
                  builder: (context, state) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        carouselImages.length,
                        (index) => PageIndicator(isActive: index == state),
                      ),
                    );
                  },
                ),
          carouselImages.isEmpty
              ? const SizedBox()
              : Container(
                  padding: EdgeInsets.symmetric(horizontal: width / 30),
                  width: width,
                  height: height / 17,
                  child: ElevatedButton(
                    onPressed: () async {
                      // Get image URLs from Firestore

                      // Get Firebase Storage reference for each banner
                      final refEn =
                          FirebaseStorage.instance.refFromURL(myBanner!.en);
                      final refAr =
                          FirebaseStorage.instance.refFromURL(myBanner!.ar);
                      carouselImages.removeWhere((e) => e.id == myBanner!.id);
                      // Delete the images from Firebase Storage
                      await refEn.delete();
                      await refAr.delete();

                      await FirebaseFirestore.instance
                          .collection("banners")
                          .doc(myBanner!.id)
                          .delete();
                      carouselImages = [];
                      await getBanners();
                      setState(() {});
                    },
                    style:
                        Theme.of(context).elevatedButtonTheme.style!.copyWith(
                              shape: WidgetStatePropertyAll(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              backgroundColor: const WidgetStatePropertyAll(
                                AppColors.kRed,
                              ),
                            ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.delete,
                          color: AppColors.kWhite,
                          size: width / 18,
                        ),
                        Text(
                          S.of(context).delete,
                          style: TextStyle(
                            fontSize: width / 26,
                            color: AppColors.kWhite,
                            fontFamily: AppFonts.poppins,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
          SizedBox(
            height: height / 40,
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: width / 30),
            width: width,
            height: height / 17,
            child: ElevatedButton(
              onPressed: () async {
                arabic = await pickAnImage(ImageSource.gallery, context);
                setState(() {});
              },
              style: Theme.of(context).elevatedButtonTheme.style!.copyWith(
                    shape: WidgetStatePropertyAll(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                        side: BorderSide(
                            color: arabic != null
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
                    arabic != null ? Ionicons.checkmark : Ionicons.add,
                    color: arabic != null
                        ? AppColors.kGreen
                        : AppColors.kBlueLight,
                    size: width / 18,
                  ),
                  Text(
                    arabic != null
                        ? S.of(context).doneBanner
                        : S.of(context).arBanner,
                    style: TextStyle(
                      fontSize: width / 26,
                      color: arabic != null
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
          SizedBox(
            height: height / 90,
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: width / 30),
            width: width,
            height: height / 17,
            child: ElevatedButton(
              onPressed: () async {
                english = await pickAnImage(ImageSource.gallery, context);
                setState(() {});
              },
              style: Theme.of(context).elevatedButtonTheme.style!.copyWith(
                    shape: WidgetStatePropertyAll(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                        side: BorderSide(
                            color: english != null
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
                    english != null ? Ionicons.checkmark : Ionicons.add,
                    color: english != null
                        ? AppColors.kGreen
                        : AppColors.kBlueLight,
                    size: width / 18,
                  ),
                  Text(
                    english != null
                        ? S.of(context).doneBanner
                        : S.of(context).enBanner,
                    style: TextStyle(
                      fontSize: width / 26,
                      color: english != null
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
          SizedBox(
            height: height / 40,
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: width / 30),
            width: width,
            height: height / 17,
            child: ElevatedButton(
              onPressed: arabic==null && english==null? (){}: () async {
                setState(() {
                  isLoading = true;
                });
                final isDone = await setImage(
                  context,
                );
                if (isDone) {
                  CustomSnackBar.show(
                    context,
                    S.of(context).addedBanner,
                    AppColors.kGreen,
                  );
                  carouselImages = [];
                  await getBanners();
                  arabic = null;
                  english = null;
                } else {
                  CustomSnackBar.show(
                    context,
                    S.of(context).tryAgain,
                    AppColors.kRed,
                  );
                }
                setState(() {
                  isLoading = false;
                });
              },
              style: Theme.of(context).elevatedButtonTheme.style!.copyWith(
                    backgroundColor: WidgetStatePropertyAll(
                      arabic != null && english != null
                          ? AppColors.kBlueLight
                          : AppColors.kGreyForDivider,
                    ),
                    shape: WidgetStatePropertyAll(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                        side: BorderSide(
                            color: arabic != null && english != null
                                ? AppColors.kBlueLight
                                : AppColors.kGreyForDivider),
                      ),
                    ),
                  ),
              child: isLoading
                  ? LoadingAnimationWidget.discreteCircle(
                      color: AppColors.kDarkBlue, size: width / 18)
                  : Text(
                      S.of(context).submit,
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
    );
  }

  Future<void> getBanners() async {
    setState(() {
      isLoading = true;
    });
    final doc = await FirebaseFirestore.instance.collection("banners").get();
    for (var x in doc.docs) {
      carouselImages.add(MyBanner.fromJson(x));
    }
    setState(() {
      isLoading = false;
    });
  }

  Future<bool> setImage(
    BuildContext context,
  ) async {
    try {
      //Uint8List? profilePic = await pickAnImage(ImageSource.gallery, context);
      final arabicUrl = await uploadImageToStorage(arabic!);
      final englishUrl = await uploadImageToStorage(english!);

      final doc = await FirebaseFirestore.instance
          .collection("banners")
          .add({"ar": arabicUrl, "en": englishUrl});

      await FirebaseFirestore.instance
          .collection("banners")
          .doc(doc.id)
          .update({
        "id": doc.id,
      });
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<String> uploadImageToStorage(Uint8List file) async {
    Reference ref = FirebaseStorage.instance
        .ref('banners')
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
