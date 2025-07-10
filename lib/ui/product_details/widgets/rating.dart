import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import '../../../constants/fonts.dart';
import '../../../../constants/colors.dart';
import '../../../generated/l10n.dart';

class Rating extends StatelessWidget {
  final String rating;
  final int numOfRates;
  const Rating({super.key, required this.rating,required this.numOfRates});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Ionicons.star,
            color: AppColors.kYellow,
            size: width / 16,
          ),
          const SizedBox(
            width: 10,
          ),
          Text(
            '$rating/5',
            style: TextStyle(
              fontSize: width / 25,
              fontFamily: AppFonts.poppins,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(width: 8,),
          Text(
            '($numOfRates ${S.of(context).rater})',
            style: TextStyle(
              fontSize: width / 25,
              fontFamily: AppFonts.poppins,
              fontWeight: FontWeight.bold,
            ),
          ),

        ],
      ),
    );
  }
}
