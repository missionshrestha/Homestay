import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:google_fonts/google_fonts.dart';
// import 'package:latlng/latlng.dart';
import 'package:latlong2/latlong.dart';

class PostDetail extends StatefulWidget {
  final snap;
  const PostDetail({Key? key, required this.snap}) : super(key: key);

  @override
  State<PostDetail> createState() => _PostDetailState();
}

class _PostDetailState extends State<PostDetail> {
  bool isPressed = false;

  void hertPressed() {
    setState(() {
      if (isPressed == false) {
        isPressed = true;
      } else {
        isPressed = false;
      }
    });
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
                        onPressed: hertPressed,
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
