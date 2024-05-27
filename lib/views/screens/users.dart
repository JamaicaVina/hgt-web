import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';

class ViewUserPage extends StatefulWidget {
  const ViewUserPage({Key? key});

  @override
  State<ViewUserPage> createState() => _ViewUserPageState();
}

class _ViewUserPageState extends State<ViewUserPage> {
  List<DataRow> _createRows(QuerySnapshot snapshot) {
    List<DataRow> newList =
        snapshot.docs.map((DocumentSnapshot documentSnapshot) {
      final data = documentSnapshot.data()! as Map<String, dynamic>;

      return DataRow(cells: [
        DataCell(
          Text(
            '${data['id']}',
          ),
        ),
        DataCell(
          Text(
            '${data['name']}'.toUpperCase(),
          ),
        ),
        DataCell(
          Text(
            '${data['email']}',
          ),
        ),
        DataCell(
          Container(
            alignment: Alignment.center, // Center align the text
            child: Text(
              '${data['role']}'.toUpperCase(),
            ),
          ),
        ),
        DataCell(
          Container(
            alignment: Alignment.center, // Center align the button
            child: ElevatedButton(
              onPressed: () {
                _showRemoveDialog(
                  documentSnapshot.id,
                  data['email'],
                );
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(
                  Colors.red, // Change the button color here
                ),
              ),
              child: Text('Remove User'),
            ),
          ),
        ),
      ]);
    }).toList();

    return newList;
  }

  void _showRemoveDialog(String userId, String email) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Remove User'),
          content: Text('Are you sure you want to remove this user?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('No'),
            ),
            TextButton(
              onPressed: () {
                _removeUser(userId, email);
                Navigator.of(context).pop();
              },
              child: Text('Yes'),
            ),
          ],
        );
      },
    );
  }

  void _removeUser(String userId, String email) async {
    try {
      // Step 1: Delete user from Firestore collection
      await FirebaseFirestore.instance.collection('users').doc(userId).delete();

      // Step 2: Delete user account from Firebase Authentication
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null && user.email == email) {
        await user.delete();
      }

      print("User removed successfully");
    } catch (error) {
      print("Failed to remove user: $error");
    }
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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Card(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('users')
                      .snapshots(),
                  builder: (BuildContext context, AsyncSnapshot userSnapshot) {
                    if (userSnapshot.hasData) {
                    return DataTable(
  headingRowHeight: 50, // Adjust the height as needed
  headingRowColor: const MaterialStatePropertyAll(
    Color.fromARGB(255, 4, 83, 158),
  ),
  headingTextStyle: GoogleFonts.roboto(
    fontSize: 17,
    color: const Color.fromARGB(255, 254, 240, 2),
  ),
  border: TableBorder.all(
    width: 1,
    color: Colors.black87,
  ),
  columns: <DataColumn>[
    DataColumn(
      label: Center(
        child: Text(
          'ID',
          style: GoogleFonts.roboto(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      numeric: false,
      tooltip: 'User ID',
      onSort: (int columnIndex, bool ascending) {
        // Implement sorting functionality here
      },
    ),
    DataColumn(
      label: Center(
        child: Text(
          'NAME',
          style: GoogleFonts.roboto(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      numeric: false,
      tooltip: 'User Name',
      onSort: (int columnIndex, bool ascending) {
        // Implement sorting functionality here
      },
    ),
    DataColumn(
      label: Center(
        child: Text(
          'EMAIL',
          style: GoogleFonts.roboto(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      numeric: false,
      tooltip: 'User Email',
      onSort: (int columnIndex, bool ascending) {
        // Implement sorting functionality here
      },
    ),
    DataColumn(
      label: Center(
        child: Text(
          'ROLE',
          style: GoogleFonts.roboto(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      numeric: false,
      tooltip: 'User Role',
      onSort: (int columnIndex, bool ascending) {
        // Implement sorting functionality here
      },
    ),
    DataColumn(
      label: Center(
        child: Text(
          'ACTION',
          style: GoogleFonts.roboto(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      numeric: false,
      tooltip: 'Actions',
      onSort: (int columnIndex, bool ascending) {
        // Implement sorting functionality here
      },
    ),
  ],
  rows: _createRows(userSnapshot.data),
);
                    } else {
                      return const SpinKitCircle(
                        color: Color.fromARGB(255, 4, 83, 158),
                      );
                    }
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
