import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:confirm_dialog/confirm_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:ionicons/ionicons.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:trustlaundry/constants/strings.dart';
import 'package:trustlaundry/logic/balance/balance_cubit.dart';
import 'package:trustlaundry/logic/payment.dart';
import 'package:trustlaundry/logic/theme/theme_cubit.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../config/routes.dart';
import '../../../constants/colors.dart';
import '../../../constants/fonts.dart';
import '../../../generated/l10n.dart';
import '../../../logic/cubit/prod_cart_cubit.dart';
import '../../../models/app_user.dart';
import '../../../widgets/sign_in_dialog.dart';
import '../../home/home_screen.dart';
import '../../payment/payment_webview.dart';
import '../product_detail.dart';
import '../../../widgets/snack_bar.dart';

import '../../../models/product.dart';
import 'rating.dart';

class UpperText extends StatelessWidget {
  final String title;
  final String subTitle;
  const UpperText({super.key, required this.title, required this.subTitle});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          title,
          textAlign: title == "No element" ? TextAlign.center : TextAlign.start,
          style: TextStyle(
            fontSize: width / 20,
            fontFamily: AppFonts.poppins,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Text(
          subTitle,
          textAlign: title == "No element" ? TextAlign.center : TextAlign.start,
          style: TextStyle(
            fontSize: width / 24,
            fontFamily: AppFonts.poppins,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

class ProductDetailsWidget extends StatefulWidget {
  final MyProduct product;
  final FromWhere from;
  const ProductDetailsWidget(
      {super.key, required this.product, required this.from});

  @override
  State<ProductDetailsWidget> createState() => _ProductDetailsWidgetState();
}

class _ProductDetailsWidgetState extends State<ProductDetailsWidget> {
  final controller = TextEditingController();

  int quantity = 1;
  bool isLoading = false;

  bool isDataLoading = false;
  AppUser? user;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.from == FromWhere.orders) {
      getDetails();
    }
  }

  Future<void> getDetails() async {
    setState(() {
      isDataLoading = true;
    });
    final data = await FirebaseFirestore.instance
        .collection("users")
        .doc(widget.product.uid)
        .get();
    setState(() {
      isDataLoading = false;
    });
    user = AppUser.fromJson(data.data()!);
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Padding(
      padding:
          EdgeInsets.symmetric(horizontal: width * .08, vertical: width * .05),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: UpperText(
                  title: widget.product.titleAr,
                  subTitle: "",
                ),
              ),
              Expanded(
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          "${widget.product.priceAfterDiscount} ${S.of(context).kwd}",
                          style: TextStyle(
                            fontSize: width / 25,
                            fontFamily: AppFonts.poppins,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        widget.product.price !=
                                widget.product.priceAfterDiscount
                            ? Text(
                                "${widget.product.price} ${S.of(context).kwd}",
                                style: TextStyle(
                                  fontFamily: AppFonts.poppins,
                                  color: AppColors.kGreyForTexts,
                                  decorationColor: AppColors.kGreyForTexts,
                                  decoration:
                                      widget.product.priceAfterDiscount !=
                                              widget.product.price
                                          ? TextDecoration.lineThrough
                                          : null,
                                  fontSize: widget.product.priceAfterDiscount !=
                                          widget.product.price
                                      ? width / 24
                                      : width / 22,
                                  fontWeight:
                                      widget.product.priceAfterDiscount !=
                                              widget.product.price
                                          ? FontWeight.w400
                                          : FontWeight.bold,
                                ),
                                textAlign: TextAlign.start,
                              )
                            : const SizedBox(),
                      ],
                    ),
                    StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('products')
                          .doc(widget.product.id)
                          .collection('ratings')
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return const CircularProgressIndicator();
                        }

                        final ratings = snapshot.data!.docs;
                        double totalRating = 0;
                        for (var rating in ratings) {
                          totalRating += rating['rating'];
                        }

                        double averageRating =
                            ratings.isEmpty ? 0 : totalRating / ratings.length;
                        String displayRating = averageRating.toStringAsFixed(1);
                        return Rating(
                            rating: displayRating, numOfRates: ratings.length);
                      },
                    ),
                  ],
                ),
              )
            ],
          ),
          widget.from == FromWhere.orders
              ? Column(
                  children: [
                    UpperText(
                      title: S.of(context).email,
                      subTitle: user == null ? "------" : user!.email,
                    ),
                    UpperText(
                      title: S.of(context).phoneNumber,
                      subTitle:
                          user == null ? "------" : "965${user!.phoneNumber}+",
                    ),
                    UpperText(
                      title: S.of(context).quantity,
                      subTitle: widget.product.quantity.toString(),
                    ),
                  ],
                )
              : UpperText(
                  title: S.of(context).prDescription,
                  subTitle: widget.product.description,
                ),
          widget.from == FromWhere.orders ? const SizedBox() : const Spacer(),
          FirebaseAuth.instance.currentUser == null
              ? const SizedBox()
              : widget.from == FromWhere.orders
                  ? const SizedBox()
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          S.of(context).rate,
                          style: TextStyle(
                            fontSize: width / 28,
                            fontFamily: AppFonts.poppins,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Row(
                          children: [
                            RatingBar(
                              minRating: 1,
                              maxRating: 5,
                              initialRating: 2,
                              itemSize: 26,
                              ratingWidget: RatingWidget(
                                full: const Icon(
                                  Icons.star,
                                  color: AppColors.kYellow,
                                ),
                                half: const Icon(
                                  Icons.star,
                                  color: AppColors.kYellow,
                                ),
                                empty: const Icon(
                                  Icons.star,
                                  color: AppColors.kGrey,
                                ),
                              ),
                              updateOnDrag: false,
                              onRatingUpdate: (value) async {
                                final doc = await FirebaseFirestore.instance
                                    .collection("products")
                                    .doc(widget.product.id)
                                    .collection("ratings")
                                    .where("userId",
                                        isEqualTo: FirebaseAuth
                                            .instance.currentUser!.uid)
                                    .limit(1)
                                    .get();

                                if (doc.docs.isNotEmpty) {
                                  await FirebaseFirestore.instance
                                      .collection("products")
                                      .doc(widget.product.id)
                                      .collection("ratings")
                                      .doc(doc.docs.first.id)
                                      .update({
                                    "rating": value,
                                  });
                                } else {
                                  final document = await FirebaseFirestore
                                      .instance
                                      .collection("products")
                                      .doc(widget.product.id)
                                      .collection("ratings")
                                      .add({
                                    "userId":
                                        FirebaseAuth.instance.currentUser!.uid,
                                    "rating": value,
                                  });
                                  await FirebaseFirestore.instance
                                      .collection("products")
                                      .doc(widget.product.id)
                                      .collection("ratings")
                                      .doc(document.id)
                                      .update({"id": document.id});
                                }
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
          const SizedBox(
            height: 20,
          ),
          SizedBox(
            width: width,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
              
                SizedBox(width: width*.7,
                  child: ElevatedButton(
                    
                    onPressed: () {
                      if (FirebaseAuth.instance.currentUser != null) {
                        widget.product.quantity=quantity;
                        BlocProvider.of<ProdCartCubit>(context).addToCart(
                          prod: widget.product,
                        );
                      
                        Navigator.pop(context);
                      }
                    },
                    style: const ButtonStyle(
                        backgroundColor:
                            WidgetStatePropertyAll(AppColors.kPrimaryColor)),
                    child: isLoading
                        ? Center(
                            child: LoadingAnimationWidget.discreteCircle(
                              color: AppColors.kWhite,
                              size: width / 25,
                            ),
                          )
                        : widget.from == FromWhere.orders
                            ? BlocBuilder<ThemeCubit, bool>(
                                builder: (context, isDark) {
                                  return Icon(Ionicons.call,
                                      size: width / 12, color: AppColors.kWhite);
                                },
                              )
                            : Text(
                                widget.from == FromWhere.ourProducts
                                    ? S.of(context).add
                                    : S.of(context).cancelReq,
                                style: TextStyle(
                                  color: AppColors.kWhite,
                                  fontSize: width / 26,
                                  fontFamily: AppFonts.poppins,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
  // widget.from == FromWhere.orders
  //                   ? const SizedBox()
  //                   : BlocBuilder<ThemeCubit, bool>(
  //                       builder: (context, isDark) {
  //                         return Row(
  //                           children: [
  //                             // SizedBox(
  //                             //   child: Row(
  //                             //       mainAxisAlignment:
  //                             //           MainAxisAlignment.spaceEvenly,
  //                             //       children: [
  //                             //         Text(
  //                             //           S.of(context).quantity,
  //                             //           style: TextStyle(
  //                             //             fontSize: width / 26,
  //                             //             fontFamily: AppFonts.poppins,
  //                             //             fontWeight: FontWeight.bold,
  //                             //           ),
  //                             //         ),
  //                             //         SizedBox(
  //                             //           width: width / 30,
  //                             //         ),
  //                             //         InkWell(
  //                             //           onTap: () {
  //                             //             if (quantity > 1) {
  //                             //               setState(() {
  //                             //                 quantity--;
  //                             //               });
  //                             //             }
  //                             //           },
  //                             //           child: CircleAvatar(
  //                             //             backgroundColor: isDark
  //                             //                 ? (quantity > 1
  //                             //                     ? AppColors.kWhite
  //                             //                     : AppColors.kRed)
  //                             //                 : (quantity > 1
  //                             //                     ? AppColors.kBlueLight
  //                             //                     : AppColors.kGreyForDivider),
  //                             //             radius: width / 30,
  //                             //             child: Icon(
  //                             //               Ionicons.remove,
  //                             //               color: isDark
  //                             //                   ? AppColors.kBlueLight
  //                             //                   : AppColors.kWhite,
  //                             //             ),
  //                             //           ),
  //                             //         ),
  //                             //         SizedBox(
  //                             //           width: width / 40,
  //                             //         ),
  //                             //         Text(
  //                             //           quantity.toString(),
  //                             //           style: TextStyle(
  //                             //             fontSize: width / 26,
  //                             //             fontFamily: AppFonts.poppins,
  //                             //             fontWeight: FontWeight.bold,
  //                             //           ),
  //                             //         ),
  //                             //         SizedBox(
  //                             //           width: width / 40,
  //                             //         ),
  //                             //         InkWell(
  //                             //           onTap: () {
  //                             //             if (quantity < 10) {
  //                             //               setState(() {
  //                             //                 quantity++;
  //                             //               });
  //                             //             }
  //                             //           },
  //                             //           child: CircleAvatar(
  //                             //             backgroundColor: isDark
  //                             //                 ? quantity < 25
  //                             //                     ? AppColors.kWhite
  //                             //                     : AppColors.kRed
  //                             //                 : quantity < 25
  //                             //                     ? AppColors.kBlueLight
  //                             //                     : AppColors.kGreyForDivider,
  //                             //             radius: width / 30,
  //                             //             child: Icon(
  //                             //               Icons.add,
  //                             //               color: isDark
  //                             //                   ? AppColors.kBlueLight
  //                             //                   : AppColors.kWhite,
  //                             //             ),
  //                             //           ),
  //                             //         ),
  //                             //       ]),
  //                            // ),
  //                           ],
  //                         );
  //                       },
  //                     ),

//  onPressed: widget.from == FromWhere.orders
//                       ? () async {
//                           if (user != null) {
//                             await launchUrl(
//                                 Uri.parse("tel:$kuwait${user!.phoneNumber}"));
//                           }
//                         }
//                       : () async {
//                           if (FirebaseAuth.instance.currentUser != null) {
//                             if (await confirm(
//                               context,
//                               content: Text(
//                                 S.of(context).sureContinue,
//                                 style: TextStyle(
//                                   fontSize: width / 26,
//                                   fontFamily: AppFonts.poppins,
//                                   fontWeight: FontWeight.bold,
//                                 ),
//                               ),
//                             )) {
                              
//                             }
//                           } else {
//                             showDialog(
//                               context: context,
//                               builder: (context) {
//                                 return const SignInDialog();
//                               },
//                             );
//                           }
//                         }
