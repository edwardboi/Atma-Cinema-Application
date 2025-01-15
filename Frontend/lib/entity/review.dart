import 'dart:convert';


class Review {
  int? id;
  int id_user;
  int id_film;
  int id_tiket;
  int rating_film;
  String komentar;

  String nama;
  String? foto;
  String? nama_film;



  // Review({this.id,required this.id_user,required this.id_film, required this.id_tiket, required this.rating_film, required this.komentar, required this.nama, required this.foto});

  Review({
    this.id = 0,
    this.id_user = 0,
    this.id_film = 0,
    this.id_tiket = 0,
    this.rating_film = 0,
    this.komentar = '',
    this.nama = '',
    this.foto = '',
    this.nama_film = '',
  });


  factory Review.fromRawJson(String str) => Review.fromJson(json.decode(str));
  factory Review.fromJson(Map<String, dynamic> json) => Review(
    // id: json["id"],
    // id_user: json["id_user"],
    // id_film: json["id_film"],
    // id_tiket: json["id_tiket"],
    // rating_film: json["rating_film"],
    // komentar: json["komentar"],
    // nama: json["nama"],
    // foto : json["foto"]

    id: json["id"] ?? 0, 
    id_user: json["id_user"] ?? 0,
    id_film: json["id_film"] ?? 0,
    id_tiket: json["id_tiket"] ?? 0,
    rating_film: json["rating_film"] ?? 0.0,
    komentar: json["komentar"] ?? "",
    nama: json["nama"] ?? "",
    foto: json["foto"] ?? "",
    nama_film: json["nama_film"] ?? "",

  );

  String toRawJson() => json.encode(toJson());
  Map<String, dynamic> toJson() => {
    // "id": id,
    "id_user": id_user,
    "id_film": id_film,
    "id_tiket": id_tiket,
    "rating_film": rating_film,
    "komentar": komentar,
     "nama":nama,
    "foto" : foto,
    "nama_film" : nama_film
  };
}
