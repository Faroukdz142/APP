import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ionicons/ionicons.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:location/location.dart';
import 'necessary.dart';

import '../../../constants/colors.dart';
import '../../../constants/fonts.dart';
import '../../../generated/l10n.dart';
import '../../../logic/address/address_cubit.dart';
import '../../../widgets/snack_bar.dart';
import '../../../widgets/text_field.dart';

class GpsLocation extends StatefulWidget {
  GpsLocation({
    super.key,
  });

  @override
  State<GpsLocation> createState() => _GpsLocationState();
}

class _GpsLocationState extends State<GpsLocation> {
  Location location = Location();
  bool _serviceEnabled = false;
  bool locLoading = false;
  PermissionStatus _permissionGranted = PermissionStatus.denied;
  LocationData? _locationData;
  bool loading = false;
  final title = TextEditingController();
  final phoneNumber = TextEditingController();

  // Method to request location permission and get the location
  Future<void> _getLocation() async {
    // Check if the location service is enabled
    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return; // Service not enabled, exit the function
      }
    }

    // Check if location permission is granted
    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return; // Permission not granted, exit the function
      }
    }
    setState(() {
      locLoading = true;
    });
    // If permission is granted and service is enabled, get the location
    _locationData = await location.getLocation();

    // Update the UI
    setState(() {
      locLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Padding(
      padding: EdgeInsets.only(bottom:  MediaQuery.of(context).viewInsets.bottom,),
      child: Container(
        height: height * .5,
        padding: EdgeInsets.only(
          left: width / 20,
          right: width / 20,
         
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
                S.of(context).currentLoc,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: width / 30,
                
                  fontFamily: AppFonts.poppins,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(
              height: height / 50,
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
            SizedBox(
              height: 2,
            ),
            Row(
              children: [
                Text(
                  S.of(context).phoneNumber,
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
                    S.of(context).phoneNumberEmpty,
                    AppColors.kRed,
                  );
                  return '';
                } else {
                  return null;
                }
              },
              controller: phoneNumber,
              hintText: S.of(context).phoneNumber,
            ),
            const SizedBox(
              height: 10,
            ),
            SizedBox(
              width: width,
              height: height / 17,
              child: ElevatedButton(
                onPressed: () async {
                  await _getLocation();
                },
                style: Theme.of(context).elevatedButtonTheme.style!.copyWith(
                      shape: WidgetStatePropertyAll(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                          side: const BorderSide(color: AppColors.kBlueLight),
                        ),
                      ),
                      backgroundColor: const WidgetStatePropertyAll(
                        AppColors.kWhite,
                      ),
                    ),
                child: locLoading
                    ? Center(
                        child: SizedBox(
                          width: width / 22,
                          height: width / 22,
                          child: const CircularProgressIndicator(),
                        ),
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _locationData != null
                              ? Icon(
                                  Ionicons.checkmark_circle_outline,
                                  color: AppColors.kGreen,
                                  size: width / 18,
                                )
                              : Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    Icon(
                                      Ionicons.locate_outline,
                                      color: AppColors.kBlueLight,
                                      size: width / 18,
                                    ),
                                    const CircleAvatar(
                                      radius: 2,
                                      backgroundColor: AppColors.kBlueLight,
                                    )
                                  ],
                                ),
                          Text(
                            _locationData != null
                                ? S.of(context).done
                                : S.of(context).currentLoc,
                            style: TextStyle(
                              fontSize: width / 26,
                              color: _locationData != null
                                  ? AppColors.kGreen
                                  : AppColors.kBlueLight,
                              fontFamily: AppFonts.poppins,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
              ),
            ),
            SizedBox(
              height: height / 20,
            ),
            SizedBox(
              width: width,
              height: height / 17,
              child: ElevatedButton(
                onPressed: () async {
                  if (title.text.isNotEmpty &&
                      phoneNumber.text.isNotEmpty &&
                      _locationData != null) {
                    setState(() {
                      loading = true;
                    });
                    final doc = await FirebaseFirestore.instance
                        .collection("users")
                        .doc(FirebaseAuth.instance.currentUser!.uid)
                        .collection("addresses")
                        .add({
                          "isExact":true,
                      "title": title.text.trim(),
                      "lat": _locationData!.latitude,
                      "lng": _locationData!.longitude,
                      "phoneNum": phoneNumber.text.trim(),
                    });
                    await FirebaseFirestore.instance
                        .collection("users")
                        .doc(FirebaseAuth.instance.currentUser!.uid)
                        .collection("addresses")
                        .doc(doc.id)
                        .update({
                      "id": doc.id,
                    });
                    setState(() {
                      loading = false;
                    });
                    await BlocProvider.of<AddressCubit>(context).getAddresses();
                    Navigator.pop(context);
                  } else {
                    CustomSnackBar.show(
                      context,
                      S.of(context).necessaryData,
                      AppColors.kRed,
                    );
                  }
                },
                style: Theme.of(context).elevatedButtonTheme.style!.copyWith(
                      backgroundColor: WidgetStatePropertyAll(
                          _locationData != null && title.text.isNotEmpty
                              ? AppColors.kBlueLight
                              : AppColors.kGreyForDivider),
                      shape: WidgetStatePropertyAll(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                          side: BorderSide(
                              color:
                                  _locationData != null && title.text.isNotEmpty
                                      ? AppColors.kBlueLight
                                      : AppColors.kGreyForDivider),
                        ),
                      ),
                    ),
                child: Center(
                  child: loading
                      ? LoadingAnimationWidget.discreteCircle(
                          color: AppColors.kWhite, size: width / 18)
                      : Text(
                          S.of(context).submit,
                          style: TextStyle(
                            fontSize: width / 26,
                            color: AppColors.kWhite,
                            fontFamily: AppFonts.poppins,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
