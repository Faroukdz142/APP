import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ionicons/ionicons.dart';

import '../constants/colors.dart';
import '../constants/fonts.dart';
import '../generated/l10n.dart';

class CustomTextField extends StatefulWidget {
  final String hintText;

  FocusNode? focus;
  final TextEditingController controller;
  final Function validator;
  int? maxLines;
  CustomTextField({
    super.key,
    this.focus,
    this.maxLines,
    required this.validator,
    required this.controller,
    required this.hintText,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool obscure = false;
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return SizedBox(
      height: height < 650 ? width / 12 : width / 7.5,
      child: TextFormField(
    
        focusNode: widget.focus,
        onTap: onTap,
        maxLines: widget.hintText == S.of(context).message ||
                widget.hintText == S.of(context).prDescription ||
                widget.hintText == S.of(context).specialInstructions
            ? (widget.maxLines??8)
            : 1,
        controller: widget.controller,
        keyboardType: getKeyboardType(),
        style: getInputTextStyle(width: width),
        cursorColor: AppColors.kBlack,
        onTapOutside: (term) {
          if (widget.focus != null) {
            widget.focus!.unfocus();
          }
        },
        validator: (value) => widget.validator(value),
        decoration: getTextFieldDecoration(width: width),
      ),
    );
  }

  List<String> hintTexts = [
    "Phone number",
    "رقم الهاتف",
    "Address title",
    "اسم المستخدم",
    "Username",
    "Special Instructions",
    "Appartement",
    "Street",
    "Boulevard",
    "Building",
    "Appartement number"
  ];

  TextInputType? getKeyboardType() {
    return widget.hintText == "Phone number" ||
            widget.hintText == "رقم الهاتف" ||
            widget.hintText == "Price"
        ? TextInputType.number
        : null;
  }

  TextStyle getInputTextStyle({required double width}) {
    return TextStyle(
      fontFamily: AppFonts.poppins,
      fontSize: width / 32,
      fontWeight: FontWeight.w600,
      color: AppColors.kBlack,
    );
  }

  void onTap() {}

  Widget? getPrefixWidget({required double width}) {
    if (widget.hintText == "Phone number" || widget.hintText == "رقم الهاتف") {
      return Icon(
        Ionicons.call,
        color: AppColors.kGrey,
        size: width / 23,
      );
    } else if (widget.hintText == "اسم المستخدم" ||
        widget.hintText == "Username") {
      return Icon(
        Ionicons.person,
        color: AppColors.kGrey,
        size: width / 23,
      );
    }else if (widget.hintText == S.of(context).email) {
      return Icon(
        Icons.email,
        color: AppColors.kGrey,
        size: width / 23,
      );
    }  else {
      return null;
    }
  }

  InputDecoration getTextFieldDecoration({required double width}) {
    return InputDecoration(
      filled: true,
      fillColor: widget.hintText == "Your message here"
          ? AppColors.kWhite
          : AppColors.kTextFieldBgColor,
      prefixIcon: getPrefixWidget(width: width),
      contentPadding: EdgeInsets.symmetric(
        horizontal: width / 30,
        vertical: 0,
      ),
      errorStyle: const TextStyle(height: 0, fontSize: 0),
      hintStyle: TextStyle(
        fontSize: width / 30,
        color: AppColors.kGrey,
        fontWeight: FontWeight.w400,
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(5),
        borderSide: const BorderSide(
          color: AppColors.kRed,
          width: 1,
        ),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(5),
        borderSide: const BorderSide(
          color: AppColors.kRed,
          width: 1.5,
        ),
      ),
      hintText: widget.hintText,
      border: const OutlineInputBorder(
        borderSide: BorderSide.none,
        borderRadius: BorderRadius.all(
          Radius.circular(5),
        ),
      ),
    );
  }
}
