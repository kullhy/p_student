class Message {
   String content;
   bool isClient;
   int? createTime;
  Message({required this.content, required this.isClient,this.createTime});

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      content: json['content']['stringValue'] ?? '',
      isClient: json['sender']['stringValue'] == 'client',
    );
  }
}