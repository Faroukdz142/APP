// import 'dart:io';
// import 'package:flutter/services.dart';
// import 'package:mailer/mailer.dart';
// import 'package:mailer/smtp_server.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:pdf/pdf.dart';
// import 'package:pdf/widgets.dart' as pw;
// import 'package:share_plus/share_plus.dart';
// import 'package:trustlaundry/models/request.dart';
// import 'package:trustlaundry/models/sub.dart';
// import 'package:trustlaundry/ui/home/home_screen.dart';
// import '../../constants/strings.dart';
// import '../../models/app_user.dart';
// import '../../models/order.dart';

// import '../../models/my_address.dart';

// Future<void> sendEmailWithPDF(String userEmail, File pdfBytes) async {
//   // Replace with your SMTP server configuration
//   final smtpServer = SmtpServer(
//     'smtp.gmail.com', // Replace with your SMTP host
//     port: 587, // Use 465 for SSL
//     username: 'trust.laundryy@gmail.com',
//     password:
//         await ApiKeyManager.decryptKey(g), // Use app password if 2FA is enabled
//   );

//   // Create email message
//   final message = Message()
//     ..from = const Address('trust.laundryy@gmail.com', 'Trust Laundry')
//     ..recipients.add(userEmail)
//     ..subject = 'Invoice for Your Order'
//     ..text = 'Attached is the invoice for your order.'
//     ..attachments = [
//       FileAttachment(pdfBytes, contentType: "pdf", fileName: "Invoice.pdf")
//         ..location = Location.inline
//         ..cid = '<myimg@3.141>'
//     ];

//   try {
//     await send(message, smtpServer);
//     print('Email sent successfully!');
//   } catch (e) {
//     print('Failed to send email: $e');
//   }
// }

// void sharePdf(File pdfFile) {
//   Share.shareXFiles([XFile(pdfFile.path)], text: 'Here is the order details.');
// }

// Future<void> handleOrderSharing(
//     UserOrder order, MyAddress address, AppUser user) async {
//   try {
//     // Generate the PDF
//     final pdfFile = await generatePdf(order, address, user);

//     // Share the PDF
//     sharePdf(pdfFile);
//   } catch (e) {
//     print('Error generating or sharing PDF: $e');
//   }
// }

// Future<void> handleDriverOrderSharing(request, AppUser user) async {
//   try {
//     // Generate the PDF
//     final pdfFile = await generateReqPdf(request, user);

//     // Share the PDF
//     sharePdf(pdfFile);
//   } catch (e) {
//     print('Error generating or sharing PDF: $e');
//   }
// }

// Future<File> generatePdf(
//     UserOrder order, MyAddress address, AppUser user) async {
//   final pdf = pw.Document();

//   // Load the image from assets
//   final ByteData data = await rootBundle.load("assets/images/logo_.png");
//   final Uint8List bytes = data.buffer.asUint8List();
//   final pw.MemoryImage logoImage = pw.MemoryImage(bytes);
//   pdf.addPage(
//     pw.Page(
//       build: (pw.Context context) {
//         return pw.Column(
//           crossAxisAlignment: pw.CrossAxisAlignment.start,
//           children: [
//             // Title Section
//             pw.Row(
//               mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
//               children: [
//                 pw.RichText(
//                   text: pw.TextSpan(
//                     text: 'Order Details\n\n',
//                     style: pw.TextStyle(
//                         fontSize: 20, fontWeight: pw.FontWeight.bold),
//                   ),
//                 ),
//                 pw.Image(logoImage, height: 120), // Adjust height as needed
//               ],
//             ),

