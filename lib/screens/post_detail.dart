import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:homestay/resources/firestore_methods.dart';
import 'package:homestay/screens/booking_screen.dart';
import 'package:homestay/screens/my_order.dart';
import 'package:homestay/utils/utils.dart';
// import 'package:latlng/latlng.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';

import '../models/user.dart';
import '../providers/user_provider.dart';

class PostDetail extends StatefulWidget {
  final snap;
  final currentUser;
  const PostDetail({Key? key, required this.snap, this.currentUser})
      : super(key: key);

  @override
  State<PostDetail> createState() => _PostDetailState();
}

class _PostDetailState extends State<PostDetail> {
  bool isPressed = false;
  bool _isLoading = false;

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

  void decreaseRoomNo() async {
    if (double.parse(widget.snap['noOfRooms']) > 0.0) {
      await FirebaseFirestore.instance
          .collection('post')
          .doc(widget.snap['postId'])
          .update({
        'noOfRooms': double.parse(widget.snap['noOfRooms']).toInt() - 1
      });
    }
  }

  void uploadBooking(String uid) async {
    try {
      String res = await FirestoreMethods().uploadBooking(
        widget.snap['postId'],
        uid,
      );
      if (res == "success") {
        showSnackBar("Booked", context);
        decreaseRoomNo();
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
    // setState(() {
    //   if (isPressed == false) {
    //     isPressed = true;
    //   } else {
    //     isPressed = false;
    //   }
    // });

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
      });
    }
  }

  void navigateToBooking() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => BookingScreen(),
      ),
    );
  }

  void bookRoom(String uid) async {
    final docRef = FirebaseFirestore.instance.collection('booking');
    final docSnapshot = await docRef.get();
    if (docSnapshot.docs.length == 0) {
      uploadBooking(uid);
    } else {
      docSnapshot.docs.forEach((doc) {
        if (doc.get('postId') == widget.snap['postId'] &&
            doc.get('userId') == uid) {
          showSnackBar("Already Booked", context);
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => MyOrder(
                currentUser: uid,
              ),
            ),
          );
        }
      });
    }
  }

  // stringToList(String temp) {
  //   temp.split(',').forEach(
  //     (element) {
  //       Text(
  //         '${element}',
  //         textAlign: TextAlign.left,
  //         style: GoogleFonts.poppins(
  //           textStyle: const TextStyle(
  //               fontSize: 14,
  //               fontWeight: FontWeight.w400,
  //               color: Color.fromARGB(255, 210, 198, 198)),
  //         ),
  //       );
  //     },
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    User user = Provider.of<UserProvider>(context).getUser;

    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.snap['name']}'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.symmetric(
              vertical: 10,
              horizontal: 15,
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
                          isPressed
                              ? Icons.favorite_rounded
                              : Icons.favorite_outline,
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
                        fontSize: 22,
                        fontWeight: FontWeight.w600,
                        color: Colors.white),
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                Row(
                  children: [
                    const Icon(Icons.my_location_rounded),
                    SizedBox(
                      width: 5,
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
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    Text(
                      'NRS ' + '${widget.snap['price']}' + '.000',
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
                const SizedBox(
                  height: 18,
                ),
                Text(
                  'Description',
                  textAlign: TextAlign.left,
                  style: GoogleFonts.poppins(
                    textStyle: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: Colors.white),
                  ),
                ),
                const SizedBox(
                  height: 8,
                ),
                Text(
                  '${widget.snap['description']}',
                  textAlign: TextAlign.left,
                  style: GoogleFonts.poppins(
                    textStyle: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: Color.fromARGB(255, 210, 198, 198)),
                  ),
                ),
                const SizedBox(
                  height: 18,
                ),
                Text(
                  'Facility',
                  textAlign: TextAlign.left,
                  style: GoogleFonts.poppins(
                    textStyle: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: Colors.white),
                  ),
                ),
                const SizedBox(
                  height: 8,
                ),
                Text(
                  '${widget.snap['facilities'].split(',').join('  - ')}',
                  textAlign: TextAlign.left,
                  style: GoogleFonts.poppins(
                    textStyle: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: Color.fromARGB(255, 210, 198, 198),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 18,
                ),
                Text(
                  'No of Rooms Available:',
                  textAlign: TextAlign.left,
                  style: GoogleFonts.poppins(
                    textStyle: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: Colors.white),
                  ),
                ),
                const SizedBox(
                  height: 8,
                ),
                Text(
                  '${widget.snap['noOfRooms']}',
                  textAlign: TextAlign.left,
                  style: GoogleFonts.poppins(
                    textStyle: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: Color.fromARGB(255, 210, 198, 198),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Text(
                  'Location',
                  textAlign: TextAlign.left,
                  style: GoogleFonts.poppins(
                    textStyle: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: Colors.white),
                  ),
                ),
                const SizedBox(
                  height: 8,
                ),
                Container(
                  height: 300,
                  width: 400,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  margin:
                      const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                  child: FlutterMap(
                    options: MapOptions(
                      center: LatLng(
                        double.parse(widget.snap['latitude']),
                        double.parse(widget.snap['longitude']),
                      ),
                      zoom: 13.0,
                    ),
                    layers: [
                      TileLayerOptions(
                        urlTemplate:
                            "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                        subdomains: ['a', 'b', 'c'],
                      ),
                      MarkerLayerOptions(
                        markers: [
                          Marker(
                            width: 80.0,
                            height: 80.0,
                            point: LatLng(
                              double.parse(widget.snap['latitude']),
                              double.parse(widget.snap['longitude']),
                            ),
                            builder: (ctx) => const Icon(
                              Icons.pin_drop,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 18,
                ),
                widget.snap['uid'] != user.uid
                    ? InkWell(
                        onTap: () {
                          bookRoom(user.uid);
                        },
                        child: Container(
                          width: double.infinity,
                          alignment: Alignment.center,
                          padding: const EdgeInsets.symmetric(vertical: 20),
                          decoration: const ShapeDecoration(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(4),
                              ),
                            ),
                            color: Color.fromRGBO(101, 146, 233, 1),
                          ),
                          child: _isLoading
                              ? const Center(
                                  child: SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                      color: Color.fromRGBO(255, 255, 255, 1),
                                    ),
                                  ),
                                )
                              : Text(
                                  "Book Now",
                                  style: GoogleFonts.poppins(
                                    textStyle: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                        ),
                      )
                    : InkWell(
                        onTap: navigateToBooking,
                        child: Container(
                          width: double.infinity,
                          alignment: Alignment.center,
                          padding: const EdgeInsets.symmetric(vertical: 20),
                          decoration: const ShapeDecoration(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(4),
                              ),
                            ),
                            color: Color.fromRGBO(101, 146, 233, 1),
                          ),
                          child: _isLoading
                              ? const Center(
                                  child: SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                      color: Color.fromRGBO(255, 255, 255, 1),
                                    ),
                                  ),
                                )
                              : Text(
                                  "View Reservation",
                                  style: GoogleFonts.poppins(
                                    textStyle: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                        ),
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
