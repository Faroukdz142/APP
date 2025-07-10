import 'package:add_to_cart_animation/add_to_cart_animation.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_svg/svg.dart';
import 'package:ionicons/ionicons.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../../config/routes.dart';
import '../../logic/items/items_cubit.dart';
import '../../logic/language/language_cubit.dart';
import '../../logic/theme/theme_cubit.dart';
import '../../models/mySection.dart';
import 'func.dart';
import 'package:widget_and_text_animator/widget_and_text_animator.dart';

import '../../constants/colors.dart';
import '../../constants/fonts.dart';
import '../../generated/l10n.dart';
import '../../logic/cart/cart_cubit.dart';
import '../../logic/navigation_cubit/navigation_cubit.dart';
import '../../models/cart.dart';
import '../../models/items.dart';
import '../../widgets/sign_in_dialog.dart';
import 'widgets/sub_item.dart';

class LaundryScreen extends StatefulWidget {
  final MySection section;
  const LaundryScreen({super.key, required this.section});

  @override
  State<LaundryScreen> createState() => _LaundryScreenState();
}

class _LaundryScreenState extends State<LaundryScreen> {
  double opacity = 0;
  List<SubItem> subItemsReady = [];
  @override
  void initState() {
    super.initState();

    // Future.delayed(
    //   const Duration(milliseconds: 350),
    //   () {
    //     setState(() {
    //       opacity = 1.0;
    //     });
    //   },
    // );
    BlocProvider.of<ItemsCubit>(context).fetchItems(widget.section.id);
  }

