import 'package:flutter/material.dart';

import '../../../../constants/colors.dart';
import '../../../../constants/fonts.dart';

class Countdown extends AnimatedWidget {
  final Animation<int>? animation;

  Countdown({
    super.key,
    this.animation,
  }) : super(listenable: animation!);

  @override
  build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    Duration clockTimer = Duration(seconds: animation!.value);

    String timerText =
        '${clockTimer.inMinutes.remainder(60).toString()}:${clockTimer.inSeconds.remainder(60).toString().padLeft(2, '0')}';

    return Text(
      timerText,
      style: TextStyle(
        fontSize: width / 36,
        color: AppColors.kBlack,
        fontFamily: AppFonts.poppins,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
