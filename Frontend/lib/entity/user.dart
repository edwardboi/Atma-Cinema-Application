import 'dart:convert';

class User {
  int id;
  String nama;
  String email;
  String password;
  String telp;
  DateTime tanggal_lahir;
  String? foto;

  User({
    required this.id,
    required this.nama,
    required this.email,
    required this.password,
    required this.telp,
    required this.tanggal_lahir,
    this.foto,
  });

  factory User.fromRawJson(String str) => User.fromJson(json.decode(str));
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json["id"],
      nama: json["nama"],
      email: json["email"],
      password: json["password"],
      telp: json["telp"],
      tanggal_lahir: DateTime.parse(json["tanggal_lahir"]), 
      foto: json["foto"],
    );
  }

  String toRawJson() => json.encode(toJson());
  Map<String, dynamic> toJson() => {
    "id": id,
    "nama": nama,
    "email": email,
    "password": password,
    "telp": telp,
    "tanggal_lahir": tanggal_lahir.toIso8601String(), 
    "foto": foto,
  };
}
