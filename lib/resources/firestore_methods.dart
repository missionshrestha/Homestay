import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:homestay/models/post.dart';
import 'package:homestay/resources/storage_methods.dart';
import 'package:homestay/models/favourite.dart';
import 'package:uuid/uuid.dart';

class FirestoreMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // upload Post
  Future<String> uploadPost(
    String adderName,
    String profileUrl,
    String description,
    Uint8List file,
    String uid,
    String name,
    String facilities,
    String noOfRooms,
    String latitude,
    String longitude,
    String address,
    String price,
  ) async {
    String res = 'some error occured';
    try {
      String photoUrl =
          await StorageMethods().uploadImageToStorage('posts', file, true);

      String postId = const Uuid().v1();

      Post post = Post(
        adderName: adderName,
        profileUrl: profileUrl,
        description: description,
        uid: uid,
        name: name,
        postId: postId,
        facilities: facilities,
        noOfRooms: noOfRooms,
        price: price,
        latitude: latitude,
        longitude: longitude,
        address: address,
        photoUrl: photoUrl,
      );

      _firestore.collection('post').doc(postId).set(
            post.toJson(),
          );
      res = 'success';
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  // upload Favourite
  Future<String> uploadFavourite(
    String postId,
    String userId,
  ) async {
    String res = "some error occured";
    try {
      String favouriteId = const Uuid().v1();
      Favourite favourite = Favourite(
        postId: postId,
        userId: userId,
        favouriteId: favouriteId,
      );

      _firestore.collection('favourite').doc(favouriteId).set(
            favourite.toJson(),
          );
      res = 'success';
    } catch (err) {
      res = err.toString();
    }
    return res;
  }
}
