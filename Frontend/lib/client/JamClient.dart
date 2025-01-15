import 'package:main/entity/jam.dart';

import 'dart:convert';
import 'package:http/http.dart';

class JamClient {
  static final String url = 'ivory-stingray-881568.hostingersite.com'; // base url
  static final String endpoint = '/api/jam'; // base endpoint


  static Stream<List<Jam>> fetchAllStream() async* {
    while (true) {
      List<Jam> jadwals = await fetchAll();
      yield jadwals; 
      await Future.delayed(Duration(seconds: 5));  
    }
  }

  static Future<List<Jam>> fetchAll() async {
    try {
      var response = await get(Uri.https(url, endpoint));

      if(response.statusCode != 200) throw Exception(response.reasonPhrase);

      Iterable list = json.decode(response.body)['data'];

      return list.map((e) => Jam.fromJson(e)).toList();
    } catch (e) {
      throw Future.error(e.toString());
    }
  }
}