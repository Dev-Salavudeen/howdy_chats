import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/websocket_bloc.dart';
import '../blocs/websocket_event.dart';
import '../blocs/websocket_state.dart';
import '../widgets/message_bubble.dart';
import '../widgets/chat_input_field.dart';
import '../core/constants/app_colors.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _controller = TextEditingController();
  final _scrollController = ScrollController();

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _setSystemUIOverlayStyle();
  }

  void _setSystemUIOverlayStyle() {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        systemNavigationBarColor:
            isDark ? const Color(0xFF121212) : Colors.white,
        systemNavigationBarIconBrightness:
            isDark ? Brightness.light : Brightness.dark,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: const Text("HowdyChats"),
        backgroundColor: AppColors.appBar,
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              color: AppColors.background,
              child: BlocConsumer<WebSocketBloc, WebSocketState>(
                listener: (_, __) => _scrollToBottom(),
                builder: (context, state) {
                  return ListView.builder(
                    controller: _scrollController,
                    itemCount: state.messages.length,
                    itemBuilder: (_, index) {
                      return MessageBubble(message: state.messages[index]);
                    },
                  );
                },
              ),
            ),
          ),
          SafeArea(
            top: false,
            child: ChatInputField(
              controller: _controller,
              onSend: () {
                final text = _controller.text.trim();
                if (text.isNotEmpty) {
                  context.read<WebSocketBloc>().add(SendWebSocketMessage(text));
                  _controller.clear();
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
