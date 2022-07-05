import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_social_media_app/screens/activity_feed.dart';
import 'package:flutter_social_media_app/screens/create_account.dart';
import 'package:flutter_social_media_app/screens/profile_page.dart';
import 'package:flutter_social_media_app/screens/search_page.dart';
import 'package:flutter_social_media_app/screens/upload_page.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_social_media_app/screens/timeline_page.dart';
import '../models/user.dart';

final GoogleSignIn googleSignIn = GoogleSignIn();
final usersRef = FirebaseFirestore.instance.collection('users');
final DateTime timestamp = DateTime.now();
User? currentUser;

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isAuth = false;
  PageController pageController = PageController();
  int pageIndex = 0;

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    pageController = PageController();

    //Authenticate User when app is opened for first time
    googleSignIn.onCurrentUserChanged.listen(
      (account) {
        print('First');
        handleSignIn(account);
      },
    );

    //Re-authenticate user when app is opened again
    googleSignIn.signInSilently(suppressErrors: false).then((account) {
      print('Second');
      handleSignIn(account);
    });
  }

  handleSignIn(GoogleSignInAccount? account) {
    if (account != null) {
      setState(() {
        createUserInFirestore();
        isAuth = true;
      });
    } else {
      setState(() {
        isAuth = false;
      });
    }
  }

  createUserInFirestore() async {
    print('Create Called');
    // 1) check if user exists in users collection in database (according to their id)
    final GoogleSignInAccount? user = googleSignIn.currentUser;
    DocumentSnapshot doc = await usersRef.doc(user!.id).get();

    if (!doc.exists) {
      // 2) if the user doesn't exist, then we want to take them to the create account page

      // if (!mounted) return;
      final username = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CreateAccount(),
        ),
      );

      // 3) get username from create account, use it to make new user document in users collection
      usersRef.doc(user.id).set({
        "id": user.id,
        "username": username,
        "photoURL": user.photoUrl,
        "email": user.email,
        "displayName": user.displayName,
        "bio": "",
        "timestamp": timestamp
      });
    }
    // print(doc.id);
    doc = await usersRef.doc(user.id).get();
    currentUser = User.fromDocument(doc);
    // print(currentUser);
    print('Hello');
    print(currentUser?.username);
  }

  login() {
    googleSignIn.signIn();
  }

  logout() {
    googleSignIn.signOut();
  }

  onPageChanged(int pageIndex) {
    setState(() {
      this.pageIndex = pageIndex;
    });
  }

  onTap(int pageIndex) {
    pageController.animateToPage(pageIndex,
        duration: Duration(milliseconds: 200), curve: Curves.easeInOut);
  }

  Scaffold buildAuthScreen() {
    //returns a scaffold widget
    return Scaffold(
      body: PageView(
        children: [
          // Timeline(),
          RaisedButton(
            onPressed: logout,
            child: Text('Log Out'),
          ),
          ActivityFeed(),
          Upload(),
          Search(),
          Profile(),
        ],
        controller: pageController,
        onPageChanged: onPageChanged,
        physics: const NeverScrollableScrollPhysics(),
      ),
      bottomNavigationBar: CupertinoTabBar(
        currentIndex: pageIndex,
        onTap: onTap,
        activeColor: Theme.of(context).primaryColor,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.whatshot),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications_active),
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.photo_camera,
              size: 35.0,
            ),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
          ),
        ],
      ),
    );
    // return RaisedButton(
    //   onPressed: logout,
    //   child: Text('Log Out'),
    // );
  }

  buildUnAuthScreen() {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [
              Theme.of(context).primaryColor,
              Theme.of(context).accentColor,
            ],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'FlutterShare',
              style: GoogleFonts.dancingScript(
                color: Colors.white,
                fontSize: 56,
                fontWeight: FontWeight.w400,
              ),
            ),
            GestureDetector(
              onTap: login,
              child: Container(
                width: 290,
                height: 60,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/google_sign.png'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return isAuth ? buildAuthScreen() : buildUnAuthScreen();
  }
}
