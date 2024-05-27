
import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:my_app/new/archivedmessages.dart';
import 'package:my_app/new/chatspage.dart';
import 'package:my_app/views/chat_screen/chat_screen.dart';
import 'your_path/dismissible_message.dart';
import 'comps/styles.dart';
import 'comps/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MessagesPage extends StatefulWidget {
  const MessagesPage({Key? key}) : super(key: key);

  @override
  State<MessagesPage> createState() => _MessagesPage();
}

class _MessagesPage extends State<MessagesPage> {
  String userName = '';
  final StreamController<List<DocumentSnapshot>> _streamController =
      StreamController<List<DocumentSnapshot>>();

  @override
  void initState() {
    super.initState();
    getData();
    fetchRooms();
  }

  @override
  void dispose() {
    _streamController.close();
    super.dispose();
  }

  Future<void> getData() async {
    final userData = await FirebaseFirestore.instance
        .collection('Users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();
    setState(() {
      userName = userData['name'];
    });
  }

  void fetchRooms() {
    FirebaseFirestore.instance
        .collection('Rooms')
        .orderBy('last_message_time', descending: true)
        .snapshots()
        .listen((snapshot) {
      final List<DocumentSnapshot> allRooms = snapshot.docs;
      final Map<String, DocumentSnapshot> userRooms = {};

      // Group messages by users
      allRooms.forEach((room) {
        final List<dynamic> users = room['users'];
        final String roomId = room.id;

        // Sort the users to ensure consistency in key formation
        users.sort();

        // Form a key by concatenating user IDs
        final String key = users.join();

        // Store the room with the key
        userRooms[key] = room;
      });

      // Add grouped rooms to stream
      _streamController.add(userRooms.values.toList());
    });
  }

  final firestore = FirebaseFirestore.instance;
  bool open = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 4, 83, 158),
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
      body: SafeArea(
        child: Stack(
          alignment: AlignmentDirectional.topEnd,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.only(top: 10),
                    decoration: Styles.friendsBox(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 20),
                              child: Text(
                                'Messages',
                                style: Styles.h1().copyWith(
                                  color: const Color.fromARGB(255, 4, 83, 158),
                                ),
                              ),
                            ),
                            TextButton(
                              style: ButtonStyle(
                                foregroundColor: MaterialStateProperty.all<Color>(Colors.blue),
                              ),
                              onPressed: () {
                                Get.to(
                                      () => const ArchivedMessage(),
                                      // arguments: [
                                      //   data[index]['friend_name'],
                                      //   data[index]['fromId']
                                      // ],
                                );
                               },
                              child: Text('Archived Messages'),
                            ),
                          ],
                        ),
                        
                        Expanded(
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 12.0),
                            child: StreamBuilder<List<DocumentSnapshot>>(
                              stream: _streamController.stream,
                              builder: (context, snapshot) {
                                if (!snapshot.hasData) {
                                  return Center(
                                    child: CircularProgressIndicator(),
                                  );
                                }

                                final data = snapshot.data!;
                                

                                return ListView.builder(
                                  itemCount: data.length,
                                  itemBuilder: (context, i) {
                                    final users = data[i]['users'];
                                    final friend = users.where((element) =>
                                        element !=
                                        FirebaseAuth.instance.currentUser!.uid);
                                    final user = friend.isNotEmpty
                                        ? friend.first
                                        : users.where((element) =>
                                            element ==
                                            FirebaseAuth.instance.currentUser!
                                                .uid).first;

                                    return ListTile(
                                      title: FutureBuilder(
                                        future: firestore
                                            .collection('users')
                                            .doc(user)
                                            .get(),
                                        builder: (context,
                                            AsyncSnapshot<DocumentSnapshot>
                                                snap) {
                                          if (!snap.hasData) {
                                            return SizedBox();
                                          }
                                          return Text(snap.data!['name']);
                                        },
                                      ),
                                      subtitle: Text(data[i]['last_message']),
                                      trailing: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          IconButton(
                                            icon: Icon(Icons.archive),
                                            onPressed: () {
                                              _archiveMessage(data[i].reference.id);
                                            },
                                          ),
                                          IconButton(
                                            icon: Icon(Icons.delete),
                                            onPressed: () {
                                              _deleteConfirmationDialog(data[i].id);
                                            },
                                          ),
                                        ],
                                      ),
                                      onTap: () {
                                        Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder: (context) {
                                              return FutureBuilder(
                                                future: firestore
                                                    .collection('users')
                                                    .doc(user)
                                                    .get(),
                                                builder: (context,
                                                    AsyncSnapshot<
                                                            DocumentSnapshot>
                                                        snap) {
                                                  if (!snap.hasData) {
                                                    return SizedBox();
                                                  }
                                                  return ChatsPage(
                                                    senderName: '$userName',
                                                    token: snap.data![
                                                        'user-token'],
                                                    id: user,
                                                    name: snap.data!['name'],
                                                  );
                                                },
                                              );
                                            },
                                          ),
                                        );
                                      },
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
              ],
            ),
            ChatWidgets.searchBar(open)
          ],
        ),
      ),
    );
  }

  void _deleteConfirmationDialog(String roomId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Delete Message"),
          content: Text("Are you sure you want to delete this message?"),
          actions: <Widget>[
            TextButton(
              child: Text("Cancel"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text("Delete"),
              onPressed: () {
                _deleteMessage(roomId);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _deleteMessage(String roomId) async {
    try {
      await FirebaseFirestore.instance
          .collection('Rooms')
          .doc(roomId)
          .delete();
      print("Message deleted successfully");
    } catch (error) {
      print("Failed to delete message: $error");
    }
  }

  void _archiveMessage(String roomId) async {
  try {
    var firestore = FirebaseFirestore.instance;

    // Fetch the room document
    var roomSnapshot = await firestore.collection('Rooms').doc(roomId).get();
    if (!roomSnapshot.exists) {
      print("Room does not exist");
      return;
    }

    // Create a JSON structure for the room document to be archived
    var roomData = {
      'users': roomSnapshot['users'],
      'last_message': roomSnapshot['last_message'],
      // Add other fields you want to archive
    };

    // Archive the room document
    await firestore.collection('ArchivedMessages').doc(roomId).set(roomData);

    // Fetch messages from the room's Messages sub-collection
    var messagesSnapshot = await firestore.collection('Rooms')
        .doc(roomId)
        .collection('messages')
        .get();

    // Archive each message
    for (var messageDoc in messagesSnapshot.docs) {
      await firestore.collection('ArchivedMessages')
          .doc(roomId)
          .collection('messages')
          .doc(messageDoc.id)
          .set(messageDoc.data());
    }

    // Delete the room's Messages sub-collection
    for (var messageDoc in messagesSnapshot.docs) {
      await firestore.collection('Rooms')
          .doc(roomId)
          .collection('messages')
          .doc(messageDoc.id)
          .delete();
    }

    // Delete the room document
    await firestore.collection('Rooms').doc(roomId).delete();

    print("Room and messages archived successfully");
  } catch (error) {
    print("Failed to archive room and messages: $error");
  }
}

  // void _archiveMessage(String roomId) async {
  //   try {
  //     var roomSnapshot = await FirebaseFirestore.instance
  //         .collection('Rooms')
  //         .doc(roomId)
  //         .get();
  //     var jsonData = {
  //       'users': roomSnapshot['users'],
  //       'last_message': roomSnapshot['last_message'],
  //       // Add other fields you want to archive
  //     };

  //     await firestore
  //         .collection('ArchivedMessages')
  //         .doc(roomId)
  //         .set(jsonData)
  //         .then((_) {
  //       return firestore.collection('Rooms').doc(roomId).delete();
  //     });
  //     print("Message archived successfully");
  //   } catch (error) {
  //     print("Failed to archive message: $error");
  //   }
  // }
}



// import 'dart:async';

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:intl/intl.dart';
// import 'package:my_app/new/archivedmessages.dart';
// import 'package:my_app/new/chatspage.dart';
// import 'package:my_app/views/chat_screen/chat_screen.dart';
// import 'your_path/dismissible_message.dart';
// import 'comps/styles.dart';
// import 'comps/widgets.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

// class MessagesPage extends StatefulWidget {
//   const MessagesPage({Key? key}) : super(key: key);

//   @override
//   State<MessagesPage> createState() => _MessagesPage();
// }

// class _MessagesPage extends State<MessagesPage> {
//   String userName = '';
//   final StreamController<List<DocumentSnapshot>> _streamController =
//       StreamController<List<DocumentSnapshot>>();

//   @override
//   void initState() {
//     super.initState();
//     getData();
//     fetchRooms();
//   }

//   @override
//   void dispose() {
//     _streamController.close();
//     super.dispose();
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

//   void fetchRooms() {
//     FirebaseFirestore.instance
//         .collection('Rooms')
//         .orderBy('last_message_time', descending: true)
//         .snapshots()
//         .listen((snapshot) {
//       final List<DocumentSnapshot> allRooms = snapshot.docs;
//       final Map<String, DocumentSnapshot> userRooms = {};

//       // Group messages by users
//       allRooms.forEach((room) {
//         final List<dynamic> users = room['users'];
//         final String roomId = room.id;

//         // Sort the users to ensure consistency in key formation
//         users.sort();

//         // Form a key by concatenating user IDs
//         final String key = users.join();

//         // Store the room with the key
//         userRooms[key] = room;
//       });

//       // Add grouped rooms to stream
//       _streamController.add(userRooms.values.toList());
//     });
//   }

//   final firestore = FirebaseFirestore.instance;
//   bool open = false;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color.fromARGB(255, 4, 83, 158),
//       appBar: AppBar(
//         backgroundColor: const Color.fromARGB(255, 4, 83, 158),
//         toolbarHeight: 120,
//         title: Row(
//           mainAxisAlignment: MainAxisAlignment.start,
//           children: [
//             ClipRRect(
//               borderRadius: BorderRadius.circular(50),
//               child: Container(
//                 decoration: const BoxDecoration(color: Colors.white),
//                 child: const Image(
//                   image: ExactAssetImage('assets/images/hgt_logo.png'),
//                   height: 100,
//                   fit: BoxFit.fill,
//                 ),
//               ),
//             ),
//             const SizedBox(
//               width: 20,
//             ),
//             Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   "Harry Guantero Trading".toUpperCase(),
//                   style: GoogleFonts.anton(
//                     fontSize: 30,
//                     letterSpacing: 10,
//                     wordSpacing: 4,
//                     color: const Color.fromARGB(255, 254, 240, 2),
//                   ),
//                 ),
//                 Text(
//                   "M. Revil St. Corner Barrientos St., Poblacion 2, Oroquieta City Misamis Occidental, Philippines",
//                   style: GoogleFonts.anton(
//                     fontSize: 15,
//                     wordSpacing: 4,
//                     color: const Color.fromARGB(255, 254, 240, 2),
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//       body: SafeArea(
//         child: Stack(
//           alignment: AlignmentDirectional.topEnd,
//           children: [
//             Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Expanded(
//                   child: Container(
//                     margin: const EdgeInsets.only(top: 10),
//                     decoration: Styles.friendsBox(),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Row(
//                           children: [
//                             Padding(
//                               padding: const EdgeInsets.symmetric(
//                                   horizontal: 20, vertical: 20),
//                               child: Text(
//                                 'Messages',
//                                 style: Styles.h1().copyWith(
//                                   color: const Color.fromARGB(255, 4, 83, 158),
//                                 ),
//                               ),
//                             ),
//                             TextButton(
//                               style: ButtonStyle(
//                                 foregroundColor: MaterialStateProperty.all<Color>(Colors.blue),
//                               ),
//                               onPressed: () {
//                                 Get.to(
//                                       () => const ArchivedMessage(),
//                                       // arguments: [
//                                       //   data[index]['friend_name'],
//                                       //   data[index]['fromId']
//                                       // ],
//                                 );
//                                },
//                               child: Text('Archived Messages'),
//                             ),
//                           ],
//                         ),
                        
//                         Expanded(
//                           child: Padding(
//                             padding:
//                                 const EdgeInsets.symmetric(horizontal: 12.0),
//                             child: StreamBuilder<List<DocumentSnapshot>>(
//                               stream: _streamController.stream,
//                               builder: (context, snapshot) {
//                                 if (!snapshot.hasData) {
//                                   return Center(
//                                     child: CircularProgressIndicator(),
//                                   );
//                                 }

//                                 final data = snapshot.data!;
                                

//                                 return ListView.builder(
//                                   itemCount: data.length,
//                                   itemBuilder: (context, i) {
//                                     final users = data[i]['users'];
//                                     final friend = users.where((element) =>
//                                         element !=
//                                         FirebaseAuth.instance.currentUser!.uid);
//                                     final user = friend.isNotEmpty
//                                         ? friend.first
//                                         : users.where((element) =>
//                                             element ==
//                                             FirebaseAuth.instance.currentUser!
//                                                 .uid).first;

//                                     return ListTile(
//                                       title: FutureBuilder(
//                                         future: firestore
//                                             .collection('users')
//                                             .doc(user)
//                                             .get(),
//                                         builder: (context,
//                                             AsyncSnapshot<DocumentSnapshot>
//                                                 snap) {
//                                           if (!snap.hasData) {
//                                             return SizedBox();
//                                           }
//                                           return Text(snap.data!['name']);
//                                         },
//                                       ),
//                                       subtitle: Text(data[i]['last_message']),
//                                       trailing: Row(
//                                         mainAxisSize: MainAxisSize.min,
//                                         children: [
//                                           IconButton(
//                                             icon: Icon(Icons.archive),
//                                             onPressed: () {
//                                               _archiveMessage(data[i].reference.id);
//                                             },
//                                           ),
//                                           IconButton(
//                                             icon: Icon(Icons.delete),
//                                             onPressed: () {
//                                               _deleteConfirmationDialog(data[i].id);
//                                             },
//                                           ),
//                                         ],
//                                       ),
//                                       onTap: () {
//                                         Navigator.of(context).push(
//                                           MaterialPageRoute(
//                                             builder: (context) {
//                                               return FutureBuilder(
//                                                 future: firestore
//                                                     .collection('users')
//                                                     .doc(user)
//                                                     .get(),
//                                                 builder: (context,
//                                                     AsyncSnapshot<
//                                                             DocumentSnapshot>
//                                                         snap) {
//                                                   if (!snap.hasData) {
//                                                     return SizedBox();
//                                                   }
//                                                   return ChatsPage(
//                                                     senderName: '$userName',
//                                                     token: snap.data![
//                                                         'user-token'],
//                                                     id: user,
//                                                     name: snap.data!['name'],
//                                                   );
//                                                 },
//                                               );
//                                             },
//                                           ),
//                                         );
//                                       },
//                                     );
//                                   },
//                                 );
//                               },
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//             ChatWidgets.searchBar(open)
//           ],
//         ),
//       ),
//     );
//   }

//   void _deleteConfirmationDialog(String roomId) {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: Text("Delete Message"),
//           content: Text("Are you sure you want to delete this message?"),
//           actions: <Widget>[
//             TextButton(
//               child: Text("Cancel"),
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//             ),
//             TextButton(
//               child: Text("Delete"),
//               onPressed: () {
//                 _deleteMessage(roomId);
//                 Navigator.of(context).pop();
//               },
//             ),
//           ],
//         );
//       },
//     );
//   }

//   void _deleteMessage(String roomId) async {
//     try {
//       await FirebaseFirestore.instance
//           .collection('Rooms')
//           .doc(roomId)
//           .delete();
//       print("Message deleted successfully");
//     } catch (error) {
//       print("Failed to delete message: $error");
//     }
//   }

//   void _archiveMessage(String roomId) async {
//     try {
//       var roomSnapshot = await FirebaseFirestore.instance
//           .collection('Rooms')
//           .doc(roomId)
//           .get();
//       var jsonData = {
//         'users': roomSnapshot['users'],
//         'last_message': roomSnapshot['last_message'],
//         // Add other fields you want to archive
//       };

//       await firestore
//           .collection('ArchivedMessages')
//           .doc(roomId)
//           .set(jsonData)
//           .then((_) {
//         return firestore.collection('Rooms').doc(roomId).delete();
//       });
//       print("Message archived successfully");
//     } catch (error) {
//       print("Failed to archive message: $error");
//     }
//   }
// }