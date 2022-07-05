import 'package:flutter/material.dart';
import 'package:flutter_social_media_app/widgets/header.dart';
import 'package:flutter_social_media_app/widgets/progress.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final usersRef = FirebaseFirestore.instance.collection('users');

class Timeline extends StatefulWidget {
  const Timeline({Key? key}) : super(key: key);

  @override
  _TimelineState createState() => _TimelineState();
}

class _TimelineState extends State<Timeline> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: header(context, title: 'FlutterShare', isApptitle: true),
      body: StreamBuilder<QuerySnapshot>(
        stream: usersRef.snapshots(),
        builder: (context, snapshot) {
          if (snapshot.data == null) {
            return circularProgress();
          } else {
            List<Text> children = snapshot.data!.docs
                .map((doc) => Text(doc['username']))
                .toList();
            return Container(
              child: ListView(
                children: children,
              ),
            );
          }
        },
      ),
    );
  }
}
