import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:homestay/screens/add_homestay.dart';
import 'package:homestay/screens/post_detail.dart';
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

  String dropdownvalue = 'Cheapest';
  var items = [
    'Cheapest',
    'Nearest',
  ];
  String communityDropdownvalue = 'None';
  var communityItems = [
    'Magar',
    'Rai',
    'Tharu',
    'Limbu',
    'Sherpa',
    'Others',
    'None'
  ];
  String? value;
  final controller = ScrollController();

  @override
  Widget build(BuildContext context) {
    User user = Provider.of<UserProvider>(context).getUser;

    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          width: double.infinity,
          child: SingleChildScrollView(
            controller: controller,
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
                  child: IgnorePointer(
                    child: TextFieldInput(
                      textEditingController: _searchController,
                      hintText: "search",
                      textInputType: TextInputType.text,
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    SizedBox(
                      width: 10,
                    ),
                    Text('Sort by: '),
                    SizedBox(
                      width: 12,
                    ),
                    DropdownButton(
                      dropdownColor: Color.fromRGBO(32, 34, 54, 1),
                      // Initial Value
                      value: dropdownvalue,

                      // Down Arrow Icon
                      icon: const Icon(Icons.keyboard_arrow_down),

                      // Array list of items
                      items: items.map((String items) {
                        return DropdownMenuItem(
                          value: items,
                          child: Text(items),
                        );
                      }).toList(),
                      // After selecting the desired option,it will
                      // change button value to selected value
                      onChanged: (String? newValue) {
                        setState(() {
                          dropdownvalue = newValue!;
                        });
                      },
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text('Community'),
                    SizedBox(
                      width: 12,
                    ),
                    DropdownButton(
                      dropdownColor: Color.fromRGBO(32, 34, 54, 1),
                      // Initial Value
                      value: communityDropdownvalue,

                      // Down Arrow Icon
                      icon: const Icon(Icons.keyboard_arrow_down),

                      // Array list of items
                      items: communityItems.map((String items) {
                        return DropdownMenuItem(
                          value: items,
                          child: Text(items),
                        );
                      }).toList(),
                      // After selecting the desired option,it will
                      // change button value to selected value
                      onChanged: (String? newValue) {
                        setState(() {
                          communityDropdownvalue = newValue!;
                        });
                      },
                    ),
                  ],
                ),
                StreamBuilder(
                  stream:
                      FirebaseFirestore.instance.collection('post').snapshots(),
                  builder: (context,
                      AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                          snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
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
                              ),
                            ),
                          )
                        },
                        child: PostCard(
                          snap: snapshot.data!.docs[index].data(),
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
      floatingActionButton: Padding(
        padding: const EdgeInsets.fromLTRB(42.0, 0, 10, 10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Container(
              width: 30,
              child: FloatingActionButton(
                onPressed: scrollUp,
                backgroundColor: Color.fromRGBO(101, 146, 233, 1),
                child: const Icon(
                  Icons.arrow_upward,
                  color: Colors.white,
                ),
                elevation: 0,
              ),
            ),
            Expanded(child: Container()),
            FloatingActionButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => AddHomestay()),
                );
              },
              backgroundColor: const Color.fromRGBO(101, 146, 233, 1),
              child: const Icon(Icons.add),
            ),
          ],
        ),
      ),
    );
  }

  void scrollUp() {
    final double start = 0;
    controller.animateTo(start,
        duration: Duration(milliseconds: 500), curve: Curves.easeIn);
  }
}
