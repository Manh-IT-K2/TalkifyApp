class MessageModel {
  final String message;
  final String sender;
  final String receiver;
  final String? messageId;
  final DateTime timestamp;
  final bool isSeenByRecevier;
  final bool? isImage;

  MessageModel(
      {required this.message,
      required this.sender,
      required this.receiver,
      this.messageId,
      required this.timestamp,
      required this.isSeenByRecevier,
      this.isImage});

  // that will convert document model to message model
  factory MessageModel.fromMap(Map<String, dynamic> map){
    return MessageModel(
      message: map["message"], 
      sender: map["senderId"], 
      receiver: map["receiverId"], 
      timestamp: DateTime.parse(map["timestamp"]), 
      messageId: map["\$id"],
      isImage: map["isImage"],
      isSeenByRecevier: map["isSeenByRecevier"]);
  }
}
