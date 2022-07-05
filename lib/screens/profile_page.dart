import 'package:flutter/material.dart';
import 'package:flutter_social_media_app/widgets/header.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: header(context, title: 'Profile'),
      body: Text('Profile'),
    );
  }
}
