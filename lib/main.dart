import 'package:flutter/cupertino.dart';
import 'package:movie_chat/router/screens/chat/chat_screen.dart';
import 'package:movie_chat/service_locator.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setupServiceLocator();
  runApp(const MovieChatApp());
}

class MovieChatApp extends StatelessWidget {
  const MovieChatApp({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoApp(title: 'Movies', home: ChatScreen.route());
  }
}
