import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:new_chat_app/controller/msgController.dart';
import 'package:new_chat_app/helpers/auth_helper.dart';
import 'package:new_chat_app/helpers/firestore_helper.dart';
import 'package:new_chat_app/modals/chat_Modal.dart';
import 'package:new_chat_app/modals/user_Modal.dart';
import 'package:new_chat_app/utils/colors.util.dart';
import 'package:new_chat_app/views/components/time_component.dart';
import 'package:share_extend/share_extend.dart';

class ChatPage extends StatelessWidget {
  const ChatPage({super.key});

  @override
  Widget build(BuildContext context) {
    UserModal userModal =
        ModalRoute.of(context)!.settings.arguments as UserModal;

    String? senderEmail = AuthHelper.authHelper.firebaseAuth.currentUser?.email;

    TextEditingController msgController = TextEditingController();

    List<ChatModal> allChats = [];

    MsgController msgFun = Get.put(MsgController());

    return Scaffold(
      appBar: AppBar(
        title: Obx(
          () => Visibility(
            visible: !msgFun.msgFun.value,
            child: Row(
              children: [
                CircleAvatar(
                  foregroundImage: NetworkImage(
                    userModal.profilePic,
                  ),
                ),
                const Gap(8),
                Text(
                  userModal.userName,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
          ),
        ),
        actions: [
          Obx(
            () => Visibility(
              visible: msgFun.msgFun.value,
              child: Row(
                children: [
                  IconButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text(
                            "Edit message",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black54,
                            ),
                          ),
                          content: TextFormField(
                            initialValue: allChats[msgFun.msgIndex.value].msg,
                            decoration: const InputDecoration(
                              isDense: true,
                              border: UnderlineInputBorder(),
                            ),
                            onFieldSubmitted: (value) {
                              FireStoreHelper.fireStoreHelper.editMsg(
                                newMsg: value,
                                chatModal: allChats[msgFun.msgIndex.value],
                                senderEmail: senderEmail!,
                                receiverEmail: userModal.email,
                              );
                            },
                          ),
                          actionsAlignment: MainAxisAlignment.center,
                          actions: [
                            OutlinedButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text("Cancel"),
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: MyColor.color1,
                                foregroundColor: MyColor.color3,
                              ),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text("Save"),
                            ),
                          ],
                        ),
                      );
                    },
                    icon: const Icon(Icons.edit),
                  ),
                  IconButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text(
                            "Delete message?",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black54,
                            ),
                          ),
                          content: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              TextButton(
                                onPressed: () {
                                  FireStoreHelper.fireStoreHelper
                                      .deleteMsgEveryone(
                                        chatModal:
                                            allChats[msgFun.msgIndex.value],
                                        senderEmail: senderEmail!,
                                        receiverEmail: userModal.email,
                                      )
                                      .then(
                                        (value) => Navigator.pop(context),
                                      );
                                  Navigator.pop(context);
                                },
                                child: const Text("Delete for everyone"),
                              ),
                              TextButton(
                                onPressed: () {
                                  FireStoreHelper.fireStoreHelper
                                      .deleteMsgMe(
                                        chatModal:
                                            allChats[msgFun.msgIndex.value],
                                        senderEmail: senderEmail!,
                                        receiverEmail: userModal.email,
                                      )
                                      .then(
                                        (value) => Navigator.pop(context),
                                      );
                                  Navigator.pop(context);
                                },
                                child: const Text("Delete for me"),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: const Text("Cancel"),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                    icon: const Icon(Icons.delete),
                  ),
                  IconButton(
                    onPressed: () {
                      Clipboard.setData(
                        ClipboardData(
                            text: allChats[msgFun.msgIndex.value].msg),
                      );
                    },
                    icon: const Icon(Icons.copy),
                  ),
                  IconButton(
                    onPressed: () {
                      ShareExtend.share(
                          allChats[msgFun.msgIndex.value].msg, "text");
                    },
                    icon: const Icon(Icons.share),
                  ),
                ],
              ),
            ),
          )
        ],
        backgroundColor: MyColor.color1,
        foregroundColor: MyColor.color3,
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: NetworkImage(
                'https://i.pinimg.com/564x/e0/0b/9a/e00b9a6bce8958583185fd2b49dd6c74.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: StreamBuilder(
                  stream: FireStoreHelper.fireStoreHelper.getChats(
                      senderEmail: senderEmail.toString(),
                      receiverEmail: userModal.email),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      QuerySnapshot<Map<String, dynamic>>? snaps =
                          snapshot.data;

                      List<QueryDocumentSnapshot> docs = snaps!.docs;

                      List<Map> data =
                          docs.map((e) => e.data() as Map).toList();

                      allChats = data
                          .map(
                            (e) => ChatModal.fromMap(data: e),
                          )
                          .toList();

                      return (allChats.isNotEmpty)
                          ? ListView.builder(
                              itemCount: allChats.length,
                              itemBuilder: (context, index) {
                                ChatModal chat = allChats[index];

                                return Obx(
                                  () => Container(
                                    decoration: BoxDecoration(
                                      color: (msgFun.msgFun.value &&
                                              (index == msgFun.msgIndex.value))
                                          ? Colors.black12
                                          : Colors.transparent,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Row(
                                      mainAxisAlignment: (chat.type == "sent")
                                          ? MainAxisAlignment.end
                                          : MainAxisAlignment.start,
                                      children: [
                                        GestureDetector(
                                          onLongPress: () {
                                            (chat.type == "sent")
                                                ? msgFun.changeValue(
                                                    value: true,
                                                    index: index,
                                                  )
                                                : null;
                                          },
                                          onTap: () {
                                            msgFun.changeValue(
                                              value: false,
                                              index: index,
                                            );
                                          },
                                          child: Container(
                                            padding: const EdgeInsets.all(8),
                                            margin: const EdgeInsets.all(4),
                                            decoration: BoxDecoration(
                                              color: (chat.type == "sent")
                                                  ? MyColor.color1
                                                  : MyColor.color2,
                                              borderRadius: (chat.type ==
                                                      "sent")
                                                  ? const BorderRadius.only(
                                                      topLeft:
                                                          Radius.circular(16),
                                                      topRight:
                                                          Radius.circular(16),
                                                      bottomLeft:
                                                          Radius.circular(16),
                                                    )
                                                  : const BorderRadius.only(
                                                      topLeft:
                                                          Radius.circular(16),
                                                      topRight:
                                                          Radius.circular(16),
                                                      bottomRight:
                                                          Radius.circular(16),
                                                    ),
                                            ),
                                            child: Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.end,
                                              children: [
                                                Text(
                                                  chat.msg,
                                                  style: (chat.msg ==
                                                          "This message was deleted")
                                                      ? TextStyle(
                                                          fontSize: 14,
                                                          fontWeight:
                                                              FontWeight.w400,
                                                          color: (chat.type ==
                                                                  "sent")
                                                              ? Colors.white54
                                                              : Colors.black38,
                                                        )
                                                      : TextStyle(
                                                          fontSize: 14,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          color: (chat.type ==
                                                                  "sent")
                                                              ? MyColor.color2
                                                              : Colors.black,
                                                        ),
                                                ),
                                                const Gap(8),
                                                TimeWidget(
                                                  time: chat.time,
                                                  type: chat.type,
                                                ),
                                                const Gap(4),
                                                (chat.type == "sent")
                                                    ? Icon(
                                                        Icons.done_all,
                                                        size: 16,
                                                        color: MyColor.color3,
                                                      )
                                                    : Container(),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            )
                          : Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset(
                                    "asset/images/mail.png",
                                    scale: 10,
                                  ),
                                  const Text(
                                    "No messages here yet...",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const Gap(12),
                                  const Text(
                                    "Send a message or tap the greeting\nbelow.",
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            );
                    } else {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                  },
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(4),
              decoration: const BoxDecoration(
                color: Colors.white,
              ),
              child: TextFormField(
                controller: msgController,
                onTapOutside: (event) {
                  FocusManager.instance.primaryFocus!.unfocus();
                },
                onFieldSubmitted: (value) {
                  ChatModal chatModal = ChatModal(
                    msg: value,
                    time: DateTime.now(),
                    type: "sender",
                    status: "unseen",
                  );

                  FireStoreHelper.fireStoreHelper.sendMsg(
                    chatModal: chatModal,
                    senderEmail: senderEmail.toString(),
                    receiverEmail: userModal.email,
                  );

                  FireStoreHelper.fireStoreHelper.setLastMsg(
                    chatModal: chatModal,
                    senderEmail: senderEmail.toString(),
                    receiverEmail: userModal.email,
                  );

                  msgController.clear();
                },
                decoration: const InputDecoration(
                  isDense: true,
                  hintText: "Message",
                  hintStyle: TextStyle(
                    fontSize: 16,
                  ),
                  prefixIcon: Icon(
                    Icons.emoji_emotions_outlined,
                    size: 24,
                  ),
                  suffixIcon: Icon(
                    Icons.send,
                    size: 24,
                  ),
                  border: InputBorder.none,
                ),
              ),
            )
          ],
        ),
      ),
      backgroundColor: MyColor.color3,
    );
  }
}
