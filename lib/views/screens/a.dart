// import 'dart:convert';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:http/http.dart' as http;
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_spinkit/flutter_spinkit.dart';
// import 'package:get/get.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:my_app/consts/consts.dart';
// import 'package:intl/intl.dart';
// import 'dart:io';

// import 'package:my_app/controller/profile_controller.dart';

// class PendingPage extends StatefulWidget {
//   const PendingPage({super.key});

//   @override
//   State<PendingPage> createState() => _PendingPageState();
// }

// class _PendingPageState extends State<PendingPage> {
//   bool orderPlaced = true;
//   final db = FirebaseFirestore.instance;

//   @override
//   Widget build(BuildContext context) {


//     var controller = Get.put(ProfileController());


//     return Scaffold(
//       body: SizedBox(
//         height: MediaQuery.of(context).size.height,
//         child: Container(
//           decoration: BoxDecoration(
//             color: const Color.fromARGB(255, 4, 83, 158),
//           ),
//           child: Card(
//             color: Color.fromARGB(255, 4, 83, 158),
//             child: Column(
//               children: [
//                 Text(
//                   "Pending Orders".toUpperCase(),
//                   style: GoogleFonts.anton(
//                     fontSize: 30,
//                     letterSpacing: 5,
//                     wordSpacing: 4,
//                     color: const Color.fromARGB(255, 254, 240, 2),
//                   ),
//                 ),
//                 Expanded(
//                   child: Padding(
//                     padding: const EdgeInsets.all(8.0),
//                     child: StreamBuilder<QuerySnapshot>(
//                       stream: FirebaseFirestore.instance
//                           .collection('orders')
//                           .where('order_placed', isEqualTo: true)
//                           .orderBy('order_date', descending: true)
//                           .snapshots(),
//                       builder: (context, snapshot) {
//                         if (snapshot.hasError) {
//                           return Text('Error: ${snapshot.error}');
//                         }

//                         if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
//                           return Row(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: [
//                               Card(child: const Text('No data available')),
//                             ],
//                           );
//                         }

//                         List<QueryDocumentSnapshot> documents =
//                             snapshot.data!.docs;
//                         return ListView.builder(
//                           shrinkWrap: true,
//                           itemCount: documents.length,
//                           itemBuilder: (context, index) {


//                             final document = documents[index];

//                             var documentData =
//                                 documents[index].data() as Map<String, dynamic>;
//                             var arrayData = documentData['orders'] as List<
//                                 dynamic>; // Replace 'array_field' with your array field name.

//                             var totalAmount = NumberFormat.simpleCurrency(
//                               locale: 'fil_PH',
//                               decimalDigits: 2,
//                             ).format(
//                               documentData['total_amount'],
//                             );

//                             String userID = documentData['order_by'];
//                             var userToken = '';

//                             var token = FirebaseFirestore.instance
//                                 .collection('users')
//                                 .doc(userID)
//                                 .get()
//                                 .then((value) {
//                               userToken = value['user-token'];
//                             });

