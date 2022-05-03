import 'package:chat_app/constants/constants.dart';
import 'package:chat_app/services/auth/cloud_service.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
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
        title: const Text('Chit Chat Profile'),
      ),
      body: Center(
        child: Column(
          children: const [
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Image(
                  image: NetworkImage(
                      'https://png.pngitem.com/pimgs/s/38-380663_monkey-d-luffy-png-pic-monkey-d-luffy.png')),
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                'Average Ranking',
                style: TextStyle(color: Colors.white, fontSize: 30),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                '4',
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
            )
          ],
        ),
      ),
    );
  }
}
