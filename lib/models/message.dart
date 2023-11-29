class Message {
  final String content;
  final bool isClient;

  Message({required this.content, required this.isClient});

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      content: json['content']['stringValue'] ?? '',
      isClient: json['sender']['stringValue'] == 'client',
    );
  }
}