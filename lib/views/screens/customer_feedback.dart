import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class CustomerFeedbackPage extends StatefulWidget {
  const CustomerFeedbackPage({super.key});

  @override
  State<CustomerFeedbackPage> createState() => _CustomerFeedbackPageState();
}

class _CustomerFeedbackPageState extends State<CustomerFeedbackPage> {
  final db = FirebaseFirestore.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 4, 83, 158),
        toolbarHeight: 120,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(50),
              child: Container(
                decoration: const BoxDecoration(color: Colors.white),
                child: const Image(
                  image: ExactAssetImage('assets/images/hgt_logo.png'),
                  height: 100,
                  fit: BoxFit.fill,
                ),
              ),
            ),
            const SizedBox(
              width: 20,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Harry Guantero Trading".toUpperCase(),
                  style: GoogleFonts.anton(
                    fontSize: 30,
                    letterSpacing: 10,
                    wordSpacing: 4,
                    color: const Color.fromARGB(255, 254, 240, 2),
                  ),
                ),
                Text(
                  "M. Revil St. Corner Barrientos St., Poblacion 2, Oroquieta City Misamis Occidental, Philippines",
                  style: GoogleFonts.anton(
                    fontSize: 15,
                    wordSpacing: 4,
                    color: const Color.fromARGB(255, 254, 240, 2),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        child: Container(
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 4, 83, 158),
          ),
          child: Card(
            color: Color.fromARGB(255, 4, 83, 158),
            child: Column(
              children: [
                Text(
                  "Customer Feedback".toUpperCase(),
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
                          .collection('feedback')
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        }

                        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Card(child: const Text('No data available')),
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

                            return SizedBox(
                              child: Card(
                                child: ListTile(
                                  dense: true,
                                  title: Text(
                                    '${documentData['feedback_text']}',
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold),
                                  ),
                                  subtitle: Text(
                                    'From: ${documentData['user']}',
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold),
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
