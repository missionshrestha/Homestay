import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:homestay/providers/user_provider.dart';
import 'package:homestay/screens/profile.dart';
import 'package:provider/provider.dart';
import 'package:homestay/models/user.dart' as model;

import 'favourite.dart';
import 'home.dart';
import 'my_order.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String name = "";

  @override
  void initState() {
    super.initState();
    addData();
    pageController = PageController();
  }

  late PageController pageController;
  int _page = 0;

  void navigationTapped(int page) {
    pageController.jumpToPage(page);
  }

  void onPageChanged(int page) {
    setState(() {
      _page = page;
    });
  }

  void addData() async {
    UserProvider _userProvider = Provider.of(context, listen: false);
    await _userProvider.refreshUser();
  }

  // do a onetime read and get a data
  void getName() async {
    DocumentSnapshot snap = await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();

    setState(() {
      name = (snap.data() as Map<String, dynamic>)['name'];
    });
  }

  @override
  void dispose() {
    super.dispose();
    pageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    model.User user = Provider.of<UserProvider>(context).getUser;
    return Scaffold(
        body: PageView(
          children: [
            Home(),
            MyOrder(),
            Favourite(),
            Setting(),
          ],
          controller: pageController,
          onPageChanged: onPageChanged,
        ),
        bottomNavigationBar: CupertinoTabBar(
          items: [
            BottomNavigationBarItem(
              icon: Icon(
                Icons.home,
                color: _page == 0
                    ? const Color.fromRGBO(101, 146, 233, 1)
                    : const Color.fromRGBO(202, 202, 202, 1),
              ),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.list,
                color: _page == 1
                    ? const Color.fromRGBO(101, 146, 233, 1)
                    : const Color.fromRGBO(202, 202, 202, 1),
              ),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.favorite,
                color: _page == 2
                    ? const Color.fromRGBO(101, 146, 233, 1)
                    : const Color.fromRGBO(202, 202, 202, 1),
              ),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.face_rounded,
                color: _page == 3
                    ? const Color.fromRGBO(101, 146, 233, 1)
                    : const Color.fromRGBO(202, 202, 202, 1),
              ),
              label: '',
            ),
            // BottomNavigationBarItem(
            //   icon: Icon(
            //     Icons.settings,
            //     color: _page == 4
            //         ? Color.fromRGBO(101, 146, 233, 1)
            //         : Color.fromRGBO(202, 202, 202, 1),
            //   ),
            //   label: '',
            // ),
          ],
          onTap: navigationTapped,
        ));
  }
}
