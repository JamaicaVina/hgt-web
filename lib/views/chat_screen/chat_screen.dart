import 'package:my_app/consts/consts.dart';
import 'package:my_app/controller/chats_controller.dart';
import 'package:my_app/controller/home_controller.dart';
import 'package:my_app/views/chat_screen/components/sender_bubble.dart';
import 'package:get/get.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Get.lazyPut(() => HomeController());
    var controller = Get.put(ChatsController());

    return Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBar(
        title: "Message".text.fontFamily(semibold).color(darkFontGrey).make(),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            Expanded(
              child: ListView(
                children: [
                  senderBubble(),
                  senderBubble(),
                ],
              ),
            ),
            10.heightBox,
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: controller.msgController,
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(
                          borderSide: BorderSide(color: textfieldGrey),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: textfieldGrey),
                        ),
                        hintText: "Type a message..."),
                  ),
                ),
                IconButton(
                    onPressed: () {
                      controller.sendMsg(controller.msgController.text);
                      controller.msgController.clear();
                    },
                    icon: const Icon(
                      Icons.send,
                      color: redColor,
                    )),
              ],
            )
                .box
                .height(80)
                .color(const Color.fromARGB(255, 4, 83, 158))
                .padding(const EdgeInsets.all(12))
                .margin(const EdgeInsets.only(bottom: 8))
                .make(),
          ],
        ),
      ),
    );
  }
}
