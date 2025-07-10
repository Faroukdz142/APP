import 'package:banner_carousel/banner_carousel.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider_plus/carousel_slider_plus.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../../../logic/indicator/page_indicator_cubit.dart';
import '../../../logic/theme/theme_cubit.dart';
import '../../../logic/user/user_cubit.dart';
import '../../../models/mySection.dart';
import '../../../models/my_banner.dart';
import 'contact_widget.dart';
import '../../../widgets/pageIndicator.dart';
import '../../../widgets/snack_bar.dart';
import 'package:widget_and_text_animator/widget_and_text_animator.dart';
import '../../../config/routes.dart';
import '../../../constants/colors.dart';
import '../../../constants/fonts.dart';
import '../../../constants/strings.dart';
import '../../../generated/l10n.dart';
import '../../../logic/language/language_cubit.dart';
import '../../../logic/navigation_cubit/navigation_cubit.dart';
import '../../../widgets/sign_in_dialog.dart';
import '../../../widgets/text_field.dart';

class HomeWidget extends StatefulWidget {
  const HomeWidget({super.key});

  @override
  State<HomeWidget> createState() => _HomeWidgetState();
}

class _HomeWidgetState extends State<HomeWidget> {
  int innerCurrentPage = 0;
  int outerCurrentPage = 0;

  double opacity = 0.0;
  bool isLoading = true;
  bool isBannersLoading = true;
  List<MySection> mySections = [
    MySection(
      id: "#",
      image: "assets/images/ourPro.jpeg",
      titleAr: "منتجاتنا",
      titleEn: "Our products",
    ),
    MySection(
      id: "#",
      image: "assets/images/reqD.jpeg",
      titleAr: "طلب السائق",
      titleEn: "Delivery request",
    ),
  ];
  List<MyBanner> carouselImages = [];
  @override
  void initState() {
    super.initState();

    getBanners();
    getSections();
  }

  Future<void> getBanners() async {
    final doc = await FirebaseFirestore.instance.collection("banners").get();
    for (var x in doc.docs) {
      carouselImages.add(MyBanner.fromJson(x));
    }
    setState(() {
      isBannersLoading = false;
    });
  }

  Future<void> getSections() async {
    final doc = await FirebaseFirestore.instance.collection("itemz").get();
    for (var x in doc.docs) {
      mySections.insert(0, MySection.fromJson(x));
    }
    setState(() {
      isLoading = false;
    });
  }

