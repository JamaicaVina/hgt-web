// import 'dart:typed_data';
// import 'dart:html' as html;
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_spinkit/flutter_spinkit.dart';
// import 'package:get/get.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:intl/intl.dart';
// import 'package:my_app/consts/consts.dart';
// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import 'package:pdf/pdf.dart';
// import 'package:pdf/widgets.dart' as pw;

// class ConfirmedPage extends StatefulWidget {
//   const ConfirmedPage({super.key});

//   @override
//   State<ConfirmedPage> createState() => _ConfirmedPageState();
// }

// class _ConfirmedPageState extends State<ConfirmedPage> {
//   bool orderConfirmed = true;
//   final db = FirebaseFirestore.instance;

//   Future<pw.Document> generatePDF(
//       List<dynamic> orderData, var totalAmount) async {
//     final pdf = pw.Document();
//     final ByteData image = await rootBundle.load('assets/images/hgt_logo.png');

//     Uint8List imageData = (image).buffer.asUint8List();
//     var myTheme = pw.ThemeData.withFont(
//       base: pw.Font.ttf(await rootBundle.load("assets/fonts/sans_regular.ttf")),
//     );

//     // Add a page to the PDF
//     pdf.addPage(
//       pw.Page(
//         theme: myTheme,
//         pageFormat: PdfPageFormat.a4,
//         build: (context) {
//           return pw.Center(
//             child: pw.Column(
//               children: [
//                 pw.Column(
//                   mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
//                   children: [
//                     pw.Container(
//                       child: pw.Row(
//                         mainAxisAlignment: pw.MainAxisAlignment.spaceEvenly,
//                         children: [
//                           pw.Container(
//                             width: 80,
//                             height: 80,
//                             child: pw.Image(pw.MemoryImage(imageData),
//                                 fit: pw.BoxFit.contain),
//                           ),
//                           pw.Column(children: [
//                             pw.Row(children: [
//                               pw.Text(
//                                 "Harry Guantero Trading".toUpperCase(),
//                               ),
//                             ]),
//                             pw.Row(children: [
//                               pw.Text(
//                                 'M. Revil St. Corner Barrientos St.',
//                               ),
//                             ]),
//                             pw.Row(children: [
//                               pw.Text(
//                                   'Poblacion 2, Oroquieta City Misamis Occidental, Philippines'),
//                             ])
//                           ]),
//                         ],
//                       ),
//                     ),
//                     pw.SizedBox(
//                       height: 20,
//                     ),
//                     pw.Container(
//                       child: pw.Expanded(
//                         child: pw.Row(
//                           children: [
//                             pw.Expanded(
//                               flex: 3,
//                               child: pw.Container(
//                                 child: pw.Text(
//                                   'PRODUCTS',
//                                 ),
//                               ),
//                             ),
//                             pw.VerticalDivider(),
//                             pw.Expanded(
//                               flex: 1,
//                               child: pw.Container(
//                                 child: pw.Text(
//                                   'QUANTITY',
//                                 ),
//                               ),
//                             ),
//                             pw.VerticalDivider(),
//                             pw.Expanded(
//                               flex: 1,
//                               child: pw.Container(
//                                 child: pw.Text(
//                                   'PRICE',
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                     pw.Divider(),
//                     pw.ListView.separated(
//                       separatorBuilder: (context, index) => pw.Divider(),
//                       itemCount: orderData.length,
//                       itemBuilder: (context, arrayIndex) {
//                         return pw.Center(
//                           child: pw.Container(
//                             child: pw.Expanded(
//                               child: pw.Row(
//                                 children: [
//                                   pw.Expanded(
//                                     flex: 3,
//                                     child: pw.Container(
//                                       child: pw.Text(
//                                         '${orderData[arrayIndex]['title']}',
//                                       ),
//                                     ),
//                                   ),
//                                   pw.Expanded(
//                                     flex: 1,
//                                     child: pw.Container(
//                                       child: pw.Text(
//                                         '${orderData[arrayIndex]['qty']}',
//                                       ),
//                                     ),
//                                   ),
//                                   pw.Expanded(
//                                     flex: 1,
//                                     child: pw.Container(
//                                       child: pw.Text(
//                                         '${orderData[arrayIndex]['tprice']} PHP',
//                                       ),
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ),
//                         );
//                       },
//                     ),
//                     pw.Divider(),
//                     pw.SizedBox(height: 10),
//                     pw.Container(
//                       child: pw.Expanded(
//                         child: pw.Row(
//                           children: [
//                             pw.Expanded(
//                               flex: 3,
//                               child: pw.Container(),
//                             ),
//                             pw.Expanded(
//                               flex: 1,
//                               child: pw.Container(
//                                 child: pw.Text('Total Amount:'),
//                               ),
//                             ),
//                             pw.Expanded(
//                               flex: 1,
//                               child: pw.Container(
//                                 child: pw.Text('$totalAmount PHP'),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           );
//         },
//       ),
//     );

//     return pdf;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SizedBox(
//         height: MediaQuery.of(context).size.height,
//         child: Card(
//           color: const Color.fromARGB(255, 4, 83, 158),
//           child: Column(
//             children: [
//               Text(
//                 "Confirmed Orders".toUpperCase(),
//                 style: GoogleFonts.anton(
//                   fontSize: 30,
//                   letterSpacing: 5,
//                   wordSpacing: 4,
//                   color: const Color.fromARGB(255, 254, 240, 2),
//                 ),
//               ),
//               Expanded(
//                 child: Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: StreamBuilder<QuerySnapshot>(
//                     stream: FirebaseFirestore.instance
//                         .collection('orders')
//                         .where('order_confirmed', isEqualTo: true)
//                         .orderBy('order_date', descending: true)
//                         .snapshots(),
//                     builder: (context, snapshot) {
//                       if (snapshot.hasError) {
//                         return Text('Error: ${snapshot.error}');
//                       }

//                       if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
//                         return const Row(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             Card(child: Text('No data available')),
//                           ],
//                         );
//                       }

//                       List<QueryDocumentSnapshot> documents =
//                           snapshot.data!.docs;
//                       return ListView.separated(
//                         separatorBuilder: (context, index) {
//                           return const Divider();
//                         },
//                         shrinkWrap: true,
//                         itemCount: documents.length,
//                         itemBuilder: (context, index) {
//                           var documentData =
//                               documents[index].data() as Map<String, dynamic>;
//                           var arrayData = documentData['orders'] as List<
//                               dynamic>; // Replace 'array_field' with your array field name.

//                           // Process the array data if needed.
//                           var totalAmount = NumberFormat.simpleCurrency(
//                             locale: 'fil_PH',
//                             decimalDigits: 2,
//                           ).format(
//                             documentData['total_amount'],
//                           );
//                           String userID = documentData['order_by'];
//                           var userToken = '';

//                           var totalAmForPDF = '${documentData['total_amount']}';

//                           var token = FirebaseFirestore.instance
//                               .collection('users')
//                               .doc(userID)
//                               .get()
//                               .then((value) {
//                             userToken = value['user-token'];
//                           });

