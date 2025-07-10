import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../logic/language/language_cubit.dart';
import '../../../../logic/theme/theme_cubit.dart';
import '../../../laundry/func.dart';

import '../../../../constants/colors.dart';
import '../../../../constants/fonts.dart';
import '../../../../generated/l10n.dart';
import '../../../../models/items.dart';
import '../../../../models/mySection.dart';
import 'sub_item_details.dart';

class SubItemAdminWidget extends StatelessWidget {
  final SubItem subItem;
  final Item item;
  final MySection section;
  final MyCategory category;
  final Function fetchItems;
  final int index;
  const SubItemAdminWidget({
    super.key,
    required this.subItem,
    required this.index,
    required this.category,
    required this.fetchItems,
    required this.item,
    required this.section,
  });

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return GestureDetector(
      onLongPress: () {
        Navigator.pop(context);
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          builder: (context) {
            return SubItemDetails(
              subItem: subItem,
              item: item,
              category: category,
              fetchItems: fetchItems,
              section: section,
            );
          },
        );
      },
      child: BlocBuilder<ThemeCubit, bool>(
        builder: (context, isDark) {
          return Container(
            width: width,
            margin: EdgeInsets.symmetric(
                horizontal: width / 30, vertical: height / 120),
            padding: EdgeInsets.all(width / 30),
            decoration: BoxDecoration(
              color: isDark? AppColors.kBlueLight:AppColors.kWhite,
              boxShadow:isDark?[]: const [
                BoxShadow(
                  color: AppColors.kGreyForDivider,
                  blurRadius: 10,
                  spreadRadius: 0,
                ),
              ],
              borderRadius: BorderRadius.circular(15),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Text(
                      "${index + 1}",
                      style: TextStyle(
                        fontSize: width / 26,
                        fontFamily: AppFonts.poppins,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      width: width / 20,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        BlocBuilder<LanguageCubit, String>(
                          builder: (context, state) {
                            return Text(
                              state == "ar" ? subItem.titleAr : subItem.titleEn,
                              style: TextStyle(
                                fontSize: width / 32,
                                fontFamily: AppFonts.poppins,
                                fontWeight: FontWeight.bold,
                              ),
                            );
                          },
                        ),
                        Row(
                          children: [
                            Text(
                              "${subItem.price} ${S.of(context).kwd}",
                              style: TextStyle(
                                fontSize: width / 23,
                                fontFamily: AppFonts.poppins,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                             Text(
                          subItem.priceFast!=subItem.price? " (${S.of(context).mousta3jil}: ${subItem.priceFast} ${S.of(context).kwd})":" (${S.of(context).noMousta3jil})",
                          style: TextStyle(
                            fontSize: width / 25,
                            fontFamily: AppFonts.poppins,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                          ],
                        ),
                      
                      ],
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
