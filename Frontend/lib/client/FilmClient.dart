import 'package:main/entity/film.dart';

import 'dart:convert';
import 'package:http/http.dart';

class FilmClient {
  static final String url = 'ivory-stingray-881568.hostingersite.com'; // base url
  static final String endpoint = '/api/film'; // base endpoint

  // untk hp
  // static final String url = 'ip kita';
  // static final String endpoint = '/main/public/api/film';

  static Future<List<Film>> fetchAll() async {
    try {
      var response = await get(Uri.https(url, endpoint));// request ke api dan simpan responsenya

      if(response.statusCode != 200) throw Exception(response.reasonPhrase);

      Iterable list = json.decode(response.body)['data'];

      return list.map((e) => Film.fromJson(e)).toList();
    } catch (e) {
      throw Future.error(e.toString());
    }
  }
}