//             pw.RichText(
//               text: pw.TextSpan(
//                 children: [
//                   pw.TextSpan(
//                     text: 'Order date & time: ',
//                     style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
//                   ),
//                   pw.TextSpan(text: '${order.timeStamp.toDate()}\n'),
//                   pw.TextSpan(
//                     text: 'Order ID: ',
//                     style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
//                   ),
//                   pw.TextSpan(text: '${order.id ?? 'N/A'}\n'),
//                   pw.TextSpan(
//                     text: 'User ID: ',
//                     style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
//                   ),
//                   pw.TextSpan(text: '${order.userId}\n'),
//                   pw.TextSpan(
//                     text: 'Email: ',
//                     style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
//                   ),
//                   pw.TextSpan(text: '${user.email}\n'),
//                   pw.TextSpan(
//                     text: 'Phone Number: ',
//                     style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
//                   ),
//                   pw.TextSpan(text: '+965${user.phoneNumber}\n'),
//                 ],
//               ),
//             ),
//             // Order Info Section

//             pw.SizedBox(height: 10),
//             // Status Section
//             pw.RichText(
//               text: pw.TextSpan(
//                 children: [
//                   pw.TextSpan(
//                     text: 'Order Status: ',
//                     style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
//                   ),
//                   pw.TextSpan(text: '${order.status}\n'),
//                   pw.TextSpan(
//                     text: 'Fast Delivery: ',
//                     style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
//                   ),
//                   pw.TextSpan(text: '${order.fast ? 'Yes' : 'No'}\n'),
//                   if (!order.fast)
//                     pw.TextSpan(
//                       text: 'Price: ',
//                       style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
//                     ),
//                   if (!order.fast)
//                     pw.TextSpan(text: '${order.price.toStringAsFixed(2)}KWD\n'),
//                 ],
//               ),
//             ),
//             if (order.fast)
//               pw.RichText(
//                 text: pw.TextSpan(
//                   children: [
//                     pw.TextSpan(
//                       text: 'Fast Price: ',
//                       style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
//                     ),
//                     pw.TextSpan(
//                       text: '${order.fastPrice.toStringAsFixed(2)}KWD\n',
//                     ),
//                   ],
//                 ),
//               ),
//             pw.SizedBox(height: 10),
//             // Dates Section
//             pw.RichText(
//               text: pw.TextSpan(
//                 children: [
//                   pw.TextSpan(
//                     text: 'Pickup Date and Time: ',
//                     style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
//                   ),
//                   pw.TextSpan(text: '${order.pickUpDateAndTime}\n'),
//                 ],
//               ),
//             ),
//             pw.SizedBox(height: 10),
//             // Payment Section
//             pw.RichText(
//               text: pw.TextSpan(
//                 children: [
//                   pw.TextSpan(
//                     text: 'Payed: ',
//                     style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
//                   ),
//                   pw.TextSpan(text: '${order.didPay ? 'YES' : "NO"}\n'),
//                   pw.TextSpan(
//                     text: 'Payment Method: ',
//                     style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
//                   ),
//                   pw.TextSpan(
//                       text:
//                           '${order.paymentMethod.toString().split('.').last}\n'),
//                 ],
//               ),
//             ),

//             pw.SizedBox(height: 10),
//             // Instructions Section
//             pw.RichText(
//               text: pw.TextSpan(
//                 children: [
//                   pw.TextSpan(
//                     text: 'Instructions: \n',
//                     style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
//                   ),
//                   pw.TextSpan(
//                       text:
//                           '${order.instructions.isNotEmpty ? order.instructions : 'None'}\n'),
//                 ],
//               ),
//             ),
//             pw.SizedBox(height: 20),
//             // Address Section
//             pw.RichText(
//               text: pw.TextSpan(
//                 text: 'Address Details\n',
//                 style:
//                     pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold),
//               ),
//             ),
//             pw.Text(
//               address.isExact
//                   ? 'Google Maps exact position link:'
//                   : 'Area: ${address.area}\nCity: ${address.city}\nBoulevard: ${address.boulevard}\nBuilding: ${address.building}\nApartment Number: ${address.apartmentNum}',
//               style: pw.TextStyle(),
//             ),
//             if (address.isExact)
//               pw.UrlLink(
//                 destination:
//                     'https://www.google.com/maps/dir/?api=1&destination=${address.lat},${address.lng}',
//                 child: pw.Text(
//                   'https://www.google.com/maps/dir/?api=1&destination=${address.lat},${address.lng}',
//                   style: const pw.TextStyle(
//                     color: PdfColors.blue, // Make the link blue
//                     decoration: pw.TextDecoration
//                         .underline, // Add underline for a link appearance
//                   ),
//                 ),
//               ),

