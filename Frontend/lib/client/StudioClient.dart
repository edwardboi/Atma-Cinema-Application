import 'package:main/entity/studio.dart';

import 'dart:convert';
import 'package:http/http.dart';

class StudioClient {
  static final String url = 'ivory-stingray-881568.hostingersite.com'; // base url
  static final String endpoint = '/api/studio'; // base endpoint

  
  static Stream<List<Studio>> fetchAllStream() async* {
    while (true) {
      List<Studio> studios = await fetchAll();
      yield studios; 
      await Future.delayed(Duration(seconds: 5));  
    }
  }

  static Future<List<Studio>> fetchAll() async {
    try {
      var response = await get(Uri.https(url, endpoint));

      if(response.statusCode != 200) throw Exception(response.reasonPhrase);

      Iterable list = json.decode(response.body)['data'];

      return list.map((e) => Studio.fromJson(e)).toList();
    } catch (e) {
      throw Future.error(e.toString());
    }
  }
}