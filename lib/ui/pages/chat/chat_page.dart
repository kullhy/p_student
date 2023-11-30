import 'package:flutter/material.dart';
import 'package:p_student/common/app_text_styles.dart';
import 'package:p_student/ui/pages/chat/chat_view_model.dart';
import 'package:p_student/ui/pages/chat/chat_widget/chat_widget.dart';
import 'package:p_student/ui/widgets/side_bar.dart';
import 'package:provider/provider.dart';
import 'package:sidebarx/sidebarx.dart';

class ChatPage extends StatelessWidget {
  const ChatPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) {
        return ChatViewModel();
      },
      child: const ChatView(),
    );
  }
}

class ChatView extends StatefulWidget {
  const ChatView({super.key});

  @override
  State<ChatView> createState() => _ChatViewState();
}

class _ChatViewState extends State<ChatView>
    with SingleTickerProviderStateMixin {
  SidebarXController controller = SidebarXController(selectedIndex: 0);
  late var _viewModel = ChatViewModel();

  @override
  void initState() {
    super.initState();
    _viewModel = context.read<ChatViewModel>();
    _viewModel.getStreamContact();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Consumer<ChatViewModel>(
        builder: (context, viewModel, child) {
          if (viewModel.students.isEmpty) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return Row(
              children: [
                MenuSideBar(controller: controller),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "  Tin nhắn",
                      style: AppTextStyle.blackS24Bold,
                    ),
                    Container(
                      margin: const EdgeInsets.all(12),
                      width: 200,
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: viewModel.students.length,
                        itemBuilder: (conntext, index) {
                          return InkWell(
                            onTap: () {
                              _viewModel.setChatUID(
                                  viewModel.students[index].uid ?? "");
                            },
                            child: Container(
                              margin: const EdgeInsets.only(bottom: 12),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  color: Colors.blueAccent.shade100),
                              child: ListTile(
                                title: Text(
                                  viewModel.students[index].name,
                                  style: AppTextStyle.blackS16W800,
                                ),
                                subtitle: Text(
                                  viewModel.students[index].nameClass,
                                  style: AppTextStyle.blackS14w500,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
                _viewModel.uid != ""
                    ? Expanded(child: ChatWidget(viewModel: _viewModel))
                    : Container(),
              ],
            );
          }
        },
      ),
    );
  }
}
