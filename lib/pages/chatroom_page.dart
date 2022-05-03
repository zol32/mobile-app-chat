import 'dart:developer';
import 'package:chat_app/constants/constants.dart';
import 'package:chat_app/constants/menu_action.dart';
import 'package:chat_app/services/auth/cloud_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ChatRoomPage extends StatefulWidget {
  final String chatRoomId;

  ChatRoomPage({
    required this.chatRoomId,
  });

  @override
  State<ChatRoomPage> createState() => _ChatRoomPageState();
}

class _ChatRoomPageState extends State<ChatRoomPage> {
  late Stream<QuerySnapshot> chats;
  TextEditingController messageEditingController = TextEditingController();
  late TextEditingController _alertController;
  int? rating;

  Widget chatMessages() {
    Query<Map<String, dynamic>> chats = FirebaseFirestore.instance
        .collection("chat_room")
        .doc(widget.chatRoomId)
        .collection("chats")
        .orderBy('time');

    return StreamBuilder<QuerySnapshot>(
      stream: chats.snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return const Text("Something went wrong querying users");
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        log('SNAPSHOT CHAT PAGE');
        return snapshot.hasData
            ? ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  return MessageTile(
                    message: snapshot.data!.docs[index]['message'],
                    sendByMe: Constants.myName ==
                        snapshot.data!.docs[index]['sendBy'],
                  );
                },
              )
            : Container();
      },
    );
  }

  addMessage() {
    if (messageEditingController.text.isNotEmpty) {
      Map<String, dynamic> chatMessageMap = {
        "sendBy": Constants.myName,
        "message": messageEditingController.text,
        'time': DateTime.now().millisecondsSinceEpoch,
      };

      CloudService().addMessage(widget.chatRoomId, chatMessageMap);

      setState(() {
        messageEditingController.text = "";
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _alertController = TextEditingController();
  }

  @override
  void dispose() {
    _alertController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat Page'),
        actions: [
          PopupMenuButton<ChatMenuAction>(
            onSelected: (value) async {
              switch (value) {
                case ChatMenuAction.rate:
                  final rating = await showRatingDialog(context);
                  final ratingInt = int.parse(rating);
                  log('PRIOR TO CLOUDDDDD');
                  if (0 < ratingInt && ratingInt < 6) {
                    log('PRIOR TO CLOUD');
                    log(ratingInt.toString());
                    // setState(() => this.rating = rating);
                    String? ratedUser = CloudService()
                        .getRatedUser(widget.chatRoomId, Constants.myName!);
                    log("RATED USER");
                    log('PRIOR TO CLOUD 3');
                    await CloudService().addRating(ratingInt, ratedUser!);
                    log('1 PRIOR TO CLOUD');
                  }
              }
            },
            itemBuilder: (context) {
              return const [
                PopupMenuItem<ChatMenuAction>(
                  value: ChatMenuAction.rate,
                  child: Text('Rate User'),
                ),
              ];
            },
          )
        ],
      ),
      body: Stack(
        children: [
          chatMessages(),
          Container(
            alignment: Alignment.bottomCenter,
            width: MediaQuery.of(context).size.width,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
              color: const Color(0x54FFFFFF),
              child: Row(
                children: [
                  Expanded(
                      child: TextField(
                    controller: messageEditingController,
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                        hintText: "Message ...",
                        hintStyle: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                        border: InputBorder.none),
                  )),
                  const SizedBox(
                    width: 16,
                  ),
                  GestureDetector(
                    onTap: () {
                      addMessage();
                    },
                    child: Container(
                        height: 40,
                        width: 40,
                        decoration: BoxDecoration(
                            gradient: const LinearGradient(
                                colors: [Color(0x36FFFFFF), Color(0x0FFFFFFF)],
                                begin: FractionalOffset.topLeft,
                                end: FractionalOffset.bottomRight),
                            borderRadius: BorderRadius.circular(40)),
                        padding: const EdgeInsets.all(12),
                        child: Image.asset(
                          "assets/send.png",
                          height: 25,
                          width: 25,
                        )),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  dynamic showRatingDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Rate User Conversation"),
            content: TextField(
              decoration: const InputDecoration(hintText: 'Rate 1 - 5'),
              keyboardType: TextInputType.number,
              controller: _alertController,
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                  child: const Text('Cancel')),
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(_alertController.text);
                  },
                  child: const Text('Submit')),
            ],
          );
        }).then((value) => value ?? false);
  }
}

class MessageTile extends StatelessWidget {
  final String message;
  final bool sendByMe;

  const MessageTile({required this.message, required this.sendByMe});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
          top: 8, bottom: 8, left: sendByMe ? 0 : 24, right: sendByMe ? 24 : 0),
      alignment: sendByMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: sendByMe
            ? const EdgeInsets.only(left: 30)
            : EdgeInsets.only(right: 30),
        padding:
            const EdgeInsets.only(top: 17, bottom: 17, left: 20, right: 20),
        decoration: BoxDecoration(
            borderRadius: sendByMe
                ? const BorderRadius.only(
                    topLeft: Radius.circular(23),
                    topRight: Radius.circular(23),
                    bottomLeft: Radius.circular(23))
                : const BorderRadius.only(
                    topLeft: Radius.circular(23),
                    topRight: Radius.circular(23),
                    bottomRight: Radius.circular(23)),
            gradient: LinearGradient(
              colors: sendByMe
                  ? [const Color(0xff007EF4), const Color(0xff2A75BC)]
                  : [const Color(0x1AFFFFFF), const Color(0x1AFFFFFF)],
            )),
        child: Text(message,
            textAlign: TextAlign.start,
            style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontFamily: 'OverpassRegular',
                fontWeight: FontWeight.w300)),
      ),
    );
  }
}
