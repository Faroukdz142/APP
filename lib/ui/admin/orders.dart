import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ionicons/ionicons.dart';
import '../../logic/admin_orders/admin_orders_cubit.dart';
import '../../logic/theme/theme_cubit.dart';

import '../../constants/colors.dart';
import '../../constants/fonts.dart';
import '../../generated/l10n.dart';
import '../../logic/language/language_cubit.dart';
import 'order_tile.dart';

class AllOrders extends StatefulWidget {
  const AllOrders({super.key});

  @override
  State<AllOrders> createState() => _AllOrdersState();
}

class _AllOrdersState extends State<AllOrders>
    with SingleTickerProviderStateMixin {
  final List<String> _statuses = [
    'Placed',
    'In Progress',
    'Out for delivery',
    "Done"
  ];
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    BlocProvider.of<AdminOrdersCubit>(context).getUsersOrders();
    _tabController = TabController(length: _statuses.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
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
              S.of(context).orders,
              style: TextStyle(
                fontSize: width / 23,
                color: AppColors.kWhite,
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
      body: BlocBuilder<AdminOrdersCubit, AdminOrdersState>(
        builder: (context, state) {
          if (state is AdminOrdersSuccess) {
            if (state.orders.isEmpty) {
              return Center(
                child: Text(
                  S.of(context).noOrders,
                  style: TextStyle(
                    fontSize: width / 30,
                    fontFamily: AppFonts.poppins,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              );
            } else {
              return Column(
                children: [
                  BlocBuilder<ThemeCubit, bool>(
                    builder: (context, isDark) {
                      return TabBar(
                        dividerHeight: 0,
                        unselectedLabelColor: isDark
                            ? AppColors.kGreyForDivider
                            : AppColors.kGreyForTexts,
                        labelStyle: TextStyle(
                          fontSize: width / 45,
                          color:
                              !isDark ? AppColors.kBlueLight : AppColors.kWhite,
                          fontFamily: AppFonts.poppins,
                          fontWeight: FontWeight.bold,
                        ),
                        unselectedLabelStyle: TextStyle(
                          fontSize: width / 45,
                          color:
                              !isDark ? AppColors.kBlueLight : AppColors.kWhite,
                          fontFamily: AppFonts.poppins,
                          fontWeight: FontWeight.bold,
                        ),
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
                        final filteredOrders = state.orders
                            .where((order) => order.status == status)
                            .toList();
                        return filteredOrders.isEmpty
                            ? Center(
                                child: Text(
                                  S.of(context).noOrders,
                                  style: TextStyle(
                                    fontSize: width / 30,
                                    color: AppColors.kBlack,
                                    fontFamily: AppFonts.poppins,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              )
                            : ListView.builder(
                                itemCount: filteredOrders.length,
                                itemBuilder: (context, index) {
                                  return OrderTile(
                                    index: index,
                                    order: filteredOrders[index],
                                  );
                                },
                              );
                      }).toList(),
                    ),
                  ),
                ],
              );
            }
          } else if (state is AdminOrdersLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return const SizedBox();
          }
        },
      ),
    );
  }

  IconData getStatusIcon(String status) {
    switch (status) {
      case 'Placed':
        return Icons.check;
      case 'In Progress':
        return Icons.construction;
      case 'Out for delivery':
        return Icons.local_shipping;
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
    } else if (string == "Out for delivery") {
      return S.of(context).outForDelivery;
    } else if (string == "Done") {
      return S.of(context).done;
    }
    return string;
  }
}