//                           return SizedBox(
//                             child: Card(
//                               child: GestureDetector(
//                                 onTap: () {
//                                   showDialog(
//                                     context: context,
//                                     builder: (BuildContext context) {
//                                       return Dialog(
//                                         child: SizedBox(
//                                           width: MediaQuery.of(context)
//                                                   .size
//                                                   .width /
//                                               2,
//                                           child: Card(
//                                             color: const Color.fromARGB(
//                                                 255, 4, 83, 158),
//                                             child: Padding(
//                                               padding:
//                                                   const EdgeInsets.all(8.0),
//                                               child: Row(
//                                                 mainAxisAlignment:
//                                                     MainAxisAlignment.center,
//                                                 children: [
//                                                   Expanded(
//                                                     child: Column(
//                                                       mainAxisAlignment:
//                                                           MainAxisAlignment
//                                                               .center,
//                                                       children: [
//                                                         Row(
//                                                           children: [
//                                                             Expanded(
//                                                               child: SizedBox(
//                                                                 child: Padding(
//                                                                   padding:
//                                                                       const EdgeInsets
//                                                                           .all(
//                                                                           8.0),
//                                                                   child: Column(
//                                                                     crossAxisAlignment:
//                                                                         CrossAxisAlignment
//                                                                             .start,
//                                                                     mainAxisAlignment:
//                                                                         MainAxisAlignment
//                                                                             .spaceEvenly,
//                                                                     children: [
//                                                                       Text(
//                                                                         'USER ID: ${documentData['order_by']}',
//                                                                         style: GoogleFonts
//                                                                             .roboto(
//                                                                           color: const Color
//                                                                               .fromARGB(
//                                                                               255,
//                                                                               252,
//                                                                               255,
//                                                                               58),
//                                                                           letterSpacing:
//                                                                               3,
//                                                                         ),
//                                                                       ),
//                                                                       const Divider(),
//                                                                       Text(
//                                                                         'USER FULLNAME: ${documentData['order_by_name']}',
//                                                                         style: GoogleFonts
//                                                                             .roboto(
//                                                                           color: const Color
//                                                                               .fromARGB(
//                                                                               255,
//                                                                               252,
//                                                                               255,
//                                                                               58),
//                                                                           letterSpacing:
//                                                                               3,
//                                                                         ),
//                                                                       ),
//                                                                       const Divider(),
//                                                                       Text(
//                                                                         'EMAIL: ${documentData['order_by_email']}',
//                                                                         style: GoogleFonts
//                                                                             .roboto(
//                                                                           color: const Color
//                                                                               .fromARGB(
//                                                                               255,
//                                                                               252,
//                                                                               255,
//                                                                               58),
//                                                                           letterSpacing:
//                                                                               3,
//                                                                         ),
//                                                                       ),
//                                                                       const Divider(),
//                                                                       Text(
//                                                                         'BARANGAY: ${documentData['order_by_address']}',
//                                                                         style: GoogleFonts
//                                                                             .roboto(
//                                                                           color: const Color
//                                                                               .fromARGB(
//                                                                               255,
//                                                                               252,
//                                                                               255,
//                                                                               58),
//                                                                           letterSpacing:
//                                                                               3,
//                                                                         ),
//                                                                       ),
//                                                                       const Divider(),
//                                                                        Text(
//                                                                         'STREET NAME / PUROK: ${documentData['order_by_purok']}',
//                                                                         style: GoogleFonts
//                                                                             .roboto(
//                                                                           color: const Color
//                                                                               .fromARGB(
//                                                                               255,
//                                                                               252,
//                                                                               255,
//                                                                               58),
//                                                                           letterSpacing:
//                                                                               3,
//                                                                         ),
//                                                                       ),
//                                                                       const Divider(),
//                                                                        Text(
//                                                                         'LANDMARK: ${documentData['order_by_landmark']}',
//                                                                         style: GoogleFonts
//                                                                             .roboto(
//                                                                           color: const Color
//                                                                               .fromARGB(
//                                                                               255,
//                                                                               252,
//                                                                               255,
//                                                                               58),
//                                                                           letterSpacing:
//                                                                               3,
//                                                                         ),
//                                                                       ),
//                                                                       const Divider(),
//                                                                       Text(
//                                                                         'CONTACT NUMBER: ${documentData['order_by_phone']}',
//                                                                         style: GoogleFonts
//                                                                             .roboto(
//                                                                           color: const Color
//                                                                               .fromARGB(
//                                                                               255,
//                                                                               252,
//                                                                               255,
//                                                                               58),
//                                                                           letterSpacing:
//                                                                               3,
//                                                                         ),
//                                                                       ),
//                                                                       const Divider(),
//                                                                       Text(
//                                                                         'ORDER(S): ',
//                                                                         style: GoogleFonts
//                                                                             .roboto(
//                                                                           color: const Color
//                                                                               .fromARGB(
//                                                                               255,
//                                                                               252,
//                                                                               255,
//                                                                               58),
//                                                                           letterSpacing:
//                                                                               3,
//                                                                         ),
//                                                                       ),
//                                                                       SizedBox(
//                                                                         height:
//                                                                             200,
//                                                                         child:
//                                                                             Card(
//                                                                           child:
//                                                                               ListView.separated(
//                                                                             separatorBuilder:
//                                                                                 (context, index) {
//                                                                               return const Divider();
//                                                                             },
//                                                                             shrinkWrap:
//                                                                                 true,
//                                                                             itemCount:
//                                                                                 arrayData.length,
//                                                                             itemBuilder:
//                                                                                 (context, arrayIndex) {
//                                                                               var arrayElement = arrayData[arrayIndex].toString();
//                                                                               return ListTile(
//                                                                                 leading: SizedBox(
//                                                                                   height: 100,
//                                                                                   width: 100,
//                                                                                   child: Image.network(
//                                                                                     arrayData[arrayIndex]['img'],
//                                                                                   ),
//                                                                                 ),
//                                                                                 dense: true,
//                                                                                 title: Text(
//                                                                                   'Product: ${arrayData[arrayIndex]['title']}\nQuantity: ${arrayData[arrayIndex]['qty']}',
//                                                                                   style: GoogleFonts.roboto(
//                                                                                     color: const Color.fromARGB(255, 4, 83, 158),
//                                                                                     letterSpacing: 3,
//                                                                                   ),
//                                                                                 ),
//                                                                               );
//                                                                             },
//                                                                           ),
//                                                                         ),
//                                                                       ),
//                                                                       const Divider(),
//                                                                       Text(
//                                                                         'PAYMENT METHOD: ${documentData['payment_method']}',
//                                                                         style: GoogleFonts
//                                                                             .roboto(
//                                                                           color: const Color
//                                                                               .fromARGB(
//                                                                               255,
//                                                                               252,
//                                                                               255,
//                                                                               58),
//                                                                           letterSpacing:
//                                                                               3,
//                                                                         ),
//                                                                       ),
//                                                                       const Divider(),
//                                                                       documentData['order_confirmed'] = true
//                                                                           ? Text(
//                                                                               'STATUS: Order Confirmed',
//                                                                               style: GoogleFonts.roboto(
//                                                                                 color: const Color.fromARGB(255, 252, 255, 58),
//                                                                                 letterSpacing: 3,
//                                                                               ),
//                                                                             )
//                                                                           : Container(),
//                                                                     ],
//                                                                   ),
//                                                                 ),
//                                                               ),
//                                                             ),
//                                                           ],
//                                                         ),
//                                                         const Divider(),