//                             return SizedBox(
//                               child: Card(
//                                 child: GestureDetector(
//                                   onTap: () {
//                                     showDialog(
//                                       context: context,
//                                       builder: (BuildContext context) {
//                                         return Dialog(
//                                           child: SizedBox(
//                                             width: MediaQuery.of(context)
//                                                     .size
//                                                     .width /
//                                                 2,
//                                             child: Card(
//                                               color: const Color.fromARGB(
//                                                   255, 4, 83, 158),
//                                               child: Padding(
//                                                 padding:
//                                                     const EdgeInsets.all(8.0),
//                                                 child: Row(
//                                                   mainAxisAlignment:
//                                                       MainAxisAlignment.center,
//                                                   children: [
//                                                     Expanded(
//                                                       child: Column(
//                                                         mainAxisAlignment:
//                                                             MainAxisAlignment
//                                                                 .center,
//                                                         children: [
//                                                           Row(
//                                                             children: [
//                                                               Expanded(
//                                                                 child: SizedBox(
//                                                                   child:
//                                                                       Padding(
//                                                                     padding:
//                                                                         const EdgeInsets
//                                                                             .all(
//                                                                             8.0),
//                                                                     child:
//                                                                         Column(
//                                                                       crossAxisAlignment:
//                                                                           CrossAxisAlignment
//                                                                               .start,
//                                                                       mainAxisAlignment:
//                                                                           MainAxisAlignment
//                                                                               .spaceEvenly,
//                                                                       children: [
//                                                                         Text(
//                                                                           'USER ID: ${documentData['order_by']}',
//                                                                           style:
//                                                                               GoogleFonts.roboto(
//                                                                             color: const Color.fromARGB(
//                                                                                 255,
//                                                                                 252,
//                                                                                 255,
//                                                                                 58),
//                                                                             letterSpacing:
//                                                                                 3,
//                                                                           ),
//                                                                         ),
//                                                                         const Divider(),
//                                                                         Text(
//                                                                           'USER FULLNAME: ${documentData['order_by_name']}',
//                                                                           style:
//                                                                               GoogleFonts.roboto(
//                                                                             color: const Color.fromARGB(
//                                                                                 255,
//                                                                                 252,
//                                                                                 255,
//                                                                                 58),
//                                                                             letterSpacing:
//                                                                                 3,
//                                                                           ),
//                                                                         ),
//                                                                         const Divider(),
//                                                                         Text(
//                                                                           'EMAIL: ${documentData['order_by_email']}',
//                                                                           style:
//                                                                               GoogleFonts.roboto(
//                                                                             color: const Color.fromARGB(
//                                                                                 255,
//                                                                                 252,
//                                                                                 255,
//                                                                                 58),
//                                                                             letterSpacing:
//                                                                                 3,
//                                                                           ),
//                                                                         ),
//                                                                          const Divider(),
//                                                                         Text(
//                                                                           'BARANGAY: ${documentData['order_by_address']}',
//                                                                           style:
//                                                                               GoogleFonts.roboto(
//                                                                             color: const Color.fromARGB(
//                                                                                 255,
//                                                                                 252,
//                                                                                 255,
//                                                                                 58),
//                                                                             letterSpacing:
//                                                                                 3,
//                                                                           ),
//                                                                         ),
//                                                                         const Divider(),
//                                                                         Text(
//                                                                           'STREET NAME / PUROK: ${documentData['order_by_purok']}',
//                                                                           style:
//                                                                               GoogleFonts.roboto(
//                                                                             color: const Color.fromARGB(
//                                                                                 255,
//                                                                                 252,
//                                                                                 255,
//                                                                                 58),
//                                                                             letterSpacing:
//                                                                                 3,
//                                                                           ),
//                                                                         ),
//                                                                         const Divider(),
//                                                                          Text(
//                                                                           'LANDMARK: ${documentData['order_by_landmark']}',
//                                                                           style:
//                                                                               GoogleFonts.roboto(
//                                                                             color: const Color.fromARGB(
//                                                                                 255,
//                                                                                 252,
//                                                                                 255,
//                                                                                 58),
//                                                                             letterSpacing:
//                                                                                 3,
//                                                                           ),
//                                                                         ),
//                                                                         const Divider(),
//                                                                         Text(
//                                                                           'CONTACT NUMBER: ${documentData['order_by_phone']}',
//                                                                           style:
//                                                                               GoogleFonts.roboto(
//                                                                             color: const Color.fromARGB(
//                                                                                 255,
//                                                                                 252,
//                                                                                 255,
//                                                                                 58),
//                                                                             letterSpacing:
//                                                                                 3,
//                                                                           ),
//                                                                         ),
//                                                                         const Divider(),
//                                                                         Text(
//                                                                           'ORDER(S): ',
//                                                                           style:
//                                                                               GoogleFonts.roboto(
//                                                                             color: const Color.fromARGB(
//                                                                                 255,
//                                                                                 252,
//                                                                                 255,
//                                                                                 58),
//                                                                             letterSpacing:
//                                                                                 3,
//                                                                           ),
//                                                                         ),
//                                                                         SizedBox(
//                                                                           height:
//                                                                               200,
//                                                                           child:
//                                                                               Card(
//                                                                             child:
//                                                                                 ListView.separated(
//                                                                               separatorBuilder: (context, index) {
//                                                                                 return const Divider();
//                                                                               },
//                                                                               shrinkWrap: true,
//                                                                               itemCount: arrayData.length,
//                                                                               itemBuilder: (context, arrayIndex) {
//                                                                                 var arrayElement = arrayData[arrayIndex].toString();
//                                                                                 return ListTile(
//                                                                                   leading: SizedBox(
//                                                                                     height: 100,
//                                                                                     width: 100,
//                                                                                     child: Image.network(
//                                                                                       arrayData[arrayIndex]['img'],
//                                                                                     ),
//                                                                                   ),
//                                                                                   dense: true,
//                                                                                   title: Text(
//                                                                                     'Product: ${arrayData[arrayIndex]['title']}\nQuantity: ${arrayData[arrayIndex]['qty']}',
//                                                                                     style: GoogleFonts.roboto(
//                                                                                       color: const Color.fromARGB(255, 31, 31, 176),
//                                                                                       letterSpacing: 3,
//                                                                                     ),
//                                                                                   ),

