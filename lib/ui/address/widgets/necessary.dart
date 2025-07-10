import 'package:flutter/material.dart';

import '../../../constants/colors.dart';
import '../../../constants/fonts.dart';

class NecessaryWidget extends StatelessWidget {
  const NecessaryWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      "*",
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: 10,
        color: AppColors.kRed,
        fontFamily: AppFonts.poppins,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
