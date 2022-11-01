class Member{
  String uid;
  String cid;
  List<String> role;

  Member({
    required this.uid,
    required this.cid,
    required this.role,
  });

  factory Member.fromJson(Map<String, dynamic> json) {
    return Member(
      uid: json['uid'] as String,
      cid: json['cid'] as String,
      role: json['role'] as List<String>,
    );
  }

  Map<String, dynamic> toJson() => {
    'uid': uid,
    'cid': cid,
    'role': role,
  };
}