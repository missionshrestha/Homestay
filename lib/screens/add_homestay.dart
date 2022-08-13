import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:homestay/providers/user_provider.dart';
import 'package:homestay/resources/firestore_methods.dart';
import 'package:homestay/screens/home_screen.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../models/user.dart';
import '../utils/utils.dart';
import '../widgets/text_field_input.dart';

class AddHomestay extends StatefulWidget {
  AddHomestay({Key? key}) : super(key: key);

  @override
  State<AddHomestay> createState() => _AddHomestayState();
}

class _AddHomestayState extends State<AddHomestay> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _facilityController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _roomNoController = TextEditingController();
  final TextEditingController _latitudeController = TextEditingController();
  final TextEditingController _longitudeController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  bool _isLoading = false;
  bool _isLoadingForPost = false;
  late StreamSubscription<Position> streamSubscription;
  Uint8List? _image;

  void selectImage() async {
    Uint8List im = await pickImage(ImageSource.gallery);
    setState(() {
      _image = im;
    });
  }

  geoLocation() async {
    setState(() {
      _isLoading = true;
    });
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    // return await Geolocator.getCurrentPosition();
    streamSubscription = Geolocator.getPositionStream().listen(
      (Position position) {
        _latitudeController.text = position.latitude.toString();
        _longitudeController.text = position.longitude.toString();
        getAddressFromLatLang(position);
      },
    );
    setState(() {
      _isLoading = false;
    });
  }

  Future<void> getAddressFromLatLang(Position position) async {
    List<Placemark> placemark =
        await placemarkFromCoordinates(position.latitude, position.longitude);
    Placemark place = placemark[0];
    _addressController.text = '${place.locality}, ${place.country}';
  }

  void post(
    String uid,
    String adderName,
    String profileUrl,
  ) async {
    try {
      setState(() {
        _isLoadingForPost = true;
      });
      String res = await FirestoreMethods().uploadPost(
        adderName,
        profileUrl,
        _descriptionController.text,
        _image!,
        uid,
        _nameController.text,
        _facilityController.text,
        _roomNoController.text,
        _latitudeController.text,
        _longitudeController.text,
        _addressController.text,
        _priceController.text,
      );

      if (res == 'success') {
        showSnackBar("Posted", context);
        clear();
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const HomeScreen()),
        );
      } else {
        showSnackBar(res, context);
      }
      setState(() {
        _isLoadingForPost = false;
      });
    } catch (err) {
      showSnackBar(err.toString(), context);
    }
  }

  @override
  void dispose() {
    super.dispose();
    _nameController.dispose();
    _descriptionController.dispose();
    _facilityController.dispose();
    _roomNoController.dispose();
    _latitudeController.dispose();
    _longitudeController.dispose();
    _addressController.dispose();
    _priceController.dispose();
  }

  void clear() {
    setState(() {
      _image = null;
      _nameController.clear();
      _descriptionController.clear();
      _facilityController.clear();
      _roomNoController.clear();
      _latitudeController.clear();
      _longitudeController.clear();
      _addressController.clear();
      _priceController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    User user = Provider.of<UserProvider>(context).getUser;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.clear),
          onPressed: () {
            // clear();
          },
        ),
        title: const Text("Add"),
        centerTitle: true,
        // actions: [
        //   IconButton(
        //     onPressed: () {},
        //     icon: Icon(
        //       Icons.settings,
        //     ),
        //   ),
        // ],
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        width: double.infinity,
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight,
                ),
                child: IntrinsicHeight(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Flexible(
                      //   child: Container(),
                      //   flex: 1,
                      // ),
                      Text(
                        "Name",
                        style: GoogleFonts.poppins(
                          textStyle: const TextStyle(
                              fontSize: 14, fontWeight: FontWeight.w500),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      TextFieldInput(
                        textEditingController: _nameController,
                        hintText: "Write Here",
                        textInputType: TextInputType.text,
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Text(
                        "Description",
                        style: GoogleFonts.poppins(
                          textStyle: const TextStyle(
                              fontSize: 14, fontWeight: FontWeight.w500),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      TextFieldInput(
                        textEditingController: _descriptionController,
                        hintText: "Description",
                        textInputType: TextInputType.multiline,
                        isDescription: true,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        "Add Photo",
                        style: GoogleFonts.poppins(
                          textStyle: const TextStyle(
                              fontSize: 14, fontWeight: FontWeight.w500),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Stack(
                        children: [
                          Center(
                            child: _image != null
                                ? ClipRRect(
                                    child: Container(
                                      height: 250,
                                      width: 600,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        image: DecorationImage(
                                          fit: BoxFit.cover,
                                          image: MemoryImage(_image!),
                                        ),
                                      ),
                                    ),
                                  )
                                : ClipRRect(
                                    child: Container(
                                      height: 100,
                                      width: 200,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        image: const DecorationImage(
                                          fit: BoxFit.cover,
                                          image: NetworkImage(
                                              "https://i.stack.imgur.com/34AD2.jpg"),
                                        ),
                                      ),
                                    ),
                                  ),
                          ),
                          Positioned(
                            bottom: -10,
                            right: 10,
                            child: IconButton(
                              onPressed: selectImage,
                              icon: const Icon(Icons.add_a_photo),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Text(
                        "Facilities",
                        style: GoogleFonts.poppins(
                          textStyle: const TextStyle(
                              fontSize: 14, fontWeight: FontWeight.w500),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      TextFieldInput(
                        textEditingController: _facilityController,
                        hintText: "Enter Facilities Each Seperated By ,",
                        textInputType: TextInputType.multiline,
                        isDescription: true,
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text("No of Rooms:"),
                                const SizedBox(
                                  height: 10,
                                ),
                                TextFieldInput(
                                  textEditingController: _roomNoController,
                                  hintText: "Write Here",
                                  textInputType: TextInputType.number,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            width: 15,
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text("Price:"),
                                const SizedBox(
                                  height: 10,
                                ),
                                TextFieldInput(
                                  textEditingController: _priceController,
                                  hintText: "Write Here",
                                  textInputType: TextInputType.number,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Location:"),
                          GestureDetector(
                            onTap: geoLocation,
                            child: Container(
                              child: _isLoading
                                  ? const Center(
                                      child: SizedBox(
                                        child: CircularProgressIndicator(
                                          color:
                                              Color.fromRGBO(255, 255, 255, 1),
                                        ),
                                        height: 21,
                                        width: 21,
                                      ),
                                    )
                                  : Text(
                                      "Autofill",
                                      style: GoogleFonts.poppins(
                                        textStyle: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                          color:
                                              Color.fromRGBO(101, 146, 233, 1),
                                        ),
                                      ),
                                    ),
                              padding: const EdgeInsets.symmetric(vertical: 8),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text("Latitude:"),
                                const SizedBox(
                                  height: 10,
                                ),
                                TextFieldInput(
                                  textEditingController: _latitudeController,
                                  hintText: "Write Here",
                                  textInputType: TextInputType.number,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            width: 15,
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text("Longitude:"),
                                const SizedBox(
                                  height: 10,
                                ),
                                TextFieldInput(
                                  textEditingController: _longitudeController,
                                  hintText: "Write Here",
                                  textInputType: TextInputType.number,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        "Address:",
                        style: GoogleFonts.poppins(
                          textStyle: const TextStyle(
                              fontSize: 14, fontWeight: FontWeight.w500),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      TextFieldInput(
                        textEditingController: _addressController,
                        hintText: "Address",
                        textInputType: TextInputType.multiline,
                        isDescription: true,
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      InkWell(
                        onTap: () {
                          // post(user.uid);
                          post(user.uid, user.name, user.photoUrl);
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
                          child: _isLoadingForPost
                              ? const Center(
                                  child: SizedBox(
                                    child: CircularProgressIndicator(
                                      color: Color.fromRGBO(255, 255, 255, 1),
                                    ),
                                    height: 20,
                                    width: 20,
                                  ),
                                )
                              : Text(
                                  "Add",
                                  style: GoogleFonts.poppins(
                                    textStyle: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                        ),
                      ),
                      const SizedBox(
                        height: 25,
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
