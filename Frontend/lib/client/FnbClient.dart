import 'package:main/entity/fnb.dart';

import 'dart:convert';
import 'package:http/http.dart';

class FnbClient {
  static final String url = 'ivory-stingray-881568.hostingersite.com'; // base url
  static final String endpoint = '/api/fnb'; // base endpoint

  // untk hp
  // static final String url = '10.53.10.249';
  // static final String endpoint = '/main/public/api/fnb';

  static Future<List<Fnb>> fetchAll() async {
    try {
      var response = await get(Uri.https(url, endpoint));// request ke api dan simpan responsenya

      if(response.statusCode != 200) throw Exception(response.reasonPhrase);

      Iterable list = json.decode(response.body)['data'];

      return list.map((e) => Fnb.fromJson(e)).toList();
    } catch (e) {
      throw Future.error(e.toString());
    }
  }
}
