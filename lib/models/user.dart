import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String id, username, email, photoURL, displayName, bio;

  User(
      {required this.id,
      required this.username,
      required this.email,
      required this.photoURL,
      required this.displayName,
      required this.bio});

  factory User.fromDocument(DocumentSnapshot doc) {
    return User(
        id: doc['id'],
        username: doc['username'],
        email: doc['email'],
        photoURL: doc['photoURL'],
        displayName: doc['displayName'],
        bio: doc['bio']);
  }
}
