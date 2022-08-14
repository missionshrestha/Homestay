import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String email;
  final String uid;
  final String name;
  final String photoUrl;
  final String number;

  const User({
    required this.email,
    required this.uid,
    required this.name,
    required this.photoUrl,
    required this.number,
  });

  // this method is used to convert whatever user object we require to an object
  Map<String, dynamic> toJson() => {
        "uid": uid,
        "name": name,
        "email": email,
        "photoUrl": photoUrl,
        "number": number,
      };

  // function that takes in a document snapshot and returns a user model
  static User fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;
    return User(
      name: snapshot['name'],
      uid: snapshot['uid'],
      email: snapshot['email'],
      photoUrl: snapshot['photoUrl'],
      number: snapshot['number'],
    );
  }
}
