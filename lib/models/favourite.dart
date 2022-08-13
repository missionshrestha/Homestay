import 'package:cloud_firestore/cloud_firestore.dart';

class Favourite {
  final String postId;
  final String userId;
  final String favouriteId;

  const Favourite({
    required this.postId,
    required this.userId,
    required this.favouriteId,
  });

  Map<String, dynamic> toJson() => {
        "postId": postId,
        "userId": userId,
        "favouriteId": favouriteId,
      };

  static Favourite fronSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;
    return Favourite(
      postId: snapshot['postId'],
      userId: snapshot['userId'],
      favouriteId: snapshot['favouriteId'],
    );
  }
}
