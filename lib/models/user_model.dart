class UserModel {
  final int id;
  final String name;
  final String email;
  final String role;
  final String? photo;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    this.photo,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: int.parse(json['id'].toString()),
      name: json['name'],
      email: json['email'],
      role: json['role'],
      photo: json['photo'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'role': role,
      'photo': photo,
    };
  }
}