  final message = TextEditingController();
  final messageFocus = FocusNode();
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return SingleChildScrollView(
      padding: EdgeInsets.zero,
      child: Padding(
        padding: EdgeInsets.only(
          top: height / 40,
          bottom: height / 120,
          left: width / 20,
          right: width / 20,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            isBannersLoading
                ? Skeletonizer(
                    enabled: true,
                    child: Container(
                      height: height / 5,
                      width: width,
                      color: AppColors.kDarkBlue,
                    ),
                  )
                : Stack(
                    alignment: Alignment.bottomCenter,
                    children: [
                      CarouselSlider(
                        options: CarouselOptions(
                          height: height / 4.6,
                          aspectRatio: 16 / 9,
                          viewportFraction: 1,
                          initialPage: 0,
                          enableInfiniteScroll: true,
                          reverse: true,
                          onPageChanged: (index, reason) {
                            BlocProvider.of<PageIndicatorCubit>(context)
                                .onPageChanged(currentIndex: index);
                          },
                          autoPlay: true,
                          autoPlayInterval: const Duration(seconds: 3),
                          autoPlayAnimationDuration:
                              const Duration(milliseconds: 600),
                          autoPlayCurve: Curves.linear,
                          enlargeCenterPage: true,
                          enlargeFactor: 0,
                          scrollDirection: Axis.horizontal,
                        ),
                        items: carouselImages.map((i) {
                          return BlocBuilder<LanguageCubit, String>(
                            builder: (context, state) {
                              return SizedBox(
                                  width: width,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(
                                        8), // Adding border radius
                                    child: CachedNetworkImage(
                                      imageUrl: state == "ar" ? i.ar : i.en,
                                      fit: BoxFit.cover,
                                      height: height / 20,
                                    ),
                                  ));
                            },
                          );
                        }).toList(),
                      ),
                      BlocBuilder<PageIndicatorCubit, int>(
                        builder: (context, state) {
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: List.generate(
                              carouselImages.length,
                              (index) =>
                                  PageIndicator(isActive: index == state),
                            ),
                          );
                        },
                      )
                    ],
                  ),
            const SizedBox(
              height: 10,
            ),
            isLoading
                ? Skeletonizer(
                    enabled: true,
                    child: GridView.builder(
                      shrinkWrap: true,
                      padding: EdgeInsets.zero,
                      itemCount: isLoading ? 5 : mySections.length,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 2,
                        mainAxisSpacing: 4,
                      ),
                      itemBuilder: (context, index) =>
                          BlocBuilder<ThemeCubit, bool>(
                        builder: (context, isDark) {
                          return Container(
                            padding: const EdgeInsets.only(bottom: 0),
                            margin: EdgeInsets.all(width / 90),
                            height: height / 6,
                            width: width / 2,
                            decoration: BoxDecoration(
                              color: AppColors.kWhite,
                              boxShadow: isDark
                                  ? []
                                  : const [
                                      BoxShadow(
                                        color: AppColors.kGreyForDivider,
                                        blurRadius: 10,
                                        spreadRadius: 0,
                                      ),
                                    ],
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: SizedBox(
                                    //  height: height / 7,
                                    width: width / 2,
                                    child: !isLoading
                                        ? ClipRRect(
                                            borderRadius:
                                                const BorderRadius.only(
                                                    topLeft:
                                                        Radius.circular(10),
                                                    topRight:
                                                        Radius.circular(10)),
                                            child: mySections[index]
                                                        .titleEn
                                                        .contains(
                                                            "Our products") ||
                                                    mySections[index].titleEn ==
                                                        "Delivery request"
                                                ? Image(
                                                    fit: BoxFit.cover,
                                                    image: AssetImage(
                                                      mySections[index].image,
                                                    ),
                                                  )
                                                : CachedNetworkImage(
                                                    imageUrl:
                                                        mySections[index].image,
                                                    fit: BoxFit.cover,
                                                  ),
                                          )
                                        : Container(
                                            height: height / 20,
                                            width: width / 10,
                                            color: AppColors.kWhite,
                                          ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                BlocBuilder<LanguageCubit, String>(
                                  builder: (context, state) {
                                    return Text(
                                      isLoading
                                          ? "aoiefoineifonoiezf"
                                          : state == "ar"
                                              ? mySections[index].titleAr
                                              : mySections[index].titleEn,
                                      style: TextStyle(
                                        fontSize: width / 28,
                                        color: AppColors.kGreyForTexts,
                                        fontFamily: AppFonts.poppins,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    );
                                  },
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  )
                : AnimationLimiter(
                    child: GridView.builder(
                      shrinkWrap: true,
                      padding: EdgeInsets.zero,
                      itemCount: isLoading ? 5 : mySections.length,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 2,
                        mainAxisSpacing: 4,
                      ),
                      itemBuilder: (context, index) =>
                          AnimationConfiguration.staggeredGrid(
                        position: index,
                        duration: const Duration(milliseconds: 375),
                        columnCount: 20,
                        child: FadeInAnimation(
                          child: ScaleAnimation(
                            child: GestureAnimator(
                              onTap: isLoading
                                  ? () {}
                                  : () {
                                      if (mySections[index]
                                          .titleEn
                                          .contains("Our products")) {
                                        Navigator.of(context)
                                            .pushNamed(AppRoutes.ourProducts);
                                      } else if (mySections[index].titleEn ==
                                          "Delivery request") {
                                        if (FirebaseAuth.instance.currentUser !=
                                            null) {
                                          Navigator.of(context).pushNamed(
                                            AppRoutes.request,
                                          );
                                        } else {
                                          showDialog(
                                            context: context,
                                            builder: (context) {
                                              return const SignInDialog();
                                            },
                                          );
                                        }
                                      } else {
                                        Navigator.of(context).pushNamed(
                                            AppRoutes.laundry,
                                            arguments: mySections[index]);
                                      }
                                    },
                              child: BlocBuilder<ThemeCubit, bool>(
                                builder: (context, isDark) {
                                  return Container(
                                    padding: const EdgeInsets.all(10),
                                    margin: EdgeInsets.all(width / 90),
                                    height: height / 6,
                                    width: width / 2,
                                    decoration: BoxDecoration(
                                      color: AppColors.kWhite,
                                      boxShadow: isDark
                                          ? []
                                          : const [
                                              BoxShadow(
                                                color:
                                                    AppColors.kGreyForDivider,
                                                blurRadius: 10,
                                                spreadRadius: 0,
                                              ),
                                            ],
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Expanded(
                                          child: SizedBox(
                                            //  height: height / 7,
                                            width: width / 2,
                                            child: !isLoading
                                                ? ClipRRect(
                                                    borderRadius:
                                                        const BorderRadius.only(
                                                            topLeft:
                                                                Radius.circular(
                                                                    10),
                                                            topRight:
                                                                Radius.circular(
                                                                    10)),
                                                    child: mySections[index]
                                                                .titleEn
                                                                .contains(
                                                                    "Our products") ||
                                                            mySections[index]
                                                                    .titleEn ==
                                                                "Delivery request"
                                                        ? Image(
                                                            fit: BoxFit
                                                                .scaleDown,
                                                            image: AssetImage(
                                                              mySections[index]
                                                                  .image,
                                                            ),
                                                          )
                                                        : CachedNetworkImage(
                                                            imageUrl:
                                                                mySections[
                                                                        index]
                                                                    .image,
                                                            fit: BoxFit
                                                                .scaleDown,
                                                          ),
                                                  )
                                                : Container(
                                                    height: height / 20,
                                                    width: width / 10,
                                                    color: AppColors.kWhite,
                                                  ),
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 5,
                                        ),
                                        BlocBuilder<LanguageCubit, String>(
                                          builder: (context, state) {
                                            return Text(
                                              isLoading
                                                  ? "aoiefoineifonoiezf"
                                                  : state == "ar"
                                                      ? mySections[index]
                                                          .titleAr
                                                      : mySections[index]
                                                          .titleEn,
                                              style: TextStyle(
                                                fontSize: state == "en" &&
                                                        mySections[index]
                                                            .titleEn
                                                            .contains(
                                                                "Our products")
                                                    ? width / 30
                                                    : width / 28,
                                                color: AppColors.kGreyForTexts,
                                                fontFamily: AppFonts.poppins,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            );
                                          },
                                        ),
                                        const SizedBox(
                                          height: 5,
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
            SizedBox(
              height: height / 50,
            ),
            Center(
              child: Text(
                S.of(context).contactUs,
                style: TextStyle(
                  fontSize: width / 22,
                  fontFamily: AppFonts.poppins,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(
              height: height / 80,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                const ContactWidget(
                  image: "assets/vectors/insta.svg",
                  url:
                      "https://www.instagram.com/laundry.trust?igsh=NzhzMDF5cWQxbDQ2",
                ),
                BlocBuilder<LanguageCubit, String>(
                  builder: (context, state) {
                    return ContactWidget(
                      image: "assets/vectors/whats.svg",
                      url:
                          "https://wa.me/+96598985886?text=${state == "ar" ? 'السلام عليكم:' : 'Hi, I need help ...'}",
                    );
                  },
                ),
                const ContactWidget(
                  image: "assets/vectors/phone.svg",
                  url: "tel:+96598985886",
                ),
              ],
            ),
            FirebaseAuth.instance.currentUser != null
                ? Padding(
                    padding: EdgeInsets.only(
                        top: height / 40,
                        bottom: height / 60,
                        left: width / 30,
                        right: width / 30),
                    child: CustomTextField(
                      focus: messageFocus,
                      validator: (v) {},
                      controller: message,
                      hintText: S.of(context).message,
                    ),
                  )
                : const SizedBox(),
            FirebaseAuth.instance.currentUser != null
                ? Center(
                    child: BlocBuilder<UserCubit, UserState>(
                      builder: (context, state) {
                        if (state is UserSuccess) {
                          return SizedBox(
                            width: width / 2,
                            child: ElevatedButton(
                                onPressed: () async {
                                 if (FirebaseAuth.instance.currentUser!=null){
                                   if (message.text.isNotEmpty) {
                                    setState(() {
                                      isLoading = true;
                                    });
                                    try {
                                      await FirebaseFirestore.instance
                                          .collection("reports")
                                          .add({
                                        "message": message.text.trim(),
                                        "appUser": state.user.toJson(),
                                      });
                                      message.clear();
                                      setState(() {
                                        isLoading = false;
                                      });
                                      CustomSnackBar.show(
                                          context,
                                          S.of(context).messageSent,
                                          AppColors.kGreen);
                                    } catch (e) {
                                      CustomSnackBar.show(
                                          context,
                                          S.of(context).tryAgain,
                                          AppColors.kRed);
                                      print("here is : ${e.toString()}");
                                    }
                                  }
                                 }
                                },
                                child: isLoading
                                    ? LoadingAnimationWidget.discreteCircle(
                                        color: AppColors.kWhite,
                                        size: width / 18,
                                      )
                                    : Text(
                                        S.of(context).send,
                                        style: TextStyle(
                                          fontSize: width / 28,
                                          color: AppColors.kWhite,
                                          fontFamily: AppFonts.poppins,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      )),
                          );
                        } else {
                          return const SizedBox();
                        }
                      },
                    ),
                  )
                : const SizedBox(),
            SizedBox(
              height: FirebaseAuth.instance.currentUser != null
                  ? height / 3.5
                  : height / 20,
            ),
          ],
        ),
      ),
    );
  }

  void update() {
    setState(() {});
  }
}
