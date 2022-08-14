import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  final String adderName;
  final String profileUrl;
  final String description;
  final String uid;
  final String name;
  final String postId;
  final String facilities;
  final String noOfRooms;
  final String price;
  final String latitude;
  final String longitude;
  final String address;
  final String photoUrl;
  final String community;

  const Post({
    required this.adderName,
    required this.profileUrl,
    required this.description,
    required this.uid,
    required this.name,
    required this.postId,
    required this.facilities,
    required this.noOfRooms,
    required this.price,
    required this.latitude,
    required this.longitude,
    required this.address,
    required this.photoUrl,
    required this.community,
  });

  // this method is used to convert whatever user object we require to an object
  Map<String, dynamic> toJson() => {
        "adderName": adderName,
        "profileUrl": profileUrl,
        "description": description,
        "uid": uid,
        "name": name,
        "postId": postId,
        "facilities": facilities,
        "noOfRooms": noOfRooms,
        "price": price,
        "latitude": latitude,
        "longitude": longitude,
        "address": address,
        "photoUrl": photoUrl,
        "community": community,
      };

  // function that takes in a document snapshot and returns a user model
  static Post fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;
    return Post(
      profileUrl: snapshot['profileUrl'],
      adderName: snapshot['adderName'],
      description: snapshot['description'],
      uid: snapshot['uid'],
      name: snapshot['name'],
      postId: snapshot['postId'],
      facilities: snapshot['facilities'],
      noOfRooms: snapshot['noOfRooms'],
      price: snapshot['price'],
      latitude: snapshot['latitude'],
      longitude: snapshot['longitude'],
      address: snapshot['address'],
      photoUrl: snapshot['photoUrl'],
      community: snapshot['community'],
    );
  }
}
