import 'package:main/entity/ticket.dart';

import 'dart:convert';
import 'package:http/http.dart';

class TicketClient {
  static final String url = 'ivory-stingray-881568.hostingersite.com'; // base url
  static final String endpoint = '/api/tiket'; // base endpoint

  // untk hp
  // static final String url = '10.53.10.249';
  // static final String endpoint = '/main/public/api/Review';

  static Future<List<Ticket>> fetchAll() async {
    try {
      var response = await get(Uri.https(url, endpoint));

      if(response.statusCode != 200) throw Exception(response.reasonPhrase);

      Iterable list = json.decode(response.body)['data'];

      return list.map((e) => Ticket.fromJson(e)).toList();
    } catch (e) {
      throw Future.error(e.toString());
    }
  }

  static Future<Ticket> fetchById(int id) async {
    try {
      var response = await get(Uri.https(url, '$endpoint/$id'));

      if(response.statusCode != 200) throw Exception(response.reasonPhrase);

      return Ticket.fromJson(json.decode(response.body)['data']);
    } catch (e) {
      throw Future.error(e.toString());
    }
  }

  static Future<List<Ticket>> fetchByUser(id) async {
    try {

      var response = await get(Uri.https(url, '$endpoint/user/show/$id'),
          headers: {
          'Accept': 'application/json',
        },);

      if(response.statusCode != 200) throw Exception(response.reasonPhrase);

      Iterable list = json.decode(response.body)['data'];
      print(list);
      return list.map((e) => Ticket.fromJson(e)).toList();
    } catch (e) {
      throw Future.error(e.toString());
    }
  }

  static Future<int> create(Ticket tiketData) async {
    try{
      print(tiketData.toRawJson());

      var response = await post(Uri.https(url, endpoint),
          headers: {"Content-Type":"application/json"},
          body: tiketData.toRawJson());
          
      if(response.statusCode != 200) throw Exception(response.reasonPhrase);

      final responseData = jsonDecode(response.body);
      return responseData['data']['id'];
    } catch (e) {
      print('Error: ${e.toString()}');
      return Future.error(e.toString());
    }
  }

  static Future<Response> update(Ticket tiketData) async {
    try{
      var response = await put(Uri.https(url, '$endpoint/${tiketData.id}'),
          headers: {"Content-Type":"application/json"},
          body: tiketData.toRawJson());

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

}
