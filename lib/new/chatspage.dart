
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:my_app/consts/consts.dart';
import 'package:my_app/new/comps/styles.dart';
import 'package:my_app/new/comps/widgets.dart';
import 'package:my_app/new/your_path/savedreplies.dart';

class ChatsPage extends StatefulWidget {
  final String id;
  final String name;
  final String senderName;
  final String token;

  const ChatsPage({
    Key? key,
    required this.id,
    required this.name,
    required this.senderName,
    required this.token,
  }) : super(key: key);

  @override
  State<ChatsPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatsPage> {
  var roomId;

    final TextEditingController _privacyController = TextEditingController();

  void handleSave(savedmessage) async {
    String saved = _privacyController.text;

    try {
      
        // If the document doesn't exist, add a new one
        await FirebaseFirestore.instance.collection('SavedReplies').add({
          'saved': savedmessage,
          'saved_date': FieldValue.serverTimestamp(),
        });

         context.showToast(msg: "Saved Successfully");
      
    } catch (e) {
      print(e.toString());
    }
    print('Saved Replies: $savedmessage');
  }


  @override
  Widget build(BuildContext context) {
    final firestore = FirebaseFirestore.instance;
    final currentUserID = FirebaseAuth.instance.currentUser!.uid;
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 4, 83, 158),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 4, 83, 158),
        title: Text(
          'Chat'.toUpperCase(),
          style: GoogleFonts.anton(
            fontSize: 30,
            letterSpacing: 10,
            wordSpacing: 4,
            color: const Color.fromARGB(255, 254, 240, 2),
          ),
        ),
        elevation: 0,
        actions: [
          PopupMenuButton(
            itemBuilder: (context) => [
              PopupMenuItem(
                child: Text('Saved Replies'),
                value: 'SavedReplies',
              ),
            ],
            onSelected: (String value) {
              if (value == 'SavedReplies') {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SavedRepliesPage()),
                );
              }
            },
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(18.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  '${widget.name}'.toUpperCase(),
                  style: GoogleFonts.anton(
                    fontSize: 30,
                    letterSpacing: 10,
                    wordSpacing: 4,
                    color: const Color.fromARGB(255, 254, 240, 2),
                  ),
                ),
                const SizedBox(
                  width: 50,
                )
              ],
            ),
          ),
          Expanded(
            child: Container(
              decoration: Styles.friendsBox(),
              child: StreamBuilder(
                stream: firestore.collection('Rooms').snapshots(),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasData) {
                    if (snapshot.data!.docs.isNotEmpty) {
                      List<QueryDocumentSnapshot?> allData = snapshot
                          .data!.docs
                          .where((element) =>
                              element['users'].contains(widget.id) &&
                              element['users'].contains(currentUserID))
                          .toList();
                      QueryDocumentSnapshot? data =
                          allData.isNotEmpty ? allData.first : null;
                      if (data != null) {
                        roomId = data.id;
                      }
                      return data == null
                          ? Container()
                          : StreamBuilder(
                              stream: data.reference
                                  .collection('messages')
                                  .orderBy('datetime', descending: true)
                                  .snapshots(),
                              builder: (context,
                                  AsyncSnapshot<QuerySnapshot> snap) {
                                return !snap.hasData
                                    ? Container()
                                    : ListView.builder(
                                        itemCount: snap.data!.docs.length,
                                        reverse: true,
                                        itemBuilder: (context, i) {
                                          final messageData =
                                              snap.data!.docs[i].data()
                                                  as Map<String, dynamic>;
                                          final sentBy =
                                              messageData['sent_by'];
                                          final isCurrentUser =
                                              sentBy == currentUserID;
                                          final isAdminMessage =
                                              sentBy == 'admin'; // Assuming admin sends messages with 'admin' as ID
                                          return Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                mainAxisAlignment: isCurrentUser
                                                    ? MainAxisAlignment.end
                                                    : MainAxisAlignment.start,
                                                children: [
                                                  if (!isAdminMessage && isCurrentUser)
                                                    PopupMenuButton(
                                                      iconSize: 20,
                                                      itemBuilder: (context) => [
                                                        PopupMenuItem(
                                                          child: Text('Save'),
                                                          height: 10,
                                                          value: 'Save',
                                                        ),
                                                      ],
                                                      onSelected: (String? value) {
                                                        // Perform action based on the selected value
                                                        if (value == 'Save') {
                                                          var savedmessage = messageData['message'];
                                                          handleSave(savedmessage);
                                                          print(messageData['message']);
                                                        } 
                                                      },
                                                    ),
                                                  Container(
                                                    margin: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                                                    decoration: BoxDecoration(
                                                      color: isCurrentUser ? Colors.blue : Colors.grey,
                                                      borderRadius: BorderRadius.only(
                                                        topLeft: Radius.circular(20),
                                                        topRight: Radius.circular(20),
                                                        bottomLeft: Radius.circular(isCurrentUser ? 20 : 0),
                                                        bottomRight: Radius.circular(isCurrentUser ? 0 : 20),
                                                      ),
                                                    ),
                                                    padding: EdgeInsets.all(10),
                                                    child: Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Text(
                                                          messageData['message'],
                                                          style: TextStyle(
                                                            color: Colors.white,
                                                          ),
                                                        ),
                                                        SizedBox(height: 4),
                                                        Text(
                                                          DateFormat('hh:mm a').format(
                                                            (messageData['datetime'] as Timestamp).toDate(),
                                                          ),
                                                          style: TextStyle(
                                                            color: Colors.white70,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          );
                                        },
                                      );
                              },
                            );
                    } else {
                      return Center(
                        child: Text(
                          'No conversion found',
                          style: Styles.h1().copyWith(
                            color: const Color.fromARGB(255, 4, 83, 158),
                          ),
                        ),
                      );
                    }
                  } else {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: Color.fromARGB(255, 4, 83, 158),
                      ),
                    );
                  }
                },
              ),
            ),
          ),
          Container(
            color: Colors.white,
            child: ChatWidgets.messageField(onSubmit: (controller) async {
              if (controller.text.toString() != '') {
                if (roomId != null) {
                  Map<String, dynamic> data = {
                    'message': controller.text.trim(),
                    'sent_by': currentUserID,
                    'datetime': DateTime.now(),
                  };
                  firestore.collection('Rooms').doc(roomId).update({
                    'last_message_time': DateTime.now(),
                    'last_message': controller.text,
                  });
                  firestore
                      .collection('Rooms')
                      .doc(roomId)
                      .collection('messages')
                      .add(data);
                } else {
                  Map<String, dynamic> data = {
                    'message': controller.text.trim(),
                    'sent_by': currentUserID,
                    'datetime': DateTime.now(),
                  };
                  firestore.collection('Rooms').add({
                    'users': [
                      widget.id,
                      currentUserID,
                    ],
                    'last_message': controller.text,
                    'last_message_time': DateTime.now(),
                  }).then((value) async {
                    value.collection('messages').add(data);
                  });
                }
                try {
                  await http.post(
                    Uri.parse('https://fcm.googleapis.com/fcm/send'),
                    headers: <String, String>{
                      'Content-Type': 'application/json',
                      'Authorization':
                          'key=AAAAS7YKmU4:APA91bEOW9oLuqFcaMPlElfBxx6VniXOG7VoIjtLY6xXkX-Zc6pYd4rNzFwaxen-0WKr-i9dgeEjSju13yFxMDxg8sX3cFk1kv3wQ6ceeNfmZdLon-StvqrwYdu0BNBV5qroS02yIFxX',
                    },
                    body: jsonEncode(
                      <String, dynamic>{
                        'notification': <String, dynamic>{
                          'body': 'New Message: ${controller.text.toString()}',
                          'title': 'From: ${widget.senderName}',
                        },
                        'priority': 'high',
                        'data': <String, dynamic>{
                          'click_action': 'FLUTTER_NOTIFICATION_CLICK',
                          'id': '1',
                          'status': 'done'
                        },
                        "to": widget.token,
                      },
                    ),
                  );
                  print('done');
                } catch (e) {
                  print("error push notification");
                }
              }
              controller.clear();
            }),
          )
        ],
      ),
    );
  }
}