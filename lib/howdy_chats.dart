import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:howdy_chats/screens/chat_screen.dart';
import 'package:howdy_chats/service/websocket_service.dart';

import 'blocs/websocket_bloc.dart';

class HowdyChats extends StatelessWidget {
  const HowdyChats({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<WebSocketBloc>(
          create: (_) => WebSocketBloc(WebSocketServiceImpl()),
        ),
      ],
      child: MaterialApp(
        title: 'HowdyChats',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.teal,
          scaffoldBackgroundColor: Colors.white,
          useMaterial3: true,
        ),
        home: const ChatScreen(),
      ),
    );
  }
}