//                                                         Container(
//                                                           child: Center(
//                                                             child: Row(
//                                                               children: <Widget> [



//                                                                 ElevatedButton(
//                                                                   style:
//                                                                       const ButtonStyle(
//                                                                     backgroundColor:
//                                                                         MaterialStatePropertyAll(
//                                                                       Color.fromARGB(
//                                                                           255,
//                                                                           252,
//                                                                           255,
//                                                                           58),
//                                                                     ),
//                                                                   ),
//                                                                   onPressed: () async {
                                                                  
                                                          
//                                                                     final pdf =
//                                                                         await generatePDF(
//                                                                       arrayData,
//                                                                       totalAmForPDF,
//                                                                     );
                                                          
//                                                                     final pdfBytes =
//                                                                         await pdf
//                                                                             .save();
                                                          
//                                                                     final blob =
//                                                                         html.Blob([
//                                                                       Uint8List
//                                                                           .fromList(
//                                                                               pdfBytes)
//                                                                     ]);
//                                                                     final url = html.Url
//                                                                         .createObjectUrlFromBlob(
//                                                                             blob);
                                                          
//                                                                     final anchor = html
//                                                                         .AnchorElement(
//                                                                             href: url)
//                                                                       ..target =
//                                                                           'webdownload'
//                                                                       ..download =
//                                                                           '${documentData['order_by_name']}_orders.pdf'
//                                                                       ..text =
//                                                                           'Download PDF';
                                                          
//                                                                     anchor.click();
                                                          
//                                                                     html.Url
//                                                                         .revokeObjectUrl(
//                                                                             url);
//                                                                   },
//                                                                   child: Text(
//                                                                     'Export Data',
//                                                                     style: GoogleFonts
//                                                                         .roboto(
//                                                                       fontWeight:
//                                                                           FontWeight
//                                                                               .bold,
//                                                                       color: const Color
//                                                                           .fromARGB(255,
//                                                                           4, 83, 158),
//                                                                     ),
//                                                                   ),
//                                                                 ),



//                                                                 ElevatedButton(
//                                                                   style:
//                                                                       const ButtonStyle(
//                                                                     backgroundColor:
//                                                                         MaterialStatePropertyAll(
//                                                                       Color.fromARGB(
//                                                                           255,
//                                                                           252,
//                                                                           255,
//                                                                           58),
//                                                                     ),
//                                                                   ),
//                                                                   onPressed: () async {
//                                                                     await FirebaseFirestore
//                                                                         .instance
//                                                                         .collection(
//                                                                             'orders')
//                                                                         .doc(documents[
//                                                                                 index]
//                                                                             .reference
//                                                                             .id)
//                                                                         .update({
//                                                                       'order_on_delivery':
//                                                                           true,
//                                                                       'order_confirmed':
//                                                                           false,
//                                                                     }).then((value) =>
//                                                                             Navigator.pop(
//                                                                                 context));
//                                                                     try {
//                                                                       await http.post(
//                                                                         Uri.parse(
//                                                                             'https://fcm.googleapis.com/fcm/send'),
//                                                                         headers: <String,
//                                                                             String>{
//                                                                           'Content-Type':
//                                                                               'application/json',
//                                                                           'Authorization':
//                                                                               'key=AAAAS7YKmU4:APA91bEOW9oLuqFcaMPlElfBxx6VniXOG7VoIjtLY6xXkX-Zc6pYd4rNzFwaxen-0WKr-i9dgeEjSju13yFxMDxg8sX3cFk1kv3wQ6ceeNfmZdLon-StvqrwYdu0BNBV5qroS02yIFxX',
//                                                                         },
//                                                                         body:
//                                                                             jsonEncode(
//                                                                           <String,
//                                                                               dynamic>{
//                                                                             'notification':
//                                                                                 <String,
//                                                                                     dynamic>{
//                                                                               'body':
//                                                                                   'Your Order: ${documentData['order_code']} is on its way!',
//                                                                             },
//                                                                             'priority':
//                                                                                 'high',
//                                                                             'data': <String,
//                                                                                 dynamic>{
//                                                                               'click_action':
//                                                                                   'FLUTTER_NOTIFICATION_CLICK',
//                                                                               'id': '1',
//                                                                               'status':
//                                                                                   'done'
//                                                                             },
//                                                                             "to":
//                                                                                 userToken
//                                                                           },
//                                                                         ),
//                                                                       );
//                                                                       print('done');
//                                                                     } catch (e) {
//                                                                       print(
//                                                                           "error push notification");
//                                                                     }
                                                          
//                                                                   },
//                                                                   child: Text(
//                                                                     'Deliver Order',
//                                                                     style: GoogleFonts
//                                                                         .roboto(
//                                                                       fontWeight:
//                                                                           FontWeight
//                                                                               .bold,
//                                                                       color: const Color
//                                                                           .fromARGB(255,
//                                                                           4, 83, 158),
//                                                                     ),
//                                                                   ),
//                                                                 ),



