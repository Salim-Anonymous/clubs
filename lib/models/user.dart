class User{
  String uid;
  String name;
  String email;
  String password;
  String phone;
  String profilePic;

  User({
    required this.uid,
    required this.name,
    required this.email,
    required this.password,
    required this.phone,
    required this.profilePic,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      uid: json['uid'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      password: json['password'] as String,
      phone: json['phone'] as String,
      profilePic: json['profilePic'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
    'uid': uid,
    'name': name,
    'email': email,
    'password': password,
    'phone': phone,
    'profilePic': profilePic,
  };
}