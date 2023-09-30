class ChatClass {
  String chatid;
  String createduser;
  String enduser;

  ChatClass({
    required this.chatid,
    required this.createduser,
    required this.enduser,
  });

  factory ChatClass.fromMap(Map<String, dynamic> map) {
    return ChatClass(
      chatid: map['chatid'].toString(),
      createduser: map['createduser'].toString(),
      enduser: map['enduser'].toString(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'chatid': chatid,
      'createduser': createduser,
      'enduser': enduser,
    };
  }
}
