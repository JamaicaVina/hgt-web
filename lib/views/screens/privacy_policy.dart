import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class PrivacyPolicyPage extends StatefulWidget {
  const PrivacyPolicyPage({Key? key}) : super(key: key);

  @override
  State<PrivacyPolicyPage> createState() => _PrivacyPolicyPageState();
}

class _PrivacyPolicyPageState extends State<PrivacyPolicyPage> {
  final TextEditingController _privacyController = TextEditingController();
  final TextEditingController _updateController = TextEditingController();
  final TextEditingController _welcomeController = TextEditingController();
  final TextEditingController _informationController = TextEditingController();
  final TextEditingController _howtoUseController = TextEditingController();
  final TextEditingController _sharinginfoController = TextEditingController();
  final TextEditingController _securityController = TextEditingController();
  final TextEditingController _contactUsController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  void _fetchData() async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('privacies')
          .limit(1)
          .get();
      if (querySnapshot.docs.isNotEmpty) {
        var data = querySnapshot.docs.first.data() as Map<String, dynamic>; 
        setState(() {
          _privacyController.text = data['privacy'] ?? "";
          _updateController.text = data['update'] ?? "";
          _welcomeController.text = data['welcome'] ?? "";
          _informationController.text = data['information'] ?? "";
          _howtoUseController.text = data['howtoUse'] ?? "";
          _sharinginfoController.text = data['sharinginfo'] ?? "";
          _securityController.text = data['security'] ?? "";
          _contactUsController.text = data['contactUs'] ?? "";
        });
      }
    } catch (e) {
      print(e.toString());
    }
  }

  void handleSave(BuildContext context) async {
    String privacy = _privacyController.text;
    String update = _updateController.text;
    String welcome= _welcomeController.text;
    String information = _informationController.text;
    String howtoUse = _howtoUseController.text;
    String sharinginfo = _sharinginfoController.text;
    String security = _securityController.text;
    String contactUs = _contactUsController.text;
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('privacies')
          .limit(1)
          .get();
      if (querySnapshot.docs.isNotEmpty) {
        String docId = querySnapshot.docs.first.id;
        await FirebaseFirestore.instance.collection('privacies').doc(docId).update({
          'privacy': privacy,
          'update': update,
          'welcome': welcome,
          'information': information,
          'howtoUse': howtoUse,
          'sharinginfo': sharinginfo,
          'security': security,
          'contactUs': contactUs,
        });
      } else {
        await FirebaseFirestore.instance.collection('privacies').add({
          'privacy': privacy,
          'update': update,
          'welcome': welcome,
          'information': information,
          'howtoUse': howtoUse,
          'sharinginfo': sharinginfo,
          'security': security,
          'contactUs': contactUs,
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
    print('Privacy: $privacy');
    print('Update: $update');
    print('Welcome: $welcome');
    print('Information: $information');
    print('HowtoUse: $howtoUse');
    print('Sharinginfo: $sharinginfo');
    print('Security: $security');
    print('ContactUs: $contactUs');
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
                            "PRIVACY POLICY".toUpperCase(), // Capitalized and bolded
                            style: GoogleFonts.anton(
                              fontSize: 30,
                              letterSpacing: 5,
                              color: const Color.fromARGB(255, 254, 240, 2),
                              fontWeight: FontWeight.bold, // Bolded
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        const SizedBox(height: 4),
                        _buildTextItem("Privacy Policy"),
                        _buildContactItem("Privacy Policy of COMPRA SA HGT App", _privacyController),
                        _buildTextItem("Last Updated"),
                        _buildContactItem("Last updated: October 2023", _updateController),
                        _buildTextItem("Welcome to Compra App"),
                        _buildContactItem("Welcome to Client Optimized Management of Products and Retail Application with Systemized Assistant for Harry Guantero Trading – COMPRA SA HGT. At COMPRA SA HGT, we are committed to protecting your privacy. This Privacy Policy outlines how we collect, use, disclose and safeguard your personal information when you visit our website.", _welcomeController),
                        _buildTextItem("Information We Collect"),
                        _buildContactItem("Personal Information: When you create an account or make a purchase, we may collect your name, address, email address, contact number, mode of delivery, feedback and payment information.", _informationController),
                        _buildTextItem("How We Use Your Information"),
                        _buildContactItem(" To provide and maintain our services.", _howtoUseController),
                        _buildTextItem("Sharing your Information"),
                        _buildContactItem("We may share your information with trusted third parties, such as payment processors or service providers, to facilitate our operations. We will never sell your personal information to third parties.", _sharinginfoController),
                        _buildSectionTitle("Security"),
                        _buildTextField(_securityController,"We take reasonable measures to protect your personal information from unauthorized access or disclosure."), // Change the color of Vision text to yellow
                        _buildSectionTitle("Contact Us"),
                        _buildTextField(_contactUsController, "If you have questions or concerns about this Privacy Policy, please Contact Us."), // Change the color of Mission text to yellow
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
              onPressed: () => handleSave(context),
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
        title.toUpperCase(),
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
        maxLines: null,
        keyboardType: TextInputType.multiline,
        decoration: InputDecoration(
          hintText: text,
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(),
          contentPadding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 12.0),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String labelText) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        maxLines: null,
        keyboardType: TextInputType.multiline,
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
        fontWeight: FontWeight.bold, // Set FontWeight.bold for bold text
        color: Colors.yellow,
      ),
    ),
  );
}
}