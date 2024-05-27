import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AboutUsPage extends StatefulWidget {
  const AboutUsPage({Key? key}) : super(key: key);

  @override
  State<AboutUsPage> createState() => _AboutUsPageState();
}

class _AboutUsPageState extends State<AboutUsPage> {
  final TextEditingController _contactNumberController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _facebookController = TextEditingController();
  final TextEditingController _visionController = TextEditingController();
  final TextEditingController _missionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  void _fetchData() async {
  try {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('about')
        .limit(1)
        .get();
    if (querySnapshot.docs.isNotEmpty) {
      var data = querySnapshot.docs.first.data() as Map<String, dynamic>; // Explicit cast
      setState(() {
        _contactNumberController.text = data['contactNumber'] ?? "";
        _emailController.text = data['email'] ?? "";
        _facebookController.text = data['facebook'] ?? "";
        _visionController.text = data['vision'] ?? "";
        _missionController.text = data['mission'] ?? "";
      });
    }
  } catch (e) {
    print(e.toString());
  }
}

  void handleSave(BuildContext context) async {
  String contactNumber = _contactNumberController.text;
  String email = _emailController.text;
  String facebook = _facebookController.text;
  String vision = _visionController.text;
  String mission = _missionController.text;

  try {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('about')
        .limit(1)
        .get();
    if (querySnapshot.docs.isNotEmpty) {
      String docId = querySnapshot.docs.first.id;
      await FirebaseFirestore.instance.collection('about').doc(docId).update({
        'contactNumber': contactNumber,
        'email': email,
        'facebook': facebook,
        'vision': vision,
        'mission': mission,
      });
    } else {
      await FirebaseFirestore.instance.collection('about').add({
        'contactNumber': contactNumber,
        'email': email,
        'facebook': facebook,
        'vision': vision,
        'mission': mission,
      });
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Saved successfully'),
        duration: Duration(seconds: 2),
      ),
    );
  } catch (e) {
    print(e.toString());
  }

  print('Contact Number: $contactNumber');
  print('Email: $email');
  print('Facebook: $facebook');
  print('Vision: $vision');
  print('Mission: $mission');
}

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
            const SizedBox(width: 20),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Harry Guantero Trading".toUpperCase(),
                  style: GoogleFonts.anton(
                    fontSize: 30,
                    letterSpacing: 5,
                    color: const Color.fromARGB(255, 254, 240, 2),
                  ),
                ),
                Text(
                  "M. Revil St. Corner Barrientos St., Poblacion 2, Oroquieta City Misamis Occidental, Philippines",
                  style: GoogleFonts.anton(
                    fontSize: 12,
                    color: const Color.fromARGB(255, 254, 240, 2),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Container(
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 4, 83, 158),
                ),
                child: Card(
                  color: Color.fromARGB(255, 4, 83, 158),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Text(
                            "About Us".toUpperCase(),
                            style: GoogleFonts.anton(
                              fontSize: 30,
                              letterSpacing: 5,
                              color: const Color.fromARGB(255, 254, 240, 2),
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        const SizedBox(height: 4),
                        _buildTextItem("Contact Number"),
                        _buildContactItem("09092890482", _contactNumberController),
                        _buildTextItem("Email Address"),
                        _buildContactItem("hgt.oroquieta@gmail.com", _emailController),
                        _buildTextItem("Visit our Facebook"),
                        _buildContactItem("www.facebook.com/hgtoroquieta", _facebookController),
                        // const SizedBox(height: 5),
                        _buildSectionTitle("Vision"),
                        _buildTextField(_visionController, "Vision"), // Change the color of Vision text to yellow
                        // const SizedBox(height: 5),
                        _buildSectionTitle("Mission"),
                        _buildTextField(_missionController, "Mission"), // Change the color of Mission text to yellow
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: ElevatedButton(
              onPressed: () => handleSave(context), // Pass context here
              child: Text(
                "Save",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              style: ElevatedButton.styleFrom(
                primary: Color.fromARGB(255, 4, 83, 158),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8.0),
    child: Text(
      title.toUpperCase(), // Convert title to uppercase
      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.yellow),
      textAlign: TextAlign.center,
    ),
  );
}
  Widget _buildContactItem(String text, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          hintText: text,
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String labelText) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          hintText: labelText,
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(),
        ),
      ),
    );
  }

  Widget _buildTextItem(String text) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8.0),
    child: Text(
      text.toUpperCase(), // Convert text to uppercase
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: Colors.yellow, // Change the color to black
      ),
    ),
  );
}
}
