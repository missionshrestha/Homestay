class User {
  final String email;
  final String uid;
  final String name;
  final String photoUrl;

  const User({
    required this.email,
    required this.uid,
    required this.name,
    required this.photoUrl,
  });

  // this method is used to convert whatever user object we require to an object
  Map<String, dynamic> toJson() => {
        "uid": uid,
        "name": name,
        "email": email,
        "photoUrl": photoUrl,
      };
}
