import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:new_chat_app/controller/themeController.dart';
import 'package:new_chat_app/helpers/auth_helper.dart';
import 'package:new_chat_app/helpers/firestore_helper.dart';
import 'package:new_chat_app/modals/chat_Modal.dart';
import 'package:new_chat_app/modals/user_Modal.dart';
import 'package:new_chat_app/utils/colors.util.dart';
import 'package:new_chat_app/utils/routes_utils.dart';
import 'package:new_chat_app/views/components/time_component.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    User? user = AuthHelper.authHelper.firebaseAuth.currentUser!;

    ThemeController themeController = Get.find();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "SociaBay",
          style: GoogleFonts.philosopher(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: MyColor.color3,
          ),
        ),
        centerTitle: true,
        backgroundColor: MyColor.color1,
        foregroundColor: MyColor.color3,
      ),
      drawer: Drawer(
        child: StreamBuilder(
          stream: FireStoreHelper.fireStoreHelper
              .getUserDataInStream(email: user.email!),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              DocumentSnapshot<Map<String, dynamic>>? doc = snapshot.data;

              Map<String, dynamic>? userData = doc!.data();

              return Column(
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        MyRoute.profilePage,
                        arguments: user,
                      );
                    },
                    child: UserAccountsDrawerHeader(
                      accountName: Text(
                        userData?["userName"],
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      accountEmail: Text(userData?["email"]),
                      currentAccountPicture: CircleAvatar(
                        foregroundImage: NetworkImage(
                          userData?["profilePic"] ?? "",
                        ),
                      ),
                    ),
                  ),
                  Obx(
                    () => ElevatedButton.icon(
                      onPressed: () {
                        themeController.changeTheme();

                        debugPrint(themeController.isDark.value.toString());
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: MyColor.color1,
                        foregroundColor: MyColor.color3,
                      ),
                      icon: Icon(
                        themeController.isDark.value
                            ? Icons.light_mode
                            : Icons.dark_mode_outlined,
                      ),
                      label: Text(
                        themeController.isDark.value
                            ? "Light Theme"
                            : "Dark Theme",
                      ),
                    ),
                  ),
                  const Spacer(),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: MyColor.color1,
                      foregroundColor: MyColor.color3,
                    ),
                    onPressed: () {
                      AuthHelper.authHelper.logOut().then(
                            (value) => Navigator.pushReplacementNamed(
                              context,
                              MyRoute.LoginPage,
                            ),
                          );
                    },
                    icon: const Icon(Icons.logout_rounded),
                    label: const Text("LogOut"),
                  ),
                  const Gap(18),
                ],
              );
            } else {
              return const Center();
            }
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Expanded(
              child: StreamBuilder(
                stream: FireStoreHelper.fireStoreHelper
                    .getContactList(email: user.email!),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    DocumentSnapshot<Map<String, dynamic>>? snap =
                        snapshot.data;

                    Map data = snap!.data() as Map;

                    List contacts = data["contacts"] ?? [];

                    return (contacts.isNotEmpty)
                        ? ListView.builder(
                            itemCount: contacts.length,
                            itemBuilder: (context, index) {
                              return StreamBuilder(
                                stream: FireStoreHelper.fireStoreHelper
                                    .getUserDataInStream(
                                        email: contacts[index]),
                                builder: (context, contSnap) {
                                  if (contSnap.hasData) {
                                    DocumentSnapshot<Map<String, dynamic>>?
                                        docs = contSnap.data;

                                    UserModal? userModal;

                                    if (docs != null) {
                                      userModal = UserModal.fromMap(
                                          data: docs.data() as Map);
                                    }

                                    return Card(
                                      elevation: 3,
                                      child: ListTile(
                                        onTap: () {
                                          Navigator.pushNamed(
                                              context, MyRoute.chatPage,
                                              arguments: userModal);

                                          FireStoreHelper.fireStoreHelper
                                              .resetCounter(
                                            senderEmail: AuthHelper.authHelper
                                                .firebaseAuth.currentUser!.email
                                                .toString(),
                                            receiverEmail: userModal!.email,
                                          );
                                        },
                                        title: Text(
                                          userModal!.userName,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        subtitle: StreamBuilder(
                                          stream: FireStoreHelper
                                              .fireStoreHelper
                                              .getLastMsg(
                                                  senderEmail:
                                                      user.email.toString(),
                                                  receiverEmail:
                                                      userModal.email),
                                          builder: (context, snapshot3) {
                                            if (snapshot3.hasData) {
                                              DocumentSnapshot<
                                                      Map<String, dynamic>>?
                                                  data = snapshot3.data;

                                              Map<String, dynamic>? data2 =
                                                  data!.data();

                                              if (data2 != null) {
                                                ChatModal chat =
                                                    ChatModal.fromMap(
                                                  data: data2,
                                                );

                                                return Row(
                                                  children: [
                                                    chat.type == "sent"
                                                        ? const Row(
                                                            children: [
                                                              Icon(
                                                                Icons.done_all,
                                                                size: 18,
                                                              ),
                                                              Gap(4),
                                                            ],
                                                          )
                                                        : const Center(),
                                                    Text(chat.msg),
                                                  ],
                                                );
                                              } else {
                                                return const Text(
                                                  "Click here to start chat..",
                                                  style: TextStyle(
                                                    color: Colors.black54,
                                                  ),
                                                );
                                              }
                                            } else {
                                              return const Text("");
                                            }
                                          },
                                        ),
                                        leading: CircleAvatar(
                                          foregroundImage: NetworkImage(
                                            userModal.profilePic,
                                          ),
                                        ),
                                        trailing: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            StreamBuilder(
                                                stream: FireStoreHelper
                                                    .fireStoreHelper
                                                    .getLastMsg(
                                                  senderEmail:
                                                      user.email.toString(),
                                                  receiverEmail:
                                                      userModal.email,
                                                ),
                                                builder: (context, snapshot5) {
                                                  if (snapshot5.hasData) {
                                                    DocumentSnapshot<
                                                            Map<String,
                                                                dynamic>>?
                                                        data = snapshot5.data;

                                                    Map<String, dynamic>?
                                                        data2 = data!.data();

                                                    if (data2 != null) {
                                                      ChatModal chat =
                                                          ChatModal.fromMap(
                                                        data: data2,
                                                      );

                                                      return homeTimeWidget(
                                                          time: chat.time,
                                                          type: chat.type);
                                                    }
                                                  }
                                                  return Container();
                                                }),
                                            const Gap(4),
                                            SizedBox(
                                              height: 24,
                                              width: 24,
                                              child: StreamBuilder(
                                                stream: FireStoreHelper
                                                    .fireStoreHelper
                                                    .getunseenCount(
                                                        senderEmail: user.email
                                                            .toString(),
                                                        receiverEmail:
                                                            userModal.email),
                                                builder: (context, snapshot4) {
                                                  if (snapshot4.hasData) {
                                                    DocumentSnapshot<
                                                            Map<String,
                                                                dynamic>>?
                                                        document =
                                                        snapshot4.data;

                                                    Map<String, dynamic>?
                                                        data1 =
                                                        document!.data();

                                                    if (data1 != null) {
                                                      return (data1["value"] ==
                                                              0)
                                                          ? Container()
                                                          : Container(
                                                              height: 24,
                                                              width: 24,
                                                              decoration: BoxDecoration(
                                                                  color: MyColor
                                                                      .color1,
                                                                  shape: BoxShape
                                                                      .circle),
                                                              alignment:
                                                                  Alignment
                                                                      .center,
                                                              child: Text(
                                                                data1["value"]
                                                                    .toString(),
                                                                style:
                                                                    TextStyle(
                                                                  fontSize: 14,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  color: MyColor
                                                                      .color3,
                                                                ),
                                                              ),
                                                            );
                                                    } else {
                                                      return Container();
                                                    }
                                                  } else {
                                                    return const Center();
                                                  }
                                                },
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  } else {
                                    return Center(
                                      child: Container(),
                                    );
                                  }
                                },
                              );
                            },
                          )
                        : Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const Spacer(
                                  flex: 2,
                                ),
                                Column(
                                  children: [
                                    Image.asset(
                                      "asset/images/Chat.gif",
                                      scale: 2,
                                    ),
                                    const Text(
                                      "Welcome to SociaBay",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 24,
                                      ),
                                    ),
                                    const Gap(8),
                                    const Text(
                                      "Start messaging by tapping the pencil button in the\nbottom right corner.",
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                                const Spacer(
                                  flex: 3,
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
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            builder: (context) {
              return Container(
                height: 600,
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                child: Column(
                  children: [
                    Container(
                      height: 50,
                      width: 240,
                      decoration: BoxDecoration(
                        color: MyColor.color1,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        "Select Contact",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: MyColor.color2,
                        ),
                      ),
                    ),
                    const Gap(12),
                    Expanded(
                      child: StreamBuilder(
                        stream: FireStoreHelper.fireStoreHelper.getUserData(),
                        builder: (context, snapshot2) {
                          if (snapshot2.hasData) {
                            QuerySnapshot<Map<String, dynamic>>? snap =
                                snapshot2.data;

                            List<QueryDocumentSnapshot> docs = snap!.docs;

                            List<Map> allData =
                                docs.map((e) => e.data() as Map).toList();

                            List<UserModal> allUsers = allData
                                .map(
                                  (e) => UserModal.fromMap(data: e),
                                )
                                .toList();

                            allUsers.removeWhere(
                                (element) => element.Uid == user.uid);

                            return (allUsers.isNotEmpty)
                                ? ListView.builder(
                                    itemCount: allUsers.length,
                                    itemBuilder: (context, index) {
                                      UserModal tempUser = allUsers[index];

                                      return Card(
                                        elevation: 3,
                                        child: ListTile(
                                          onTap: () {
                                            FireStoreHelper.fireStoreHelper
                                                .addContact(
                                                    senderEmail: user.email!,
                                                    receiverEmail:
                                                        tempUser.email)
                                                .then((value) {
                                              Navigator.pushNamed(
                                                context,
                                                MyRoute.chatPage,
                                                arguments: tempUser,
                                              );
                                            });
                                          },
                                          title: Text(tempUser.userName),
                                          subtitle: Text(tempUser.email),
                                          leading: CircleAvatar(
                                            foregroundImage: NetworkImage(
                                                tempUser.profilePic),
                                          ),
                                          trailing: IconButton.filledTonal(
                                            color: MyColor.color1,
                                            onPressed: () {},
                                            icon: const Icon(
                                              Icons.add,
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  )
                                : const Center(
                                    child: CircularProgressIndicator(),
                                  );
                          } else {
                            return const CircularProgressIndicator();
                          }
                        },
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
        backgroundColor: MyColor.color1,
        foregroundColor: MyColor.color3,
        child: const Icon(
          Icons.edit,
        ),
      ),
      backgroundColor: MyColor.color3,
    );
  }
}
