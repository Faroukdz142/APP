import 'dart:math';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:ionicons/ionicons.dart';

import 'package:loading_animation_widget/loading_animation_widget.dart';
import '../../config/routes.dart';
import '../../logic/balance/balance_cubit.dart';
import '../../logic/cart/cart_cubit.dart';
import '../../logic/pdf/pdf.dart';
import '../../models/app_user.dart';
import '../../models/my_address.dart';
import '../address/address.dart';
import '../otp/views/otpScreen.dart';
import '../../logic/payment.dart';
import '../../widgets/snack_bar.dart';
import '../../widgets/text_field.dart';
import '../../constants/colors.dart';
import '../../constants/fonts.dart';
import '../../generated/l10n.dart';
import '../../logic/language/language_cubit.dart';
import '../../logic/theme/theme_cubit.dart';
import '../../models/items.dart';
import '../../models/order.dart';
import '../payment/payment_webview.dart';

enum UserPaymentMethod { cash, online }

class Order extends StatefulWidget {
  final List<SubItem> cartItems;
  const Order({super.key, required this.cartItems});

  @override
  State<Order> createState() => _OrderState();
}

class _OrderState extends State<Order> {
  UserPaymentMethod selectedMethod = UserPaymentMethod.online;
  int activeStep = 0;
  final instructions = TextEditingController();
  MyAddress? address;
  String? pickupDateAndTime;
  String? deliveryDateAndTime;
  bool isFast = false;
  bool isLoading = false;
  DateTime? pickupDate;
  DateTime? deliveryDate;
  DateTime? pickUpTime;
  void next() {
    if (activeStep == 0 && address != null) {
      setState(() {
        activeStep++;
      });
    } else if (activeStep == 1) {
      setState(() {
        activeStep++;
      });
    }
  }

  void back() {
    if (activeStep == 0) {
      return;
    }
    setState(() {
      activeStep--;
    });
  }

  List<DateTime> generateDates(int daysAhead) {
    DateTime now = DateTime.now();
    List<DateTime> allDates = List.generate(
      daysAhead + 1,
      (index) => now.add(Duration(days: index)),
    );

    // Filter dates within valid working hours
    return allDates.where((date) {
      if (date.day == now.day) {
        return now.hour < 23; // Include today only if it's before 11 PM
      }
      return true;
    }).toList();
  }

  /// Filters the available times based on the selected date.
  List<String> filterTimesForToday(List<String> times, DateTime selectedDate) {
    DateTime now = DateTime.now();
    if (selectedDate.day == now.day) {
      // Current time + 2 hours.
      DateTime threshold = now.add(Duration(hours: 2));
      return times.where((time) {
        final timeParts = time.toLowerCase().split(RegExp(r'[ap]m'));
        int hour = int.parse(timeParts[0]);

        if (time.contains('pm')) hour += 12; // Convert PM to 24-hour format
        return hour >= threshold.hour && hour <= 23; // Keep within valid range
      }).toList();
    }
    return times;
  }

  List<DateTime> dates = [];
  List<String> times = [
    '9am',
    '10am',
    '12pm',
    '2pm',
    '4pm',
    '6pm',
    '8pm',
    '10pm'
  ];
  DateTime? selectedDate;
  String selectedTime = "";
  List<String> availableTimes = [];

  @override
  void initState() {
    super.initState();
    dates = generateDates(4);
    selectedDate = dates.first;
    
    availableTimes = filterTimesForToday(times, selectedDate!);
    if (availableTimes.isNotEmpty) {
      selectedTime = availableTimes.first;
    }else{
      dates.removeAt(0);
      selectedDate = dates.first;
      availableTimes = filterTimesForToday(times,selectedDate!);
      selectedTime = availableTimes.first;
    }
  }

