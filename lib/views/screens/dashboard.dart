import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'package:intl/intl.dart';
import 'package:my_app/services/notif_service.dart';
import 'package:oktoast/oktoast.dart';
import 'package:intl/intl.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  DateTime currDay = DateTime.now();

  static final notifications = NotificationService();

  @override
  void initState() {
    notifications.requestPermission();
    notifications.firebaseNotification(context);

    super.initState();
  }

  Future<void> updateMapFieldInMultipleDocuments() async {
    final CollectionReference collection =
        FirebaseFirestore.instance.collection('collectionName');

    // Get documents and their IDs from Firestore
    QuerySnapshot snapshot = await collection.get();

    // Extract document IDs from the snapshot
    List<String> documentIds = snapshot.docs.map((doc) => doc.id).toList();

    // Create a list to hold all transaction futures
    List<Future<void>> futures = [];

    // Update a specific key in the map field in each document using for loop
    for (String docId in documentIds) {
      Future<void> transactionFuture =
          FirebaseFirestore.instance.runTransaction((transaction) async {
        DocumentReference docRef = collection.doc(docId);
        DocumentSnapshot docSnapshot = await transaction.get(docRef);

        if (docSnapshot.exists) {
          // Get the current map from the document
          Map<String, dynamic>? docData =
              docSnapshot.data() as Map<String, dynamic>?;

          // Check if the field exists and is a map
          if (docData != null &&
              docData.containsKey('yourMapField') &&
              docData['yourMapField'] is Map<String, dynamic>) {
            Map<String, dynamic> currentMap =
                Map<String, dynamic>.from(docData['yourMapField']);

            // Update a specific key in the map or add a new key if it doesn't exist
            String keyToUpdate =
                'specificKey'; // Replace 'specificKey' with your key
            int currentValue = currentMap.containsKey(keyToUpdate)
                ? currentMap[keyToUpdate] as int
                : 0;
            int updatedValue = currentValue + 1;

            // Update the key in the map
            currentMap[keyToUpdate] = updatedValue;

            // Update the map field in Firestore
            transaction.update(docRef, {'yourMapField': currentMap});
          }
        }
      });
      futures.add(transactionFuture);
    }

    // Wait for all transactions to complete
    await Future.wait(futures);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            decoration:
                const BoxDecoration(color: Color.fromARGB(255, 4, 83, 158)),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "dashboard".toUpperCase(),
                    style: GoogleFonts.anton(
                      fontSize: 30,
                      letterSpacing: 5,
                      wordSpacing: 4,
                      color: const Color.fromARGB(255, 254, 240, 2),
                    ),
                  ),
                  const Divider(
                    color: Color.fromARGB(255, 254, 240, 2),
                  ),
                  SizedBox(
                    child: Card(
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: StreamBuilder(
                            stream: FirebaseFirestore.instance
                                .collection('sales')
                                .doc('daily_sales')
                                .snapshots(),
                            builder: (context, snapshot) {
                              if (!snapshot.hasData) {
                                return const Center(
                                    child: CircularProgressIndicator());
                              }

                              String thisDay =
                                  '${currDay.day}_${currDay.month}_${currDay.year}';
                              FirebaseFirestore.instance
                                  .collection('sales')
                                  .doc('daily_sales')
                                  .update(
                                {
                                  thisDay: FieldValue.arrayUnion([0])
                                },
                              );

                              // Get the array from the document data
                              List<dynamic> numbersArray =
                                  snapshot.data![thisDay] ?? [];

                              // Calculate the sum of the numbers
                              double sum = numbersArray.fold(0,
                                  (double currentSum, dynamic number) {
                                return currentSum + (number as double);
                              });

                              var totalAmount = NumberFormat.simpleCurrency(
                                locale: 'fil_PH',
                                decimalDigits: 2,
                              ).format(
                                sum,
                              );
                              final List<FlSpot> dataPoints =
                                  numbersArray.asMap().entries.map((entry) {
                                return FlSpot(entry.key.toDouble(),
                                    entry.value.toDouble());
                              }).toList();

                              return Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    SizedBox(
                                      height: 500,
                                      child: LineChart(
                                        LineChartData(
                                            gridData: const FlGridData(
                                                drawVerticalLine: true,
                                                show: true),
                                            titlesData: const FlTitlesData(
                                              show: true,
                                              bottomTitles: AxisTitles(
                                                sideTitles: SideTitles(
                                                    showTitles: false),
                                              ),
                                              topTitles: AxisTitles(
                                                sideTitles: SideTitles(
                                                    showTitles: false),
                                              ),
                                            ),
                                            borderData:
                                                FlBorderData(show: true),
                                            minX: 0,
                                            maxX:
                                                numbersArray.length.toDouble() -
                                                    1,
                                            minY: 0,
                                            maxY: numbersArray
                                                .reduce((a, b) => a > b ? a : b)
                                                .toDouble(),
                                            lineBarsData: [
                                              LineChartBarData(
                                                spots: dataPoints,
                                                isCurved: true,
                                                color: const Color.fromARGB(
                                                    255, 254, 240, 2),
                                                belowBarData:
                                                    BarAreaData(show: false),
                                                preventCurveOverShooting: true,
                                              )
                                            ]),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      'Total Sales for $thisDay: $totalAmount',
                                      style: GoogleFonts.roboto(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
