class ChatModal {
  String msg;
  DateTime time;
  String type;
  String status;

  ChatModal(
      {required this.msg,
      required this.time,
      required this.type,
      required this.status});

  factory ChatModal.fromMap({required Map data}) {
    return ChatModal(
      msg: data["msg"],
      time: DateTime.fromMillisecondsSinceEpoch(
        int.parse(data["time"]),
      ),
      type: data["type"],
      status: data["status"],
    );
  }

  Map<String, dynamic> get toMap => {
        "msg": msg,
        "time": time.millisecondsSinceEpoch.toString(),
        "type": type,
        "status": status,
      };
}
