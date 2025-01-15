import 'package:main/entity/jamTayang.dart';

import 'dart:convert';
import 'package:http/http.dart';

class JamTayangClient {
  static final String url = 'ivory-stingray-881568.hostingersite.com'; // base url
  static final String endpoint = '/api/jamTayang'; // base endpoint


  static Stream<List<JamTayang>> fetchAllStream() async* {
    while (true) {
      List<JamTayang> jadwals = await fetchAll();
      yield jadwals; 
      await Future.delayed(Duration(seconds: 5));  
    }
  }

  static Future<List<JamTayang>> fetchAll() async {
    try {
      var response = await get(Uri.https(url, endpoint));

      if(response.statusCode != 200) throw Exception(response.reasonPhrase);

      var responseBody = json.decode(response.body);
      if (responseBody['data'] == null) {
        throw Exception('Data is null');
      }

      Iterable list = json.decode(response.body)['data'];

      return list.map((e) => JamTayang.fromJson(e)).toList();
    } catch (e) {
      throw Future.error(e.toString());
    }
  }

  static Stream<List<JamTayang>> fetchJamStudioStream(int idStudio) async* {
    while (true) {
      List<JamTayang> jamStudio = await fetchJamTayangsByStudioId(idStudio);
      yield jamStudio; 
      await Future.delayed(Duration(seconds: 5));  
    }
  }

  static Future<List<JamTayang>> fetchJamTayangsByStudioId(int idStudio) async {
    try {
      var response = await get(Uri.https(url, '$endpoint/studio/$idStudio'));

      if (response.statusCode != 200) {
        throw Exception('Failed to load data: ${response.reasonPhrase}');
      }
      Iterable list = json.decode(response.body)['data'];

      return list.map((e) => JamTayang.fromJson(e)).toList();
    } catch (e) {
      throw Future.error(e.toString());
    }
  }

}