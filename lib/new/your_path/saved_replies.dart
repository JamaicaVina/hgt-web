// // import 'dart:async';

// // import 'package:cloud_firestore/cloud_firestore.dart';
// // import 'package:firebase_auth/firebase_auth.dart';
// // import 'package:flutter/material.dart';
// // import 'package:get/get.dart';
// // import 'package:google_fonts/google_fonts.dart';
// // import 'package:intl/intl.dart';
// // import 'package:my_app/new/archivedmessages.dart';
// // import 'package:my_app/new/chatspage.dart';
// // import 'package:my_app/views/chat_screen/chat_screen.dart';
// // import 'package:cloud_firestore/cloud_firestore.dart';

// // class SavedRepliesPage extends StatefulWidget {
// //   const SavedRepliesPage({Key? key}) : super(key: key);

// //   @override
// //   State<SavedRepliesPage> createState() => SavedRepliesPage();
// // }

// // class SavedRepliesPage extends State<SavedRepliesPage> {
// //   late String userName;
// //   final StreamController<List<DocumentSnapshot>> _streamController =
// //       StreamController<List<DocumentSnapshot>>();

// //   @override
// //   void initState() {
// //     super.initState();
// //     getData();
// //     fetchRooms();
// //   }

// //   @override
// //   void dispose() {
// //     _streamController.close();
// //     super.dispose();
// //   }

// //   Future<void> getData() async {
// //     final userData = await FirebaseFirestore.instance
// //         .collection('Users')
// //         .doc(FirebaseAuth.instance.currentUser!.uid)
// //         .get();
// //     setState(() {
// //       userName = userData['name'];
// //     });
// //   }

// //   void fetchRooms() {
// //     FirebaseFirestore.instance
// //         .collection('Rooms')
// //         .orderBy('last_message_time', descending: true)
// //         .snapshots()
// //         .listen((snapshot) {
// //       final List<DocumentSnapshot> rooms = snapshot.docs
// //           .where((element) => element['users']
// //               .toString()
// //               .contains(FirebaseAuth.instance.currentUser!.uid))
// //           .toList();
// //       _streamController.add(rooms);
// //     });
// //   }

// //   final firestore = FirebaseFirestore.instance;
// //   bool open = false;

// //   @override
// //   Widget build(BuildContext context) {
// //     return StreamBuilder<QuerySnapshot>(
// //       stream: Firestore.instance.collection("SavedReplies").snapshots(),
// //       builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
// //         if (snapshot.connectionState == ConnectionState.waiting) {
// //           // Show a loading indicator while waiting for data
// //           return Center(child: CircularProgressIndicator());
// //         }
// //         if (snapshot.hasError) {
// //           // Show an error message if there's an error
// //           return Text("Error: ${snapshot.error}");
// //         }
// //         if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
// //           // Show a message if there's no data
// //           return Text("There are no saved replies");
// //         }
// //         // If data is available, display it
// //         return ListView(
// //           children: getSavedRepliesItems(snapshot),
// //         );
// //       },
// //     );
// //   }

// //   List<Widget> getSavedRepliesItems(AsyncSnapshot<QuerySnapshot> snapshot) {
// //     return snapshot.data!.docs.map((doc) {
// //       return ListTile(
// //         title: Text(doc["saved"]),
// //         subtitle: Text(doc["saved_date"].toString()),
// //         // Add any other fields you want to display here
// //       );
// //     }).toList();
// //   }
// // }

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';

// class SavedRepliesPage extends StatefulWidget {
//   const SavedRepliesPage({Key? key}) : super(key: key);

//   @override
//   State<SavedRepliesPage> createState() => _SavedRepliesPageState();
// }

// class _SavedRepliesPageState extends State<SavedRepliesPage> {
//   late String userName;

//   @override
//   void initState() {
//     super.initState();
//     getData();
//   }

//   Future<void> getData() async {
//     final userData = await FirebaseFirestore.instance
//         .collection('Users')
//         .doc(FirebaseAuth.instance.currentUser!.uid)
//         .get();
//     setState(() {
//       userName = userData['name'];
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Saved Replies'),
//       ),
//       body: StreamBuilder<QuerySnapshot>(
//         stream: FirebaseFirestore.instance.collection("SavedReplies").snapshots(),
//         builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return Center(child: CircularProgressIndicator());
//           }
//           if (snapshot.hasError) {
//             return Center(child: Text("Error: ${snapshot.error}"));
//           }
//           if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
//             return Center(child: Text("There are no saved replies"));
//           }
//           return ListView(
//             children: snapshot.data!.docs.map((doc) {
//               return ListTile(
//                 title: Text(doc["saved"]),
//                 subtitle: Text(doc["saved_date"].toString()),
//                 // Add any other fields you want to display here
//               );
//             }).toList(),
//           );
//         },
//       ),
//     );
//   }
// }

