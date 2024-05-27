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

class YearlyPage extends StatefulWidget {
  const YearlyPage({super.key});

  @override
  State<YearlyPage> createState() => _YearlyPageState();
}

class _YearlyPageState extends State<YearlyPage> {
  DateTime currDay = DateTime.now();

  static final notifications = NotificationService();

  @override
  void initState() {
    notifications.requestPermission();
    notifications.firebaseNotification(context);

    super.initState();
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
                                .doc('yearly_sales')
                                .snapshots(),
                            builder: (context, snapshot) {
                              if (!snapshot.hasData) {
                                return const Center(
                                    child: CircularProgressIndicator());
                              }
                              var now = DateTime.now();
                              String yearKey = '${now.year}';
                              FirebaseFirestore.instance
                                  .collection('sales')
                                  .doc('yearly_sales')
                                  .update(
                                {
                                  yearKey: FieldValue.arrayUnion([0])
                                },
                              );
                              // Get the array from the document data
                              List<dynamic> numbersArray =
                                  snapshot.data![yearKey] ?? [];

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
                                      'Total Sales for $yearKey: $totalAmount',
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