//             pw.SizedBox(height: 20),
//             // Items Section
//             pw.Text(
//               'Ordered Items',
//               style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold),
//             ),
//             pw.SizedBox(height: 10),
//             pw.Column(
//               crossAxisAlignment: pw.CrossAxisAlignment.start,
//               children: order.subItems.map((item) {
//                 return pw.Text(
//                   '- ${item.titleEn} (Quantity: ${item.quantity}, Price: ${item.price.toStringAsFixed(2)}KWD, Service type: ${item.laundryTypeEn})',
//                   style: pw.TextStyle(fontSize: 12),
//                 );
//               }).toList(),
//             ),
//           ],
//         );
//       },
//     ),
//   );

//   final output = await getApplicationDocumentsDirectory();
//   final file = File("${output.path}/order_${order.id ?? 'unknown'}.pdf");
//   await file.writeAsBytes(await pdf.save());
//   return file;
// }

// Future<File> generateReqPdf(Request request, AppUser user) async {
//   final pdf = pw.Document();

//   // Load the image from assets
//   final ByteData data = await rootBundle.load("assets/images/logo_.png");
//   final Uint8List bytes = data.buffer.asUint8List();
//   final pw.MemoryImage logoImage = pw.MemoryImage(bytes);
//   pdf.addPage(
//     pw.Page(
//       build: (pw.Context context) {
//         return pw.Column(
//           crossAxisAlignment: pw.CrossAxisAlignment.start,
//           children: [
//             // Title Section
//             pw.Row(
//               mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
//               children: [
//                 pw.RichText(
//                   text: pw.TextSpan(
//                     text: 'Driver Request Details\n\n',
//                     style: pw.TextStyle(
//                         fontSize: 20, fontWeight: pw.FontWeight.bold),
//                   ),
//                 ),
//                 pw.Image(logoImage, height: 120), // Adjust height as needed
//               ],
//             ),

//             pw.RichText(
//               text: pw.TextSpan(
//                 children: [
//                   pw.TextSpan(
//                     text: 'Driver Request date & time: ',
//                     style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
//                   ),
//                   pw.TextSpan(text: '${request.timeStamp.toDate()}\n'),
//                   pw.TextSpan(
//                     text: 'Order ID: ',
//                     style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
//                   ),
//                   pw.TextSpan(text: '${request.id ?? 'N/A'}\n'),
//                   pw.TextSpan(
//                     text: 'User ID: ',
//                     style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
//                   ),
//                   pw.TextSpan(text: '${request.userId}\n'),
//                   pw.TextSpan(
//                     text: 'Email: ',
//                     style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
//                   ),
//                   pw.TextSpan(text: '${user.email}\n'),
//                   pw.TextSpan(
//                     text: 'Phone Number: ',
//                     style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
//                   ),
//                   pw.TextSpan(text: '+965${user.phoneNumber}\n'),
//                 ],
//               ),
//             ),
//             // Order Info Section

