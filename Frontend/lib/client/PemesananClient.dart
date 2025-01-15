import 'package:main/entity/pemesanan.dart';

import 'dart:convert';
import 'package:http/http.dart';

class PemesananClient {
  static final String url = 'ivory-stingray-881568.hostingersite.com'; // base url
  static final String endpoint = '/api/pemesanan'; // base endpoint

  // untk hp
  // static final String url = '10.53.10.249';
  // static final String endpoint = '/main/public/api/Review';

  static Future<List<Pemesanan>> fetchAll() async {
    try {
      var response = await get(Uri.https(url, endpoint));

      if(response.statusCode != 200) throw Exception(response.reasonPhrase);

      Iterable list = json.decode(response.body)['data'];

      return list.map((e) => Pemesanan.fromJson(e)).toList();
    } catch (e) {
      throw Future.error(e.toString());
    }
  }

  static Future<Pemesanan> fetchById(int id) async {
    try {
      var response = await get(Uri.https(url, '$endpoint/$id'));

      if(response.statusCode != 200) throw Exception(response.reasonPhrase);

      return Pemesanan.fromJson(json.decode(response.body)['data']);
    } catch (e) {
      throw Future.error(e.toString());
    }
  }

  static Future<int> create(Pemesanan pemesananData) async {
    try{
      print(pemesananData.toRawJson());

      var response = await post(Uri.https(url, endpoint),
          headers: {"Content-Type":"application/json"},
          body: pemesananData.toRawJson());
          
      if(response.statusCode != 200) throw Exception(response.reasonPhrase);

      final responseData = jsonDecode(response.body);
      print(responseData['data']['id']);
      return responseData['data']['id'];

    } catch (e) {
      print('Error: ${e.toString()}');
      return Future.error(e.toString());
    }
  }

  static Future<Response> update(Pemesanan pemesananData) async {
    try{
      var response = await put(Uri.https(url, '$endpoint/${pemesananData.id}'),
          headers: {"Content-Type":"application/json"},
          body: pemesananData.toRawJson());

      if(response.statusCode != 200) throw Exception(response.reasonPhrase);

      return response;
    } catch (e) {
      return Future.error(e.toString());
    }
  }

  static Future<Response> destroy(id) async {
    try{
      var response = await delete(Uri.https(url, '$endpoint/$id'));

      if(response.statusCode != 200) throw Exception(response.reasonPhrase);

      return response;
    }catch (e) {
      return Future.error(e.toString());
    }
  }

  static Future<int> getSisaKapasitas({
    required int idJadwal,
    required int idStudio,
    required int idJamTayang,
    required int idFilm,
  }) async {

    try {
      final response = await get(Uri.https(url, '$endpoint/kapasitas/$idJadwal/$idStudio/$idJamTayang/$idFilm'));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['sisa_kapasitas'];
      } else {
        throw Exception('Failed to load kapasitas. Status Code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching kapasitas: $e');
    }
  }

}
