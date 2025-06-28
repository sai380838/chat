import 'package:chat/chat_bloc.dart';
import 'package:chat/chat_message_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class ChatPage extends StatefulWidget {
  final String currentUser;
  final String peerUser;
  final String receiverToken;

  const ChatPage({
    super.key,
    required this.currentUser,
    required this.peerUser,
    required this.receiverToken,
  });

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    context.read<ChatBloc>().add(LoadMessages(widget.currentUser, widget.peerUser));
    super.initState();
  }

void _send() {
  final text = _controller.text.trim();
  if (text.isEmpty) return;

  final msg = ChatMessage(
    sender: widget.currentUser,
    receiver: widget.peerUser,
    text: text,
    timestamp: DateTime.now(),
  );

  context.read<ChatBloc>().add(SendMessage(msg, widget.receiverToken));
  _controller.clear();
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.peerUser)),
      body: Column(
        children: [
          Expanded(
            child: BlocBuilder<ChatBloc, ChatState>(
              builder: (context, state) {
                if (state is ChatLoading) return Center(child: CircularProgressIndicator());
                if (state is ChatLoaded) {
                  return ListView.builder(
                    itemCount: state.messages.length,
                    itemBuilder: (_, i) {
                      final msg = state.messages[i];
                      final isMe = msg.sender == widget.currentUser;
                      return Align(
                        alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: isMe ? Colors.teal : Colors.grey[300],
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(msg.text),
                        ),
                      );
                    },
                  );
                }
                return Container();
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(hintText: "Type your message..."),
                  ),
                ),
                IconButton(icon: Icon(Icons.send), onPressed: _send)
              ],
            ),
          )
        ],
      ),
    );
  }
}