//                                                               ],
//                                                             ),
//                                                           ),
//                                                         ),
//                                                       ],
//                                                     ),
//                                                   ),
//                                                 ],
//                                               ),
//                                             ),
//                                           ),
//                                         ),
//                                       );
//                                     },
//                                   );
//                                 },
//                                 child: ListTile(
//                                   dense: true,
//                                   title: Text(
//                                     'Order Code: ${documentData['order_code']}',
//                                     style: const TextStyle(
//                                         fontWeight: FontWeight.bold),
//                                   ),
//                                   trailing: TextButton(
//                                     onPressed: () {
//                                       showDialog(
//                                         context: context,
//                                         builder: (BuildContext context) {
//                                           return Dialog(
//                                             child: SizedBox(
//                                               width: MediaQuery.of(context)
//                                                       .size
//                                                       .width /
//                                                   2,
//                                               child: Card(
//                                                 color: const Color.fromARGB(
//                                                     255, 4, 83, 158),
//                                                 child: Padding(
//                                                   padding:
//                                                       const EdgeInsets.all(8.0),
//                                                   child: Row(
//                                                     mainAxisAlignment:
//                                                         MainAxisAlignment
//                                                             .center,
//                                                     children: [
//                                                       Expanded(
//                                                         child: Column(
//                                                           mainAxisAlignment:
//                                                               MainAxisAlignment
//                                                                   .center,
//                                                           children: [
//                                                             Row(
//                                                               children: [
//                                                                 Expanded(
//                                                                   child:
//                                                                       SizedBox(
//                                                                     child:
//                                                                         Padding(
//                                                                       padding: const EdgeInsets
//                                                                           .all(
//                                                                           8.0),
//                                                                       child:
//                                                                           Column(
//                                                                         crossAxisAlignment:
//                                                                             CrossAxisAlignment.start,
//                                                                         mainAxisAlignment:
//                                                                             MainAxisAlignment.spaceEvenly,
//                                                                         children: [
//                                                                           Text(
//                                                                             'USER ID: ${documentData['order_by']}',
//                                                                             style:
//                                                                                 GoogleFonts.roboto(
//                                                                               color: const Color.fromARGB(255, 252, 255, 58),
//                                                                               letterSpacing: 3,
//                                                                             ),
//                                                                           ),
//                                                                           const Divider(),
//                                                                           Text(
//                                                                             'USER FULLNAME: ${documentData['order_by_name']}',
//                                                                             style:
//                                                                                 GoogleFonts.roboto(
//                                                                               color: const Color.fromARGB(255, 252, 255, 58),
//                                                                               letterSpacing: 3,
//                                                                             ),
//                                                                           ),
//                                                                           const Divider(),
//                                                                           Text(
//                                                                             'EMAIL: ${documentData['order_by_email']}',
//                                                                             style:
//                                                                                 GoogleFonts.roboto(
//                                                                               color: const Color.fromARGB(255, 252, 255, 58),
//                                                                               letterSpacing: 3,
//                                                                             ),
//                                                                           ),
//                                                                           const Divider(),
//                                                                           Text(
//                                                                             'ADDRESS: ${documentData['order_by_address']}',
//                                                                             style:
//                                                                                 GoogleFonts.roboto(
//                                                                               color: const Color.fromARGB(255, 252, 255, 58),
//                                                                               letterSpacing: 3,
//                                                                             ),
//                                                                           ),
//                                                                           const Divider(),
//                                                                           Text(
//                                                                             'CONTACT NUMBER: ${documentData['order_by_phone']}',
//                                                                             style:
//                                                                                 GoogleFonts.roboto(
//                                                                               color: const Color.fromARGB(255, 252, 255, 58),
//                                                                               letterSpacing: 3,
//                                                                             ),
//                                                                           ),
//                                                                           const Divider(),
//                                                                           Text(
//                                                                             'ORDER(S): ',
//                                                                             style:
//                                                                                 GoogleFonts.roboto(
//                                                                               color: const Color.fromARGB(255, 252, 255, 58),
//                                                                               letterSpacing: 3,
//                                                                             ),
//                                                                           ),
//                                                                           SizedBox(
//                                                                             height:
//                                                                                 200,
//                                                                             child:
//                                                                                 Card(
//                                                                               child: ListView.separated(
//                                                                                 separatorBuilder: (context, index) {
//                                                                                   return const Divider();
//                                                                                 },
//                                                                                 shrinkWrap: true,
//                                                                                 itemCount: arrayData.length,
//                                                                                 itemBuilder: (context, arrayIndex) {
//                                                                                   var arrayElement = arrayData[arrayIndex].toString();
//                                                                                   return ListTile(
//                                                                                     leading: SizedBox(
//                                                                                       height: 100,
//                                                                                       width: 100,
//                                                                                       child: Image.network(
//                                                                                         arrayData[arrayIndex]['img'],
//                                                                                       ),
//                                                                                     ),
//                                                                                     dense: true,
//                                                                                     title: Text(
//                                                                                       'Product: ${arrayData[arrayIndex]['title']}\nQuantity: ${arrayData[arrayIndex]['qty']}',
//                                                                                       style: GoogleFonts.roboto(
//                                                                                         color: const Color.fromARGB(255, 4, 83, 158),
//                                                                                         letterSpacing: 3,
//                                                                                       ),
//                                                                                     ),
//                                                                                   );
//                                                                                 },
//                                                                               ),
//                                                                             ),
//                                                                           ),
//                                                                           const Divider(),
//                                                                           Text(
//                                                                             'PAYMENT METHOD: ${documentData['payment_method']}',
//                                                                             style:
//                                                                                 GoogleFonts.roboto(
//                                                                               color: const Color.fromARGB(255, 252, 255, 58),
//                                                                               letterSpacing: 3,
//                                                                             ),
//                                                                           ),
//                                                                           const Divider(),
//                                                                           documentData['order_confirmed'] = true
//                                                                               ? Text(
//                                                                                   'STATUS: Order Confirmed',
//                                                                                   style: GoogleFonts.roboto(
//                                                                                     color: const Color.fromARGB(255, 252, 255, 58),
//                                                                                     letterSpacing: 3,
//                                                                                   ),
//                                                                                 )
//                                                                               : Container(),
//                                                                         ],
//                                                                       ),
//                                                                     ),
//                                                                   ),
//                                                                 ),
//                                                               ],
//                                                             ),
//                                                             const Divider(),
//                                                             ElevatedButton(
//                                                               style:
//                                                                   const ButtonStyle(
//                                                                 backgroundColor:
//                                                                     MaterialStatePropertyAll(
//                                                                   Color
//                                                                       .fromARGB(
//                                                                           255,
//                                                                           252,
//                                                                           255,
//                                                                           58),
//                                                                 ),
//                                                               ),
//                                                               onPressed:
//                                                                   () async {
//                                                                 await FirebaseFirestore
//                                                                     .instance
//                                                                     .collection(
//                                                                         'orders')
//                                                                     .doc(documents[
//                                                                             index]
//                                                                         .reference
//                                                                         .id)
//                                                                     .update({
//                                                                   'order_on_delivery':
//                                                                       true,
//                                                                   'order_confirmed':
//                                                                       false,
//                                                                 }).then((value) =>
//                                                                         Navigator.pop(
//                                                                             context));
//                                                                 try {
//                                                                   await http
//                                                                       .post(
//                                                                     Uri.parse(
//                                                                         'https://fcm.googleapis.com/fcm/send'),
//                                                                     headers: <String,
//                                                                         String>{
//                                                                       'Content-Type':
//                                                                           'application/json',
//                                                                       'Authorization':
//                                                                           'key=AAAAS7YKmU4:APA91bEOW9oLuqFcaMPlElfBxx6VniXOG7VoIjtLY6xXkX-Zc6pYd4rNzFwaxen-0WKr-i9dgeEjSju13yFxMDxg8sX3cFk1kv3wQ6ceeNfmZdLon-StvqrwYdu0BNBV5qroS02yIFxX',
//                                                                     },
//                                                                     body:
//                                                                         jsonEncode(
//                                                                       <String,
//                                                                           dynamic>{
//                                                                         'notification':
//                                                                             <String,
//                                                                                 dynamic>{
//                                                                           'body':
//                                                                               'Your Order: ${documentData['order_code']} is on its way!',
//                                                                         },
//                                                                         'priority':
//                                                                             'high',
//                                                                         'data': <String,
//                                                                             dynamic>{
//                                                                           'click_action':
//                                                                               'FLUTTER_NOTIFICATION_CLICK',
//                                                                           'id':
//                                                                               '1',
//                                                                           'status':
//                                                                               'done'
//                                                                         },
//                                                                         "to":
//                                                                             userToken
//                                                                       },
//                                                                     ),
//                                                                   );
//                                                                   print('done');
//                                                                 } catch (e) {
//                                                                   print(
//                                                                       "error push notification");
//                                                                 }

