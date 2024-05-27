import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_app/consts/consts.dart';
import 'package:intl/intl.dart';
import 'dart:io';

import 'package:my_app/controller/profile_controller.dart';
import 'package:my_app/models/product_dialog.dart';
import 'package:my_app/models/product_grid.dart';
import 'package:my_app/models/product_provider.dart';
import 'package:my_app/models/selected_product_list_provider.dart';
import 'package:provider/provider.dart';

class PendingPage extends StatefulWidget {
  
  const PendingPage({super.key});

  @override
  State<PendingPage> createState() => _PendingPageState();
}

class _PendingPageState extends State<PendingPage> {
  bool orderPlaced = true;
  final db = FirebaseFirestore.instance;
  final ProductListProvider productListProvider = ProductListProvider();

  @override
  Widget build(BuildContext context) {
    var controller = Get.put(ProfileController());

    @override
    void initState() {
      super.initState();
      productListProvider.getProducts();
    }

    return Scaffold(
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        child: Container(
          decoration: const BoxDecoration(
            color: Color.fromARGB(255, 4, 83, 158),
          ),
          child: Card(
            color: const Color.fromARGB(255, 4, 83, 158),
            child: Column(
              children: [
                Text(
                  "Pending Orders".toUpperCase(),
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
                          .where('order_placed', isEqualTo: true)
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
                        return ListView.builder(
                          shrinkWrap: true,
                          itemCount: documents.length,
                          itemBuilder: (context, index) {
                            final document = documents[index];

                            var documentData =
                                documents[index].data() as Map<String, dynamic>;
                            var arrayData = documentData['orders'] as List<
                                dynamic>; // Replace 'array_field' with your array field name.

                            var totalAmount = NumberFormat.simpleCurrency(
                              locale: 'fil_PH',
                              decimalDigits: 2,
                            ).format(
                              documentData['total_amount'],
                            );

                            String userID = documentData['order_by'];
                            var userToken = '';

                            /* var token = FirebaseFirestore.instance
                                .collection('users')
                                .doc(userID)
                                .get()
                                .then((value) {
                              userToken = value['user-token'];
                            }
                            
                            
                            
                            ); */

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
                                                                  child:
                                                                      Padding(
                                                                    padding:
                                                                        const EdgeInsets
                                                                            .all(
                                                                            8.0),
                                                                    child:
                                                                        Column(
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .start,
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .spaceEvenly,
                                                                      children: [
                                                                        Text(
                                                                          'USER ID: ${documentData['order_by']}',
                                                                          style:
                                                                              GoogleFonts.roboto(
                                                                            color: const Color.fromARGB(
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
                                                                          style:
                                                                              GoogleFonts.roboto(
                                                                            color: const Color.fromARGB(
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
                                                                          style:
                                                                              GoogleFonts.roboto(
                                                                            color: const Color.fromARGB(
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
                                                                          style:
                                                                              GoogleFonts.roboto(
                                                                            color: const Color.fromARGB(
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
                                                                          style:
                                                                              GoogleFonts.roboto(
                                                                            color: const Color.fromARGB(
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
                                                                          style:
                                                                              GoogleFonts.roboto(
                                                                            color: const Color.fromARGB(
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
                                                                          style:
                                                                              GoogleFonts.roboto(
                                                                            color: const Color.fromARGB(
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
                                                                          style:
                                                                              GoogleFonts.roboto(
                                                                            color: const Color.fromARGB(
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
                                                                                      color: const Color.fromARGB(255, 31, 31, 176),
                                                                                      letterSpacing: 3,
                                                                                    ),
                                                                                  ),
                                                                                  trailing: Row(
                                                                                    mainAxisSize: MainAxisSize.min,
                                                                                    children: <Widget>[
                                                                                      IconButton(
                                                                                        icon: const Icon(Icons.edit),
                                                                                        color: Colors.green,

                                                                                        onPressed: () async {
                                                                                          // Retrieve the document
                                                                                          DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance.collection('orders').doc(document.reference.id).get();

                                                                                          // Get the data
                                                                                          Map<String, dynamic> data = documentSnapshot.data() as Map<String, dynamic>;

                                                                                          // Get the array you want to modify
                                                                                          List<dynamic> yourArray = List.from(data['orders']);

                                                                                          // Assuming you want to update the quantity of a product at a specific index
                                                                                          int indexToUpdate = arrayIndex; // specify the index of the item you want to update
                                                                                          // ignore: use_build_context_synchronously
                                                                                          var newQuantity = await showDialog<int>(
                                                                                            context: context,
                                                                                            builder: (BuildContext context) {
                                                                                              // Create a dialog to input the new quantity
                                                                                              int currentQuantity = yourArray[indexToUpdate]['qty'];
                                                                                              return AlertDialog(
                                                                                                title: const Text('Edit Quantity'),
                                                                                                content: TextField(
                                                                                                  keyboardType: TextInputType.number,
                                                                                                  decoration: const InputDecoration(labelText: 'New Quantity', hintText: 'Enter new quantity'),
                                                                                                  onChanged: (String value) {
                                                                                                    // Validate and parse user input
                                                                                                    // For simplicity, let's assume the user always enters a valid integer
                                                                                                    currentQuantity = int.parse(value);
                                                                                                  },
                                                                                                ),
                                                                                                actions: <Widget>[
                                                                                                  IconButton(
                                                                                                    icon: const Icon(Icons.edit),
                                                                                                    color: Colors.yellowAccent,
                                                                                                    onPressed: () {
                                                                                                      // Close the dialog and return the new quantity
                                                                                                      Navigator.of(context).pop(currentQuantity);
                                                                                                    },
                                                                                                  ),
                                                                                                ],
                                                                                              );
                                                                                            },
                                                                                          );

                                                                                          // Update the quantity only if the user entered a new quantity
                                                                                          if (newQuantity != null) {
                                                                                            yourArray[indexToUpdate]['qty'] = newQuantity; // update the quantity

                                                                                            // Update the document with the modified data
                                                                                            await FirebaseFirestore.instance.collection('orders').doc(document.reference.id).update({
                                                                                              'orders': yourArray,
                                                                                            });

                                                                                            Navigator.pop(context);
                                                                                          }
                                                                                        },

                                                                                        // onPressed: () async {
                                                                                        //   // Add your edit functionality here

                                                                                        //        // Retrieve the document
                                                                                        //             DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance.collection('orders').doc(document.reference.id).get();

                                                                                        //             // Get the data
                                                                                        //             Map<String, dynamic> data = documentSnapshot.data() as Map<String, dynamic>;

                                                                                        //             // Get the array you want to modify
                                                                                        //             List<dynamic> yourArray = List.from(data['orders']);

                                                                                        //             // Assuming you want to update the quantity of a product at a specific index
                                                                                        //             int indexToUpdate = arrayIndex; // specify the index of the item you want to update
                                                                                        //             yourArray[indexToUpdate]['qty'] = 1; // update the quantity

                                                                                        //             // Update the document with the modified data
                                                                                        //             await FirebaseFirestore.instance.collection('orders').doc(document.reference.id).update({
                                                                                        //               'orders': yourArray,
                                                                                        //             });

                                                                                        //             Navigator.pop(context);

                                                                                        // },
                                                                                      ),
                                                                                      IconButton(
                                                                                        icon: const Icon(Icons.delete),
                                                                                        color: Colors.red,
                                                                                        onPressed: () async {
                                                                                          // Add your delete functionality here
                                                                                          // await firestore.collection(productsCollection).doc(data[index].id).delete();

                                                                                          // await firestore.collection(productsCollection).doc(data[index].id).set({
                                                                                          //   'p_wishlist': FieldValue.arrayRemove([currentUser!.uid])
                                                                                          // },SetOptions(merge: true));

                                                                                          // showDialog(
                                                                                          //     context: context,
                                                                                          //     builder: (context) =>
                                                                                          //         AlertDialog(
                                                                                          //       title:
                                                                                          //           const Text('Delete?'),
                                                                                          //       actions: [
                                                                                          //         TextButton(
                                                                                          //           onPressed: () {
                                                                                          //             FirebaseFirestore
                                                                                          //                 .instance
                                                                                          //                 .collection(
                                                                                          //                     'orders')
                                                                                          //                 .doc(document
                                                                                          //                     .reference.id)
                                                                                          //                 .delete();
                                                                                          //             Navigator.pop(
                                                                                          //                 context);
                                                                                          //           },
                                                                                          //           child:
                                                                                          //               const Text('Yes'),
                                                                                          //         ),
                                                                                          //         TextButton(
                                                                                          //           onPressed: () {
                                                                                          //             Navigator.pop(
                                                                                          //                 context);
                                                                                          //           },
                                                                                          //           child: const Text('No'),
                                                                                          //         ),
                                                                                          //       ],
                                                                                          //     ),
                                                                                          //   );

                                                                                          showDialog(
                                                                                            context: context,
                                                                                            builder: (context) => AlertDialog(
                                                                                              title: const Text('Delete?'),
                                                                                              actions: [
                                                                                                TextButton(
                                                                                                  onPressed: () async {
                                                                                                    // Retrieve the document
                                                                                                    DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance.collection('orders').doc(document.reference.id).get();

                                                                                                    // Get the data
                                                                                                    Map<String, dynamic> data = documentSnapshot.data() as Map<String, dynamic>;

                                                                                                    // Get the array you want to modify
                                                                                                    List<dynamic> yourArray = List.from(data['orders']);

                                                                                                    // Remove the desired index from the array
                                                                                                    yourArray.removeAt(arrayIndex);

                                                                                                    // Update the document with the modified data
                                                                                                    await FirebaseFirestore.instance.collection('orders').doc(document.reference.id).update({
                                                                                                      'orders': yourArray,
                                                                                                    });

                                                                                                    Navigator.pop(context);
                                                                                                  },
                                                                                                  child: const Text('Yes'),
                                                                                                ),
                                                                                                TextButton(
                                                                                                  onPressed: () {
                                                                                                    Navigator.pop(context);
                                                                                                  },
                                                                                                  child: const Text('No'),
                                                                                                ),
                                                                                              ],
                                                                                            ),
                                                                                          );
                                                                                        },
                                                                                      ),
                                                                                    ],
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
                                                                            color: const Color.fromARGB(
                                                                                255,
                                                                                252,
                                                                                255,
                                                                                58),
                                                                            letterSpacing:
                                                                                3,
                                                                          ),
                                                                        ),
                                                                        const Divider(),
                                                                        documentData['order_placed'] = true
                                                                            ? Text(
                                                                                'STATUS: Order Placed',
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
                                                                      await FirebaseFirestore
                                                                          .instance
                                                                          .collection(
                                                                              'orders')
                                                                          .doc(documents[index]
                                                                              .reference
                                                                              .id)
                                                                          .update({
                                                                        'order_placed':
                                                                            false,
                                                                        'order_confirmed':
                                                                            true,
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
                                                                              'notification': <String, dynamic>{
                                                                                'body': 'Your Order: ${documentData['order_code']} is confirmed!',
                                                                              },
                                                                              'priority': 'high',
                                                                              'data': <String, dynamic>{
                                                                                'click_action': 'FLUTTER_NOTIFICATION_CLICK',
                                                                                'id': '1',
                                                                                'status': 'done'
                                                                              },
                                                                              "to": userToken
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
                                                                      'Confirm Order',
                                                                      style: GoogleFonts
                                                                          .roboto(
                                                                        fontWeight:
                                                                            FontWeight.bold,
                                                                        color: const Color
                                                                            .fromARGB(
                                                                            255,
                                                                            31,
                                                                            31,
                                                                            176),
                                                                      ),
                                                                    ),
                                                                  ),

                                                                  const Divider(),

                                                                  //                                                                   ElevatedButton(
                                                                  //   style: ButtonStyle(
                                                                  //     backgroundColor: MaterialStateProperty.all(
                                                                  //       Color(0xFF03E316),
                                                                  //     ),
                                                                  //   ),
                                                                  //   onPressed: () async {
                                                                  //     // Retrieve the document
                                                                  //     DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
                                                                  //         .collection('orders')
                                                                  //         .doc(document.reference.id)
                                                                  //         .get();

                                                                  //     // Get the data
                                                                  //     Map<String, dynamic> data = documentSnapshot.data() as Map<String, dynamic>;

                                                                  //     // Get the array you want to modify
                                                                  //     List<dynamic> yourArray = List.from(data['orders']);

                                                                  //     // Assuming you want to add a new item to the order
                                                                  //     // You should have an item object with details like name, quantity, price, etc.
                                                                  //     var newItem = {
                                                                  //       'name': 'New Item', // Set the name of the new item
                                                                  //       'qty': 1, // Set the quantity (you can prompt the user for this value)
                                                                  //       // You can add more properties like price, description, etc.
                                                                  //     };

                                                                  //     // Add the new item to your array
                                                                  //     yourArray.add(newItem);

                                                                  //     // Update the document with the modified data
                                                                  //     await FirebaseFirestore.instance
                                                                  //         .collection('orders')
                                                                  //         .doc(document.reference.id)
                                                                  //         .update({
                                                                  //       'orders': yourArray,
                                                                  //     });

                                                                  //     // Close the dialog
                                                                  //     Navigator.pop(context);
                                                                  //   },
                                                                  //   child: Text(
                                                                  //     'Add Item',
                                                                  //     style: GoogleFonts.roboto(
                                                                  //       fontWeight: FontWeight.bold,
                                                                  //       color: Color.fromRGBO(246, 246, 253, 1),
                                                                  //     ),
                                                                  //   ),
                                                                  // )

                                                                  ElevatedButton(
                                                                    style:
                                                                        ButtonStyle(
                                                                      backgroundColor:
                                                                          MaterialStateProperty
                                                                              .all(
                                                                        const Color(
                                                                            0xFF03E316),
                                                                      ),
                                                                    ),
                                                                    onPressed: () => showDialog(
                                                                      context: context,
                                                                      builder: (BuildContext context) => ProductDialog(
                                                                        productItemId: document.reference.id,
                                                                      ),
                                                                    ),

                                                                    // onPressed: () =>
                                                                    //     showDialog(
                                                                    //   context:
                                                                    //       context,
                                                                    //   builder: (BuildContext
                                                                    //           context) =>
                                                                    //       const ProductDialog(),                                                                       
                                                                    // ),
                                                                    child:
                                                                        const Text(
                                                                      'Add Item',
                                                                      style:
                                                                          TextStyle(
                                                                        fontWeight:
                                                                            FontWeight.bold,
                                                                        color: Color.fromRGBO(
                                                                            246,
                                                                            246,
                                                                            253,
                                                                            1),
                                                                      ),
                                                                    ),
                                                                  ),

                                                                  // ElevatedButton(
                                                                  //   style: ButtonStyle(
                                                                  //     backgroundColor:
                                                                  //         MaterialStatePropertyAll(
                                                                  //       Color(0xFF03E316),
                                                                  //     ),
                                                                  //   ),
                                                                  //   onPressed:
                                                                  //       () async {

                                                                  //         // Retrieve the document
                                                                  //                             DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance.collection('orders').doc(document.reference.id).get();

                                                                  //                             // Get the data
                                                                  //                             Map<String, dynamic> data = documentSnapshot.data() as Map<String, dynamic>;

                                                                  //                             // Get the array you want to modify
                                                                  //                             List<dynamic> yourArray = List.from(data['orders']);

                                                                  //                             // Assuming you want to update the quantity of a product at a specific index
                                                                  //                             int indexToUpdate = arrayIndex; // specify the index of the item you want to update
                                                                  //                             var newQuantity = await showDialog<int>(
                                                                  //                               context: context,
                                                                  //                               builder: (BuildContext context) {
                                                                  //                                 // Create a dialog to input the new quantity
                                                                  //                                 int currentQuantity = yourArray[indexToUpdate]['qty'];
                                                                  //                                 return AlertDialog(
                                                                  //                                   title: Text('Edit Quantity'),
                                                                  //                                   content: TextField(
                                                                  //                                     keyboardType: TextInputType.number,
                                                                  //                                     decoration: InputDecoration(labelText: 'New Quantity', hintText: 'Enter new quantity'),
                                                                  //                                     onChanged: (String value) {
                                                                  //                                       // Validate and parse user input
                                                                  //                                       // For simplicity, let's assume the user always enters a valid integer
                                                                  //                                       currentQuantity = int.parse(value);
                                                                  //                                     },
                                                                  //                                   ),
                                                                  //                                   actions: <Widget>[
                                                                  //                                     IconButton(
                                                                  //                                       icon: Icon(Icons.edit),
                                                                  //                                       color: Colors.yellowAccent,
                                                                  //                                       onPressed: () {
                                                                  //                                         // Close the dialog and return the new quantity
                                                                  //                                         Navigator.of(context).pop(currentQuantity);
                                                                  //                                       },
                                                                  //                                     ),
                                                                  //                                   ],
                                                                  //                                 );
                                                                  //                               },
                                                                  //                             );

                                                                  //                             // Update the quantity only if the user entered a new quantity
                                                                  //                             if (newQuantity != null) {
                                                                  //                               yourArray[indexToUpdate]['qty'] = newQuantity; // update the quantity

                                                                  //                               // Update the document with the modified data
                                                                  //                               await FirebaseFirestore.instance.collection('orders').doc(document.reference.id).update({
                                                                  //                                 'orders': yourArray,
                                                                  //                               });

                                                                  //                               Navigator.pop(context);
                                                                  //                             }

                                                                  //   },
                                                                  //   child: Text(
                                                                  //     'Add Item',
                                                                  //     style: GoogleFonts
                                                                  //         .roboto(
                                                                  //       fontWeight:
                                                                  //           FontWeight
                                                                  //               .bold,
                                                                  //       color: Color.fromRGBO(246, 246, 253, 1),
                                                                  //     ),
                                                                  //   ),
                                                                  // ),
                                                                ],
                                                              ),
                                                            ),
                                                          ),

                                                          // ElevatedButton(
                                                          //   style: ButtonStyle(
                                                          //     backgroundColor:
                                                          //         MaterialStatePropertyAll(
                                                          //       const Color
                                                          //           .fromARGB(
                                                          //           255,
                                                          //           252,
                                                          //           255,
                                                          //           58),
                                                          //     ),
                                                          //   ),
                                                          //   onPressed:
                                                          //       () async {
                                                          //     await FirebaseFirestore
                                                          //         .instance
                                                          //         .collection(
                                                          //             'orders')
                                                          //         .doc(documents[
                                                          //                 index]
                                                          //             .reference
                                                          //             .id)
                                                          //         .update({
                                                          //       'order_placed':
                                                          //           false,
                                                          //       'order_confirmed':
                                                          //           true,
                                                          //     }).then((value) =>
                                                          //             Navigator.pop(
                                                          //                 context));

                                                          //     try {
                                                          //       await http.post(
                                                          //         Uri.parse(
                                                          //             'https://fcm.googleapis.com/fcm/send'),
                                                          //         headers: <String,
                                                          //             String>{
                                                          //           'Content-Type':
                                                          //               'application/json',
                                                          //           'Authorization':
                                                          //               'key=AAAAS7YKmU4:APA91bEOW9oLuqFcaMPlElfBxx6VniXOG7VoIjtLY6xXkX-Zc6pYd4rNzFwaxen-0WKr-i9dgeEjSju13yFxMDxg8sX3cFk1kv3wQ6ceeNfmZdLon-StvqrwYdu0BNBV5qroS02yIFxX',
                                                          //         },
                                                          //         body:
                                                          //             jsonEncode(
                                                          //           <String,
                                                          //               dynamic>{
                                                          //             'notification':
                                                          //                 <String,
                                                          //                     dynamic>{
                                                          //               'body':
                                                          //                   'Your Order: ${documentData['order_code']} is confirmed!',
                                                          //             },
                                                          //             'priority':
                                                          //                 'high',
                                                          //             'data': <String,
                                                          //                 dynamic>{
                                                          //               'click_action':
                                                          //                   'FLUTTER_NOTIFICATION_CLICK',
                                                          //               'id':
                                                          //                   '1',
                                                          //               'status':
                                                          //                   'done'
                                                          //             },
                                                          //             "to":
                                                          //                 userToken
                                                          //           },
                                                          //         ),
                                                          //       );
                                                          //       print('done');
                                                          //     } catch (e) {
                                                          //       print(
                                                          //           "error push notification");
                                                          //     }
                                                          //   },
                                                          //   child: Text(
                                                          //     'Cancel Order',
                                                          //     style: GoogleFonts
                                                          //         .roboto(
                                                          //       fontWeight:
                                                          //           FontWeight
                                                          //               .bold,
                                                          //       color: const Color
                                                          //           .fromARGB(
                                                          //           255,
                                                          //           31,
                                                          //           31,
                                                          //           176),
                                                          //     ),
                                                          //   ),
                                                          // ),
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
                                                height: MediaQuery.of(context)
                                                    .size
                                                    .height,
                                                child: Card(
                                                  color: const Color.fromARGB(
                                                      255, 4, 83, 158),
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
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
                                                                              style: GoogleFonts.roboto(
                                                                                color: const Color.fromARGB(255, 252, 255, 58),
                                                                                letterSpacing: 3,
                                                                              ),
                                                                            ),
                                                                            const Divider(),
                                                                            Text(
                                                                              'USER FULLNAME: ${documentData['order_by_name']}',
                                                                              style: GoogleFonts.roboto(
                                                                                color: const Color.fromARGB(255, 252, 255, 58),
                                                                                letterSpacing: 3,
                                                                              ),
                                                                            ),
                                                                            const Divider(),
                                                                            Text(
                                                                              'EMAIL: ${documentData['order_by_email']}',
                                                                              style: GoogleFonts.roboto(
                                                                                color: const Color.fromARGB(255, 252, 255, 58),
                                                                                letterSpacing: 3,
                                                                              ),
                                                                            ),
                                                                            const Divider(),
                                                                            Text(
                                                                              'ADDRESS: ${documentData['order_by_address']}',
                                                                              style: GoogleFonts.roboto(
                                                                                color: const Color.fromARGB(255, 252, 255, 58),
                                                                                letterSpacing: 3,
                                                                              ),
                                                                            ),
                                                                            const Divider(),
                                                                            Text(
                                                                              'CONTACT NUMBER: ${documentData['order_by_phone']}',
                                                                              style: GoogleFonts.roboto(
                                                                                color: const Color.fromARGB(255, 252, 255, 58),
                                                                                letterSpacing: 3,
                                                                              ),
                                                                            ),
                                                                            const Divider(),
                                                                            Text(
                                                                              'ORDER(S): ',
                                                                              style: GoogleFonts.roboto(
                                                                                color: const Color.fromARGB(255, 252, 255, 58),
                                                                                letterSpacing: 3,
                                                                              ),
                                                                            ),
                                                                            SizedBox(
                                                                              height: 200,
                                                                              child: Card(
                                                                                child: ListView.separated(
                                                                                  separatorBuilder: (context, index) {
                                                                                    return const Divider();
                                                                                  },
                                                                                  shrinkWrap: true,
                                                                                  scrollDirection: Axis.vertical,
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
                                                                                          color: const Color.fromARGB(255, 31, 31, 176),
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
                                                                              style: GoogleFonts.roboto(
                                                                                color: const Color.fromARGB(255, 252, 255, 58),
                                                                                letterSpacing: 3,
                                                                              ),
                                                                            ),
                                                                            const Divider(),
                                                                            documentData['order_placed'] = true
                                                                                ? Text(
                                                                                    'STATUS: Order Placed',
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
                                                                    'order_placed':
                                                                        false,
                                                                    'order_confirmed':
                                                                        true,
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
                                                                              <String, dynamic>{
                                                                            'body':
                                                                                'Your Order: ${documentData['order_code']} is confirmed!',
                                                                          },
                                                                          'priority':
                                                                              'high',
                                                                          'data':
                                                                              <String, dynamic>{
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
                                                                    print(
                                                                        'done');
                                                                  } catch (e) {
                                                                    print(
                                                                        "error push notification");
                                                                  }
                                                                },
                                                                child: Text(
                                                                  'Confirm Order',
                                                                  style:
                                                                      GoogleFonts
                                                                          .roboto(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    color: const Color
                                                                        .fromARGB(
                                                                        255,
                                                                        31,
                                                                        31,
                                                                        176),
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
                                      'Name: ${documentData['order_by_name']}\nTotal Amount: ${totalAmount}',
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
      ),
    );
  }
}
