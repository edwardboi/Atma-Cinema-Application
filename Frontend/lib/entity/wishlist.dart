import 'package:main/entity/film.dart';
import 'dart:convert';

class Wishlist {
  int id;
  int id_film;
  int id_user;

  String nama_film;
  String durasi;
  String genre;
  String sinopsis;
  String rating_film;
  String rating_usia;
  String cast;
  String gambar_film;
  String status;

  Wishlist({
    required this.id,
    required this.id_film,
    required this.id_user,
    required this.nama_film,
    required this.durasi,
    required this.genre,
    required this.sinopsis,
    required this.rating_film,
    required this.rating_usia,
    required this.cast,
    required this.gambar_film,
    required this.status,
  });

  factory Wishlist.fromRawJson(String str) =>
      Wishlist.fromJson(json.decode(str));

  factory Wishlist.fromJson(Map<String, dynamic> json) => Wishlist(
        id: json['wishlist_id'],
        id_film: json['film_id'],
        id_user: json['user_id'],
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
        "id_film": id_film,
        "id_user": id_user,
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
}
