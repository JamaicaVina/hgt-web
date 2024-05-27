import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:my_app/consts/consts.dart';
import 'package:my_app/controller/home_controller.dart';
import 'package:my_app/services/firestore_services.dart';
import 'package:my_app/views/chat_screen/chat_screen.dart';
import 'package:my_app/widgets_common/loading_indicator.dart';

class MessagesScreen extends StatelessWidget {
  const MessagesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(() => HomeController());
    return Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBar(
        title:
            "My Message".text.color(darkFontGrey).fontFamily(semibold).make(),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('chats')
            .where('toId', isEqualTo: currentUser!.uid)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: loadingIndicator(),
            );
          } else if (snapshot.data!.docs.isEmpty) {
            return "No messages yet!".text.color(darkFontGrey).makeCentered();
          } else {
            var data = snapshot.data!.docs;
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                        itemCount: data.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Card(
                            child: ListTile(
                              onTap: () {
                                Get.to(
                                  () => const ChatScreen(),
                                  arguments: [
                                    data[index]['friend_name'],
                                    data[index]['fromId']
                                  ],
                                );
                              },
                              leading: const CircleAvatar(
                                backgroundColor: redColor,
                                child: Icon(
                                  Icons.person,
                                  color: whiteColor,
                                ),
                              ),
                              title: "${data[index]['friend_name']}"
                                  .text
                                  .fontFamily(semibold)
                                  .color(darkFontGrey)
                                  .make(),
                              subtitle:
                                  "${data[index]['last_msg']}".text.make(),
                            ),
                          );
                        }),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
