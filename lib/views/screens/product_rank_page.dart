// import 'dart:convert';

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:fl_chart/fl_chart.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_spinkit/flutter_spinkit.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:intl/date_symbol_data_local.dart';

// import 'package:intl/intl.dart';
// import 'package:my_app/services/notif_service.dart';
// import 'package:oktoast/oktoast.dart';
// import 'package:intl/intl.dart';

// class ProductRank extends StatefulWidget {
//   const ProductRank({super.key});

//   @override
//   State<ProductRank> createState() => _ProductRankState();
// }

// class _ProductRankState extends State<ProductRank> {
//   DateTime currDay = DateTime.now();

//   static final notifications = NotificationService();

//   @override
//   void initState() {
//     notifications.requestPermission();
//     notifications.firebaseNotification(context);

//     try {
//       FirebaseMessaging.instance.getToken().then(
//             (token) => FirebaseFirestore.instance
//                 .collection('users')
//                 .doc(FirebaseAuth.instance.currentUser!.uid)
//                 .update(
//               {
//                 'user-token': token,
//               },
//             ),
//           );
//     } catch (e) {
//       showToast('$e'.toString());
//     }

//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SafeArea(
//         child: SingleChildScrollView(
//           child: Container(
//             decoration:
//                 const BoxDecoration(color: Color.fromARGB(255, 4, 83, 158)),
//             child: Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     "dashboard".toUpperCase(),
//                     style: GoogleFonts.anton(
//                       fontSize: 30,
//                       letterSpacing: 5,
//                       wordSpacing: 4,
//                       color: const Color.fromARGB(255, 254, 240, 2),
//                     ),
//                   ),
//                   const Divider(
//                     color: Color.fromARGB(255, 254, 240, 2),
//                   ),
//                   Card(
//                     child: Center(
//                       child: Padding(
//                         padding: const EdgeInsets.all(8.0),
//                         child: StreamBuilder(
//                           stream: FirebaseFirestore.instance
//                               .collection('products')
//                               // .orderBy('p_sold', descending: true)
//                               .orderBy('p_sold.$monthKey', descending: true)

//                               .snapshots(),
//                           builder: (context, snapshot) {
//                             if (!snapshot.hasData) {
//                               return const Center(
//                                   child: CircularProgressIndicator());
//                             }
//                             int itemCount = snapshot.data?.docs.length ?? 0;
//                             var now = DateTime.now();
//                             String monthKey = '${now.month}_${now.year}';

//                             final documents = snapshot.data!.docs;
//                             return ListView.builder(
//                               shrinkWrap: true,
//                               itemCount: documents.length,
//                               itemBuilder: (context, index) {
//                                 final document = documents[index];

//                                 final data = document.data();

//                                 // Map<String, dynamic> mapData =
//                                 //     data['p_sold'] ?? {};
//                                 // var sold = mapData[monthKey];
//                                 Map<String, dynamic>? soldData = data['p_sold'];
//                                 var sold = soldData != null ? soldData[monthKey] ?? 0 : 0;
//                                 int count = index + 1;
//                                 return Padding(
//                                   padding: const EdgeInsets.all(8.0),
//                                   child: Card(
//                                     child: SizedBox(
//                                       child: Column(
//                                         children: [
//                                           Padding(
//                                             padding: const EdgeInsets.symmetric(
//                                                 horizontal: 20),
//                                             child: Row(
//                                               mainAxisAlignment:
//                                                   MainAxisAlignment.spaceAround,
//                                               children: [
//                                                 Text(
//                                                   '$count',
//                                                   style: GoogleFonts.roboto(
//                                                     fontSize: 15,
//                                                     color: const Color.fromARGB(
//                                                         255, 4, 83, 158),
//                                                   ),
//                                                 ),
//                                                 const SizedBox(
//                                                   width: 5,
//                                                 ),
//                                                 SizedBox(
//                                                   height: 80,
//                                                   width: 80,
//                                                   child: Card(
//                                                     child: Image.network(
//                                                       '${data['p_imgs'][0]}',
//                                                       scale: 2,
//                                                       fit: BoxFit.cover,
//                                                     ),
//                                                   ),
//                                                 ),
//                                                 Expanded(
//                                                   child: Row(
//                                                     mainAxisAlignment:
//                                                         MainAxisAlignment
//                                                             .spaceBetween,
//                                                     children: [
//                                                       Text(
//                                                         '${data['p_name']}',
//                                                         style:
//                                                             GoogleFonts.roboto(
//                                                           fontSize: 15,
//                                                           color: const Color
//                                                               .fromARGB(
//                                                               255, 4, 83, 158),
//                                                         ),
//                                                       ),
//                                                       const Divider(
//                                                         thickness: 1,
//                                                         color: Color.fromARGB(
//                                                             255, 4, 83, 158),
//                                                       ),
//                                                       const SizedBox(
//                                                         height: 10,
//                                                       ),
//                                                     ],
//                                                   ),
//                                                 ),
//                                                 Expanded(
//                                                   child: Row(
//                                                     mainAxisAlignment:
//                                                         MainAxisAlignment
//                                                             .spaceEvenly,
//                                                     children: [
//                                                       Text(
//                                                         'Price: ₱${data['p_price']}',
//                                                         style:
//                                                             GoogleFonts.roboto(
//                                                           fontSize: 15,
//                                                           color: const Color
//                                                               .fromARGB(
//                                                               255, 4, 83, 158),
//                                                         ),
//                                                       ),
//                                                       // Text(
//                                                       //   'Quantity: ${data['p_quantity']}',
//                                                       //   style:
//                                                       //       GoogleFonts.roboto(
//                                                       //     fontSize: 15,
//                                                       //     color: const Color
//                                                       //         .fromARGB(
//                                                       //         255, 4, 83, 158),
//                                                       //   ),
//                                                       // ),
//                                                       Text(
//                                                         'Sold($monthKey): $sold',
//                                                         style:
//                                                             GoogleFonts.roboto(
//                                                           fontSize: 15,
//                                                           color: const Color
//                                                               .fromARGB(
//                                                               255, 4, 83, 158),
//                                                         ),
//                                                       ),
//                                                     ],
//                                                   ),
//                                                 ),
//                                               ],
//                                             ),
//                                           ),
//                                         ],
//                                       ),
//                                     ),
//                                   ),
//                                 );
//                               },
//                             );
//                           },
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }





