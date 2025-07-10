import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trustlaundry/models/product.dart';
import 'package:trustlaundry/models/sub.dart';
import '../../config/routes.dart';
import '../../constants/colors.dart';
import '../../generated/l10n.dart';
import '../../logic/balance/balance_cubit.dart';
import '../../logic/cubit/prod_cart_cubit.dart';
import '../../logic/pdf/pdf.dart';
import '../../models/app_user.dart';
import '../../models/my_address.dart';
import '../../widgets/snack_bar.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../logic/cart/cart_cubit.dart';
import '../../models/order.dart';

enum PaymentFor { order, sub, prod }

class PaymentWebView extends StatefulWidget {
  final String txnId;
  final PaymentFor paymentFor;
  final String paymentUrl;
  UserOrder? order;
  MyAddress? address;
  List<MyProduct>? prods;
  double? pay;
  double? get;
  PaymentWebView({
    required this.txnId,
    this.address,
    this.prods,
    required this.paymentFor,
    this.get,
    this.order,
    this.pay,
    required this.paymentUrl,
  });

  @override
  _PaymentWebViewState createState() => _PaymentWebViewState();
}

class _PaymentWebViewState extends State<PaymentWebView> {
  var controller = WebViewController();
  bool isExecuted = false;
  bool _isLoading = true;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageFinished: (String url) async {
            if (url.contains(
                "https://docs.google.com/document/d/1XeAWwlpdY5JaL8M7wu-bhRIlmkBcP_BEYn0k2ch8mWU")) {
              bool isOrderPayed = await checkTransactionStatus(
                  widget.txnId, context, widget.paymentFor);
              if (isOrderPayed) {
                if (widget.paymentFor == PaymentFor.sub) {
                  await BlocProvider.of<BalanceCubit>(context)
                      .increaseBalance(widget.get!);
                  await subscribed(widget.pay!, widget.get!);
                  CustomSnackBar.show(
                      context, S.of(context).subSuc, AppColors.kGreen);
                } else if (widget.paymentFor == PaymentFor.prod &&
                    !isExecuted) {
                  isExecuted = true;
                   BlocProvider.of<ProdCartCubit>(context).emptyCart();
                     
                  String phone = "";
                  final data = await FirebaseFirestore.instance
                      .collection("users")
                      .doc(FirebaseAuth.instance.currentUser!.uid)
                      .get();
                  phone = data.data()!["phoneNumber"];

                  final doc = await FirebaseFirestore.instance
                      .collection('prodOrders')
                      .add({
                    "payment": "online",
                    "address": widget.address!.toJson(),
                    "phone": phone,
                    "uid": FirebaseAuth.instance.currentUser!.uid,
                    "orders": widget.prods!.map((e) => e.toJson()).toList()
                  });
                   CustomSnackBar.show(
                          context, S.of(context).addedToCard, AppColors.kGreen);
                  await FirebaseFirestore.instance
                      .collection('prodOrders')
                      .doc(doc.id)
                      .update({"docId": doc.id});
                
                }
                Navigator.pushNamedAndRemoveUntil(
                    context, AppRoutes.home, (route) => false);
              } else {
                CustomSnackBar.show(
                    context, S.of(context).tryAgain, AppColors.kRed);
                Navigator.pushNamedAndRemoveUntil(
                    context, AppRoutes.home, (route) => false);
              }
            }
          },
          onHttpError: (HttpResponseError error) {
            // CustomSnackBar.show(
            //     context,
            //     "There was an onHttpError ${error.response!.uri}",
            //     AppColors.kRed);
          },
          onWebResourceError: (WebResourceError error) {
            // CustomSnackBar.show(
            //     context,
            //     "the onWebResourceError : ${error.description}",
            //     AppColors.kRed);
          },
          onNavigationRequest: (NavigationRequest request) {
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.paymentUrl));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).onlinePay),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          WebViewWidget(
            controller: controller,
          )
        ],
      ),
    );
  }
}

Future<void> subscribed(double pay, double get) async {
  final userDoc = FirebaseFirestore.instance
      .collection("users")
      .doc(FirebaseAuth.instance.currentUser!.uid);
  final subDoc = userDoc.collection("subscriptionsHistory").add({
    "pay": pay,
    "get": get,
    "timeStamp": Timestamp.now(),
  });

  final payDoc = userDoc.collection("paymentsHistory").add({
    "amount": pay,
    "paymentMethod": "k-net",
    "timeStamp": Timestamp.now(),
  });
}

Future<void> uploadUserOrderToFirestore(UserOrder order) async {
  try {
    // Get a reference to the Firestore collection
    CollectionReference orders =
        FirebaseFirestore.instance.collection('orders');

    // Convert the order to a map
    Map<String, dynamic> orderMap = order.toMap();

    // Add the order to Firestore and get the document reference
    DocumentReference docRef = await orders.add(orderMap);

    // Get the document ID
    String docId = docRef.id;

    // Update the document to include the document ID in its data
    await docRef.update({
      'id': docId,
      'userId': FirebaseAuth.instance.currentUser!.uid,
    });

    print('Order uploaded successfully with ID: $docId');
  } catch (e) {
    print('Error uploading order: $e');
  }
}

Future<bool> checkTransactionStatus(
    String transactionId, BuildContext context, PaymentFor paymentFor) async {
  final dio = Dio();
  final headers = {
    'Authorization': 'Bearer sk_test_8PCeQFI6Nixvsq5JbH7lpdw9',
  };

  final response = await dio.get(
      'https://api.tap.company/v2/charges/$transactionId',
      options: Options(headers: headers));

  final status = response.data['status'];
  if (status != null) {}
  return status == 'CAPTURED';
}
