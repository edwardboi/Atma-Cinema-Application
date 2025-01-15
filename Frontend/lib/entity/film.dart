import 'dart:convert';

class Film {
  int id;
  String nama_film;
  String durasi;
  String genre;
  String sinopsis;
  String rating_film;
  String rating_usia;
  String cast;
  String gambar_film;
  String status;

  Film({
    required this.id,
    required this.nama_film,
    required this.genre,
    required this.durasi,
    required this.sinopsis,
    required this.rating_film,
    required this.rating_usia,
    required this.cast,
    required this.gambar_film,
    required this.status,
  });

  factory Film.fromRawJson(String str) => Film.fromJson(json.decode(str));
  factory Film.fromJson(Map<String, dynamic> json) => Film(
    id: json["id"],
    nama_film: json["nama_film"],
    durasi: json["durasi"],
    genre: json["genre"],
    sinopsis: json["sinopsis"],
    rating_film: json["rating_film"],
    rating_usia: json["rating_usia"],
    cast: json["cast"],
    gambar_film: json["gambar_film"],
    status: json["status"],
  );

  String toRawJson() => json.encode(toJson());
  Map<String, dynamic> toJson() => {
    "id": id,
    "nama_film": nama_film,
    "durasi": durasi,
    "genre": genre,
    "sinopsis": sinopsis,
    "rating_film": rating_film,
    "rating_usia": rating_usia,
    "cast": cast,
    "gambar_film": gambar_film,
    "status": status,
  };
  
    factory Film.empty() => Film(
        id: 0,
        nama_film: "",
        durasi: "",
        genre: "",
        sinopsis: "",
        rating_film: "",
        rating_usia: "",
        cast: "",
        gambar_film: "",
        status: "",
      );
}