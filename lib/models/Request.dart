
class Request{
  final String uid;
  final String mid;
  final String email;
  final int timestamp;

  Request({
    required this.uid,
    required this.email,
    required this.timestamp,
    required this.mid,
  });

  factory Request.fromMap(String mid,Map<String, dynamic> data) {
    return Request(
      mid: mid,
      uid: data['uid'],
      email: data['email'],
      timestamp: data['timestamp'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'timestamp': timestamp,
    };
  }
}