import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProductRank extends StatefulWidget {
  const ProductRank({Key? key}) : super(key: key);

  @override
  State<ProductRank> createState() => _ProductRankState();
}

class _ProductRankState extends State<ProductRank> {
  late String monthKey;

  @override
  void initState() {
    super.initState();
    var now = DateTime.now();
    monthKey = '${now.month}_${now.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            decoration: const BoxDecoration(color: Color.fromARGB(255, 4, 83, 158)),
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
                  Card(
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: StreamBuilder(
                          stream: FirebaseFirestore.instance.collection('products').snapshots(),
                          builder: (context, snapshot) {
                            if (!snapshot.hasData) {
                              return const Center(child: CircularProgressIndicator());
                            }
                            final documents = snapshot.data!.docs;
                            List sortedProducts = documents.map((doc) => doc.data()).toList();
                            sortedProducts.sort((a, b) {
                              var soldA = a['p_sold'][monthKey] ?? 0;
                              var soldB = b['p_sold'][monthKey] ?? 0;
                              return soldB.compareTo(soldA); // Sort in descending order
                            });

                            return ListView.builder(
                              shrinkWrap: true,
                              itemCount: sortedProducts.length,
                              itemBuilder: (context, index) {
                                final data = sortedProducts[index];
                                var sold = data['p_sold'][monthKey] ?? 0;
                                int count = index + 1;
                                return Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Card(
                                    child: SizedBox(
                                      child: Column(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.symmetric(horizontal: 20),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                                              children: [
                                                Text(
                                                  '$count',
                                                  style: GoogleFonts.roboto(
                                                    fontSize: 15,
                                                    color: const Color.fromARGB(255, 4, 83, 158),
                                                  ),
                                                ),
                                                const SizedBox(width: 5),
                                                SizedBox(
                                                  height: 80,
                                                  width: 80,
                                                  child: Card(
                                                    child: Image.network(
                                                      '${data['p_imgs'][0]}',
                                                      scale: 2,
                                                      fit: BoxFit.cover,
                                                    ),
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [
                                                      Text(
                                                        '${data['p_name']}',
                                                        style: GoogleFonts.roboto(
                                                          fontSize: 15,
                                                          color: const Color.fromARGB(255, 4, 83, 158),
                                                        ),
                                                      ),
                                                      const Divider(
                                                        thickness: 1,
                                                        color: Color.fromARGB(255, 4, 83, 158),
                                                      ),
                                                      const SizedBox(height: 10),
                                                    ],
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                    children: [
                                                      Text(
                                                        'Price: ₱${data['p_price']}',
                                                        style: GoogleFonts.roboto(
                                                          fontSize: 15,
                                                          color: const Color.fromARGB(255, 4, 83, 158),
                                                        ),
                                                      ),
                                                      Text(
                                                        'Sold($monthKey): $sold',
                                                        style: GoogleFonts.roboto(
                                                          fontSize: 15,
                                                          color: const Color.fromARGB(255, 4, 83, 158),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
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