  final controller = TextEditingController();
  int category1Index = 0;
  final GlobalKey widgetKey = GlobalKey();
  int quantityAnimation = 0;
  GlobalKey<CartIconKey> cartKey = GlobalKey<CartIconKey>();
  late Function(GlobalKey) runAddToCartAnimation;
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return AddToCartAnimation(
      cartKey: cartKey,
      height: 30,
      width: 30,
      opacity: 0.85,
      dragAnimation: const DragToCartAnimationOptions(
        rotation: true,
      ),
      jumpAnimation: const JumpAnimationOptions(),
      createAddToCartAnimation: (runAddToCartAnimation) {
        // You can run the animation by addToCartAnimationMethod, just pass trough the the global key of  the image as parameter
        this.runAddToCartAnimation = runAddToCartAnimation;
      },
      child: Scaffold(
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
                  child: GestureAnimator(
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
            title: GestureAnimator(
              onTap: () async {},
              child: Center(
                child: BlocBuilder<LanguageCubit, String>(
                  builder: (context, state) {
                    return Text(
                      state == "ar"
                          ? widget.section.titleAr
                          : widget.section.titleEn,
                      style: TextStyle(
                        fontSize: width / 18,
                        color: AppColors.kWhite,
                        fontFamily: AppFonts.poppins,
                        fontWeight: FontWeight.bold,
                      ),
                    );
                  },
                ),
              ),
            ),
            actions: [
              SizedBox(
                width: width / 30,
              ),
              FirebaseAuth.instance.currentUser == null
                  ? SizedBox(
                      width: width / 10,
                    )
                  : BlocBuilder<CartCubit, Cart>(
                      builder: (context, state) {
                        return GestureAnimator(
                          onTap: () {
                            if (FirebaseAuth.instance.currentUser != null) {
                              Navigator.of(context).pushNamed(AppRoutes.cart);
                            }
                          },
                          child: Stack(
                            alignment: Alignment.bottomRight,
                            children: [
                              Icon(
                                Ionicons.cart,
                                color: AppColors.kWhite,
                                size: width / 12,
                              ),
                              FirebaseAuth.instance.currentUser == null ||
                                      state.itemsToPayFor.isEmpty
                                  ? SizedBox(
                                      width: width / 12,
                                    )
                                  : CircleAvatar(
                                      backgroundColor: AppColors.kRed,
                                      radius: width / 50,
                                      child: Center(
                                        child: Text(
                                          state.itemsToPayFor.length.toString(),
                                          style: TextStyle(
                                            fontSize: width / 34,
                                            fontFamily: AppFonts.poppins,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                    )
                            ],
                          ),
                        );
                      },
                    ),
              SizedBox(
                width: width / 20,
              ),
            ],
          ),
        ),
        body: Column(
          children: [
            Container(
              margin: EdgeInsets.symmetric(
                horizontal: width / 30,
                vertical: height / 80,
              ).copyWith(right: 0),
              height: height / 20,
              child: BlocBuilder<ItemsCubit, ItemsState>(
                builder: (context, state) {
                  if (state is ItemsLoading) {
                    return Skeletonizer(
                      enabled: true,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        separatorBuilder: (context, index) {
                          return const SizedBox(
                            width: 10,
                          );
                        },
                        itemBuilder: (context, index) {
                          return Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            decoration: BoxDecoration(
                              border: Border.all(
                                  color: AppColors.kGreyForPin, width: 1),
                              color: AppColors.kWhite,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Center(
                              child: Text(
                                "ezfezefzfe",
                                style: TextStyle(
                                  fontSize: width / 28,
                                  color: category1Index == index
                                      ? AppColors.kWhite
                                      : AppColors.kBlueLight,
                                  fontFamily: AppFonts.poppins,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          );
                        },
                        itemCount: 6,
                      ),
                    );
                  } else if (state is ItemsSuccess) {
                    state.categories.sort((a, b) {
                      int aOrder = int.tryParse(a.titleAr.substring(0, 1)) ?? 0;
                      int bOrder = int.tryParse(b.titleAr.substring(0, 1)) ?? 0;
                      return aOrder.compareTo(bOrder);
                    });
                    return ListView.separated(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      separatorBuilder: (context, index) {
                        return const SizedBox(
                          width: 10,
                        );
                      },
                      itemBuilder: (context, index) {
                        return GestureAnimator(
                          onTap: () {
                            setState(() {
                              category1Index = index;
                            });
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            decoration: BoxDecoration(
                              border: category1Index == index
                                  ? null
                                  : Border.all(
                                      color: AppColors.kBlueLight, width: 2),
                              color: category1Index == index
                                  ? AppColors.kBlueLight
                                  : AppColors.kWhite,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Center(
                              child: BlocBuilder<LanguageCubit, String>(
                                builder: (context, language) {
                                  return Text(
                                    language == "ar"
                                        ? state.categories[index].titleAr
                                            .substring(1)
                                        : state.categories[index].titleEn
                                            .substring(1),
                                    style: TextStyle(
                                      fontSize: width / 28,
                                      color: category1Index == index
                                          ? AppColors.kWhite
                                          : AppColors.kBlueLight,
                                      fontFamily: AppFonts.poppins,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                        );
                      },
                      itemCount: state.categories.length,
                    );
                  } else {
                    return const SizedBox();
                  }
                },
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Container(
                  padding: EdgeInsets.symmetric(
                      horizontal: width / 30, vertical: height / 80),
                  child: BlocBuilder<ItemsCubit, ItemsState>(
                    builder: (context, state) {
                      if (state is ItemsLoading) {
                        return Skeletonizer(
                          enabled: true,
                          child: GridView.builder(
                            shrinkWrap: true,
                            padding: EdgeInsets.zero,
                            itemCount: 20,
                            physics: const PageScrollPhysics(),
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              crossAxisSpacing: width / 200,
                            ),
                            itemBuilder: (context, index) => Container(
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
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    height: height / 20,
                                    width: width / 10,
                                    color: AppColors.kDarkBlue,
                                  ),
                                  SizedBox(
                                    height: height / 60,
                                  ),
                                  Text(
                                    "fzefezffffffffffff",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: width / 34,
                                      color: AppColors.kBlack,
                                      fontFamily: AppFonts.poppins,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      } else if (state is ItemsSuccess) {
                        final category = state.categories.where((e) {
                          return e.id == state.categories[category1Index].id;
                        });
                        List<Item> items = category.isEmpty
                            ? []
                            : sortAndRemoveNumbers(category.first.items);

                        return AnimationLimiter(
                          child: GridView.builder(
                            shrinkWrap: true,
                            padding: EdgeInsets.zero,
                            itemCount: items.length,
                            physics: const PageScrollPhysics(),
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              crossAxisSpacing: width / 200,
                            ),
                            itemBuilder: (context, index) {
                              return AnimationConfiguration.staggeredGrid(
                                position: index,
                                duration: const Duration(milliseconds: 375),
                                columnCount: 20,
                                child: ScaleAnimation(
                                  child: FadeInAnimation(
                                    child: GestureAnimator(
                                      onTap: () {
                                        showModalBottomSheet(
                                          context: context,
                                          enableDrag: false,
                                          builder: (context) {
                                            double pagePrice = 0;
                                            double pageFastPrice = 0;
                                            subItemsReady = [];

                                            return StatefulBuilder(
                                              builder: (BuildContext context,
                                                  StateSetter setState) {
                                                return Container(
                                                  height: height / 1.5,
                                                  padding: EdgeInsets.only(
                                                    left: width / 20,
                                                    right: width / 20,
                                                    bottom: height / 45,
                                                  ),
                                                  width: width,
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .stretch,
                                                    children: [
                                                      const SizedBox(
                                                        height: 5,
                                                      ),
                                                      Center(
                                                        child: Center(
                                                          child: Container(
                                                            height: 5,
                                                            width: 60,
                                                            decoration:
                                                                BoxDecoration(
                                                              color: AppColors
                                                                  .kGreyForDivider,
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          20),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        height: height / 60,
                                                      ),
                                                      ListTile(
                                                        trailing:
                                                            const SizedBox(),
                                                        leading:
                                                            GestureAnimator(
                                                          onTap: () {
                                                            Navigator.of(
                                                                    context)
                                                                .pop();
                                                          },
                                                          child: Icon(
                                                            Icons
                                                                .arrow_back_ios,
                                                            size: width / 16,
                                                          ),
                                                        ),
                                                        title: BlocBuilder<
                                                            LanguageCubit,
                                                            String>(
                                                          builder:
                                                              (context, state) {
                                                            return Text(
                                                              state == "ar"
                                                                  ? items[index]
                                                                              .titleAr
                                                                              .split(
                                                                                  ".")
                                                                              .length ==
                                                                          2
                                                                      ? items[index]
                                                                              .titleAr
                                                                              .split(".")[
                                                                          1]
                                                                      : items[index]
                                                                          .titleAr
                                                                  : items[index]
                                                                      .titleEn,
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                              style: TextStyle(
                                                                fontSize:
                                                                    width / 26,
                                                                fontFamily:
                                                                    AppFonts
                                                                        .poppins,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                              ),
                                                            );
                                                          },
                                                        ),
                                                      ),
                                                      Expanded(
                                                        child:
                                                            items[index]
                                                                    .subItems
                                                                    .isEmpty
                                                                ? Center(
                                                                    child: Text(
                                                                      S
                                                                          .of(context)
                                                                          .itemsSoon,
                                                                    ),
                                                                  )
                                                                : ListView
                                                                    .builder(
                                                                    itemCount: items[
                                                                            index]
                                                                        .subItems
                                                                        .length,
                                                                    itemBuilder:
                                                                        (context,
                                                                            indexx) {
                                                                      final subItem =
                                                                          items[index]
                                                                              .subItems[indexx];
                                                                      return SubItemWidget(
                                                                        dontShowPrice:
                                                                            false,
                                                                        isInCart:
                                                                            false,
                                                                        add: (double
                                                                                price,
                                                                            double
                                                                                fastPrice) {
                                                                          setState(
                                                                              () {
                                                                            pagePrice +=
                                                                                price;
                                                                            pageFastPrice +=
                                                                                fastPrice;
                                                                            final existingItemIndex =
                                                                                subItemsReady.indexWhere(
                                                                              (i) => i.id == subItem.id,
                                                                            );

                                                                            if (existingItemIndex !=
                                                                                -1) {
                                                                              subItemsReady[existingItemIndex].quantity += 1;
                                                                            } else {
                                                                              subItem.quantity = 1;

                                                                              subItemsReady.add(subItem);
                                                                            }
                                                                            subItem.laundryTypeAr =
                                                                                state.categories[category1Index].titleAr.substring(1);
                                                                            subItem.laundryTypeEn =
                                                                                state.categories[category1Index].titleEn.substring(1);
                                                                          });
                                                                        },
                                                                        remove: (double
                                                                                price,
                                                                            double
                                                                                fastPrice) {
                                                                          setState(
                                                                              () {
                                                                            pagePrice -=
                                                                                price;
                                                                            pageFastPrice -=
                                                                                fastPrice;

                                                                            final existingItemIndex = subItemsReady.indexWhere((i) =>
                                                                                i.id ==
                                                                                subItem.id);
                                                                            if (existingItemIndex !=
                                                                                -1) {
                                                                              if (subItemsReady[existingItemIndex].quantity > 1) {
                                                                                // Decrease quantity
                                                                                subItemsReady[existingItemIndex].quantity -= 1;
                                                                              } else {
                                                                                // Remove item if quantity is 1
                                                                                subItemsReady.removeAt(existingItemIndex);
                                                                              }
                                                                            }
                                                                          });
                                                                        },
                                                                        index:
                                                                            indexx,
                                                                        subItem:
                                                                            subItem,
                                                                      );
                                                                    },
                                                                  ),
                                                      ),
                                                    
                                                      SizedBox(
                                                        width: width,
                                                        height: height / 17,
                                                        child: ElevatedButton(
                                                          onPressed: () async {
                                                            if (FirebaseAuth
                                                                    .instance
                                                                    .currentUser !=
                                                                null) {
                                                              if (subItemsReady
                                                                  .isNotEmpty) {
                                                                BlocProvider.of<
                                                                            CartCubit>(
                                                                        context)
                                                                    .addToCart(
                                                                  subItems:
                                                                      subItemsReady,
                                                                );
                                                               
                                                                Navigator.pop(
                                                                    context);
                                                              }
                                                            } else {
                                                              showDialog(
                                                                context:
                                                                    context,
                                                                builder:
                                                                    (context) {
                                                                  return const SignInDialog();
                                                                },
                                                              );
                                                            }
                                                          },
                                                          style: Theme.of(
                                                                  context)
                                                              .elevatedButtonTheme
                                                              .style!
                                                              .copyWith(
                                                                backgroundColor:
                                                                    WidgetStatePropertyAll(
                                                                  subItemsReady
                                                                          .isNotEmpty
                                                                      ? AppColors
                                                                          .kBlueLight
                                                                      : AppColors
                                                                          .kGreyForDivider,
                                                                ),
                                                              ),
                                                          child: Container(
                                                            key: widgetKey,
                                                            child: Text(
                                                              S.of(context).add,
                                                              style: TextStyle(
                                                                fontSize:
                                                                    width / 26,
                                                                color: AppColors
                                                                    .kWhite,
                                                                fontFamily:
                                                                    AppFonts
                                                                        .poppins,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                );
                                              },
                                            );
                                          },
                                        );
                                      },
                                      child: BlocBuilder<ThemeCubit, bool>(
                                        builder: (context, isDark) {
                                          return Container(
                                            padding: EdgeInsets.all(width / 60),
                                            margin: EdgeInsets.all(width / 60),
                                            decoration: BoxDecoration(
                                              color: AppColors.kWhite,
                                              boxShadow: isDark
                                                  ? []
                                                  : const [
                                                      BoxShadow(
                                                        color: AppColors
                                                            .kGreyForDivider,
                                                        blurRadius: 5,
                                                        spreadRadius: 0,
                                                      ),
                                                    ],
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                            ),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                // Container(
                                                //   decoration: BoxDecoration(
                                                //     borderRadius:
                                                //         BorderRadius.circular(
                                                //             10),
                                                //   ),
                                                //   child: CachedNetworkImage(
                                                //     imageUrl: items[index].image,
                                                //     imageBuilder: (context,
                                                //         imageProvider) {
                                                //       // Use the cached file to render the SVG
                                                //       return SvgPicture.network(
                                                //         items[index].image,
                                                //         height: height,
                                                //       );
                                                //     },
                                                //     placeholder: (context,
                                                //             url) =>
                                                //        Image.asset("assets/images/loading.gif"),
                                                //     errorWidget:
                                                //         (context, url, error) =>
                                                //             const Icon(Icons.error),
                                                //   ),
                                                // ),
                                                Container(
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                  ),
                                                  child: CachedNetworkImage(
                                                    imageUrl:
                                                        items[index].image,
                                                    height: height / 20,
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: height / 60,
                                                ),
                                                BlocBuilder<LanguageCubit,
                                                    String>(
                                                  builder: (context, state) {
                                                    return Text(
                                                      state == "ar"
                                                          ? items[index]
                                                                  .titleAr
                                                                  .contains(".")
                                                              ? items[index]
                                                                  .titleAr
                                                                  .split(".")[1]
                                                              : items[index]
                                                                  .titleAr
                                                          : items[index]
                                                              .titleEn,
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                        fontSize: width / 34,
                                                        color: AppColors.kBlack,
                                                        fontFamily:
                                                            AppFonts.poppins,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    );
                                                  },
                                                ),
                                              ],
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        );
                      } else {
                        return const SizedBox();
                      }
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Item> sortAndRemoveNumbers(List<Item> items) {
    // Separate items with and without a numerical prefix
    List<Item> withNumbers = [];
    List<Item> withoutNumbers = [];

    for (var x in items) {
      if (x.titleAr.contains('.') &&
          int.tryParse(x.titleAr.split('.')[0]) != null) {
        withNumbers.add(x);
      } else {
        withoutNumbers.add(x);
      }
    }

    // Sort items with numbers based on the numerical prefix
    withNumbers.sort((a, b) {
      int numA = int.parse(a.titleAr.split('.')[0]);
      int numB = int.parse(b.titleAr.split('.')[0]);
      return numA.compareTo(numB);
    });

    // Combine the sorted lists
    return [...withNumbers, ...withoutNumbers];
  }
}