//                                                                 final pdf =
//                                                                     await generatePDF(
//                                                                   arrayData,
//                                                                   totalAmForPDF,
//                                                                 );

//                                                                 final pdfBytes =
//                                                                     await pdf
//                                                                         .save();

//                                                                 final blob =
//                                                                     html.Blob([
//                                                                   Uint8List
//                                                                       .fromList(
//                                                                           pdfBytes)
//                                                                 ]);
//                                                                 final url = html
//                                                                         .Url
//                                                                     .createObjectUrlFromBlob(
//                                                                         blob);

//                                                                 final anchor = html
//                                                                     .AnchorElement(
//                                                                         href:
//                                                                             url)
//                                                                   ..target =
//                                                                       'webdownload'
//                                                                   ..download =
//                                                                       '${documentData['order_by_name']}_orders.pdf'
//                                                                   ..text =
//                                                                       'Download PDF';

//                                                                 anchor.click();

//                                                                 html.Url
//                                                                     .revokeObjectUrl(
//                                                                         url);
//                                                               },
//                                                               child: Text(
//                                                                 'Export Data to PDF & Deliver Order',
//                                                                 style:
//                                                                     GoogleFonts
//                                                                         .roboto(
//                                                                   fontWeight:
//                                                                       FontWeight
//                                                                           .bold,
//                                                                   color: const Color
//                                                                       .fromARGB(
//                                                                       255,
//                                                                       4,
//                                                                       83,
//                                                                       158),
//                                                                 ),
//                                                               ),
//                                                             ),
//                                                           ],
//                                                         ),
//                                                       ),
//                                                     ],
//                                                   ),
//                                                 ),
//                                               ),
//                                             ),
//                                           );
//                                         },
//                                       );
//                                     },
//                                     child: const Text('Details'),
//                                   ),
//                                   subtitle: Text(
//                                     '${documentData['order_by_name']}\nTotal Amount: $totalAmount',
//                                     style: const TextStyle(
//                                         fontWeight: FontWeight.bold),
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           );
//                         },
//                       );
//                     },
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
import 'dart:typed_data';
import 'dart:html' as html;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:my_app/consts/consts.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class ConfirmedPage extends StatefulWidget {
  const ConfirmedPage({super.key});

  @override
  State<ConfirmedPage> createState() => _ConfirmedPageState();
}

class _ConfirmedPageState extends State<ConfirmedPage> {
  bool orderConfirmed = true;
  final db = FirebaseFirestore.instance;