//                                                                                     trailing: Row(
//                                                                                       mainAxisSize: MainAxisSize.min,
//                                                                                       children: <Widget>[
//                                                                                         IconButton(
//                                                                                           icon: Icon(Icons.edit),
//                                                                                           color: Colors.green,


//                                                                                           onPressed: () async {
//                                                                                               DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance.collection('orders').doc(document.reference.id).get();
//                                                                                               Map<String, dynamic> data = documentSnapshot.data() as Map<String, dynamic>;
//                                                                                               List<dynamic> yourArray = List.from(data['orders']);
//                                                                                               int indexToUpdate = arrayIndex; // specify the index of the item you want to update
//                                                                                               var newQuantity = await showDialog<int>(
//                                                                                                 context: context,
//                                                                                                 builder: (BuildContext context) {
//                                                                                                   int currentQuantity = yourArray[indexToUpdate]['qty'];
//                                                                                                   return AlertDialog(
//                                                                                                     title: Text('Edit Quantity'),
//                                                                                                     content: TextField(
//                                                                                                       keyboardType: TextInputType.number,
//                                                                                                       decoration: InputDecoration(labelText: 'New Quantity', hintText: 'Enter new quantity'),
//                                                                                                       onChanged: (String value) {
//                                                                                                         currentQuantity = int.parse(value);
//                                                                                                       },
//                                                                                                     ),
//                                                                                                     actions: <Widget>[
//                                                                                                       IconButton(
//                                                                                                         icon: Icon(Icons.edit),
//                                                                                                         color: Colors.yellowAccent,
//                                                                                                         onPressed: () {
//                                                                                                           Navigator.of(context).pop(currentQuantity);
//                                                                                                         },
//                                                                                                       ),
//                                                                                                     ],
//                                                                                                   );
//                                                                                                 },
//                                                                                               );
//                                                                                               if (newQuantity != null) {
//                                                                                                 yourArray[indexToUpdate]['qty'] = newQuantity; // update the quantity
//                                                                                                 await FirebaseFirestore.instance.collection('orders').doc(document.reference.id).update({
//                                                                                                   'orders': yourArray,
//                                                                                                 });
//                                                                                                 Navigator.pop(context);
//                                                                                               }
//                                                                                             },                                                                                        ),
//                                                                                         IconButton(
//                                                                                           icon: Icon(Icons.delete),
//                                                                                           color: Colors.red,
//                                                                                           onPressed: () async {
//                                                                                           showDialog(
//                                                                                               context: context,
//                                                                                               builder: (context) => AlertDialog(
//                                                                                                 title: const Text('Delete?'),
//                                                                                                 actions: [
//                                                                                                   TextButton(
//                                                                                                     onPressed: () async {
//                                                                                                       DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance.collection('orders').doc(document.reference.id).get();
//                                                                                                       Map<String, dynamic> data = documentSnapshot.data() as Map<String, dynamic>;
//                                                                                                       List<dynamic> yourArray = List.from(data['orders']);
//                                                                                                       yourArray.removeAt(arrayIndex);
//                                                                                                       await FirebaseFirestore.instance.collection('orders').doc(document.reference.id).update({
//                                                                                                         'orders': yourArray,
//                                                                                                       });
//                                                                                                       Navigator.pop(context);
//                                                                                                     },
//                                                                                                     child: const Text('Yes'),
//                                                                                                   ),
//                                                                                                   TextButton(
//                                                                                                     onPressed: () {
//                                                                                                       Navigator.pop(context);
//                                                                                                     },
//                                                                                                     child: const Text('No'),
//                                                                                                   ),
//                                                                                                 ],
//                                                                                               ),
//                                                                                             );
//                                                                                           },
//                                                                                         ),
//                                                                                       ],
//                                                                                     ),
//                                                                                 );
//                                                                               },
//                                                                             ),
//                                                                           ),
//                                                                         ),
//                                                                         const Divider(),
//                                                                         Text(
//                                                                           'PAYMENT METHOD: ${documentData['payment_method']}',
//                                                                           style:
//                                                                               GoogleFonts.roboto(
//                                                                             color: const Color.fromARGB(
//                                                                                 255,
//                                                                                 252,
//                                                                                 255,
//                                                                                 58),
//                                                                             letterSpacing:
//                                                                                 3,
//                                                                           ),
//                                                                         ),
//                                                                         const Divider(),
//                                                                         documentData['order_placed'] = true
//                                                                             ? Text(
//                                                                                 'STATUS: Order Placed',
//                                                                                 style: GoogleFonts.roboto(
//                                                                                   color: const Color.fromARGB(255, 252, 255, 58),
//                                                                                   letterSpacing: 3,
//                                                                                 ),
//                                                                               )
//                                                                             : Container(),
//                                                                       ],
//                                                                     ),
//                                                                   ),
//                                                                 ),
//                                                               ),
//                                                             ],
//                                                           ),
//                                                           const Divider(),
//                                                           Container(
//                                                             child: Center(
//                                                               child: Row(
//                                                                 children: <Widget> [
//                                                                   ElevatedButton(
//                                                                     style: ButtonStyle(
//                                                                       backgroundColor:
//                                                                           MaterialStatePropertyAll(
//                                                                         const Color
//                                                                             .fromARGB(
//                                                                             255,
//                                                                             252,
//                                                                             255,
//                                                                             58),
//                                                                       ),
//                                                                     ),
//                                                                     onPressed:
//                                                                         () async {
//                                                                       await FirebaseFirestore
//                                                                           .instance
//                                                                           .collection(
//                                                                               'orders')
//                                                                           .doc(documents[
//                                                                                   index]
//                                                                               .reference
//                                                                               .id)
//                                                                           .update({
//                                                                         'order_placed':
//                                                                             false,
//                                                                         'order_confirmed':
//                                                                             true,
//                                                                       }).then((value) =>
//                                                                               Navigator.pop(
//                                                                                   context));
//                                                                     child: Text(
//                                                                       'Confirm Order',
//                                                                       style: GoogleFonts
//                                                                           .roboto(
//                                                                         fontWeight:
//                                                                             FontWeight
//                                                                                 .bold,
//                                                                         color: const Color
//                                                                             .fromARGB(
//                                                                             255,
//                                                                             31,
//                                                                             31,
//                                                                             176),
//                                                                       ),
//                                                                     ),
//                                                                   ),                                                                                                                     
//                                                                                                                       const Divider(),                                     
//                                                                   ElevatedButton(
//                                                                     style: ButtonStyle(
//                                                                       backgroundColor:
//                                                                           MaterialStatePropertyAll(
//                                                                         Color(0xFF03E316),
//                                                                       ),
//                                                                     ),
//                                                                     onPressed:
//                                                                         () async {




