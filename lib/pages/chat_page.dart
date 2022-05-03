import 'dart:developer';
import 'package:chat_app/constants/constants.dart';
import 'package:chat_app/helper/helper_functions.dart';
import 'package:chat_app/pages/chatroom_page.dart';
import 'package:chat_app/widgets/custom_app_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:chat_app/constants/routes.dart';
import 'package:chat_app/services/auth/auth_service.dart';
import 'package:chat_app/services/auth/cloud_service.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({Key? key}) : super(key: key);

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  Widget chatRoomsList() {
    Query<Map<String, dynamic>> chats = FirebaseFirestore.instance
        .collection('chat_room')
        .where('users', arrayContains: Constants.myName!);

    return StreamBuilder<QuerySnapshot>(
      stream: chats.snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return const Text("Something went wrong querying users");
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        log("SNAPSHOT 101");
        log(Constants.myName!);
        return snapshot.hasData
            ? ListView.builder(
                itemCount: snapshot.data!.docs.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return ChatRoomsTile(
                    userName: snapshot.data!.docs[index]['chatRoomId']
                        .toString()
                        .replaceAll("_", "")
                        .replaceAll(Constants.myName!, ""),
                    chatRoomId: snapshot.data!.docs[index]['chatRoomId'],
                  );
                })
            : Container();
      },
    );
  }

  @override
  void initState() {
    setUser();
    super.initState();
  }

  setUser() async {
    Constants.myName = await HelperFunctions.getUserNameSharedPreference();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      body: Container(
        child: chatRoomsList(),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.search),
        onPressed: () {
          Navigator.of(context).pushNamed(searchPageRoute);
        },
      ),
    );
  }
}

class ChatRoomsTile extends StatelessWidget {
  final String userName;
  final String chatRoomId;

  ChatRoomsTile({required this.userName, required this.chatRoomId});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ChatRoomPage(
                      chatRoomId: chatRoomId,
                    )));
      },
      child: Container(
        color: Colors.black26,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        child: Row(
          children: [
            Container(
              height: 30,
              width: 30,
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(30)),
              child: Text(userName,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontFamily: 'OverpassRegular',
                      fontWeight: FontWeight.w300)),
            ),
            const SizedBox(
              width: 12,
            ),
            Text(userName,
                textAlign: TextAlign.start,
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontFamily: 'OverpassRegular',
                    fontWeight: FontWeight.w300))
          ],
        ),
      ),
    );
  }
}
