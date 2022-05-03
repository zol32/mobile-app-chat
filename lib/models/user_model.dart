class User {
  final String uid;

  User({required this.uid});

  User.fromJson(String uid, Map<String, dynamic> json)
      : this(
          uid: uid,
        );

  // Map<String, Object?> toJson() {
  //   return {"display_name": displayName, "isAdmin": isAdmin};
  // }
}
