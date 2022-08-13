import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:homestay/utils/colors.dart';
import 'package:provider/provider.dart';

import '../models/user.dart';
import '../providers/user_provider.dart';
import '../resources/firestore_methods.dart';
import '../utils/utils.dart';

class PostCard extends StatefulWidget {
  final snap;
  final currentUser;
  const PostCard({Key? key, required this.snap, this.currentUser})
      : super(key: key);

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  bool isPressed = false;

  // void hertPressed() {
  //   setState(() {
  //     if (isPressed == false) {
  //       isPressed = true;
  //     } else {
  //       isPressed = false;
  //     }
  //   });
  // }
  void uploadFavourite(String uid) async {
    try {
      String res = await FirestoreMethods().uploadFavourite(
        widget.snap['postId'],
        uid,
      );
      if (res == "success") {
        showSnackBar("Added to Favourite", context);
        setState(() {
          isPressed = true;
        });
      } else {
        showSnackBar(res, context);
      }
    } catch (err) {
      showSnackBar(err.toString(), context);
    }
  }

  Future<void> check(String uid) async {
    final docRef = FirebaseFirestore.instance.collection('favourite');
    final docSnapshot = await docRef.get();
    docSnapshot.docs.forEach((doc) {
      if (doc.get('postId') == widget.snap['postId'] &&
          doc.get('userId') == uid) {
        // showSnackBar("Removed from favourite.", context);
        // docRef.doc(doc.get('favouriteId')).delete();
        setState(() {
          isPressed = true;
        });
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    check(widget.currentUser);
  }

  void hertPressed(String uid) async {
    final docRef = FirebaseFirestore.instance.collection('favourite');
    final docSnapshot = await docRef.get();
    if (docSnapshot.docs.length == 0) {
      uploadFavourite(uid);
    } else if (isPressed == false) {
      uploadFavourite(uid);
    } else {
      docSnapshot.docs.forEach((doc) {
        if (doc.get('postId') == widget.snap['postId'] &&
            doc.get('userId') == uid) {
          showSnackBar("Removed from favourite.", context);
          docRef.doc(doc.get('favouriteId')).delete();
          setState(() {
            isPressed = false;
          });
        }
        // else {
        //   showSnackBar("Different", context);
        //   uploadFavourite(uid);
        //   setState(() {
        //     isPressed = true;
        //   });
        // }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    User user = Provider.of<UserProvider>(context).getUser;
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 20),
      padding: const EdgeInsets.symmetric(
        vertical: 10,
        horizontal: 10,
      ),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 54, 57, 90),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(
                child: Container(
                  height: 200,
                  width: 600,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: NetworkImage(
                        widget.snap['photoUrl'],
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                top: -0,
                right: 10,
                child: IconButton(
                  onPressed: () {
                    hertPressed(user.uid);
                  },
                  icon: Icon(
                    isPressed ? Icons.favorite_rounded : Icons.favorite_outline,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 18,
          ),
          Text(
            '${widget.snap['name']}',
            textAlign: TextAlign.left,
            style: GoogleFonts.poppins(
              textStyle: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: Colors.white),
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          Text(
            "${widget.snap['address']}",
            textAlign: TextAlign.right,
            style: GoogleFonts.poppins(
              textStyle: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: Color.fromRGBO(202, 202, 202, 1),
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            children: [
              Text(
                '${widget.snap['price']}' + '.000',
                textAlign: TextAlign.left,
                style: GoogleFonts.poppins(
                  textStyle: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w400,
                      color: Colors.white),
                ),
              ),
              Text(
                "/night",
                textAlign: TextAlign.left,
                style: GoogleFonts.poppins(
                  textStyle: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w400,
                    color: Color.fromRGBO(202, 202, 202, 1),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
