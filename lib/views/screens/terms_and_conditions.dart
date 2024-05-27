import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TermsAndConditionsPage extends StatefulWidget {
  const TermsAndConditionsPage({Key? key}) : super(key: key);

  @override
  State<TermsAndConditionsPage> createState() => _TermsAndConditionsPageState();
}

class _TermsAndConditionsPageState extends State<TermsAndConditionsPage> {
  TextEditingController _termsController = TextEditingController();
  bool _isEditing = false;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    _fetchTerms(); // Fetch terms from Firestore when the page initializes
  }

  Future<void> _fetchTerms() async {
    try {
      // Fetch terms from Firestore
      DocumentSnapshot snapshot = await _firestore.collection('terms_and_conditions').doc('terms').get();
      if (snapshot.exists) {
        setState(() {
          _termsController.text = snapshot['text'] ?? ''; // Set terms from Firestore
        });
      }
    } catch (e) {
      print('Error fetching terms: $e');
    }
  }

  void _toggleEdit() {
    setState(() {
      _isEditing = !_isEditing;
    });
  }

  Future<void> _saveTerms() async {
    try {
      // Update terms in Firestore
      await _firestore.collection('terms_and_conditions').doc('terms').set({'text': _termsController.text});
      // Show snackbar indicating successful save
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Terms saved successfully'),
          duration: Duration(seconds: 2), // Adjust duration as needed
        ),
      );
      print('Terms saved successfully');
    } catch (e) {
      print('Error saving terms: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 4, 83, 158),
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
            Spacer(),
          ],
        ),
      ),
      body: Center(
        child: Stack(
          children: [
            Container(
              padding: EdgeInsets.all(20.0),
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 234, 237, 239),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Card(
                color: Color.fromARGB(255, 4, 83, 158),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(height: 20),
                      Text(
                        "Terms and Conditions".toUpperCase(),
                        style: GoogleFonts.anton(
                          fontSize: 30,
                          letterSpacing: 5,
                          wordSpacing: 4,
                          color: const Color.fromARGB(255, 254, 240, 2),
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 20),
                      Expanded(
                        child: TextField(
                          enabled: _isEditing,
                          controller: _termsController,
                          maxLines: null,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                          textAlign: TextAlign.center,
                          decoration: InputDecoration(
                            hintText: "Enter Terms and Conditions",
                            hintStyle: TextStyle(
                              color: Colors.white.withOpacity(0.5),
                            ),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
            bottom: 200,
            left: 5,
            right: 10,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center, // Center the row horizontally
              children: [
                if (_isEditing)
                  ElevatedButton(
                    onPressed: _saveTerms,
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                        Colors.blue,
                      ),
                    ),
                      child: Text('Save'),
                    ),
                  SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: _toggleEdit,
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                        _isEditing ? Colors.red : Colors.blue, // Change the button color here based on _isEditing state
                      ),
                    ),
                    child: Text(_isEditing ? 'Cancel' : 'Edit'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}