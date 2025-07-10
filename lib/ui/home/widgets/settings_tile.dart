import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import '../../../logic/theme/theme_cubit.dart';
import '../../../constants/colors.dart';
import '../../../constants/fonts.dart';

class SettingsTile extends StatelessWidget {
  final String image;
  final String title;
  final Function onTap;
  const SettingsTile(
      {super.key,
      required this.image,
      required this.title,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: () => onTap(),
      child: BlocBuilder<ThemeCubit, bool>(
        builder: (context, isDark) {
          return Container(
            width: width,
            padding: EdgeInsets.symmetric(
                horizontal: width / 30, vertical: height / 120),
            decoration: BoxDecoration(
              color: isDark?AppColors.kBlueLight:AppColors.kWhite,
              boxShadow: isDark?[]:
                  const [
                    BoxShadow(
                      color: AppColors.kGreyForDivider,
                      blurRadius: 10,
                      spreadRadius: 0,
                    ),
                  ],
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  child: Row(
                    children: [
                      Image.asset(
                        image,
                        height: height / 30,
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: width / 28,
                          color: isDark? AppColors.kWhite:AppColors.kGreyForTexts,
                          fontFamily: AppFonts.poppins,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
               Icon(
                  Icons.arrow_forward_ios,
                  size: width/23,
                  color: isDark? AppColors.kWhite:AppColors.kGrey,
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
