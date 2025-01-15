import 'package:main/entity/wishlist.dart';

import 'dart:convert';
import 'package:http/http.dart';

class WishlistClient {
  static final String url = 'ivory-stingray-881568.hostingersite.com';
  static final String endpoint = '/api/wishlist';

  static Future<List<Wishlist>> fetchAll() async {
    try {
      var response = await get(
          Uri.https(url, endpoint)); // request ke api dan simpan responsenya

      if (response.statusCode != 200) throw Exception(response.reasonPhrase);

      Iterable list = json.decode(response.body)['data'];

      return list.map((e) => Wishlist.fromJson(e)).toList();
    } catch (e) {
      throw Future.error(e.toString());
    }
  }

  static Future<List<Wishlist>> fetchByUser(int id_user) async {
    try {
      var response = await get(Uri.https(url, '$endpoint/user/$id_user'));

      if (response.statusCode != 200) throw Exception(response.reasonPhrase);

      Iterable list = json.decode(response.body)['data'];

      return list.map((e) => Wishlist.fromJson(e)).toList();
    } catch (e) {
      throw Future.error(e.toString());
    }
  }

  // membuat data baru
  static Future<Response> create(Wishlist wishlist) async {
    try {
      var response = await post(Uri.https(url, endpoint),
          headers: {"Content-Type": "application/json"},
          body: wishlist.toRawJson());

      if (response.statusCode != 200) throw Exception(response.reasonPhrase);

      return response;
    } catch (e) {
      return Future.error(e.toString());
    }
  }

  // menghapus data
  static Future<Response> destroy(id) async {
    try {
      var response = await delete(Uri.https(url, '$endpoint/$id'));
      if (response.statusCode != 200) throw Exception(response.reasonPhrase);

      return response;
    } catch (e) {
      return Future.error(e.toString());
    }
  }

  //cari
  static Future<bool> isFilmInWishlist(int idFilm, int idUser) async {
    try {
      final response = await WishlistClient.fetchAll();

      bool isExist = response.any((wishlist) =>
          wishlist.id_film == idFilm && wishlist.id_user == idUser);

      return isExist;
    } catch (e) {
      print("Error checking wishlist: $e");
      return false;
    }
  }

  static Future<int?> findWishlistIdByFilmAndUser(
      int idFilm, int idUser) async {
    try {
      final response = await WishlistClient.fetchAll();

      for (var wishlist in response) {
        if (wishlist.id_film == idFilm && wishlist.id_user == idUser) {
          return wishlist.id;
        }
      }
      return null;
    } catch (e) {
      print("Error finding wishlist: $e");
      throw Exception("Error occurred while finding wishlist");
    }
  }
}
