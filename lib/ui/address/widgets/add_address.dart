import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ionicons/ionicons.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import '../../../logic/address/address_cubit.dart';
import '../../../logic/theme/theme_cubit.dart';
import '../../../models/my_address.dart';
import 'add_address_or_modify.dart';
import 'gps_location.dart';
import 'necessary.dart';

import '../../../constants/colors.dart';
import '../../../constants/fonts.dart';
import '../../../generated/l10n.dart';
import '../../../widgets/snack_bar.dart';
import '../../../widgets/text_field.dart';

class AddAdress extends StatefulWidget {
  AddAdress({
    super.key,
  });

  @override
  State<AddAdress> createState() => _AddAdressState();
}

class _AddAdressState extends State<AddAdress> {
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Container(
      height: height * .4,
      padding: EdgeInsets.only(
        left: width / 20,
        right: width / 20,
        // bottom: 20,
      ),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
      width: width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
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
          ListTile(
            trailing: const SizedBox(),
            leading: Icon(
              Icons.arrow_back_ios,
              size: width / 18,
            ),
            title: Text(
              S.of(context).addAddress,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: width / 30,
                fontFamily: AppFonts.poppins,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(
            height: height / 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                  showModalBottomSheet(
                    isScrollControlled: true,

                    context: context,
                    builder: (context) {
                      return GpsLocation();
                    },
                  );
                },
                child: BlocBuilder<ThemeCubit, bool>(
                  builder: (context, isDark) {
                    return Container(
                      height: height / 5.5,
                      width: height / 5.5,
                      padding: EdgeInsets.symmetric(
                        vertical: height / 90,
                        horizontal: width / 90,
                      ),
                      decoration: BoxDecoration(
                        border:
                            Border.all(width: 1, color: AppColors.kBlueLight),
                        color: isDark ? AppColors.kBlueLight : AppColors.kWhite,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: const [
                          BoxShadow(
                            color: AppColors.kGreyForDivider,
                            blurRadius: 3,
                            spreadRadius: 0,
                          ),
                        ],
                      ),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              S.of(context).currentLoc,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: width / 28,
                                fontFamily: AppFonts.poppins,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Stack(
                              alignment: Alignment.center,
                              children: [
                                Icon(
                                  Ionicons.locate_outline,
                                  color: !isDark
                                      ? AppColors.kBlueLight
                                      : AppColors.kWhite,
                                  size: width / 18,
                                ),
                                CircleAvatar(
                                  radius: 2,
                                  backgroundColor: !isDark
                                      ? AppColors.kBlueLight
                                      : AppColors.kWhite,
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              SizedBox(
                width: width / 15,
              ),
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                  showModalBottomSheet(
                    isScrollControlled: true,
                    context: context,
                    builder: (context) {
                      return AddAdressOrModify(
                        myAddress: null,
                        addOrModify: AddOrModify.add,
                      );
                    },
                  );
                },
                child: BlocBuilder<ThemeCubit, bool>(
                  builder: (context, isDark) {
                    return Container(
                      height: height / 5.5,
                      width: height / 5.5,
                      padding: EdgeInsets.symmetric(
                          vertical: height / 90, horizontal: width / 40),
                      decoration: BoxDecoration(
                        border:
                            Border.all(width: 1, color: AppColors.kBlueLight),
                        color: isDark ? AppColors.kBlueLight : AppColors.kWhite,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: const [
                          BoxShadow(
                            color: AppColors.kGreyForDivider,
                            blurRadius: 3,
                            spreadRadius: 0,
                          ),
                        ],
                      ),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              S.of(context).addressDetails,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: width / 28,
                                fontFamily: AppFonts.poppins,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Icon(
                              Ionicons.location_outline,
                              size: width / 15,
                              color: !isDark
                                  ? AppColors.kBlueLight
                                  : AppColors.kWhite,
                            )
                          ],
                        ),
                      ),
                    );
                  },
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
