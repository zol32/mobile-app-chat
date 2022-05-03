import 'package:chat_app/pages/chat_page.dart';
import 'package:chat_app/pages/chatroom_page.dart';
import 'package:chat_app/pages/login_page.dart';
import 'package:chat_app/pages/profile_page.dart';
import 'package:chat_app/pages/register_page.dart';
import 'package:chat_app/pages/search.dart';
import 'package:chat_app/services/auth/auth_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'constants/routes.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Chat App',
      theme: ThemeData(
        primaryColor: Color.fromARGB(255, 80, 20, 158),
        scaffoldBackgroundColor: Color(0xff1F1F1F),
        fontFamily: "OverpassRegular",
        visualDensity: VisualDensity.adaptivePlatformDensity,
        colorScheme: ColorScheme.fromSwatch()
            .copyWith(secondary: Color.fromARGB(255, 143, 143, 143)),
      ),
      home: const HomePage(),
      routes: {
        loginRoute: (context) => const LoginPage(),
        registerRoute: (context) => const RegisterPage(),
        chatPageRoute: (context) => const ChatPage(),
        searchPageRoute: (context) => const SearchPage(),
        profileRoute: (context) => const ProfilePage(),
        chatRoomPageRoute: (context) => ChatRoomPage(
              chatRoomId: '',
            ),
      },
    ),
  );
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: AuthService().initialize(),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.done:
            final user = AuthService().currentUser;
            if (user != null) {
              return const ChatPage();
            } else {
              return const LoginPage();
            }
          default:
            return const CircularProgressIndicator();
        }
      },
    );
  }
}
