import 'package:flutter/material.dart';
import 'package:p_student/models/message.dart';
import 'package:p_student/view_model/chat_view_model.dart';
import 'package:provider/provider.dart';

class ChatWidget extends StatefulWidget {
  const ChatWidget({super.key, required this.viewModel});
  final ChatViewModel viewModel;

  @override
  State<ChatWidget> createState() => _ChatWidgetState();
}

class _ChatWidgetState extends State<ChatWidget> {

final TextEditingController _messageController = TextEditingController();

@override
  void initState() {
    widget.viewModel.getChatData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
   return Scaffold(
      appBar: AppBar(title: const Text("ĐOÀN TRƯỜNG")),
      body: Column(
        children: [
          Expanded(
            child: Consumer<ChatViewModel>(builder: (context, viewModel, child) {
                final messages = viewModel.messages;
                return ListView.builder(
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final mes = messages[index];
                    Message message = Message(content: mes.content, isClient: mes.isClient);
                    return _buildMessageWidget(message);
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: const InputDecoration(hintText: 'Type your message...'),
                  ),
                ),
                // IconButton(
                //   icon: const Icon(Icons.send),
                //   onPressed: () async {
                //     await chatProvider.sendMessage(GlobalData.instance.uid!, _messageController.text);
                //     _messageController.clear();
                //   },
                // ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageWidget(Message message) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 20),
    alignment: message.isClient ? Alignment.topRight : Alignment.topLeft,
    child: Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      padding: const EdgeInsets.all(8),
      constraints: BoxConstraints(
        maxWidth: MediaQuery.of(context).size.width * 0.7,
      ),
      decoration: BoxDecoration(
        color: message.isClient ? Colors.blue : Colors.grey,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        message.content,
        style: const TextStyle(color: Colors.white),
      ),
    ),
  );
}
}
