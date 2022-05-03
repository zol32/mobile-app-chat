import 'dart:developer';

import 'package:chat_app/constants/constants.dart';
import 'package:chat_app/pages/chatroom_page.dart';
import 'package:chat_app/pages/loading_page.dart';
import 'package:chat_app/services/auth/cloud_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  CloudService _cloudService = CloudService();
  TextEditingController searchEditingController = TextEditingController();
  late QuerySnapshot searchResultSnapshot;

  bool isLoading = false;
  bool haveUserSearched = false;

  initiateSearch() async {
    if (searchEditingController.text.isNotEmpty) {
      setState(() {
        isLoading = true;
      });
      await _cloudService
          .searchByName(searchEditingController.text)
          .then((snapshot) {
        searchResultSnapshot = snapshot;
        print("$searchResultSnapshot");
        setState(() {
          isLoading = false;
          haveUserSearched = true;
        });
      });
    }
  }

  Widget userList() {
    return haveUserSearched
        ? ListView.builder(
            shrinkWrap: true,
            itemCount: searchResultSnapshot.docs.length,
            itemBuilder: (context, index) {
              return userTile(
                searchResultSnapshot.docs[0]['username'],
                searchResultSnapshot.docs[0]['email'],
              );
            })
        : Container();
  }

  sendMessage(String userName) {
    List<String> users = [Constants.myName!, userName];

    String chatRoomId = getChatRoomId(Constants.myName!, userName);
    log('CHAT ROOM');
    log(chatRoomId);

    Map<String, dynamic> chatRoom = {
      "users": users,
      "chatRoomId": chatRoomId,
    };

    _cloudService.addChatRoom(chatRoom, chatRoomId);
    log('CHAT ROOM CREATED');

    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ChatRoomPage(
                  chatRoomId: chatRoomId,
                )));
  }

  Widget userTile(String userName, String userEmail) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                userName,
                style: const TextStyle(color: Colors.white, fontSize: 16),
              ),
              Text(
                userEmail,
                style: const TextStyle(color: Colors.white, fontSize: 16),
              )
            ],
          ),
          const Spacer(),
          GestureDetector(
            onTap: () {
              log('TAP');
              log(Constants.myName!);
              sendMessage(userName);
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                  color: Color.fromARGB(255, 8, 57, 97),
                  borderRadius: BorderRadius.circular(24)),
              child: const Text(
                "Message",
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
          )
        ],
      ),
    );
  }

  getChatRoomId(String a, String b) {
    if (a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)) {
      return "$b\_$a";
    } else {
      return "$a\_$b";
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('Search'),
      ),
      body: isLoading
          ? const LoadingPage()
          : Column(
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  color: const Color.fromARGB(255, 8, 57, 97),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: searchEditingController,
                          style: const TextStyle(color: Colors.white),
                          decoration: const InputDecoration(
                              hintText: "search username ...",
                              hintStyle: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                              border: InputBorder.none),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          initiateSearch();
                        },
                        child: Container(
                            height: 40,
                            width: 40,
                            decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                    colors: [
                                      Color(0x36FFFFFF),
                                      Color(0x0FFFFFFF)
                                    ],
                                    begin: FractionalOffset.topLeft,
                                    end: FractionalOffset.bottomRight),
                                borderRadius: BorderRadius.circular(40)),
                            padding: const EdgeInsets.all(12),
                            child: Image.asset(
                              'assets/search.png',
                              height: 25,
                              width: 25,
                            )),
                      )
                    ],
                  ),
                ),
                userList(),
              ],
            ),
    );
  }
}
