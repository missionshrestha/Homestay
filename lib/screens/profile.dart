import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:homestay/screens/add_homestay.dart';
import 'package:homestay/screens/post_detail.dart';
import 'package:homestay/screens/search_screen.dart';
import 'package:homestay/widgets/post_card.dart';
import 'package:homestay/widgets/text_field_input.dart';
import 'package:provider/provider.dart';

import '../models/user.dart';
import '../providers/user_provider.dart';

String greeting() {
  var hour = DateTime.now().hour;
  if (hour < 12) {
    return 'Morning';
  }
  if (hour < 17) {
    return 'Afternoon';
  }
  return 'Evening';
}

class Setting extends StatelessWidget {
  const Setting({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    User user = Provider.of<UserProvider>(context).getUser;

    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          width: double.infinity,
          child: SingleChildScrollView(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 100,
                child: ClipOval(
                  child: Image.network(
                    user.photoUrl,
                    width: 300,
                    height: 300,
                    // fit: BoxFit.cover,
                  ),
                ),
              ),
              Text(
                // " ${user.name}",
                " ${user.name}",
                style: GoogleFonts.poppins(
                  textStyle: const TextStyle(
                      fontSize: 40, fontWeight: FontWeight.w400),
                ),
              ),
              const SizedBox(
                // height: 10,
                width: double.infinity,
                height: 60,

                child: Text(
                  "User Details",
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.left,
                ),
              ),
              SingleChildScrollView(
                child: SizedBox(
                  width: double.infinity,
                  height: 400,
                  child: ListView(
                    children: [
                      Text(
                        " Full Name: \n${user.name}",
                        style: GoogleFonts.poppins(
                          textStyle: const TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w400),
                        ),
                        textAlign: TextAlign.start,
                      ),
                      Text(
                        " Your email: \n ${user.email}",
                        style: GoogleFonts.poppins(
                          textStyle: const TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w400),
                        ),
                        textAlign: TextAlign.start,
                      ),

                      // TODO Update with other user data
                      Text(
                        " Full Name: \n${user.name}",
                        style: GoogleFonts.poppins(
                          textStyle: const TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w400),
                        ),
                        textAlign: TextAlign.start,
                      ),
                      Text(
                        " Your email: \n ${user.email}",
                        style: GoogleFonts.poppins(
                          textStyle: const TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w400),
                        ),
                        textAlign: TextAlign.start,
                      ),
                      Text(
                        " Full Name: \n${user.name}",
                        style: GoogleFonts.poppins(
                          textStyle: const TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w400),
                        ),
                        textAlign: TextAlign.start,
                      ),
                      Text(
                        " Your email: \n ${user.email}",
                        style: GoogleFonts.poppins(
                          textStyle: const TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w400),
                        ),
                        textAlign: TextAlign.start,
                      ),
                      Text(
                        " Full Name: \n${user.name}",
                        style: GoogleFonts.poppins(
                          textStyle: const TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w400),
                        ),
                        textAlign: TextAlign.start,
                      ),
                      Text(
                        " Your email: \n ${user.email}",
                        style: GoogleFonts.poppins(
                          textStyle: const TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w400),
                        ),
                        textAlign: TextAlign.start,
                      ),
                    ],
                  ),
                ),
              ),
              /* Container(
                child: Row(
                  children: [
                    Text(
                      " Full Name: ${user.name}",
                      style: GoogleFonts.poppins(
                        textStyle: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w400),
                      ),
                      textAlign: TextAlign.left,
                    ),
                    Text(
                      " Your email: ${user.email}",
                      style: GoogleFonts.poppins(
                        textStyle: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w400),
                      ),
                      textAlign: TextAlign.left,
                    ),

                    // TODO Field for Vendor / Tourist
                    // TODO Field for No of rooms Room Sold / Rooms Booked
                    //TODO: Vendor Phone number Tourist
                    //TODO Vendor / Tourist Rating

                    /* Text(
                      " Your User ID: ${user.uid}",
                      style: GoogleFonts.poppins(
                        textStyle: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w400),
                      ),
                      textAlign: TextAlign.left,
                    ), */
                  ],
                ),
              ), */
            ],
          )),
        ),
      ),
    );
  }
}