//                                                                           // Retrieve the document
//                                                                                               DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance.collection('orders').doc(document.reference.id).get();

//                                                                                               // Get the data
//                                                                                               Map<String, dynamic> data = documentSnapshot.data() as Map<String, dynamic>;

//                                                                                               // Get the array you want to modify
//                                                                                               List<dynamic> yourArray = List.from(data['orders']);

//                                                                                               // Assuming you want to update the quantity of a product at a specific index
//                                                                                               int indexToUpdate = arrayIndex; // specify the index of the item you want to update
//                                                                                               var newQuantity = await showDialog<int>(
//                                                                                                 context: context,
//                                                                                                 builder: (BuildContext context) {
//                                                                                                   // Create a dialog to input the new quantity
//                                                                                                   int currentQuantity = yourArray[indexToUpdate]['qty'];
//                                                                                                   return AlertDialog(
//                                                                                                     title: Text('Edit Quantity'),
//                                                                                                     content: TextField(
//                                                                                                       keyboardType: TextInputType.number,
//                                                                                                       decoration: InputDecoration(labelText: 'New Quantity', hintText: 'Enter new quantity'),
//                                                                                                       onChanged: (String value) {
//                                                                                                         // Validate and parse user input
//                                                                                                         // For simplicity, let's assume the user always enters a valid integer
//                                                                                                         currentQuantity = int.parse(value);
//                                                                                                       },
//                                                                                                     ),
//                                                                                                     actions: <Widget>[
//                                                                                                       IconButton(
//                                                                                                         icon: Icon(Icons.edit),
//                                                                                                         color: Colors.yellowAccent,
//                                                                                                         onPressed: () {
//                                                                                                           // Close the dialog and return the new quantity
//                                                                                                           Navigator.of(context).pop(currentQuantity);
//                                                                                                         },
//                                                                                                       ),
//                                                                                                     ],
//                                                                                                   );
//                                                                                                 },
//                                                                                               );

//                                                                                               // Update the quantity only if the user entered a new quantity
//                                                                                               if (newQuantity != null) {
//                                                                                                 yourArray[indexToUpdate]['qty'] = newQuantity; // update the quantity

//                                                                                                 // Update the document with the modified data
//                                                                                                 await FirebaseFirestore.instance.collection('orders').doc(document.reference.id).update({
//                                                                                                   'orders': yourArray,
//                                                                                                 });

//                                                                                                 Navigator.pop(context);
//                                                                                               }                                                                                     
//                                                                     },