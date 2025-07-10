import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import '../../../logic/address/address_cubit.dart';
import '../../../logic/theme/theme_cubit.dart';
import '../../../models/my_address.dart';
import 'necessary.dart';

import '../../../constants/colors.dart';
import '../../../constants/fonts.dart';
import '../../../generated/l10n.dart';
import '../../../widgets/snack_bar.dart';
import '../../../widgets/text_field.dart';

enum AddOrModify { add, modify }

class AddAdressOrModify extends StatefulWidget {
  final AddOrModify addOrModify;
  MyAddress? myAddress;
  AddAdressOrModify({super.key, required this.addOrModify, this.myAddress});

  @override
  State<AddAdressOrModify> createState() => _AddAdressOrModifyState();
}

class _AddAdressOrModifyState extends State<AddAdressOrModify> {
  String currentArea = '------';
  List<String> areas = [
    '------',
    'Al Asimah',
    'Hawalli',
    'Farwaniya',
    'Mubarak Al-Kabeer',
    'Al Jahra',
    'Al Ahmadi'
  ];
  String getLocalizedAreaName(BuildContext context, String area) {
    if (area == "Al Asimah") {
      return S.of(context).asimah;
    } else if (area == "Hawalli") {
      return S.of(context).hawalli;
    } else if (area == "Farwaniya") {
      return S.of(context).farwaniya;
    } else if (area == "Mubarak Al-Kabeer") {
      return S.of(context).mubarakAlKabeer;
    } else if (area == "Al Jahra") {
      return S.of(context).jahra;
    } else if (area == "Al Ahmadi") {
      return S.of(context).ahmadi;
    } else {
      return area; // Default to the original name if no match found
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.addOrModify == AddOrModify.modify) {
      currentArea = widget.myAddress!.area!;
      city.text = widget.myAddress!.city!;
      title.text = widget.myAddress!.addressTitle;
      piece.text = widget.myAddress!.piece!;
      street.text = widget.myAddress!.street!;
      jada.text = widget.myAddress!.boulevard!;
      building.text = widget.myAddress!.building!;
      phoneNumber.text = widget.myAddress!.phoneNum;
      buildingNum.text = widget.myAddress!.apartmentNum!;
    }
  }

