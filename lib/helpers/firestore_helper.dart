import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:new_chat_app/modals/chat_Modal.dart';
import 'package:new_chat_app/modals/user_Modal.dart';

class FireStoreHelper {
  FireStoreHelper._();

  static final FireStoreHelper fireStoreHelper = FireStoreHelper._();
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  String usersCollection = "UserData";
  String lastMsg = "lastMsg";

  Future<void> addUserData({required User user}) async {
    UserModal userModal = UserModal(
      email: user.email.toString(),
      userName: user.displayName ?? "NULL",
      Uid: user.uid,
      profilePic: user.photoURL ??
          "https://www.shutterstock.com/image-vector/vector-design-avatar-dummy-sign-600nw-1290556063.jpg",
    );

    DocumentSnapshot<Map<String, dynamic>> userData =
        await firestore.collection(usersCollection).doc(userModal.email).get();

    Map<String, dynamic>? data = userData.data();

    if (data == null) {
      firestore
          .collection(usersCollection)
          .doc(userModal.email)
          .set(userModal.toMap);
    }
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getUserData() {
    return firestore.collection(usersCollection).snapshots();
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> getUserByID(
      {required String email}) async {
    DocumentSnapshot<Map<String, dynamic>> snap =
        await firestore.collection(usersCollection).doc(email).get();

    return snap;
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> getUserDataInStream(
      {required String email}) {
    return firestore.collection(usersCollection).doc(email).snapshots();
  }

  Future<void> updateUserData({required UserModal userModal}) async {
    firestore
        .collection(usersCollection)
        .doc(userModal.email)
        .update(userModal.toMap);
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> getContactList(
      {required String email}) {
    return firestore.collection(usersCollection).doc(email).snapshots();
  }

  Future<List> getContactData({required String email}) async {
    DocumentSnapshot<Map<String, dynamic>> snapshot =
        await firestore.collection(usersCollection).doc(email).get();

    Map data = snapshot.data() as Map;

    return data["contacts"] ?? [];
  }

  Future<void> addContact(
      {required String senderEmail, required String receiverEmail}) async {
    List contacts = await getContactData(email: senderEmail);

    if (!contacts.contains(receiverEmail)) {
      contacts.add(receiverEmail);
      firestore
          .collection(usersCollection)
          .doc(senderEmail)
          .update({"contacts": contacts});
    }

    contacts = await getContactData(email: receiverEmail);

    if (!contacts.contains(senderEmail)) {
      contacts.add(senderEmail);
      firestore
          .collection(usersCollection)
          .doc(receiverEmail)
          .update({"contacts": contacts});
    }
  }

  Future<void> sendMsg({
    required ChatModal chatModal,
    required String senderEmail,
    required String receiverEmail,
  }) async {
    Map<String, dynamic> chat = chatModal.toMap;

    chat.update("type", (value) => "sent");

    await firestore
        .collection(usersCollection)
        .doc(senderEmail)
        .collection(receiverEmail)
        .doc("allChats")
        .collection("chatData")
        .doc(chatModal.time.millisecondsSinceEpoch.toString())
        .set(chat);

    chat.update("type", (value) => "receive");

    await firestore
        .collection(usersCollection)
        .doc(receiverEmail)
        .collection(senderEmail)
        .doc("allChats")
        .collection("chatData")
        .doc(chatModal.time.millisecondsSinceEpoch.toString())
        .set(chat);

    await unseenMsgCount(
      senderEmail: senderEmail,
      receiverEmail: receiverEmail,
    );
  }

  Future<void> deleteMsgEveryone({
    required ChatModal chatModal,
    required String senderEmail,
    required String receiverEmail,
  }) async {
    Map<String, dynamic> chat = chatModal.toMap;

    chat.update("type", (value) => "sent");
    chat.update("msg", (value) => "This message was deleted");

    await firestore
        .collection(usersCollection)
        .doc(senderEmail)
        .collection(receiverEmail)
        .doc("allChats")
        .collection("chatData")
        .doc(chatModal.time.millisecondsSinceEpoch.toString())
        .update(chat);

    chat.update("type", (value) => "receive");
    chat.update("msg", (value) => "This message was deleted");

    await firestore
        .collection(usersCollection)
        .doc(receiverEmail)
        .collection(senderEmail)
        .doc("allChats")
        .collection("chatData")
        .doc(chatModal.time.millisecondsSinceEpoch.toString())
        .update(chat);
  }

  Future<void> deleteMsgMe({
    required ChatModal chatModal,
    required String senderEmail,
    required String receiverEmail,
  }) async {
    Map<String, dynamic> chat = chatModal.toMap;

    chat.update("type", (value) => "sent");
    chat.update("msg", (value) => "This message was deleted");

    await firestore
        .collection(usersCollection)
        .doc(senderEmail)
        .collection(receiverEmail)
        .doc("allChats")
        .collection("chatData")
        .doc(chatModal.time.millisecondsSinceEpoch.toString())
        .update(chat);
  }

  Future<void> editMsg({
    required String newMsg,
    required ChatModal chatModal,
    required String senderEmail,
    required String receiverEmail,
  }) async {
    Map<String, dynamic> chat = chatModal.toMap;

    chat.update("type", (value) => "sent");
    chat.update("msg", (value) => newMsg);

    await firestore
        .collection(usersCollection)
        .doc(senderEmail)
        .collection(receiverEmail)
        .doc("allChats")
        .collection("chatData")
        .doc(chatModal.time.millisecondsSinceEpoch.toString())
        .update(chat);

    chat.update("type", (value) => "receive");
    chat.update("msg", (value) => newMsg);

    await firestore
        .collection(usersCollection)
        .doc(receiverEmail)
        .collection(senderEmail)
        .doc("allChats")
        .collection("chatData")
        .doc(chatModal.time.millisecondsSinceEpoch.toString())
        .update(chat);
  }

  setLastMsg({
    required ChatModal chatModal,
    required String senderEmail,
    required String receiverEmail,
  }) {
    Map<String, dynamic> chat = chatModal.toMap;

    chat.update("type", (value) => "sent");

    firestore
        .collection(usersCollection)
        .doc(senderEmail)
        .collection(receiverEmail)
        .doc(lastMsg)
        .set(chat);

    chat.update("type", (value) => "receive");

    firestore
        .collection(usersCollection)
        .doc(receiverEmail)
        .collection(senderEmail)
        .doc(lastMsg)
        .set(chat);
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getChats(
      {required String senderEmail, required String receiverEmail}) {
    return firestore
        .collection(usersCollection)
        .doc(senderEmail)
        .collection(receiverEmail)
        .doc("allChats")
        .collection("chatData")
        .snapshots();
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> getLastMsg({
    required String senderEmail,
    required String receiverEmail,
  }) {
    return firestore
        .collection(usersCollection)
        .doc(senderEmail)
        .collection(receiverEmail)
        .doc(lastMsg)
        .snapshots();
  }

  Future<void> unseenMsgCount({
    required String senderEmail,
    required String receiverEmail,
  }) async {
    DocumentSnapshot<Map<String, dynamic>> documentSnapshot = await firestore
        .collection(usersCollection)
        .doc(receiverEmail)
        .collection(senderEmail)
        .doc("unseen")
        .get();

    Map<String, dynamic>? data = documentSnapshot.data();

    int count = data!["value"];

    firestore
        .collection(usersCollection)
        .doc(receiverEmail)
        .collection(senderEmail)
        .doc("unseen")
        .set(
      {
        "value": ++count,
      },
    );
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> getunseenCount({
    required String senderEmail,
    required String receiverEmail,
  }) {
    return firestore
        .collection(usersCollection)
        .doc(senderEmail)
        .collection(receiverEmail)
        .doc("unseen")
        .snapshots();
  }

  resetCounter({
    required String senderEmail,
    required String receiverEmail,
  }) async {
    firestore
        .collection(usersCollection)
        .doc(senderEmail)
        .collection(receiverEmail)
        .doc("unseen")
        .set(
      {
        "value": 0,
      },
    );
    firestore
        .collection(usersCollection)
        .doc(receiverEmail)
        .collection(senderEmail)
        .doc("unseen")
        .set(
      {
        "value": 0,
      },
    );
  }
}
