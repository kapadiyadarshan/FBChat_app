import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:new_chat_app/helpers/firestore_helper.dart';
import 'package:new_chat_app/modals/user_Modal.dart';
import 'package:new_chat_app/utils/colors.util.dart';
import 'package:new_chat_app/utils/routes_utils.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  build(BuildContext context) {
    User? user = ModalRoute.of(context)!.settings.arguments as User;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Profile",
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: MyColor.color1,
        foregroundColor: MyColor.color3,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: StreamBuilder(
          stream: FireStoreHelper.fireStoreHelper
              .getUserDataInStream(email: user.email!),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              DocumentSnapshot<Map<String, dynamic>> data = snapshot.data!;

              data.data();

              UserModal userModal = UserModal.fromMap(data: data.data()!);

              return Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      CircleAvatar(
                        radius: 100,
                        foregroundImage: NetworkImage(userModal.profilePic),
                      ),
                      IconButton.filled(
                        onPressed: () {},
                        icon: const Icon(Icons.add),
                        iconSize: 40,
                      )
                    ],
                  ),
                  const Gap(18),
                  Card(
                    child: ListTile(
                      title: const Text(
                        "Username",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Text(userModal.userName),
                      leading: const Icon(Icons.person_2),
                      trailing: IconButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                titleTextStyle: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                  color: Colors.black54,
                                ),
                                title: const Text(
                                  "Enter your name",
                                  textAlign: TextAlign.center,
                                ),
                                content: TextFormField(
                                  initialValue: userModal.userName,
                                  textAlign: TextAlign.center,
                                  decoration: const InputDecoration(
                                    isDense: true,
                                    hintText: "Username",
                                    border: UnderlineInputBorder(),
                                  ),
                                  onFieldSubmitted: (value) {
                                    userModal.userName = value;
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
                                      FireStoreHelper.fireStoreHelper
                                          .updateUserData(userModal: userModal)
                                          .then(
                                            (value) => Navigator.pop(context),
                                          );
                                    },
                                    child: const Text("Save"),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        icon: const Icon(
                          Icons.edit,
                        ),
                      ),
                    ),
                  ),
                  const Gap(12),
                  Card(
                    child: ListTile(
                      title: const Text(
                        "Email",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Text(userModal.email),
                      leading: const Icon(Icons.email),
                    ),
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushReplacementNamed(
                        context,
                        MyRoute.HomePage,
                        arguments: user,
                      );
                    },
                    child: Container(
                      height: 50,
                      width: 200,
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: MyColor.color1,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        "Save",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: MyColor.color2,
                        ),
                      ),
                    ),
                  )
                ],
              );
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
      ),
    );
  }
}