  bool isLoading = false;
  final title = TextEditingController();
  final city = TextEditingController();
  final piece = TextEditingController();
  final street = TextEditingController();
  final jada = TextEditingController();
  final building = TextEditingController();
  final buildingNum = TextEditingController();
  final phoneNumber = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Container(
      padding: EdgeInsets.only(
        left: width / 20,
        right: width / 20,
        bottom: MediaQuery.of(context).viewInsets.bottom,
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
          SizedBox(
            height: width / 15,
          ),
          ListTile(
            trailing: const SizedBox(),
            leading: GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Icon(
                Icons.arrow_back_ios,
                size: width / 18,
              ),
            ),
            title: Text(
              widget.addOrModify == AddOrModify.add
                  ? S.of(context).addAddress
                  : S.of(context).modifyAddress,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: width / 30,
                fontFamily: AppFonts.poppins,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          Row(
            children: [
              Row(
                children: [
                  Text(
                    S.of(context).chooseArea,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: width / 36,
                      fontFamily: AppFonts.poppins,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const NecessaryWidget()
                ],
              ),
              SizedBox(
                width: width / 20,
              ),
              BlocBuilder<ThemeCubit, bool>(
                builder: (context, isDark) {
                  return DropdownButton<String>(
                    value: currentArea,
                    icon: Icon(
                      Icons.arrow_downward,
                      color: isDark ? AppColors.kWhite : AppColors.kBlack,
                      size: width / 18,
                    ),
                    elevation: 16,
                    style: TextStyle(
                      fontSize: width / 32,
                      color: isDark ? AppColors.kWhite : AppColors.kBlack,
                      fontFamily: AppFonts.poppins,
                      fontWeight: FontWeight.bold,
                    ),
                    underline: Container(
                      height: 2,
                      color: AppColors.kBlueLight,
                    ),
                    onChanged: (String? newValue) async {
                      setState(() {
                        currentArea = newValue!;
                      });
                    },
                    items: areas.map<DropdownMenuItem<String>>((String area) {
                      return DropdownMenuItem<String>(
                        value: area,
                        child: Text(getLocalizedAreaName(context, area)),
                      );
                    }).toList(),
                  );
                },
              ),
            ],
          ),
          SizedBox(
            height: height / 90,
          ),
          Row(
            children: [
              Text(
                S.of(context).addressTitle,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: width / 36,
                  fontFamily: AppFonts.poppins,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const NecessaryWidget()
            ],
          ),
          const SizedBox(
            height: 2,
          ),
          CustomTextField(
            validator: (value) {
              if (value.isEmpty) {
                CustomSnackBar.show(
                  context,
                  S.of(context).usernameEmpty,
                  AppColors.kRed,
                );
                return '';
              } else {
                return null;
              }
            },
            controller: title,
            hintText: S.of(context).addressTitle,
          ),
          Row(
            children: [
              Expanded(
                child: Column(
                  children: [
                    Row(
                      children: [
                        Text(
                          S.of(context).city,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: width / 36,
                            fontFamily: AppFonts.poppins,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const NecessaryWidget()
                      ],
                    ),
                    const SizedBox(
                      height: 2,
                    ),
                    CustomTextField(
                      validator: (value) {
                        if (value.isEmpty) {
                          CustomSnackBar.show(
                            context,
                            S.of(context).usernameEmpty,
                            AppColors.kRed,
                          );
                          return '';
                        } else {
                          return null;
                        }
                      },
                      controller: city,
                      hintText: S.of(context).city,
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: width / 30,
              ),
              Expanded(
                child: Column(
                  children: [
                    Row(
                      children: [
                        Text(
                          S.of(context).street,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: width / 36,
                            fontFamily: AppFonts.poppins,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const NecessaryWidget()
                      ],
                    ),
                    const SizedBox(
                      height: 2,
                    ),
                    CustomTextField(
                      validator: (value) {
                        if (value.isEmpty) {
                          CustomSnackBar.show(
                            context,
                            S.of(context).usernameEmpty,
                            AppColors.kRed,
                          );
                          return '';
                        } else {
                          return null;
                        }
                      },
                      controller: street,
                      hintText: S.of(context).street,
                    ),
                  ],
                ),
              )
            ],
          ),

          const SizedBox(
            height: 2,
          ),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          S.of(context).appartement,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: width / 36,
                            fontFamily: AppFonts.poppins,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const NecessaryWidget()
                      ],
                    ),
                    const SizedBox(
                      height: 2,
                    ),
                    CustomTextField(
                      validator: (value) {
                        if (value.isEmpty) {
                          CustomSnackBar.show(
                            context,
                            S.of(context).usernameEmpty,
                            AppColors.kRed,
                          );
                          return '';
                        } else {
                          return null;
                        }
                      },
                      controller: piece,
                      hintText: S.of(context).appartement,
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: width / 30,
              ),
              Expanded(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    S.of(context).appartementNumber,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: width / 36,
                      fontFamily: AppFonts.poppins,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(
                    height: 2,
                  ),
                  CustomTextField(
                    validator: (value) {
                      if (value.isEmpty) {
                        CustomSnackBar.show(
                          context,
                          S.of(context).usernameEmpty,
                          AppColors.kRed,
                        );
                        return '';
                      } else {
                        return null;
                      }
                    },
                    controller: buildingNum,
                    hintText: S.of(context).appartementNumber,
                  ),
                ],
              ))
            ],
          ),

          const SizedBox(
            height: 2,
          ),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      S.of(context).boulevard,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: width / 36,
                        fontFamily: AppFonts.poppins,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    CustomTextField(
                      validator: (value) {
                        return null;
                      },
                      controller: jada,
                      hintText: S.of(context).boulevard,
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: width / 30,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          S.of(context).building,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: width / 36,
                            fontFamily: AppFonts.poppins,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const NecessaryWidget()
                      ],
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    CustomTextField(
                      validator: (value) {
                        if (value.isEmpty) {
                          CustomSnackBar.show(
                            context,
                            S.of(context).usernameEmpty,
                            AppColors.kRed,
                          );
                          return '';
                        } else {
                          return null;
                        }
                      },
                      controller: building,
                      hintText: S.of(context).building,
                    ),
                  ],
                ),
              ),
            ],
          ),
          // const SizedBox(
          //   height: 2,
          // ),
          // Row(
          //   children: [
          //     Text(
          //       S.of(context).phoneNumber,
          //       textAlign: TextAlign.center,
          //       style: TextStyle(
          //         fontSize: width / 36,
          //         fontFamily: AppFonts.poppins,
          //         fontWeight: FontWeight.bold,
          //       ),
          //     ),
          //     const NecessaryWidget()
          //   ],
          // ),
          // const SizedBox(
          //   height: 2,
          // ),
          // CustomTextField(
          //   validator: (value) {
          //     if (value.isEmpty) {
          //       CustomSnackBar.show(
          //         context,
          //         S.of(context).phoneNumberEmpty,
          //         AppColors.kRed,
          //       );
          //       return '';
          //     } else {
          //       return null;
          //     }
          //   },
          //   controller: phoneNumber,
          //   hintText: S.of(context).phoneNumber,
          // ),
          // const SizedBox(
          //   height: 10,
          // ),
          const Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SizedBox(
                width: width * .4,
                height: height / 17,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  style: Theme.of(context).elevatedButtonTheme.style!.copyWith(
                        backgroundColor: const WidgetStatePropertyAll(
                          AppColors.kGreyForDivider,
                        ),
                      ),
                  child: Text(
                    S.of(context).cancel,
                    style: TextStyle(
                      fontSize: width / 26,
                      color: AppColors.kWhite,
                      fontFamily: AppFonts.poppins,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: width * .4,
                height: height / 17,
                child: ElevatedButton(
                  onPressed: () async {
                    if (currentArea != '------' &&
                        title.text.isNotEmpty &&
                        piece.text.isNotEmpty &&
                        jada.text.isNotEmpty &&
                        street.text.isNotEmpty &&
                        title.text.isNotEmpty &&
                        building.text.isNotEmpty &&
                        buildingNum.text.isNotEmpty
                       ) {
                      bool isDone = false;
                      setState(() {
                        isLoading = true;
                      });
                      if (widget.addOrModify == AddOrModify.add) {
                        isDone = await BlocProvider.of<AddressCubit>(context)
                            .addAddress(
                          area: currentArea,
                          city: city.text.trim(),
                          piece: piece.text.trim(),
                          jada: jada.text.trim(),
                          street: street.text.trim(),
                          title: title.text.trim(),
                          building: building.text.trim(),
                          phoneNum: phoneNumber.text.trim(),
                          buildingNum: buildingNum.text.trim(),
                        );
                      } else {
                        isDone = await BlocProvider.of<AddressCubit>(context)
                            .editAddress(
                          area: currentArea,
                          city: city.text.trim(),
                          id: widget.myAddress!.id,
                          piece: piece.text.trim(),
                          jada: jada.text.trim(),
                          street: street.text.trim(),
                          title: title.text.trim(),
                          building: building.text.trim(),
                          phoneNum: phoneNumber.text.trim(),
                          buildingNum: buildingNum.text.trim(),
                        );
                      }
                      if (isDone) {
                        await BlocProvider.of<AddressCubit>(context)
                            .getAddresses();
                        setState(() {
                          isLoading = false;
                        });
                        CustomSnackBar.show(
                          context,
                          "${widget.addOrModify == AddOrModify.add ? S.of(context).addSuccess : S.of(context).updateSuccess} address successfully!",
                          AppColors.kGreen,
                        );
                        Navigator.pop(context);
                      } else {
                        CustomSnackBar.show(
                          context,
                          S.of(context).tryAgain,
                          AppColors.kRed,
                        );
                      }
                    } else {
                      CustomSnackBar.show(
                        context,
                        S.of(context).necessaryData,
                        AppColors.kRed,
                      );
                    }
                  },
                  style: Theme.of(context).elevatedButtonTheme.style!.copyWith(
                        backgroundColor: const WidgetStatePropertyAll(
                          AppColors.kBlueLight,
                        ),
                      ),
                  child: isLoading
                      ? LoadingAnimationWidget.discreteCircle(
                          color: AppColors.kWhite,
                          size: width / 18,
                        )
                      : Text(
                          S.of(context).save,
                          style: TextStyle(
                            fontSize: width / 26,
                            color: AppColors.kWhite,
                            fontFamily: AppFonts.poppins,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: height / 50,
          ),
        ],
      ),
    );
  }
}