//             pw.SizedBox(height: 10),
//             // Status Section
//             pw.RichText(
//               text: pw.TextSpan(
//                 children: [
//                   pw.TextSpan(
//                     text: 'Driver Request Status: ',
//                     style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
//                   ),
//                   pw.TextSpan(text: '${request.status}\n'),
//                 ],
//               ),
//             ),
//             pw.SizedBox(height: 20),
//             // Address Section
//             pw.RichText(
//               text: pw.TextSpan(
//                 text: 'Address Details\n',
//                 style:
//                     pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold),
//               ),
//             ),
//             pw.Text(
//               request.address.isExact
//                   ? 'Google Maps directions link:'
//                   : 'Area: ${request.address.area}\nCity: ${request.address.city}\nBoulevard: ${request.address.boulevard}\nBuilding: ${request.address.building}\nApartment Number: ${request.address.apartmentNum}',
//               style: pw.TextStyle(),
//             ),
//             if (request.address.isExact)
//               pw.UrlLink(
//                 destination:
//                     'https://www.google.com/maps/dir/?api=1&destination=${request.address.lat},${request.address.lng}',
//                 child: pw.Text(
//                   'https://www.google.com/maps/dir/?api=1&destination=${request.address.lat},${request.address.lng}',
//                   style: const pw.TextStyle(
//                     color: PdfColors.blue,
//                     decoration: pw.TextDecoration.underline,
//                   ),
//                 ),
//               ),
//           ],
//         );
//       },
//     ),
//   );

//   final output = await getApplicationDocumentsDirectory();
//   final file = File("${output.path}/driver_request${request.id}.pdf");
//   await file.writeAsBytes(await pdf.save());
//   return file;
// }

// Future<File> generateSubPdf(MySub sub, AppUser user) async {
//   final pdf = pw.Document();

//   // Load the image from assets
//   final ByteData data = await rootBundle.load("assets/images/logo_.png");
//   final Uint8List bytes = data.buffer.asUint8List();
//   final pw.MemoryImage logoImage = pw.MemoryImage(bytes);
//   pdf.addPage(
//     pw.Page(
//       build: (pw.Context context) {
//         return pw.Column(
//           crossAxisAlignment: pw.CrossAxisAlignment.start,
//           children: [
//             // Title Section
//             pw.Row(
//               mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
//               children: [
//                 pw.RichText(
//                   text: pw.TextSpan(
//                     text: 'Subscription Details\n\n',
//                     style: pw.TextStyle(
//                         fontSize: 20, fontWeight: pw.FontWeight.bold),
//                   ),
//                 ),
//                 pw.Image(logoImage, height: 120), // Adjust height as needed
//               ],
//             ),

//             pw.RichText(
//               text: pw.TextSpan(
//                 children: [
//                   pw.TextSpan(
//                     text: 'Subscription date & time: ',
//                     style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
//                   ),
//                   pw.TextSpan(text: '${sub.timeStamp.toDate()}\n'),
//                   pw.TextSpan(
//                     text: 'Email: ',
//                     style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
//                   ),
//                   pw.TextSpan(text: '${user.email}\n'),
//                   pw.TextSpan(
//                     text: 'Phone Number: ',
//                     style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
//                   ),
//                   pw.TextSpan(text: '+965${user.phoneNumber}\n'),
//                   pw.TextSpan(
//                     text: 'Balance: ',
//                     style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
//                   ),
//                   pw.TextSpan(text: '${user.balance} KWD\n'),
//                 ],
//               ),
//             ),
//             // Order Info Section

//             pw.SizedBox(height: 10),
//             // Status Section
//             pw.RichText(
//               text: pw.TextSpan(
//                 children: [
//                   pw.TextSpan(
//                     text: 'You payed: ',
//                     style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
//                   ),
//                   pw.TextSpan(text: '${sub.pay} KWD\n'),
//                 ],
//               ),
//             ),
//             pw.RichText(
//               text: pw.TextSpan(
//                 children: [
//                   pw.TextSpan(
//                     text: 'You got: ',
//                     style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
//                   ),
//                   pw.TextSpan(text: '${sub.get} KWD\n'),
//                 ],
//               ),
//             ),
//           ],
//         );
//       },
//     ),
//   );

//   final output = await getApplicationDocumentsDirectory();
//   final file = File("${output.path}/subscription${user.phoneNumber}.pdf");
//   await file.writeAsBytes(await pdf.save());
//   return file;
// }
