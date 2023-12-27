import 'chat_Modal.dart';

class UserModal {
  String Uid;
  String email;
  String userName;
  String profilePic;

  UserModal({
    required this.email,
    required this.userName,
    required this.Uid,
    required this.profilePic,
  });

  factory UserModal.fromMap({required Map data}) {
    return UserModal(
      Uid: data["Uid"],
      email: data["email"],
      userName: data["userName"],
      profilePic: data["profilePic"],
    );
  }

  Map<String, dynamic> get toMap => {
        "Uid": Uid,
        "email": email,
        "userName": userName,
        "profilePic": profilePic,
      };
}
