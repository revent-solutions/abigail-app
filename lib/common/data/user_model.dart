
class Usermodel {
  String email;
  String name;
  String uid;
  String id;
  String type;

  Usermodel({
    required this.uid,
    required this.name,
    required this.email,
    required this.id,
    required this.type,
  });

  Usermodel.fromJson(Map<String, dynamic> json)
      : email = json['email'],
        uid = json['uid'],
        name = json['name'],
        id = json['id'],
        type = json['type'];

  Map<String, dynamic> toJson() => {
        'email': email,
        'id': id,
        'uid': uid,
        'name': name,
        'type': type,
      };
}
