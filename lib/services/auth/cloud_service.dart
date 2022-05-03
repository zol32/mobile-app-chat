import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';

class CloudService {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  CollectionReference usersCollection =
      FirebaseFirestore.instance.collection('users');

  Future<dynamic> addUser(
    String username,
    String fullName,
    String email,
  ) {
    return usersCollection
        .add({
          'username': username,
          'full_name': fullName,
          'email': email,
          'reg_datetime': FieldValue.serverTimestamp(),
          'role': 'USER',
        })
        .then((value) => log('USER ADDED'))
        .catchError((error) => error);
  }

  Future<QuerySnapshot> searchByName(String searchField) async {
    return await _firestore
        .collection("users")
        .where('username', isEqualTo: searchField)
        .get();
  }

  Future<void> addChatRoom(chatRoom, chatRoomId) async {
    log('IN ADD CHAT');
    return await _firestore
        .collection("chat_room")
        .doc(chatRoomId)
        .set(chatRoom)
        .catchError((e) {
      print(e);
    });
  }

  Future<QuerySnapshot> getUserInfo(String email) async {
    return await _firestore
        .collection("users")
        .where("email", isEqualTo: email)
        .get()
        .catchError((e) {
      print(e.toString());
    });
  }

  String? getUserID(String username) {
    _firestore
        .collection("users")
        .where("username", isEqualTo: username)
        .get()
        .then((value) {
      return value.docs[0]['uid'];
    });
  }

  String? getUserImg(String username) {
    _firestore
        .collection("users")
        .where("username", isEqualTo: username)
        .get()
        .then((value) {
      return value.docs[0]['img_url'];
    });
  }

  String? getUserFullName(String username) {
    _firestore
        .collection("users")
        .where("username", isEqualTo: username)
        .get()
        .then((value) {
      return value.docs[0]['fullName'];
    });
  }

  int? getUserRating(String username) {
    _firestore
        .collection("users")
        .where("username", isEqualTo: username)
        .get()
        .then((value) {
      return value.docs[0]['rating'];
    });
  }

  void addMessage(String chatRoomId, chatMessageData) {
    _firestore
        .collection("chat_room")
        .doc(chatRoomId)
        .collection("chats")
        .add(chatMessageData)
        .catchError((e) {
      print(e.toString());
    });
  }

  String? getRatedUser(String chatRoomId, String myName) {
    String ratedUser = '';
    _firestore
        .collection('chat_room')
        .doc(chatRoomId)
        .get()
        .then((DocumentSnapshot snapshot) {
      if (snapshot.exists) {
        for (var i in snapshot['users']) {
          if (i != myName) {
            ratedUser = i;
            log(ratedUser);
            return ratedUser;
          }
        }
        return ratedUser;
      } else {
        return ratedUser;
      }
    });
  }

  addRating(int rating, String ratedUser) {
    String uid = getUserID(ratedUser).toString();
    log("UID");
    log(uid);
    log('PASET');
    usersCollection.doc(uid).update({
      "ratings": FieldValue.arrayUnion([rating]),
    }).catchError((e) {
      print(e.toString());
    });
  }
}