  Future<pw.Document> generatePDF(List<dynamic> orderData, var totalAmount,



      Map<String, dynamic> userData) async {
    final pdf = pw.Document();
    final ByteData image = await rootBundle.load('assets/images/hgt_logo.png');

    Uint8List imageData = (image).buffer.asUint8List();
    var myTheme = pw.ThemeData.withFont(
      base: pw.Font.ttf(await rootBundle.load("assets/fonts/sans_regular.ttf")),
    );

    // Add a page to the PDF
    pdf.addPage(
      pw.Page(
        theme: myTheme,
        pageFormat: PdfPageFormat.a4,
        build: (context) {
          return pw.Center(
            child: pw.Column(
              children: [
                pw.Column(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Container(
                      child: pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.spaceEvenly,
                        children: [
                          pw.Container(
                            width: 80,
                            height: 80,
                            child: pw.Image(pw.MemoryImage(imageData),
                                fit: pw.BoxFit.contain),
                          ),
                          pw.Column(children: [
                            pw.Row(children: [
                              pw.Text(
                                "Harry Guantero Trading".toUpperCase(),
                              ),
                            ]),
                            pw.Row(children: [
                              pw.Text(
                                'M. Revil St. Corner Barrientos St.',
                              ),
                            ]),
                            pw.Row(children: [
                              pw.Text(
                                  'Poblacion 2, Oroquieta City Misamis Occidental, Philippines'),
                            ])
                          ]),
                        ],
                      ),
                    ),
                    pw.SizedBox(
                      height: 20,
                    ),
                    pw.Container(
                      child: pw.Expanded(
                        child: pw.Row(
                          mainAxisAlignment: pw.MainAxisAlignment.spaceEvenly,
                          children: [
                            pw.Expanded(
                              flex: 1,
                              child: pw.Container(
                                child: pw.Text(
                                    'Full Name: ${userData['order_by_name']}'),
                              ),
                            ),
                            pw.Expanded(
                              flex: 1,
                              child: pw.Container(
                                child: pw.Text(
                                    'Address: ${userData['order_by_address']}'),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                     pw.Container(
                        child: pw.Expanded(
                        child: pw.Row(
                          mainAxisAlignment: pw.MainAxisAlignment.spaceEvenly,
                          children: [
                            pw.Expanded(
                              flex: 1,
                              child: pw.Container(
                                child: pw.Text(
                                   'Contact Number: ${userData['order_by_phone']}'),
                                  ),
                            ),
                            pw.Expanded(
                              flex: 1,
                              child: pw.Container(
                                child: pw.Text(
                                    'Street Name/Purok: ${userData['order_by_purok']}'),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                      pw.Container(
                        child: pw.Expanded(
                        child: pw.Row(
                          mainAxisAlignment: pw.MainAxisAlignment.spaceEvenly,
                          children: [
                            pw.Expanded(
                              flex: 1,
                              child: pw.Container(
                                child: pw.Text(
                                  'Payment Method: ${userData['payment_method']}'),
                                  ),
                            ),
                            pw.Expanded(
                              flex: 1,
                              child: pw.Container(
                                child: pw.Text(
                                    'Landmark: ${userData['order_by_landmark']}'),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    pw.SizedBox(height: 15),
                    pw.Container(
                      child: pw.Expanded(
                        child: pw.Row(
                          children: [
                            pw.Expanded(
                              flex: 3,
                              child: pw.Container(
                                child: pw.Text(
                                  'PRODUCTS',
                                ),
                              ),
                            ),
                            pw.VerticalDivider(),
                            pw.Expanded(
                              flex: 1,
                              child: pw.Container(
                                child: pw.Text(
                                  'QUANTITY',
                                ),
                              ),
                            ),
                            pw.VerticalDivider(),
                            pw.Expanded(
                              flex: 1,
                              child: pw.Container(
                                child: pw.Text(
                                  'PRICE',
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    pw.Divider(),
                    pw.ListView.separated(
                      separatorBuilder: (context, index) => pw.Divider(),
                      itemCount: orderData.length,
                      itemBuilder: (context, arrayIndex) {
                        return pw.Center(
                          child: pw.Container(
                            child: pw.Expanded(
                              child: pw.Row(
                                children: [
                                  pw.Expanded(
                                    flex: 3,
                                    child: pw.Container(
                                      child: pw.Text(
                                        '${orderData[arrayIndex]['title']}',
                                      ),
                                    ),
                                  ),
                                  pw.Expanded(
                                    flex: 1,
                                    child: pw.Container(
                                      child: pw.Text(
                                        '${orderData[arrayIndex]['qty']}',
                                      ),
                                    ),
                                  ),
                                  
                                  pw.Expanded(
                                    flex: 1,
                                    child: pw.Container(
                                      child: pw.Text(
                                        '${orderData[arrayIndex]['tprice']}'.numCurrency + ' PHP',
                                        // '${orderData[arrayIndex]['tprice']} PHP',
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                    pw.Divider(),
                    pw.SizedBox(height: 10),
                    pw.Container(
                      child: pw.Expanded(
                        child: pw.Row(
                          children: [
                            pw.Expanded(
                              flex: 3,
                              child: pw.Container(),
                            ),
                            pw.Expanded(
                              flex: 1,
                              child: pw.Container(
                                child: pw.Text('Total Amount:'),
                              ),
                            ),
                            pw.Expanded(
                              flex: 1,
                              child: pw.Container(
                                child: pw.Text('$totalAmount'.numCurrency + ' PHP'),
                                // child: pw.Text('$totalAmount PHP'),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );

    return pdf;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        child: Card(
          color: const Color.fromARGB(255, 4, 83, 158),
          child: Column(
            children: [
              Text(
                "Confirmed Orders".toUpperCase(),
                style: GoogleFonts.anton(
                  fontSize: 30,
                  letterSpacing: 5,
                  wordSpacing: 4,
                  color: const Color.fromARGB(255, 254, 240, 2),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('orders')
                        .where('order_confirmed', isEqualTo: true)
                        .orderBy('order_date', descending: true)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      }

                      if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                        return const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Card(child: Text('No data available')),
                          ],
                        );
                      }

                      List<QueryDocumentSnapshot> documents =
                          snapshot.data!.docs;
                      return ListView.separated(
                        separatorBuilder: (context, index) {
                          return const Divider();
                        },
                        shrinkWrap: true,
                        itemCount: documents.length,
                        itemBuilder: (context, index) {
                          var documentData =
                              documents[index].data() as Map<String, dynamic>;
                          var arrayData = documentData['orders'] as List<
                              dynamic>; // Replace 'array_field' with your array field name.

                          // Process the array data if needed.
                          var totalAmount = NumberFormat.simpleCurrency(
                            locale: 'fil_PH',
                            decimalDigits: 2,
                          ).format(
                            documentData['total_amount'],
                          );
                          String userID = documentData['order_by'];
                          var userToken = '';

                          var totalAmForPDF = '${documentData['total_amount']}';

                          var token = FirebaseFirestore.instance
                              .collection('users')
                              .doc(userID)
                              .get()
                              .then((value) {
                            userToken = value['user-token'];
                          });

                          return SizedBox(
                            child: Card(
                              child: GestureDetector(
                                onTap: () {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return Dialog(
                                        child: SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              2,
                                          child: Card(
                                            color: const Color.fromARGB(
                                                255, 4, 83, 158),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Expanded(
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Row(
                                                          children: [
                                                            Expanded(
                                                              child: SizedBox(
                                                                child: Padding(
                                                                  padding:
                                                                      const EdgeInsets
                                                                          .all(
                                                                          8.0),
                                                                  child: Column(
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .start,
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .spaceEvenly,
                                                                    children: [
                                                                      Text(
                                                                        'USER ID: ${documentData['order_by']}',
                                                                        style: GoogleFonts
                                                                            .roboto(
                                                                          color: const Color
                                                                              .fromARGB(
                                                                              255,
                                                                              252,
                                                                              255,
                                                                              58),
                                                                          letterSpacing:
                                                                              3,
                                                                        ),
                                                                      ),
                                                                      const Divider(),
                                                                      Text(
                                                                        'USER FULLNAME: ${documentData['order_by_name']}',
                                                                        style: GoogleFonts
                                                                            .roboto(
                                                                          color: const Color
                                                                              .fromARGB(
                                                                              255,
                                                                              252,
                                                                              255,
                                                                              58),
                                                                          letterSpacing:
                                                                              3,
                                                                        ),
                                                                      ),
                                                                      const Divider(),
                                                                      Text(
                                                                        'EMAIL: ${documentData['order_by_email']}',
                                                                        style: GoogleFonts
                                                                            .roboto(
                                                                          color: const Color
                                                                              .fromARGB(
                                                                              255,
                                                                              252,
                                                                              255,
                                                                              58),
                                                                          letterSpacing:
                                                                              3,
                                                                        ),
                                                                      ),
                                                                      const Divider(),
                                                                      Text(
                                                                        'BARANGAY: ${documentData['order_by_address']}',
                                                                        style: GoogleFonts
                                                                            .roboto(
                                                                          color: const Color
                                                                              .fromARGB(
                                                                              255,
                                                                              252,
                                                                              255,
                                                                              58),
                                                                          letterSpacing:
                                                                              3,
                                                                        ),
                                                                      ),
                                                                      const Divider(),
                                                                      Text(
                                                                        'STREET NAME / PUROK: ${documentData['order_by_purok']}',
                                                                        style: GoogleFonts
                                                                            .roboto(
                                                                          color: const Color
                                                                              .fromARGB(
                                                                              255,
                                                                              252,
                                                                              255,
                                                                              58),
                                                                          letterSpacing:
                                                                              3,
                                                                        ),
                                                                      ),
                                                                      const Divider(),
                                                                      Text(
                                                                        'LANDMARK: ${documentData['order_by_landmark']}',
                                                                        style: GoogleFonts
                                                                            .roboto(
                                                                          color: const Color
                                                                              .fromARGB(
                                                                              255,
                                                                              252,
                                                                              255,
                                                                              58),
                                                                          letterSpacing:
                                                                              3,
                                                                        ),
                                                                      ),
                                                                      const Divider(),
                                                                      Text(
                                                                        'CONTACT NUMBER: ${documentData['order_by_phone']}',
                                                                        style: GoogleFonts
                                                                            .roboto(
                                                                          color: const Color
                                                                              .fromARGB(
                                                                              255,
                                                                              252,
                                                                              255,
                                                                              58),
                                                                          letterSpacing:
                                                                              3,
                                                                        ),
                                                                      ),
                                                                      const Divider(),
                                                                      Text(
                                                                        'ORDER(S): ',
                                                                        style: GoogleFonts
                                                                            .roboto(
                                                                          color: const Color
                                                                              .fromARGB(
                                                                              255,
                                                                              252,
                                                                              255,
                                                                              58),
                                                                          letterSpacing:
                                                                              3,
                                                                        ),
                                                                      ),
                                                                      SizedBox(
                                                                        height:
                                                                            200,
                                                                        child:
                                                                            Card(
                                                                          child:
                                                                              ListView.separated(
                                                                            separatorBuilder:
                                                                                (context, index) {
                                                                              return const Divider();
                                                                            },
                                                                            shrinkWrap:
                                                                                true,
                                                                            itemCount:
                                                                                arrayData.length,
                                                                            itemBuilder:
                                                                                (context, arrayIndex) {
                                                                              var arrayElement = arrayData[arrayIndex].toString();
                                                                              return ListTile(
                                                                                leading: SizedBox(
                                                                                  height: 100,
                                                                                  width: 100,
                                                                                  child: Image.network(
                                                                                    arrayData[arrayIndex]['img'],
                                                                                  ),
                                                                                ),
                                                                                dense: true,
                                                                                title: Text(
                                                                                  'Product: ${arrayData[arrayIndex]['title']}\nQuantity: ${arrayData[arrayIndex]['qty']}',
                                                                                  style: GoogleFonts.roboto(
                                                                                    color: const Color.fromARGB(255, 4, 83, 158),
                                                                                    letterSpacing: 3,
                                                                                  ),
                                                                                ),
                                                                              );
                                                                            },
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      const Divider(),
                                                                      Text(
                                                                        'PAYMENT METHOD: ${documentData['payment_method']}',
                                                                        style: GoogleFonts
                                                                            .roboto(
                                                                          color: const Color
                                                                              .fromARGB(
                                                                              255,
                                                                              252,
                                                                              255,
                                                                              58),
                                                                          letterSpacing:
                                                                              3,
                                                                        ),
                                                                      ),
                                                                      const Divider(),
                                                                      documentData['order_confirmed'] = true
                                                                          ? Text(
                                                                              'STATUS: Order Confirmed',
                                                                              style: GoogleFonts.roboto(
                                                                                color: const Color.fromARGB(255, 252, 255, 58),
                                                                                letterSpacing: 3,
                                                                              ),
                                                                            )
                                                                          : Container(),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        const Divider(),
                                                        Container(
                                                          child: Center(
                                                            child: Row(
                                                              children: <Widget>[
                                                                ElevatedButton(
                                                                  style:
                                                                      const ButtonStyle(
                                                                    backgroundColor:
                                                                        MaterialStatePropertyAll(
                                                                      Color.fromARGB(
                                                                          255,
                                                                          252,
                                                                          255,
                                                                          58),
                                                                    ),
                                                                  ),
                                                                  onPressed:
                                                                      () async {
                                                                    final pdf =
                                                                        await generatePDF(
                                                                      arrayData,
                                                                      totalAmForPDF,
                                                                      documentData,
                                                                    );

                                                                    final pdfBytes =
                                                                        await pdf
                                                                            .save();

                                                                    final blob =
                                                                        html.Blob([
                                                                      Uint8List
                                                                          .fromList(
                                                                              pdfBytes)
                                                                    ]);
                                                                    final url = html
                                                                            .Url
                                                                        .createObjectUrlFromBlob(
                                                                            blob);

                                                                    final anchor = html
                                                                        .AnchorElement(
                                                                            href:
                                                                                url)
                                                                      ..target =
                                                                          'webdownload'
                                                                      ..download =
                                                                          '${documentData['order_by_name']}_orders.pdf'
                                                                      ..text =
                                                                          'Download PDF';

                                                                    anchor
                                                                        .click();

                                                                    html.Url
                                                                        .revokeObjectUrl(
                                                                            url);
                                                                  },
                                                                  child: Text(
                                                                    'Print PDF',
                                                                    style: GoogleFonts
                                                                        .roboto(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      color: const Color
                                                                          .fromARGB(
                                                                          255,
                                                                          4,
                                                                          83,
                                                                          158),
                                                                    ),
                                                                  ),
                                                                ),
                                                                ElevatedButton(
                                                                  style:
                                                                      const ButtonStyle(
                                                                    backgroundColor:
                                                                        MaterialStatePropertyAll(
                                                                      Color.fromARGB(
                                                                          255,
                                                                          252,
                                                                          255,
                                                                          58),
                                                                    ),
                                                                  ),
                                                                  onPressed:
                                                                      () async {
                                                                    await FirebaseFirestore
                                                                        .instance
                                                                        .collection(
                                                                            'orders')
                                                                        .doc(documents[index]
                                                                            .reference
                                                                            .id)
                                                                        .update({
                                                                      'order_on_delivery':
                                                                          true,
                                                                      'order_confirmed':
                                                                          false,
                                                                    }).then((value) =>
                                                                            Navigator.pop(context));
                                                                    try {
                                                                      await http
                                                                          .post(
                                                                        Uri.parse(
                                                                            'https://fcm.googleapis.com/fcm/send'),
                                                                        headers: <String,
                                                                            String>{
                                                                          'Content-Type':
                                                                              'application/json',
                                                                          'Authorization':
                                                                              'key=AAAAS7YKmU4:APA91bEOW9oLuqFcaMPlElfBxx6VniXOG7VoIjtLY6xXkX-Zc6pYd4rNzFwaxen-0WKr-i9dgeEjSju13yFxMDxg8sX3cFk1kv3wQ6ceeNfmZdLon-StvqrwYdu0BNBV5qroS02yIFxX',
                                                                        },
                                                                        body:
                                                                            jsonEncode(
                                                                          <String,
                                                                              dynamic>{
                                                                            'notification':
                                                                                <String, dynamic>{
                                                                              'body': 'Your Order: ${documentData['order_code']} is on its way!',
                                                                            },
                                                                            'priority':
                                                                                'high',
                                                                            'data':
                                                                                <String, dynamic>{
                                                                              'click_action': 'FLUTTER_NOTIFICATION_CLICK',
                                                                              'id': '1',
                                                                              'status': 'done'
                                                                            },
                                                                            "to":
                                                                                userToken
                                                                          },
                                                                        ),
                                                                      );
                                                                      print(
                                                                          'done');
                                                                    } catch (e) {
                                                                      print(
                                                                          "error push notification");
                                                                    }
                                                                  },
                                                                  child: Text(
                                                                    'Deliver Order',
                                                                    style: GoogleFonts
                                                                        .roboto(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      color: const Color
                                                                          .fromARGB(
                                                                          255,
                                                                          4,
                                                                          83,
                                                                          158),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                },
                                child: ListTile(
                                  dense: true,
                                  title: Text(
                                    'Order Code: ${documentData['order_code']}',
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold),
                                  ),
                                  trailing: TextButton(
                                    onPressed: () {
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return Dialog(
                                            child: SizedBox(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  2,
                                              child: Card(
                                                color: const Color.fromARGB(
                                                    255, 4, 83, 158),
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Expanded(
                                                        child: Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Row(
                                                              children: [
                                                                Expanded(
                                                                  child:
                                                                      SizedBox(
                                                                    child:
                                                                        Padding(
                                                                      padding: const EdgeInsets
                                                                          .all(
                                                                          8.0),
                                                                      child:
                                                                          Column(
                                                                        crossAxisAlignment:
                                                                            CrossAxisAlignment.start,
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.spaceEvenly,
                                                                        children: [
                                                                          Text(
                                                                            'USER ID: ${documentData['order_by']}',
                                                                            style:
                                                                                GoogleFonts.roboto(
                                                                              color: const Color.fromARGB(255, 252, 255, 58),
                                                                              letterSpacing: 3,
                                                                            ),
                                                                          ),
                                                                          const Divider(),
                                                                          Text(
                                                                            'USER FULLNAME: ${documentData['order_by_name']}',
                                                                            style:
                                                                                GoogleFonts.roboto(
                                                                              color: const Color.fromARGB(255, 252, 255, 58),
                                                                              letterSpacing: 3,
                                                                            ),
                                                                          ),
                                                                          const Divider(),
                                                                          Text(
                                                                            'EMAIL: ${documentData['order_by_email']}',
                                                                            style:
                                                                                GoogleFonts.roboto(
                                                                              color: const Color.fromARGB(255, 252, 255, 58),
                                                                              letterSpacing: 3,
                                                                            ),
                                                                          ),
                                                                          const Divider(),
                                                                          Text(
                                                                            'ADDRESS: ${documentData['order_by_address']}',
                                                                            style:
                                                                                GoogleFonts.roboto(
                                                                              color: const Color.fromARGB(255, 252, 255, 58),
                                                                              letterSpacing: 3,
                                                                            ),
                                                                          ),
                                                                          const Divider(),
                                                                          Text(
                                                                            'CONTACT NUMBER: ${documentData['order_by_phone']}',
                                                                            style:
                                                                                GoogleFonts.roboto(
                                                                              color: const Color.fromARGB(255, 252, 255, 58),
                                                                              letterSpacing: 3,
                                                                            ),
                                                                          ),
                                                                          const Divider(),
                                                                          Text(
                                                                            'ORDER(S): ',
                                                                            style:
                                                                                GoogleFonts.roboto(
                                                                              color: const Color.fromARGB(255, 252, 255, 58),
                                                                              letterSpacing: 3,
                                                                            ),
                                                                          ),
                                                                          SizedBox(
                                                                            height:
                                                                                200,
                                                                            child:
                                                                                Card(
                                                                              child: ListView.separated(
                                                                                separatorBuilder: (context, index) {
                                                                                  return const Divider();
                                                                                },
                                                                                shrinkWrap: true,
                                                                                itemCount: arrayData.length,
                                                                                itemBuilder: (context, arrayIndex) {
                                                                                  var arrayElement = arrayData[arrayIndex].toString();
                                                                                  return ListTile(
                                                                                    leading: SizedBox(
                                                                                      height: 100,
                                                                                      width: 100,
                                                                                      child: Image.network(
                                                                                        arrayData[arrayIndex]['img'],
                                                                                      ),
                                                                                    ),
                                                                                    dense: true,
                                                                                    title: Text(
                                                                                      'Product: ${arrayData[arrayIndex]['title']}\nQuantity: ${arrayData[arrayIndex]['qty']}',
                                                                                      style: GoogleFonts.roboto(
                                                                                        color: const Color.fromARGB(255, 4, 83, 158),
                                                                                        letterSpacing: 3,
                                                                                      ),
                                                                                    ),
                                                                                  );
                                                                                },
                                                                              ),
                                                                            ),
                                                                          ),
                                                                          const Divider(),
                                                                          Text(
                                                                            'PAYMENT METHOD: ${documentData['payment_method']}',
                                                                            style:
                                                                                GoogleFonts.roboto(
                                                                              color: const Color.fromARGB(255, 252, 255, 58),
                                                                              letterSpacing: 3,
                                                                            ),
                                                                          ),
                                                                          const Divider(),
                                                                          documentData['order_confirmed'] = true
                                                                              ? Text(
                                                                                  'STATUS: Order Confirmed',
                                                                                  style: GoogleFonts.roboto(
                                                                                    color: const Color.fromARGB(255, 252, 255, 58),
                                                                                    letterSpacing: 3,
                                                                                  ),
                                                                                )
                                                                              : Container(),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                            const Divider(),
                                                            ElevatedButton(
                                                              style:
                                                                  const ButtonStyle(
                                                                backgroundColor:
                                                                    MaterialStatePropertyAll(
                                                                  Color
                                                                      .fromARGB(
                                                                          255,
                                                                          252,
                                                                          255,
                                                                          58),
                                                                ),
                                                              ),
                                                              onPressed:
                                                                  () async {
                                                                await FirebaseFirestore
                                                                    .instance
                                                                    .collection(
                                                                        'orders')
                                                                    .doc(documents[
                                                                            index]
                                                                        .reference
                                                                        .id)
                                                                    .update({
                                                                  'order_on_delivery':
                                                                      true,
                                                                  'order_confirmed':
                                                                      false,
                                                                }).then((value) =>
                                                                        Navigator.pop(
                                                                            context));
                                                                try {
                                                                  await http
                                                                      .post(
                                                                    Uri.parse(
                                                                        'https://fcm.googleapis.com/fcm/send'),
                                                                    headers: <String,
                                                                        String>{
                                                                      'Content-Type':
                                                                          'application/json',
                                                                      'Authorization':
                                                                          'key=AAAAS7YKmU4:APA91bEOW9oLuqFcaMPlElfBxx6VniXOG7VoIjtLY6xXkX-Zc6pYd4rNzFwaxen-0WKr-i9dgeEjSju13yFxMDxg8sX3cFk1kv3wQ6ceeNfmZdLon-StvqrwYdu0BNBV5qroS02yIFxX',
                                                                    },
                                                                    body:
                                                                        jsonEncode(
                                                                      <String,
                                                                          dynamic>{
                                                                        'notification':
                                                                            <String,
                                                                                dynamic>{
                                                                          'body':
                                                                              'Your Order: ${documentData['order_code']} is on its way!',
                                                                        },
                                                                        'priority':
                                                                            'high',
                                                                        'data': <String,
                                                                            dynamic>{
                                                                          'click_action':
                                                                              'FLUTTER_NOTIFICATION_CLICK',
                                                                          'id':
                                                                              '1',
                                                                          'status':
                                                                              'done'
                                                                        },
                                                                        "to":
                                                                            userToken
                                                                      },
                                                                    ),
                                                                  );
                                                                  print('done');
                                                                } catch (e) {
                                                                  print(
                                                                      "error push notification");
                                                                }

                                                                final pdf = await generatePDF(
                                                                    arrayData,
                                                                    totalAmForPDF,
                                                                    documentData);

                                                                final pdfBytes =
                                                                    await pdf
                                                                        .save();

                                                                final blob =
                                                                    html.Blob([
                                                                  Uint8List
                                                                      .fromList(
                                                                          pdfBytes)
                                                                ]);
                                                                final url = html
                                                                        .Url
                                                                    .createObjectUrlFromBlob(
                                                                        blob);

                                                                final anchor = html
                                                                    .AnchorElement(
                                                                        href:
                                                                            url)
                                                                  ..target =
                                                                      'webdownload'
                                                                  ..download =
                                                                      '${documentData['order_by_name']}_orders.pdf'
                                                                  ..text =
                                                                      'Download PDF';

                                                                anchor.click();

                                                                html.Url
                                                                    .revokeObjectUrl(
                                                                        url);
                                                              },
                                                              child: Text(
                                                                'Export Data to PDF & Deliver Order',
                                                                style:
                                                                    GoogleFonts
                                                                        .roboto(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  color: const Color
                                                                      .fromARGB(
                                                                      255,
                                                                      4,
                                                                      83,
                                                                      158),
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          );
                                        },
                                      );
                                    },
                                    child: const Text('Details'),
                                  ),
                                  subtitle: Text(
                                    '${documentData['order_by_name']}\nTotal Amount: $totalAmount',
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
