import 'package:cloud_firestore/cloud_firestore.dart';

class Book {
  final String postId;
  final String userId;
  final String bookId;

  const Book({
    required this.postId,
    required this.userId,
    required this.bookId,
  });

  Map<String, dynamic> toJson() => {
        "postId": postId,
        "userId": userId,
        "bookId": bookId,
      };

  static Book fronSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;
    return Book(
      postId: snapshot['postId'],
      userId: snapshot['userId'],
      bookId: snapshot['bookId'],
    );
  }
}