  void onDateSelected(DateTime date) {
    setState(() {
      selectedDate = date;
      availableTimes = filterTimesForToday(times, date);
      selectedTime = availableTimes.first;
    });
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        backgroundColor: AppColors.kBlueLight,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(20),
            bottomRight: Radius.circular(20),
          ),
        ),
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(
            Icons.arrow_back_ios,
            color: AppColors.kWhite,
            size: width / 18,
          ),
        ),
        title: GestureDetector(
          onTap: () async {
            // await createItemsCollection();
          },
          child: Center(
            child: Text(
              S.of(context).orderDetails,
              style: TextStyle(
                fontSize: width / 18,
                color: AppColors.kWhite,
                fontFamily: AppFonts.poppins,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        actions: [
          SizedBox(
            width: width / 5,
          ),
        ],
      ),
      body: BlocBuilder<ThemeCubit, bool>(
        builder: (context, isDark) {
          return Column(
            children: [
              Expanded(
                child: Stepper(
                  elevation: 0,
                  physics: const NeverScrollableScrollPhysics(),
                  type: StepperType.horizontal,
                  connectorColor: WidgetStatePropertyAll(
                      isDark ? AppColors.kWhite : AppColors.kBlueLight),
                  stepIconBuilder: (stepIndex, stepState) {
                    if (stepIndex == 0) {
                      return Icon(
                        Icons.delivery_dining,
                        color:
                            !isDark ? AppColors.kWhite : AppColors.kBlueLight,
                        size: width / 20,
                      );
                    } else if (stepIndex == 1) {
                      return Icon(
                        Icons.monetization_on_outlined,
                        color:
                            !isDark ? AppColors.kWhite : AppColors.kBlueLight,
                        size: width / 24,
                      );
                    } else if (stepIndex == 2) {
                      return Icon(
                        Icons.done,
                        color:
                            !isDark ? AppColors.kWhite : AppColors.kBlueLight,
                        size: width / 24,
                      );
                    }
                  },
                  controlsBuilder: (context, details) {
                    return const SizedBox();
                  },
                  currentStep: activeStep,
                  steps: [
                    Step(
                      stepStyle: StepStyle(
                          color: activeStep >= 0
                              ? isDark
                                  ? AppColors.kWhite
                                  : AppColors.kBlueLight
                              : AppColors.kGreyForDivider),
                      state: activeStep > 0
                          ? StepState.complete
                          : StepState.editing,
                      isActive: activeStep >= 0,
                      title: BlocBuilder<LanguageCubit, String>(
                        builder: (context, state) {
                          return Text(
                            state == "ar"
                                ? S.of(context).details
                                : S.of(context).order,
                            style: TextStyle(
                              fontSize: width / 40,
                              color: activeStep >= 0
                                  ? isDark
                                      ? AppColors.kWhite
                                      : AppColors.kBlueLight
                                  : AppColors.kGrey,
                              fontFamily: AppFonts.poppins,
                              fontWeight: FontWeight.bold,
                            ),
                          );
                        },
                      ),
                      subtitle: BlocBuilder<LanguageCubit, String>(
                        builder: (context, state) {
                          return Text(
                            state == "ar"
                                ? S.of(context).order
                                : S.of(context).details,
                            style: TextStyle(
                              fontSize: width / 40,
                              color: activeStep >= 0
                                  ? isDark
                                      ? AppColors.kWhite
                                      : AppColors.kBlueLight
                                  : AppColors.kGrey,
                              fontFamily: AppFonts.poppins,
                              fontWeight: FontWeight.bold,
                            ),
                          );
                        },
                      ),
                      content: BlocBuilder<ThemeCubit, bool>(
                        builder: (context, isDark) {
                          return Column(
                            children: [
                              Row(
                                children: [
                                  Text(
                                    S
                                        .of(context)
                                        .chooseDate, // Weekday (e.g., Sat)
                                    style: TextStyle(
                                      color: AppColors.kPrimaryColor,
                                      fontFamily: AppFonts.poppins,
                                      fontSize: width / 30,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Icon(
                                    Icons.date_range_outlined,
                                    size: width / 20,
                                    color: AppColors.kPrimaryColor,
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: height / 90,
                              ),
                              SizedBox(
                                height: 80,
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: dates.length,
                                  itemBuilder: (context, index) {
                                    DateTime date = dates[index];

                                    return GestureDetector(
                                      onTap: () => onDateSelected(date),
                                      child: Container(
                                        margin: const EdgeInsets.symmetric(
                                            horizontal: 8),
                                        padding: const EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                              color: AppColors.kPrimaryColor),
                                          color: date == selectedDate
                                              ? AppColors.kPrimaryColor
                                              : AppColors.kWhite,
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              DateFormat('EEE').format(
                                                  date), // Weekday (e.g., Sat)
                                              style: TextStyle(
                                                color: date == selectedDate
                                                    ? AppColors.kWhite
                                                    : AppColors.kBlack,
                                                fontFamily: AppFonts.poppins,
                                                fontSize: width / 30,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            Text(
                                              DateFormat('dd MMM').format(
                                                  date), // Date (e.g., 25 Nov)
                                              style: TextStyle(
                                                color: selectedDate == date
                                                    ? AppColors.kWhite
                                                    : AppColors.kGreyForTexts,
                                                fontFamily: AppFonts.poppins,
                                                fontSize: width / 30,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                              SizedBox(
                                height: height / 90,
                              ),
                              Row(
                                children: [
                                  Text(
                                    S
                                        .of(context)
                                        .chooseTime, // Weekday (e.g., Sat)
                                    style: TextStyle(
                                      color: AppColors.kPrimaryColor,
                                      fontFamily: AppFonts.poppins,
                                      fontSize: width / 30,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Icon(
                                    Icons.timer_outlined,
                                    size: width / 20,
                                    color: AppColors.kPrimaryColor,
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: height / 90,
                              ),
                              // Time Selector using GridView

                              GridView.builder(
                                shrinkWrap: true,
                                padding: EdgeInsets.zero,
                                physics: const NeverScrollableScrollPhysics(),
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2, // Number of items in a row
                                  crossAxisSpacing: 8.0,
                                  mainAxisSpacing: 8.0,
                                  childAspectRatio:
                                      3.5, // Adjust for button size
                                ),
                                itemCount: availableTimes.length,
                                itemBuilder: (context, index) {
                                  String time = availableTimes[index];
                                  return GestureDetector(
                                    onTap: () {
                                      // Handle time selection
                                      setState(() {
                                        selectedTime = time;
                                      });
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: selectedTime == time
                                            ? AppColors.kPrimaryColor
                                            : AppColors.kWhite,
                                        border: Border.all(
                                            color: AppColors.kPrimaryColor),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Center(
                                        child: Text(
                                          time,
                                          style: TextStyle(
                                            color: selectedTime == time
                                                ? AppColors.kWhite
                                                : AppColors.kBlack,
                                            fontFamily: AppFonts.poppins,
                                            fontSize: width / 30,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                              SizedBox(
                                height: height / 50,
                              ),
                              GestureDetector(
                                onTap: () async {
                                  address = await Navigator.of(context)
                                      .pushNamed(AppRoutes.address,
                                          arguments: NavigationFromSettingsTo
                                              .order) as MyAddress;

                                  setState(() {});
                                },
                                child: Container(
                                  width: width,
                                  //   height: height / 13,
                                  margin: EdgeInsets.symmetric(
                                      horizontal: width / 30,
                                      vertical: height / 120),
                                  padding: EdgeInsets.symmetric(
                                    horizontal: width / 30,
                                    vertical: address == null
                                        ? height / 50
                                        : height / 120,
                                  ),
                                  decoration: BoxDecoration(
                                    color: isDark
                                        ? AppColors.kBlueLight
                                        : AppColors.kWhite,
                                    border: Border.all(
                                        color: address == null
                                            ? AppColors.kGreyForDivider
                                            : AppColors.kBlueLight,
                                        width: 1),
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      address == null
                                          ? Row(
                                              children: [
                                                Icon(
                                                  Icons.location_on_rounded,
                                                  color: address == null
                                                      ? AppColors
                                                          .kGreyForDivider
                                                      : AppColors.kBlueLight,
                                                  size: width / 18,
                                                ),
                                                const SizedBox(
                                                  width: 5,
                                                ),
                                                Text(
                                                  S.of(context).deliveryAddress,
                                                  style: TextStyle(
                                                    fontSize: width / 28,
                                                    fontFamily:
                                                        AppFonts.poppins,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ],
                                            )
                                          : Column(
                                              children: [
                                                Row(
                                                  children: [
                                                    Icon(
                                                      Icons.location_on_rounded,
                                                      color: address == null
                                                          ? AppColors.kBlueLight
                                                          : AppColors
                                                              .kBlueLight,
                                                      size: width / 18,
                                                    ),
                                                    const SizedBox(
                                                      width: 5,
                                                    ),
                                                    Text(
                                                      S
                                                          .of(context)
                                                          .deliveryAddress,
                                                      style: TextStyle(
                                                        fontSize: width / 28,
                                                        fontFamily:
                                                            AppFonts.poppins,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      "${S.of(context).title} ${address!.addressTitle}",
                                                      style: TextStyle(
                                                        fontSize: width / 30,
                                                        color: isDark
                                                            ? AppColors
                                                                .kGreyForPin
                                                            : AppColors
                                                                .kGreyForTexts,
                                                        fontFamily:
                                                            AppFonts.poppins,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                    address!.street != null
                                                        ? Text(
                                                            "${S.of(context).street}: ${address!.street}",
                                                            style: TextStyle(
                                                              fontSize:
                                                                  width / 30,
                                                              color: isDark
                                                                  ? AppColors
                                                                      .kGreyForPin
                                                                  : AppColors
                                                                      .kGreyForTexts,
                                                              fontFamily:
                                                                  AppFonts
                                                                      .poppins,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                            ),
                                                          )
                                                        : const SizedBox(),
                                                  ],
                                                ),
                                              ],
                                            ),
                                      Icon(
                                        Icons.arrow_forward_ios,
                                        size: width / 18,
                                      )
                                    ],
                                  ),
                                ),
                              ),

                              SizedBox(
                                height: height / 50,
                              ),
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    S.of(context).mousta3jil,
                                    style: TextStyle(
                                      fontSize: width / 30,
                                      color: isDark
                                          ? AppColors.kGreyForPin
                                          : AppColors.kGreyForTexts,
                                      fontFamily: AppFonts.poppins,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Transform.scale(
                                    scale: 1,
                                    child: CupertinoSwitch(
                                      value: isFast,
                                      activeColor: AppColors.kPrimaryColor,
                                      onChanged: (bool value) {
                                        setState(() {
                                          isFast = value;
                                        });
                                      },
                                    ),
                                  ),
                                ],
                              )
                            ],
                          );
                        },
                      ),
                    ),
                    Step(
                      stepStyle: StepStyle(
                          color: activeStep >= 1
                              ? isDark
                                  ? AppColors.kWhite
                                  : AppColors.kBlueLight
                              : AppColors.kGreyForDivider),
                      state: activeStep > 1
                          ? StepState.complete
                          : StepState.editing,
                      isActive: activeStep >= 1,
                      title: BlocBuilder<LanguageCubit, String>(
                        builder: (context, state) {
                          return Text(
                            state == "ar"
                                ? S.of(context).details
                                : S.of(context).payment,
                            style: TextStyle(
                              fontSize: width / 40,
                              color: activeStep >= 1
                                  ? isDark
                                      ? AppColors.kWhite
                                      : AppColors.kBlueLight
                                  : AppColors.kGrey,
                              fontFamily: AppFonts.poppins,
                              fontWeight: FontWeight.bold,
                            ),
                          );
                        },
                      ),
                      subtitle: BlocBuilder<LanguageCubit, String>(
                        builder: (context, state) {
                          return Text(
                            state == "ar"
                                ? S.of(context).payment
                                : S.of(context).details,
                            style: TextStyle(
                              fontSize: width / 40,
                              color: activeStep >= 1
                                  ? isDark
                                      ? AppColors.kWhite
                                      : AppColors.kBlueLight
                                  : AppColors.kGrey,
                              fontFamily: AppFonts.poppins,
                              fontWeight: FontWeight.bold,
                            ),
                          );
                        },
                      ),
                      content: Column(
                        children: [
                          Text(
                            S.of(context).paymentMethod,
                            style: TextStyle(
                              fontSize: width / 28,
                              fontFamily: AppFonts.poppins,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(
                            height: height / 60,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    selectedMethod = UserPaymentMethod.online;
                                  });
                                },
                                child: Container(
                                  height: height / 8,
                                  width: height / 8,
                                  padding: EdgeInsets.symmetric(
                                    vertical: height / 90,
                                    horizontal: width / 90,
                                  ),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        width: selectedMethod ==
                                                UserPaymentMethod.online
                                            ? 3
                                            : 1,
                                        color: selectedMethod ==
                                                UserPaymentMethod.online
                                            ? !isDark
                                                ? AppColors.kBlueLight
                                                : AppColors.kWhite
                                            : AppColors.kGreyForDivider),
                                    color: isDark
                                        ? AppColors.kBlueLight
                                        : AppColors.kWhite,
                                    borderRadius: BorderRadius.circular(10),
                                    boxShadow: isDark
                                        ? []
                                        : const [
                                            BoxShadow(
                                              color: AppColors.kGreyForDivider,
                                              blurRadius: 3,
                                              spreadRadius: 0,
                                            ),
                                          ],
                                  ),
                                  child: Center(
                                    child: Text(
                                      S.of(context).online,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: width / 28,
                                        fontFamily: AppFonts.poppins,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: width / 15,
                              ),
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    selectedMethod = UserPaymentMethod.cash;
                                  });
                                },
                                child: Container(
                                  height: height / 8,
                                  width: height / 8,
                                  padding: EdgeInsets.symmetric(
                                      vertical: height / 90,
                                      horizontal: width / 40),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        width: selectedMethod ==
                                                UserPaymentMethod.cash
                                            ? 3
                                            : 1,
                                        color: selectedMethod ==
                                                UserPaymentMethod.cash
                                            ? !isDark
                                                ? AppColors.kBlueLight
                                                : AppColors.kWhite
                                            : AppColors.kGreyForDivider),
                                    color: isDark
                                        ? AppColors.kBlueLight
                                        : AppColors.kWhite,
                                    borderRadius: BorderRadius.circular(10),
                                    boxShadow: isDark
                                        ? []
                                        : const [
                                            BoxShadow(
                                              color: AppColors.kGreyForDivider,
                                              blurRadius: 3,
                                              spreadRadius: 0,
                                            ),
                                          ],
                                  ),
                                  child: Center(
                                    child: Text(
                                      S.of(context).cash,
                                      style: TextStyle(
                                        fontSize: width / 28,
                                        fontFamily: AppFonts.poppins,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                    Step(
                      stepStyle: StepStyle(
                          color: activeStep == 2
                              ? isDark
                                  ? AppColors.kWhite
                                  : AppColors.kBlueLight
                              : AppColors.kGreyForDivider),
                      state: StepState.complete,
                      isActive: activeStep >= 2,
                      title: Text(
                        S.of(context).confirm,
                        style: TextStyle(
                          fontSize: width / 40,
                          color: activeStep >= 2
                              ? isDark
                                  ? AppColors.kWhite
                                  : AppColors.kBlueLight
                              : AppColors.kGrey,
                          fontFamily: AppFonts.poppins,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Text(
                        S.of(context).order,
                        style: TextStyle(
                          fontSize: width / 40,
                          color: activeStep >= 2
                              ? isDark
                                  ? AppColors.kWhite
                                  : AppColors.kBlueLight
                              : AppColors.kGrey,
                          fontFamily: AppFonts.poppins,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      content: Column(
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(
                                vertical: height / 90, horizontal: width / 40),
                            decoration: BoxDecoration(
                              color: isDark
                                  ? AppColors.kBlueLight
                                  : AppColors.kWhite,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: isDark
                                  ? []
                                  : const [
                                      BoxShadow(
                                        color: AppColors.kGreyForDivider,
                                        blurRadius: 5,
                                        spreadRadius: 0,
                                      ),
                                    ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "${S.of(context).specialInstructions}:",
                                  style: TextStyle(
                                    fontSize: width / 26,
                                    fontFamily: AppFonts.poppins,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                CustomTextField(
                                  validator: (v) {},
                                  controller: instructions,
                                  focus: FocusNode(),
                                  hintText: S.of(context).specialInstructions,
                                )
                              ],
                            ),
                          ),
                          SizedBox(
                            height: height / 40,
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(
                                vertical: height / 90, horizontal: width / 40),
                            decoration: BoxDecoration(
                              color: isDark
                                  ? AppColors.kBlueLight
                                  : AppColors.kWhite,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: isDark
                                  ? []
                                  : const [
                                      BoxShadow(
                                        color: AppColors.kGreyForDivider,
                                        blurRadius: 5,
                                        spreadRadius: 0,
                                      ),
                                    ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  S.of(context).deliveryAddress,
                                  style: TextStyle(
                                    fontSize: width / 26,
                                    fontFamily: AppFonts.poppins,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.location_on_rounded,
                                      color: AppColors.kBlueLight,
                                      size: width / 18,
                                    ),
                                    SizedBox(
                                      width: width / 20,
                                    ),
                                    address != null
                                        ? Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                address!.addressTitle,
                                                style: TextStyle(
                                                  fontSize: width / 40,
                                                  fontFamily: AppFonts.poppins,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              address!.street != null
                                                  ? Text(
                                                      address!.street!,
                                                      style: TextStyle(
                                                        fontSize: width / 40,
                                                        fontFamily:
                                                            AppFonts.poppins,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    )
                                                  : const SizedBox()
                                            ],
                                          )
                                        : const SizedBox()
                                  ],
                                ),
                                const Divider(
                                  color: AppColors.kGreyForDivider,
                                ),
                                Row(
                                  children: [
                                    Text(
                                      S.of(context).pickupDate,
                                      style: TextStyle(
                                        fontSize: width / 26,
                                        fontFamily: AppFonts.poppins,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      "${selectedDate.toString().substring(0, 10)} $selectedTime" ?? "",
                                      style: TextStyle(
                                        fontSize: width / 30,
                                        fontFamily: AppFonts.poppins,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                
                                const Divider(
                                  color: AppColors.kGreyForDivider,
                                ),
                                Text(
                                  S.of(context).paymentInfo,
                                  style: TextStyle(
                                    fontSize: width / 26,
                                    fontFamily: AppFonts.poppins,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  "${S.of(context).totalPrice} ${isFast ? BlocProvider.of<CartCubit>(context).calcFastPrice() : BlocProvider.of<CartCubit>(context).calculatePriceToPay()} ${S.of(context).kwd} ${isFast ? "(${S.of(context).mousta3jil})" : ""}",
                                  style: TextStyle(
                                    fontSize: width / 34,
                                    fontFamily: AppFonts.poppins,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Row(
                                  children: [
                                    Text(
                                      "${S.of(context).paymentMethod}: ",
                                      style: TextStyle(
                                        fontSize: width / 32,
                                        fontFamily: AppFonts.poppins,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      selectedMethod == UserPaymentMethod.cash
                                          ? "${S.of(context).cash}"
                                          : "${S.of(context).online}",
                                      style: TextStyle(
                                        fontSize: width / 34,
                                        fontFamily: AppFonts.poppins,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                const Divider(
                                  color: AppColors.kGreyForDivider,
                                ),
                                Text(
                                  "${S.of(context).numberOfItems} ${widget.cartItems.length}",
                                  style: TextStyle(
                                    fontSize: width / 26,
                                    fontFamily: AppFonts.poppins,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    margin: EdgeInsets.only(
                      bottom: height / 40,
                    ),
                    width: width * .4,
                    height: height / 17,
                    child: ElevatedButton(
                      onPressed: () => back(),
                      style:
                          Theme.of(context).elevatedButtonTheme.style!.copyWith(
                                backgroundColor: const WidgetStatePropertyAll(
                                  AppColors.kGreyForDivider,
                                ),
                              ),
                      child: Text(
                        S.of(context).back,
                        style: TextStyle(
                          fontSize: width / 32,
                          color:
                              isDark ? AppColors.kBlueLight : AppColors.kWhite,
                          fontFamily: AppFonts.poppins,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(
                      bottom: height / 40,
                    ),
                    width: width * .4,
                    height: height / 17,
                    child: ElevatedButton(
                      onPressed: () async {
                        if (activeStep == 2) {
                          setState(() {
                            isLoading = true;
                          });

                          final priceToPay = isFast
                              ? BlocProvider.of<CartCubit>(context)
                                  .calcFastPrice()
                              : BlocProvider.of<CartCubit>(context)
                                  .calculatePriceToPay();
                          final order = UserOrder(
                            fastPrice: BlocProvider.of<CartCubit>(context)
                                .calcFastPrice(),
                            fast: isFast,
                            timeStamp: Timestamp.now(),
                            status: "Placed",
                            instructions: instructions.text.isEmpty
                                ? "No special instructions"
                                : instructions.text.trim(),
                            userId: FirebaseAuth.instance.currentUser!.uid,
                            subItems: widget.cartItems,
                            price: priceToPay,
                            address: address!,
                            pickUpDateAndTime:
                                "${selectedDate.toString().substring(0, 10)} $selectedTime",
                            didPay: false,
                            paymentMethod: selectedMethod,
                          );
                          bool isUploaded = false;
                
                          if (selectedMethod == UserPaymentMethod.online) {
                            final balance =
                                BlocProvider.of<BalanceCubit>(context).balance;
                            if (balance >= order.price) {
                              order.didPay = true;

                              BlocProvider.of<BalanceCubit>(context)
                                  .decreaseBalance(order.fast
                                      ? order.fastPrice
                                      : order.price);
                            } else {
                              CustomSnackBar.show(context,
                                  S.of(context).balanceLow, AppColors.kRed);
                              setState(() {
                                isLoading = false;
                              });
                              return;
                            }
                          }

                          final orderUpload =
                              await uploadUserOrderToFirestore(order);
                          isUploaded = orderUpload.isUploaded;
                          order.id = orderUpload.orderId;
                          setState(() {
                            isLoading = false;
                          });
                          if (isUploaded) {
                            CustomSnackBar.show(
                              context,
                              S.of(context).orderSuc,
                              AppColors.kGreen,
                            );
                          } else {
                            CustomSnackBar.show(context, S.of(context).tryAgain,
                                AppColors.kRed);
                          }

                          BlocProvider.of<CartCubit>(context).emptyCart();
                          Navigator.of(context)
                              .pushReplacementNamed(AppRoutes.home);
                          // final pdfFile =
                          //     await generatePdf(order, addresss, user);

                          // await sendEmailWithPDF(user.email, pdfFile);
                        } else {
                          next();
                        }
                      },
                      style:
                          Theme.of(context).elevatedButtonTheme.style!.copyWith(
                                backgroundColor: const WidgetStatePropertyAll(
                                  AppColors.kBlueLight,
                                ),
                              ),
                      child: activeStep == 2 && isLoading
                          ? LoadingAnimationWidget.discreteCircle(
                              color: AppColors.kWhite,
                              size: height / 40,
                            )
                          : Text(
                              activeStep != 2
                                  ? S.of(context).okContinue
                                  : selectedMethod == UserPaymentMethod.cash
                                      ? S.of(context).save
                                      : S.of(context).checkout,
                              style: TextStyle(
                                fontSize: width / 32,
                                color: AppColors.kWhite,
                                fontFamily: AppFonts.poppins,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    ),
                  ),
                ],
              )
            ],
          );
        },
      ),
    );
  }

  Future<OrderUpload> uploadUserOrderToFirestore(UserOrder order) async {
    try {
      // Get a reference to the Firestore collection
      CollectionReference orders =
          FirebaseFirestore.instance.collection('orders');

      // Convert the order to a map
      Map<String, dynamic> orderMap = order.toMap();

      // Add the order to Firestore and get the document reference
      DocumentReference docRef = await orders.add(orderMap);

      // Get the document ID
      String docId = docRef.id;

      // Update the document to include the document ID in its data
      await docRef.update({
        'id': docId,
        'userId': FirebaseAuth.instance.currentUser!.uid,
      });

      return OrderUpload(isUploaded: true, orderId: docId);
    } catch (e) {
      return OrderUpload(isUploaded: false, orderId: null);
      print('Error uploading order: $e');
    }
  }
}

class OrderUpload {
  String? orderId;
  final bool isUploaded;
  OrderUpload({
    required this.isUploaded,
    required this.orderId,
  });
}
    // BlocBuilder<LanguageCubit, String>(
    //                             builder: (context, state) {
    //                               return GestureDetector(
    //                                 onTap: () async {
    //                                   DateTime? date = await showDatePicker(
    //                                     locale: Locale(state),
    //                                     context: context,
    //                                     initialDate: DateTime.now(),
    //                                     firstDate: DateTime
    //                                         .now(), // Set the minimum date to today
    //                                     lastDate: DateTime(2100),
    //                                   );

    //                                   if (date != null) {
    //                                     final time = await showTimePicker(
    //                                       context: context,
    //                                       initialTime: TimeOfDay.now().hour >=
    //                                                   8 &&
    //                                               TimeOfDay.now().hour <= 18
    //                                           ? TimeOfDay.now()
    //                                           : const TimeOfDay(
    //                                               hour: 8,
    //                                               minute:
    //                                                   0), // Default to 8 AM if current time is outside [8 AM, 6 PM]
    //                                     );

    //                                     if (time != null &&
    //                                         time.hour >= 8 &&
    //                                         time.hour <= 23) {
    //                                       // Only allow times within [8 AM, 6 PM]
    //                                       DateTime currentTime = DateTime.now();
    //                                       DateTime selectedDateTime = DateTime(
    //                                         date.year,
    //                                         date.month,
    //                                         date.day,
    //                                         time.hour,
    //                                         time.minute,
    //                                       );

    //                                       // Check if selected time is at least 2 hours after the current time
    //                                       if (selectedDateTime.isBefore(
    //                                           currentTime.add(
    //                                               const Duration(hours: 4)))) {
    //                                         CustomSnackBar.show(
    //                                           context,
    //                                           S.of(context).sorryForNotPicking,
    //                                           AppColors.kRed,
    //                                         );
    //                                       } else {
    //                                         pickUpTime = selectedDateTime;
    //                                         pickupDate = date;
    //                                         pickupDateAndTime =
    //                                             "${date.toString().substring(0, 10)} ${time.hour}:${time.minute}";
    //                                         setState(() {});
    //                                       }
    //                                     } else {
    //                                       // Optional: show a message if time is outside allowed interval
    //                                       CustomSnackBar.show(
    //                                         context,
    //                                         S.of(context).selectPeriodCorrect,
    //                                         AppColors.kRed,
    //                                       );
    //                                     }
    //                                   }
    //                                 },
    //                                 child: Container(
    //                                   width: width,
    //                                   //   height: height / 13,
    //                                   margin: EdgeInsets.symmetric(
    //                                       horizontal: width / 30,
    //                                       vertical: height / 120),
    //                                   padding: EdgeInsets.symmetric(
    //                                     horizontal: width / 30,
    //                                     vertical: pickupDateAndTime == null
    //                                         ? height / 50
    //                                         : height / 120,
    //                                   ),
    //                                   decoration: BoxDecoration(
    //                                     color: isDark
    //                                         ? AppColors.kBlueLight
    //                                         : AppColors.kWhite,
    //                                     border: Border.all(
    //                                         color: pickupDateAndTime == null
    //                                             ? AppColors.kGreyForDivider
    //                                             : AppColors.kBlueLight,
    //                                         width: 1),
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
    //                                     borderRadius: BorderRadius.circular(5),
    //                                   ),
    //                                   child: Row(
    //                                     mainAxisAlignment:
    //                                         MainAxisAlignment.spaceBetween,
    //                                     children: [
    //                                       pickupDateAndTime == null
    //                                           ? Row(
    //                                               children: [
    //                                                 Icon(
    //                                                   Ionicons.time,
    //                                                   color: pickupDateAndTime !=
    //                                                           null
    //                                                       ? AppColors.kBlueLight
    //                                                       : AppColors
    //                                                           .kGreyForDivider,
    //                                                   size: width / 18,
    //                                                 ),
    //                                                 const SizedBox(
    //                                                   width: 5,
    //                                                 ),
    //                                                 Text(
    //                                                   S
    //                                                       .of(context)
    //                                                       .pickupDateAndTime,
    //                                                   style: TextStyle(
    //                                                     fontSize: width / 28,
    //                                                     fontFamily:
    //                                                         AppFonts.poppins,
    //                                                     fontWeight:
    //                                                         FontWeight.bold,
    //                                                   ),
    //                                                 ),
    //                                               ],
    //                                             )
    //                                           : Column(
    //                                               crossAxisAlignment:
    //                                                   CrossAxisAlignment.center,
    //                                               children: [
    //                                                 Row(
    //                                                   children: [
    //                                                     Icon(
    //                                                       Ionicons.time,
    //                                                       color: pickupDateAndTime ==
    //                                                               null
    //                                                           ? AppColors
    //                                                               .kGreyForDivider
    //                                                           : AppColors
    //                                                               .kBlueLight,
    //                                                       size: width / 18,
    //                                                     ),
    //                                                     const SizedBox(
    //                                                       width: 5,
    //                                                     ),
    //                                                     Text(
    //                                                       S
    //                                                           .of(context)
    //                                                           .pickupDateAndTime,
    //                                                       style: TextStyle(
    //                                                         fontSize:
    //                                                             width / 28,
    //                                                         fontFamily: AppFonts
    //                                                             .poppins,
    //                                                         fontWeight:
    //                                                             FontWeight.bold,
    //                                                       ),
    //                                                     ),
    //                                                   ],
    //                                                 ),
    //                                                 Column(
    //                                                   crossAxisAlignment:
    //                                                       CrossAxisAlignment
    //                                                           .start,
    //                                                   children: [
    //                                                     Text(
    //                                                       pickupDateAndTime!,
    //                                                       style: TextStyle(
    //                                                         fontSize:
    //                                                             width / 30,
    //                                                         color: isDark
    //                                                             ? AppColors
    //                                                                 .kGreyForPin
    //                                                             : AppColors
    //                                                                 .kGreyForTexts,
    //                                                         fontFamily: AppFonts
    //                                                             .poppins,
    //                                                         fontWeight:
    //                                                             FontWeight.bold,
    //                                                       ),
    //                                                     ),
    //                                                   ],
    //                                                 ),
    //                                               ],
    //                                             ),
    //                                       Icon(
    //                                         Icons.arrow_forward_ios,
    //                                         size: width / 18,
    //                                       )
    //                                     ],
    //                                   ),
    //                                 ),
    //                               );
    //                             },
    //                           ),
    //                           BlocBuilder<LanguageCubit, String>(
    //                             builder: (context, state) {
    //                               return GestureDetector(
    //                                 onTap: pickupDate == null
    //                                     ? () {}
    //                                     : () async {
    //                                         final tomorrow = DateTime.now()
    //                                             .add(const Duration(days: 1));
    //                                         DateTime? date =
    //                                             await showDatePicker(
    //                                           locale: Locale(state),
    //                                           context: context,
    //                                           initialDate:
    //                                               tomorrow, // Start from tomorrow
    //                                           firstDate: DateTime.now().add(
    //                                               const Duration(
    //                                                   days:
    //                                                       1)), // Set the minimum date to tomorrow
    //                                           lastDate: DateTime(2100),
    //                                         );

    //                                         if (date != null) {
    //                                           if (date.isBefore(pickupDate!)) {
    //                                             CustomSnackBar.show(
    //                                               context,
    //                                               S.of(context).tryAgain,
    //                                               AppColors.kRed,
    //                                             );
    //                                             return;
    //                                           }
    //                                           final time = await showTimePicker(
    //                                             context: context,
    //                                             initialTime: const TimeOfDay(
    //                                                 hour: 8,
    //                                                 minute:
    //                                                     0), // Default initial time is 8 AM
    //                                           );

    //                                           if (time != null &&
    //                                               time.hour >= 8 &&
    //                                               time.hour <= 22) {
    //                                             // Ensure time is within [8 AM, 6 PM]
    //                                             DateTime currentTime =
    //                                                 DateTime.now();
    //                                             DateTime selectedDateTime =
    //                                                 DateTime(
    //                                               date.year,
    //                                               date.month,
    //                                               date.day,
    //                                               time.hour,
    //                                               time.minute,
    //                                             );

    //                                             // Check if selected time is at least 2 hours after the current time
    //                                             if (selectedDateTime.isBefore(
    //                                                     currentTime.add(
    //                                                         const Duration(
    //                                                             hours: 2))) ||
    //                                                 selectedDateTime.isBefore(
    //                                                     pickUpTime!.add(
    //                                                         const Duration(
    //                                                             hours: 4)))) {
    //                                               CustomSnackBar.show(
    //                                                 context,
    //                                                 S.of(context).tryAgain,
    //                                                 AppColors.kRed,
    //                                               );
    //                                             } else {
    //                                               deliveryDate = date;
    //                                               deliveryDateAndTime =
    //                                                   "${date.toString().substring(0, 10)} ${time.hour}:${time.minute}";
    //                                               setState(() {});
    //                                             }
    //                                           } else {
    //                                             // Optional: show a message if time is outside allowed interval
    //                                             CustomSnackBar.show(
    //                                               context,
    //                                               S
    //                                                   .of(context)
    //                                                   .selectPeriodCorrect,
    //                                               AppColors.kRed,
    //                                             );
    //                                           }
    //                                         }
    //                                       },
    //                                 child: Container(
    //                                   width: width,
    //                                   //   height: height / 13,
    //                                   margin: EdgeInsets.symmetric(
    //                                       horizontal: width / 30,
    //                                       vertical: height / 120),
    //                                   padding: EdgeInsets.symmetric(
    //                                     horizontal: width / 30,
    //                                     vertical: deliveryDateAndTime == null
    //                                         ? height / 50
    //                                         : height / 120,
    //                                   ),
    //                                   decoration: BoxDecoration(
    //                                     color: isDark
    //                                         ? AppColors.kBlueLight
    //                                         : AppColors.kWhite,
    //                                     border: Border.all(
    //                                         color: deliveryDateAndTime == null
    //                                             ? AppColors.kGreyForDivider
    //                                             : AppColors.kBlueLight,
    //                                         width: 1),
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
    //                                     borderRadius: BorderRadius.circular(5),
    //                                   ),
    //                                   child: Row(
    //                                     mainAxisAlignment:
    //                                         MainAxisAlignment.spaceBetween,
    //                                     children: [
    //                                       deliveryDateAndTime == null
    //                                           ? Row(
    //                                               children: [
    //                                                 Icon(
    //                                                   Ionicons.time,
    //                                                   color: deliveryDateAndTime !=
    //                                                           null
    //                                                       ? AppColors.kBlueLight
    //                                                       : AppColors
    //                                                           .kGreyForDivider,
    //                                                   size: width / 18,
    //                                                 ),
    //                                                 const SizedBox(
    //                                                   width: 5,
    //                                                 ),
    //                                                 Text(
    //                                                   S
    //                                                       .of(context)
    //                                                       .deliveryDateAndTime,
    //                                                   style: TextStyle(
    //                                                     fontSize: width / 28,
    //                                                     fontFamily:
    //                                                         AppFonts.poppins,
    //                                                     fontWeight:
    //                                                         FontWeight.bold,
    //                                                   ),
    //                                                 ),
    //                                               ],
    //                                             )
    //                                           : Column(
    //                                               crossAxisAlignment:
    //                                                   CrossAxisAlignment.center,
    //                                               children: [
    //                                                 Row(
    //                                                   children: [
    //                                                     Icon(
    //                                                       Ionicons.time,
    //                                                       color: deliveryDateAndTime ==
    //                                                               null
    //                                                           ? AppColors
    //                                                               .kBlueLight
    //                                                           : AppColors
    //                                                               .kBlueLight,
    //                                                       size: width / 18,
    //                                                     ),
    //                                                     const SizedBox(
    //                                                       width: 5,
    //                                                     ),
    //                                                     Text(
    //                                                       S
    //                                                           .of(context)
    //                                                           .deliveryDateAndTime,
    //                                                       style: TextStyle(
    //                                                         fontSize:
    //                                                             width / 28,
    //                                                         fontFamily: AppFonts
    //                                                             .poppins,
    //                                                         fontWeight:
    //                                                             FontWeight.bold,
    //                                                       ),
    //                                                     ),
    //                                                   ],
    //                                                 ),
    //                                                 Column(
    //                                                   crossAxisAlignment:
    //                                                       CrossAxisAlignment
    //                                                           .start,
    //                                                   children: [
    //                                                     Text(
    //                                                       deliveryDateAndTime!,
    //                                                       style: TextStyle(
    //                                                         fontSize:
    //                                                             width / 30,
    //                                                         color: isDark
    //                                                             ? AppColors
    //                                                                 .kGreyForPin
    //                                                             : AppColors
    //                                                                 .kGreyForTexts,
    //                                                         fontFamily: AppFonts
    //                                                             .poppins,
    //                                                         fontWeight:
    //                                                             FontWeight.bold,
    //                                                       ),
    //                                                     ),
    //                                                   ],
    //                                                 ),
    //                                               ],
    //                                             ),
    //                                       Icon(
    //                                         Icons.arrow_forward_ios,
    //                                         size: width / 18,
    //                                       )
    //                                     ],
    //                                   ),
    //                                 ),
    //                               );
    //                             },
    //                           ),
                             