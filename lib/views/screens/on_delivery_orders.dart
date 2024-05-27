import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:my_app/consts/consts.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class OnDeliveryPage extends StatefulWidget {
  const OnDeliveryPage({super.key});

  @override
  State<OnDeliveryPage> createState() => _OnDeliveryPageState();
}

class _OnDeliveryPageState extends State<OnDeliveryPage> {
  DateTime currDay = DateTime.now();
  bool orderConfirmed = true;
  final db = FirebaseFirestore.instance;

  List<String> documentIDs = [];
  List<Future<void>> futures = [];

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
                "Orders On-Delivery".toUpperCase(),
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
                        .where('order_on_delivery', isEqualTo: true)
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
                          var documentData =
                              documents[index].data() as Map<String, dynamic>;
                          var arrayData = documentData['orders'] as List<
                              dynamic>; // Replace 'array_field' with your array field name.
                          String dateToday =
                              '${currDay.day}_${currDay.month}_${currDay.year}';
                          // Process the array data if needed.
                          var totalAmount = NumberFormat.simpleCurrency(
                            locale: 'fil_PH',
                            decimalDigits: 2,
                          ).format(
                            documentData['total_amount'],
                          );
                          String userID = documentData['order_by'];
                          var userToken = '';

                          var token = FirebaseFirestore.instance
                              .collection('users')
                              .doc(userID)
                              .get()
                              .then((value) {
                            userToken = value['user-token'];
                          });
                          List<dynamic>? arrayField = documentData['orders'];
                          List<dynamic> desiredFields = [];
                          if (arrayField != null) {
                            // Assuming the array elements are maps and you want to extract a specific field 'desiredField'
                            desiredFields = arrayField.map((element) {
                              if (element is Map<String, dynamic> &&
                                  element.containsKey('product_id')) {
                                return element['product_id'];
                              }
                              return null; // If 'desiredField' doesn't exist in an array element
                            }).toList();

                            // Now 'desiredFields' contains the values of 'desiredField' from all array elements
                            print(desiredFields);
                          } else {
                            print('Array field is null or empty.');
                          }

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
                                                                              ListView.builder(
                                                                            shrinkWrap:
                                                                                true,
                                                                            itemCount:
                                                                                arrayData.length,
                                                                            itemBuilder:
                                                                                (context, arrayIndex) {
                                                                              var arrayElement = arrayData[arrayIndex];
                                                                              List<String> localDocumentIDs = [
                                                                                arrayElement['product_id']
                                                                              ];
                                                                              documentIDs = localDocumentIDs.toList();

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
                                                                                  'Product: ${arrayData[arrayIndex]['title']}\nQuantity: ${arrayData[arrayIndex]['qty']}\n',
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
                                                                      documentData['order_on_delivery'] = true
                                                                          ? Text(
                                                                              'STATUS: Order On-Delivery',
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
                                                              Color.fromARGB(
                                                                  255,
                                                                  252,
                                                                  255,
                                                                  58),
                                                            ),
                                                          ),
                                                          onPressed: () async {
                                                            await FirebaseFirestore
                                                                .instance
                                                                .collection(
                                                                    'sales')
                                                                .doc(
                                                                    'daily_sales')
                                                                .update({
                                                              dateToday: FieldValue
                                                                  .arrayUnion([
                                                                documentData[
                                                                    'total_amount']
                                                              ])
                                                            });

                                                            await initializeDateFormatting(
                                                                    'en_US',
                                                                    null)
                                                                .then(
                                                              (_) async {
                                                                var now =
                                                                    DateTime
                                                                        .now();
                                                                String
                                                                    monthKey =
                                                                    '${now.month}_${now.year}';

                                                                String yearKey =
                                                                    '${now.year}';
                                                                var firstDayOfWeek =
                                                                    now.subtract(Duration(
                                                                        days: now.weekday -
                                                                            1));
                                                                var lastDayOfWeek =
                                                                    firstDayOfWeek.add(
                                                                        const Duration(
                                                                            days:
                                                                                6));

                                                                print(
                                                                    'First day of the week (Monday): ${DateFormat.yMd().format(firstDayOfWeek)}');
                                                                print(
                                                                    'Date Now: ${DateFormat.yMd().format(now)}');
                                                                print(
                                                                    'Last day of the week (Sunday): ${DateFormat.yMd().format(lastDayOfWeek)}');

                                                                FirebaseFirestore
                                                                    .instance
                                                                    .collection(
                                                                        'sales')
                                                                    .doc(
                                                                        'weekly_sales')
                                                                    .update({
                                                                  '${DateFormat.yMd().format(firstDayOfWeek)}_${DateFormat.yMd().format(lastDayOfWeek)}'
                                                                      .replaceAll(
                                                                          '/',
                                                                          '_'): FieldValue
                                                                      .arrayUnion([
                                                                    documentData[
                                                                        'total_amount']
                                                                  ])
                                                                });
                                                                FirebaseFirestore
                                                                    .instance
                                                                    .collection(
                                                                        'sales')
                                                                    .doc(
                                                                        'monthly_sales')
                                                                    .update({
                                                                  monthKey:
                                                                      FieldValue
                                                                          .arrayUnion([
                                                                    documentData[
                                                                        'total_amount']
                                                                  ])
                                                                });
                                                                FirebaseFirestore
                                                                    .instance
                                                                    .collection(
                                                                        'sales')
                                                                    .doc(
                                                                        'yearly_sales')
                                                                    .update({
                                                                  yearKey:
                                                                      FieldValue
                                                                          .arrayUnion([
                                                                    documentData[
                                                                        'total_amount']
                                                                  ])
                                                                });
                                                              },
                                                            );

                                                            for (String docId
                                                                in desiredFields) {
                                                              var now = DateTime
                                                                  .now();
                                                              String monthKey =
                                                                  '${now.month}_${now.year}';

                                                              DocumentReference
                                                                  docRef =
                                                                  FirebaseFirestore
                                                                      .instance
                                                                      .collection(
                                                                          'products')
                                                                      .doc(
                                                                          docId);
                                                              DocumentSnapshot
                                                                  docSnapshot =
                                                                  await docRef
                                                                      .get();

                                                              if (docSnapshot
                                                                  .exists) {
                                                                Map<String,
                                                                        dynamic>?
                                                                    docData =
                                                                    docSnapshot
                                                                            .data()
                                                                        as Map<
                                                                            String,
                                                                            dynamic>?;

                                                                if (docData !=
                                                                        null &&
                                                                    docData.containsKey(
                                                                        'p_sold') &&
                                                                    docData['p_sold']
                                                                        is Map<
                                                                            String,
                                                                            dynamic>) {
                                                                  Map<String,
                                                                          dynamic>
                                                                      currentMap =
                                                                      Map<String,
                                                                              dynamic>.from(
                                                                          docData[
                                                                              'p_sold']);

                                                                  String
                                                                      keyToUpdate =
                                                                      monthKey;
                                                                  int currentValue = currentMap
                                                                          .containsKey(
                                                                              keyToUpdate)
                                                                      ? currentMap[
                                                                              keyToUpdate]
                                                                          as int
                                                                      : 0;
                                                                  int updatedValue =
                                                                      currentValue +
                                                                          1;

                                                                  currentMap[
                                                                          keyToUpdate] =
                                                                      updatedValue;

                                                                  docRef
                                                                      .update({
                                                                    'p_sold':
                                                                        currentMap,
                                                                  });
                                                                }
                                                              }
                                                            }

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
                                                                  false,
                                                              'order_delivered':
                                                                  true,
                                                            }).then((value) =>
                                                                    Navigator.pop(
                                                                        context));
                                                            try {
                                                              await http.post(
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
                                                                          'Your Order: ${documentData['order_code']} is delivered!',
                                                                    },
                                                                    'priority':
                                                                        'high',
                                                                    'data': <String,
                                                                        dynamic>{
                                                                      'click_action':
                                                                          'FLUTTER_NOTIFICATION_CLICK',
                                                                      'id': '1',
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
                                                          },
                                                          child: Text(
                                                            'Delivered Order',
                                                            style: GoogleFonts
                                                                .roboto(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color: const Color
                                                                  .fromARGB(255,
                                                                  31, 31, 176),
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
                                  title: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Order Code: ${documentData['order_code']}',
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
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
                                                                              child: ListView.builder(
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
                                                                          documentData['order_on_delivery'] = true
                                                                              ? Text(
                                                                                  'STATUS: Order On-Delivery',
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
                                                                        'sales')
                                                                    .doc(
                                                                        'daily_sales')
                                                                    .update({
                                                                  dateToday:
                                                                      FieldValue
                                                                          .arrayUnion([
                                                                    documentData[
                                                                        'total_amount']
                                                                  ]),
                                                                });

                                                                await initializeDateFormatting(
                                                                        'en_US',
                                                                        null)
                                                                    .then(
                                                                  (_) {
                                                                    var now =
                                                                        DateTime
                                                                            .now();
                                                                    String
                                                                        monthKey =
                                                                        '${now.month}_${now.year}';

                                                                    String
                                                                        yearKey =
                                                                        '${now.year}';

                                                                    var firstDayOfWeek =
                                                                        now.subtract(Duration(
                                                                            days:
                                                                                now.weekday - 1));
                                                                    var lastDayOfWeek =
                                                                        firstDayOfWeek.add(const Duration(
                                                                            days:
                                                                                6));

                                                                    print(
                                                                        'First day of the week (Monday): ${DateFormat.yMd().format(firstDayOfWeek)}');
                                                                    print(
                                                                        'Date Now: ${DateFormat.yMd().format(now)}');
                                                                    print(
                                                                        'Last day of the week (Sunday): ${DateFormat.yMd().format(lastDayOfWeek)}');

                                                                    FirebaseFirestore
                                                                        .instance
                                                                        .collection(
                                                                            'sales')
                                                                        .doc(
                                                                            'weekly_sales')
                                                                        .update({
                                                                      '${DateFormat.yMd().format(firstDayOfWeek)}_${DateFormat.yMd().format(lastDayOfWeek)}'
                                                                          .replaceAll(
                                                                              '/',
                                                                              '_'): FieldValue
                                                                          .arrayUnion([
                                                                        documentData[
                                                                            'total_amount']
                                                                      ])
                                                                    });
                                                                    FirebaseFirestore
                                                                        .instance
                                                                        .collection(
                                                                            'sales')
                                                                        .doc(
                                                                            'monthly_sales')
                                                                        .update({
                                                                      monthKey:
                                                                          FieldValue
                                                                              .arrayUnion([
                                                                        documentData[
                                                                            'total_amount']
                                                                      ])
                                                                    });
                                                                    FirebaseFirestore
                                                                        .instance
                                                                        .collection(
                                                                            'sales')
                                                                        .doc(
                                                                            'yearly_sales')
                                                                        .update({
                                                                      yearKey:
                                                                          FieldValue
                                                                              .arrayUnion([
                                                                        documentData[
                                                                            'total_amount']
                                                                      ])
                                                                    });
                                                                  },
                                                                );

                                                                for (String docId
                                                                    in desiredFields) {
                                                                  var now =
                                                                      DateTime
                                                                          .now();
                                                                  String
                                                                      monthKey =
                                                                      '${now.month}_${now.year}';

                                                                  DocumentReference
                                                                      docRef =
                                                                      FirebaseFirestore
                                                                          .instance
                                                                          .collection(
                                                                              'products')
                                                                          .doc(
                                                                              docId);
                                                                  DocumentSnapshot
                                                                      docSnapshot =
                                                                      await docRef
                                                                          .get();

                                                                  if (docSnapshot
                                                                      .exists) {
                                                                    Map<String,
                                                                            dynamic>?
                                                                        docData =
                                                                        docSnapshot.data() as Map<
                                                                            String,
                                                                            dynamic>?;

                                                                    if (docData !=
                                                                            null &&
                                                                        docData.containsKey(
                                                                            'p_sold') &&
                                                                        docData['p_sold'] is Map<
                                                                            String,
                                                                            dynamic>) {
                                                                      Map<String,
                                                                              dynamic>
                                                                          currentMap =
                                                                          Map<String,
                                                                              dynamic>.from(docData['p_sold']);

                                                                      String
                                                                          keyToUpdate =
                                                                          monthKey;
                                                                      int currentValue = currentMap.containsKey(
                                                                              keyToUpdate)
                                                                          ? currentMap[keyToUpdate]
                                                                              as int
                                                                          : 0;
                                                                      int updatedValue =
                                                                          currentValue +
                                                                              1;

                                                                      currentMap[
                                                                              keyToUpdate] =
                                                                          updatedValue;

                                                                      docRef
                                                                          .update({
                                                                        'p_sold':
                                                                            currentMap,
                                                                      });
                                                                    }
                                                                  }
                                                                }

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
                                                                      false,
                                                                  'order_delivered':
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
                                                                            <String,
                                                                                dynamic>{
                                                                          'body':
                                                                              'Your Order: ${documentData['order_code']} is delivered!',
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
                                                              },
                                                              child: Text(
                                                                'Delivered Order',
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
                                      '${documentData['order_by_name']}\nTotal Amount: $totalAmount'),
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
