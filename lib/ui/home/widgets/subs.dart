import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../logic/subscription/subscription_cubit.dart';
import '../../../logic/theme/theme_cubit.dart';
import 'subs_tile.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:widget_and_text_animator/widget_and_text_animator.dart';
import '../../../constants/colors.dart';
import '../../../constants/fonts.dart';
import '../../../generated/l10n.dart';

class SubscriptionsScreen extends StatelessWidget {
  const SubscriptionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 30),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Align(
                    alignment: Alignment.center,
                    child: WidgetAnimator(
                      incomingEffect:
                          WidgetTransitionEffects.incomingSlideInFromRight(
                              duration: const Duration(milliseconds: 800)),
                      //     atRestEffect: WidgetRestingEffects.wave(),
                      child: Text(
                        S.of(context).subscribeNow,
                        style: TextStyle(
                          fontSize: width / 14,
                          fontFamily: AppFonts.poppins,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: height < 1000 ? 0 : width / 20,
                  ),
                  height < 1000
                      ? const SizedBox()
                      : Align(
                          alignment: Alignment.center,
                          child: WidgetAnimator(
                            incomingEffect:
                                WidgetTransitionEffects.incomingSlideInFromLeft(
                                    duration:
                                        const Duration(milliseconds: 800)),
                            atRestEffect: WidgetRestingEffects.size(),
                            child: Text(
                              S.of(context).saveMore,
                              style: TextStyle(
                                fontSize: width / 14,
                                fontFamily: AppFonts.poppins,
                                color: AppColors.kPrimaryColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                ],
              ),
              const SizedBox(
                height: 5,
              ),
              height > 1000
                  ? const SizedBox()
                  : Align(
                      alignment: Alignment.center,
                      child: WidgetAnimator(
                        incomingEffect:
                            WidgetTransitionEffects.incomingSlideInFromLeft(
                                duration: Duration(milliseconds: 800)),
                        atRestEffect: WidgetRestingEffects.size(),
                        child: Text(
                          S.of(context).saveMore,
                          style: TextStyle(
                            fontSize: width / 14,
                            fontFamily: AppFonts.poppins,
                            color: AppColors.kPrimaryColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
            ],
          ),
        ),
        SizedBox(
          height: height / 20,
        ),
        Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.center,
          children: [
            // Square Border with Rounded Corners
            Container(
              width: width * .8, // Width of the square border
              height: height > 1000
                  ? width * .8
                  : width * .9, // Height of the square border
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16), // Rounded corners
                border: Border.all(color: AppColors.kPrimaryColor, width: 2),
              ),
              // Padding to push contents down
            ),

            // Text at the top of the square
            Positioned(
              top: -width / 25, // Adjust as needed
              child: Container(
                color: const Color.fromARGB(255, 247, 245, 245),
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Text(
                  S.of(context).subs,
                  style: TextStyle(
                    fontSize: width / 24,
                    fontWeight: FontWeight.bold,
                    fontFamily: AppFonts.poppins,
                    color: AppColors.kPrimaryColor,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: height > 1000 ? width * .8 : width * .9,
              child: Column(
                children: [
                  Expanded(
                    child: BlocBuilder<SubscriptionCubit, SubscriptionState>(
                      builder: (context, state) {
                        if (state is SubscriptionSuccess) {
                          return SizedBox(
                            width: width * .9,
                            child: ListView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              padding: EdgeInsets.only(top: width / 15),
                              itemBuilder: (context, index) {
                                return SubsTile(
                                  get:
                                      state.subscriptions[index].get.toDouble(),
                                  index: index,
                                  pay:
                                      state.subscriptions[index].pay.toDouble(),
                                );
                              },
                              itemCount: state.subscriptions.length,
                            ),
                          );
                        } else {
                          return SizedBox(
                            height: width / 20,
                            child: const Center(
                              child: CircularProgressIndicator(),
                            ),
                          );
                        }
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  BlocBuilder<ThemeCubit, bool>(
                    builder: (context, isDark) {
                      return WidgetAnimator(
                        incomingEffect:
                            WidgetTransitionEffects.incomingSlideInFromLeft(
                                duration: const Duration(milliseconds: 1000)),
                        child: Text(
                          S.of(context).ghasil,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: isDark
                                ? AppColors.kWhite
                                : AppColors.kPrimaryColor,
                            fontSize: width / 28,
                            fontFamily: AppFonts.poppins,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  BlocBuilder<ThemeCubit, bool>(
                    builder: (context, isDark) {
                      return WidgetAnimator(
                        incomingEffect:
                            WidgetTransitionEffects.incomingSlideInFromRight(
                                duration: const Duration(milliseconds: 1000)),
                        child: Text(
                          S.of(context).freeDelivery,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: isDark
                                ? AppColors.kWhite
                                : AppColors.kPrimaryColor,
                            fontSize: width / 28,
                            fontFamily: AppFonts.poppins,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 5,
        ),
        BlocBuilder<ThemeCubit, bool>(
          builder: (context, isDark) {
            return SizedBox(
              width: width * .7,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  WidgetAnimator(
                    incomingEffect:
                        WidgetTransitionEffects.incomingSlideInFromLeft(
                            duration: const Duration(milliseconds: 1000)),
                    child: GestureAnimator(
                      onTap: () async {
                        await launchUrl(Uri.parse("tel:+96598985886"));
                      },
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            "98985886",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: isDark
                                  ? AppColors.kWhite
                                  : AppColors.kPrimaryColor,
                              fontSize: width / 32,
                              fontFamily: AppFonts.poppins,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(
                            width: 4,
                          ),
                          Image.asset(
                            "assets/images/telephone.png",
                            height: width / 20,
                          ),
                        ],
                      ),
                    ),
                  ),
                  WidgetAnimator(
                    incomingEffect:
                        WidgetTransitionEffects.incomingSlideInFromRight(
                            duration: const Duration(milliseconds: 1000)),
                    child: GestureAnimator(
                      onTap: () async {
                        await launchUrl(Uri.parse(
                            "https://www.instagram.com/laundry.trust?igsh=NzhzMDF5cWQxbDQ2"));
                      },
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            "laundry.trust",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: isDark
                                  ? AppColors.kWhite
                                  : AppColors.kPrimaryColor,
                              fontSize: width / 32,
                              fontFamily: AppFonts.poppins,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(
                            width: 4,
                          ),
                          Image.asset(
                            "assets/images/instagram.png",
                            height: width / 20,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
    // return Column(
    //   children: [
    //     SizedBox(
    //       height: height / 50,
    //     ),
    // Center(
    //   child: Text(
    //     S.of(context).subs,
    //     style: TextStyle(
    //       fontSize: width / 22,
    //       fontFamily: AppFonts.poppins,
    //       fontWeight: FontWeight.bold,
    //     ),
    //   ),
    // ),
    //     SizedBox(
    //       height: height / 80,
    //     ),
    //     Expanded(child: BlocBuilder<SubscriptionCubit, SubscriptionState>(
    //       builder: (context, state) {
    //         if (state is SubscriptionSuccess) {
    //           return AnimationLimiter(
    //             child: ListView.builder(
    //               padding: EdgeInsets.zero,
    //               itemBuilder: (context, index) {
    //                 return GestureDetector(
    //                   onTap: () async {
    //                     if (FirebaseAuth.instance.currentUser != null) {
    //                       Navigator.of(context).pushNamed(
    //                         AppRoutes.payment,
    //                         arguments: {
    //                           "pay": state.subscriptions[index].pay.toDouble(),
    //                           "get": state.subscriptions[index].get.toDouble(),
    //                           "paymentFor": PaymentFor.sub,
    //                           "order": null,
    //                         },
    //                       );
    //                     } else {
    //                       showDialog(
    //                         context: context,
    //                         builder: (context) {
    //                           return const SignInDialog();
    //                         },
    //                       );
    //                     }
    //                   },
    //                   child: BlocBuilder<LanguageCubit, String>(
    //                     builder: (context, language) {
    //                       return BlocBuilder<ThemeCubit, bool>(
    //                         builder: (context, isDark) {
    //                           return AnimationConfiguration.staggeredList(
    //                             position: index,
    //                             duration: const Duration(milliseconds: 375),
    //                             child: FadeInAnimation(
    //                               child: ScaleAnimation(
    //                                 child: Container(
    //                                   width: width,
    //                                   margin: EdgeInsets.symmetric(
    //                                       horizontal: width / 30,
    //                                       vertical: height / 120),
    //                                   padding: EdgeInsets.all(width / 30),
    //                                   decoration: BoxDecoration(
    //                                     color: AppColors.kWhite,
    //                                     image: const DecorationImage(
    //                                       image: AssetImage(
    //                                           "assets/images/sub_en.png"),
    //                                       fit: BoxFit.cover,
    //                                       opacity: 0.75,
    //                                     ),
    //                                     boxShadow: isDark
    //                                         ? []
    //                                         : const [
    //                                             BoxShadow(
    //                                               color:
    //                                                   AppColors.kGreyForDivider,
    //                                               blurRadius: 10,
    //                                               spreadRadius: 0,
    //                                             ),
    //                                           ],
    //                                     borderRadius: BorderRadius.circular(15),
    //                                   ),
    //                                   child: Row(
    //                                     children: [
    //                                       Text(
    //                                         "${index + 1}",
    //                                         style: TextStyle(
    //                                           fontSize: width / 26,
    //                                           color: AppColors.kBlack,
    //                                           fontFamily: AppFonts.poppins,
    //                                           fontWeight: FontWeight.bold,
    //                                         ),
    //                                       ),
    //                                       SizedBox(
    //                                         width: width / 20,
    //                                       ),
    //                                       Column(
    //                                         crossAxisAlignment:
    //                                             CrossAxisAlignment.start,
    //                                         children: [
    //                                           Text(
    //                                             "${S.of(context).pay} ${state.subscriptions[index].pay} ${S.of(context).kwd}.",
    //                                             style: TextStyle(
    //                                               fontSize: width / 23,
    //                                               color: AppColors.kBlack,
    //                                               fontFamily: AppFonts.poppins,
    //                                               fontWeight: FontWeight.bold,
    //                                             ),
    //                                           ),
    //                                           Text(
    //                                             "${S.of(context).get} ${state.subscriptions[index].get} ${S.of(context).kwd}.",
    //                                             style: TextStyle(
    //                                               fontSize: width / 23,
    //                                               color: AppColors.kBlack,
    //                                               fontFamily: AppFonts.poppins,
    //                                               fontWeight: FontWeight.bold,
    //                                             ),
    //                                           ),
    //                                         ],
    //                                       )
    //                                     ],
    //                                   ),
    //                                 ),
    //                               ),
    //                             ),
    //                           );
    //                         },
    //                       );
    //                     },
    //                   ),
    //                 );
    //               },
    //               itemCount: state.subscriptions.length,
    //             ),
    //           );
    //         } else {
    //           return Skeletonizer(
    //               enabled: true,
    //               child: ListView.builder(
    //                 padding: EdgeInsets.zero,
    //                 itemBuilder: (context, index) {
    //                   return Container(
    //                     width: width,
    //                     margin: EdgeInsets.symmetric(
    //                         horizontal: width / 30, vertical: height / 120),
    //                     padding: EdgeInsets.all(width / 30),
    //                     decoration: BoxDecoration(
    //                       color: AppColors.kWhite,
    //                       borderRadius: BorderRadius.circular(15),
    //                     ),
    //                     child: Row(
    //                       children: [
    //                         Text(
    //                           "z",
    //                           style: TextStyle(
    //                             fontSize: width / 26,
    //                             color: AppColors.kBlack,
    //                             fontFamily: AppFonts.poppins,
    //                             fontWeight: FontWeight.bold,
    //                           ),
    //                         ),
    //                         SizedBox(
    //                           width: width / 20,
    //                         ),
    //                         Column(
    //                           crossAxisAlignment: CrossAxisAlignment.start,
    //                           children: [
    //                             Text(
    //                               "fezfzefzefe",
    //                               style: TextStyle(
    //                                 fontSize: width / 23,
    //                                 color: AppColors.kBlack,
    //                                 fontFamily: AppFonts.poppins,
    //                                 fontWeight: FontWeight.bold,
    //                               ),
    //                             ),
    //                             Text(
    //                               "fezfzefzefzefzef",
    //                               style: TextStyle(
    //                                 fontSize: width / 23,
    //                                 color: AppColors.kBlack,
    //                                 fontFamily: AppFonts.poppins,
    //                                 fontWeight: FontWeight.bold,
    //                               ),
    //                             ),
    //                           ],
    //                         )
    //                       ],
    //                     ),
    //                   );
    //                 },
    //                 itemCount: 4,
    //               ));
    //         }
    //       },
    //     ))
    //   ],
    // );
  }
}

// class PaymentService {
//   // Replace with your actual Tap Payment API key
//   static const String apiKey = 'sk_test_8PCeQFI6Nixvsq5JbH7lpdw9';
//   static const String chargeUrl = 'https://api.tap.company/v2/charges';

//   // Function to create a payment charge using Tap Payments
//   static Future<void> createCharge({
//     required double amount,
//     required String currency,
//     required String description,
//     required String customerEmail,
//     required BuildContext context,
//   }) async {
//     final dio = Dio();
//     dio.options.headers['Authorization'] = 'Bearer $apiKey';
//     dio.options.headers['Content-Type'] = 'application/json';

//     try {
//       final response = await dio.post(
//         chargeUrl,
//         data: {
//           'amount': amount,
//           'currency': currency,
//           'threeDSecure': true,
//           'save_card': false,
//           'description': description,
//           'customer': {
//             'email': customerEmail,
//           },
//           'source': {
//             'id':
//                 'src_all', // Adjust based on the payment source type (e.g., card, Apple Pay, etc.)
//           },
//           'redirect': {
//             'url':
//                 'YOUR_APP_REDIRECT_URL', // Replace with your app's redirect URL
//           }
//         },
//       );

//       if (response.statusCode == 200) {
//         final responseData = response.data;
//         final transactionUrl = responseData['transaction']['url'];
//         print(responseData['transaction']);
//         if (transactionUrl != null) {
//           // Redirect the user to complete the payment
//           Navigator.push(
//             context,
//             MaterialPageRoute(
//               builder: (context) => PaymentWebView(paymentUrl: transactionUrl),
//             ),
//           );
//         }
//       } else {
//         throw Exception('Failed to create charge: ${response.data}');
//       }
//     } catch (error) {
//       print('Error creating charge: $error');
//     }
//   }
// }
