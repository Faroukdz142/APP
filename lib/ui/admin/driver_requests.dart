import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../logic/language/language_cubit.dart';
import '../../logic/theme/theme_cubit.dart';
import '../../widgets/snack_bar.dart';
import '../../constants/colors.dart';
import '../../constants/fonts.dart';
import '../../generated/l10n.dart';
import '../../models/request.dart';
import 'driverRequestsTile.dart';

class DriverRequests extends StatefulWidget {
  const DriverRequests({super.key});

  @override
  State<DriverRequests> createState() => _DriverRequestsState();
}

class _DriverRequestsState extends State<DriverRequests>
    with SingleTickerProviderStateMixin {
  List<Request> myRequests = [];
  bool isLoading2 = false;
  bool isLoading = false;
  final List<String> _statuses = ['Placed', 'In Progress', "Done"];
  late TabController _tabController;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getRequests();
    _tabController = TabController(length: _statuses.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> getRequests() async {
    isLoading = true;
    try {
      final requests = FirebaseFirestore.instance.collection("driverRequests");

      final data = await requests.get();
      for (var x in data.docs) {
        myRequests.add(Request.fromJson(x.data()));
      }
      isLoading = false;
      setState(() {});
    } catch (e) {
      CustomSnackBar.show(context, S.of(context).tryAgain, AppColors.kRed);
    }
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: PreferredSize(
        preferredSize: MediaQuery.of(context).size / 16,
        child: AppBar(
          toolbarHeight: height / 20,
          backgroundColor: AppColors.kBlueLight,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(20),
            ),
          ),
          leading: BlocBuilder<LanguageCubit, String>(
            builder: (context, state) {
              return Padding(
                padding: EdgeInsets.only(
                    right: state == "ar" ? width / 30 : 0,
                    left: state == "en" ? width / 30 : 0),
                child: GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Icon(
                    Icons.arrow_back_ios,
                    color: AppColors.kWhite,
                    size: width / 18,
                  ),
                ),
              );
            },
          ),
          title: Center(
                child: Text(
                  S.of(context).driverRequests,
                  style: TextStyle(
                    fontSize: width / 23,
                    color:AppColors.kWhite ,
                    fontFamily: AppFonts.poppins,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
          actions: [
            SizedBox(
              width: width / 10,
            ),
          ],
        ),
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : myRequests.isEmpty
              ? Center(
                  child: Text(
                    S.of(context).noReq,
                    style: TextStyle(
                      fontSize: width / 30,
            
                      fontFamily: AppFonts.poppins,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )
              : Column(
                  children: [
                    BlocBuilder<ThemeCubit, bool>(
                      builder: (context, isDark) {
                        return TabBar(
                          dividerHeight: 0,
                          unselectedLabelColor: isDark
                              ? AppColors.kGreyForDivider
                              : AppColors.kGreyForTexts,
                          labelStyle: TextStyle(
                            fontSize: width / 38,
                            color: !isDark? AppColors.kBlueLight: AppColors.kWhite,
                            fontFamily: AppFonts.poppins,
                            fontWeight: FontWeight.bold,
                          ),
                          unselectedLabelStyle: TextStyle(
                            fontSize: width / 38,
                            color: !isDark? AppColors.kBlueLight: AppColors.kWhite,
                            fontFamily: AppFonts.poppins,
                            fontWeight: FontWeight.bold,
                          ) ,
                          dividerColor: null,
                          controller: _tabController,
                          tabs: _statuses
                              .map((status) => Tab(
                                    text: getString(status),

                                    icon: Icon(
                                      getStatusIcon(status),
                                      size: width / 18,
                                    ),
                                  ))
                              .toList(),
                          indicatorColor: AppColors.kWhite,
                        );
                      },
                    ),
                    Expanded(
                      child: TabBarView(
                        controller: _tabController,
                        children: _statuses.map((status) {
                          // Filter the orders based on the selected status
                          final filteredOrders = myRequests
                              .where((order) => order.status == status)
                              .toList();
                          return filteredOrders.isEmpty
                              ? Center(
                                  child: Text(
                                    S.of(context).noReq,
                                    style: TextStyle(
                                      fontSize: width / 30,
                                      fontFamily: AppFonts.poppins,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                )
                              : ListView.builder(
                                  padding: const EdgeInsets.only(top: 8),
                                  itemCount: filteredOrders.length,
                                  itemBuilder: (context, index) {
                                    return DriverRequestsTile(
                                      updateUi: updateUi,
                                      cancel: cancelRequest,
                                      index: index,
                                      myRequest: myRequests[index],
                                    );
                                  },
                                );
                        }).toList(),
                      ),
                    ),
                  ],
                ),
    );
  }

  void updateUi() {
    setState(() {});
  }

  Future<bool> cancelRequest({
    required String id,
  }) async {
    try {
      await FirebaseFirestore.instance
          .collection("driverRequests")
          .doc(id)
          .delete();
      setState(() {
        myRequests.removeWhere(
          (element) => element.id == id,
        );
      });

      return true;
    } catch (e) {
      return false;
    }
  }

  IconData getStatusIcon(String status) {
    switch (status) {
      case 'Placed':
        return Icons.check;
      case 'In Progress':
        return Icons.construction;
      case 'Done':
        return Icons.check_circle;
      default:
        return Icons.error;
    }
  }

  String getString(String string) {
    if (string == "Placed") {
      return S.of(context).placed;
    } else if (string == "In Progress") {
      return S.of(context).inProg;
    } else if (string == "Done") {
      return S.of(context).done;
    }
    return string;
  }
}
