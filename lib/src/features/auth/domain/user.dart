class User {
  String? userName;
  String? face;

  // Password is transient - used only during auth flow, never persisted
  String? password;

  User({this.userName, this.face, this.password});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is User &&
          runtimeType == other.runtimeType &&
          userName == other.userName &&
          face == other.face);

  @override
  int get hashCode => userName.hashCode ^ face.hashCode;

  @override
  String toString() {
    return 'User{' + ' userName: $userName,' + ' face: $face,' + '}';
  }

  User copyWith({String? userName, String? face}) {
    return User(userName: userName ?? this.userName, face: face ?? this.face);
  }

  // Password intentionally excluded from serialization - never persist
  Map<String, dynamic> toMap() {
    return {'userName': userName, 'face': face};
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      userName: map['userName'] as String?,
      face: map['face'] as String?,
    );
  }
}
