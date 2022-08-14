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

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  TextEditingController _searchController = TextEditingController();
  String? searchQuery = '';
  String? communityQuery = '';

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

  final items = ['None', 'Tharu', 'Gurung', 'Sherpa'];
  DropdownMenuItem<String> buildMenuItem(String item) => DropdownMenuItem(
        value: item,
        child: Text(
          item,
        ),
      );
  String? community;
  void doSomething(String s) {
    setState(() {
      searchQuery = _searchController.text;
    });
  }

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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ListTile(
                  title: Text(
                    "Good ${greeting()}, ${user.name}!",
                    style: GoogleFonts.poppins(
                      textStyle: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w400),
                    ),
                  ),
                  // subtitle: Text(
                  //   "Subtitle is here",
                  //   style: GoogleFonts.poppins(
                  //     textStyle: const TextStyle(
                  //         fontSize: 14, fontWeight: FontWeight.w400),
                  //   ),
                  // ),
                  leading: CircleAvatar(
                    radius: 25,
                    child: ClipOval(
                      child: Image.network(
                        user.photoUrl,
                        width: 100,
                        height: 100,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    "Where do you want to go?",
                    style: GoogleFonts.poppins(
                      textStyle: const TextStyle(
                          fontSize: 25, fontWeight: FontWeight.w500),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                InkWell(
                  onTap: () {
                    // Navigator.of(context).push(
                    //   MaterialPageRoute(
                    //     builder: (context) => () => {},
                    //   ),
                    // );
                  },
                  // // child: IgnorePointer(
                  // child: TextFieldInput(
                  //   textEditingController: _searchController,
                  //   hintText: "Search by address",
                  //   textInputType: TextInputType.text,
                  // ),
                  child: TextField(
                    controller: _searchController,
                    onChanged: doSomething,
                    decoration:
                        const InputDecoration(hintText: "Search by address"),
                  ),
                  // ),
                ),
                DropdownButton(
                  value: community,
                  items: items.map(buildMenuItem).toList(),
                  onChanged: (value) => setState(
                    () {
                      community = value.toString();
                    },
                  ),
                ),
                searchQuery == ''
                    ? StreamBuilder(
                        stream: FirebaseFirestore.instance
                            .collection('post')
                            .snapshots(),
                        builder: (context,
                            AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                                snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                          return ListView.builder(
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: snapshot.data!.docs.length,
                            itemBuilder: (context, index) => GestureDetector(
                              onTap: () => {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => PostDetail(
                                      snap: snapshot.data!.docs[index].data(),
                                      currentUser: user.uid,
                                    ),
                                  ),
                                )
                              },
                              child: PostCard(
                                snap: snapshot.data!.docs[index].data(),
                                currentUser: user.uid,
                              ),
                            ),
                          );
                        },
                      )
                    : StreamBuilder(
                        stream: FirebaseFirestore.instance
                            .collection('post')
                            .where('address',
                                isGreaterThanOrEqualTo: searchQuery)
                            .where("address",
                                isLessThanOrEqualTo: '{searchQuery}' + "\uf7ff")
                            .snapshots(),
                        builder: (context,
                            AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                                snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                          return ListView.builder(
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: snapshot.data!.docs.length,
                            itemBuilder: (context, index) => GestureDetector(
                              onTap: () => {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => PostDetail(
                                      snap: snapshot.data!.docs[index].data(),
                                      currentUser: user.uid,
                                    ),
                                  ),
                                )
                              },
                              child: PostCard(
                                snap: snapshot.data!.docs[index].data(),
                                currentUser: user.uid,
                              ),
                            ),
                          );
                        },
                      ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => AddHomestay()),
          );
        },
        backgroundColor: const Color.fromRGBO(101, 146, 233, 1),
        child: const Icon(Icons.add),
      ),
    );
  }
}
