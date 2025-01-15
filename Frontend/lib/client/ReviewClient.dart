import 'package:main/entity/review.dart';

import 'dart:convert';
import 'package:http/http.dart';

class ReviewClient {
  static final String url = 'ivory-stingray-881568.hostingersite.com'; // base url
  static final String endpoint = '/api/review'; // base endpoint

  // untk hp
  // static final String url = '10.53.10.249';
  // static final String endpoint = '/main/public/api/Review';

  static Future<List<Review>> fetchAll() async {
    try {
      var response = await get(
          Uri.https(url, endpoint)); 

      if (response.statusCode != 200) throw Exception(response.reasonPhrase);

      Iterable list = json.decode(response.body)['data'];

      return list.map((e) => Review.fromJson(e)).toList();
    } catch (e) {
      throw Future.error(e.toString());
    }
  }

  static Future<List<Review>> fetchByFilmId(int idFilm) async {
    try {
      print('Fetching reviews for film ID: $idFilm');
      var response = await get(Uri.https(url, '$endpoint/film/$idFilm'));

      if (response.statusCode != 200) {
        throw Exception(
            'Failed to fetch reviews. Status: ${response.statusCode}, Reason: ${response.reasonPhrase}');
      }

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      Iterable list = json.decode(response.body)['data'];

      return list.map((e) => Review.fromJson(e)).toList();
    } catch (e) {
      print('Error in fetchByFilmId: $e');
      throw Future.error(e.toString());
    }
  }

  static Future<List<Review>> fetchByUser(int idUser) async {
    try {
      print('Fetching reviews for User ID: $idUser');
      var response = await get(Uri.https(url, '$endpoint/user/$idUser'));

      if (response.statusCode != 200) {
        throw Exception(
            'Failed to fetch reviews. Status: ${response.statusCode}, Reason: ${response.reasonPhrase}');
      }

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      Iterable list = json.decode(response.body)['data'];

      return list.map((e) => Review.fromJson(e)).toList();
    } catch (e) {
      print('Error in fetchByFilmId: $e');
      throw Future.error(e.toString());
    }
  }

  static Future<Review> fetchByTiket(int idTiket) async {
    try {
      print('Fetching reviews for Ticket ID: $idTiket');
      var response = await get(Uri.https(url, '$endpoint/tiket/$idTiket'));

      if (response.statusCode != 200) {
        throw Exception(
            'Failed to fetch reviews. Status: ${response.statusCode}, Reason: ${response.reasonPhrase}');
      }

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      final responseBody = json.decode(response.body);

      if (responseBody['data'] == null) {
        print('No review found');
      }

      return responseBody['data'] == null
          ? Review()
          : Review.fromJson(json.decode(response.body)['data']);

    } catch (e) {
      print('Error in fetchByTicketId: $e');
      throw Future.error(e.toString());
    }
  }

  static Future<String> fetchUserName(int idUser) async {
    try {
      var response =
          await get(Uri.https(url, '/api/users/$idUser')); // Endpoint user
      if (response.statusCode != 200) throw Exception(response.reasonPhrase);

      var data = json.decode(response.body);
      return data['name'];
    } catch (e) {
      throw Future.error(e.toString());
    }
  }

  static Future<Review> find(id) async {
    try {
      var response = await get(Uri.https(url, '$endpoint/$id'));

      if (response.statusCode != 200) throw Exception(response.reasonPhrase);

      return Review.fromJson(json.decode(response.body)['data']);
    } catch (e) {
      return Future.error(e.toString());
    }
  }

  static Future<Response> create(Review reviewData) async {
    try {
      print(reviewData.toRawJson());

      var response = await post(Uri.https(url, endpoint),
          headers: {"Content-Type": "application/json"},
          body: reviewData.toRawJson());

      if (response.statusCode != 200) throw Exception(response.reasonPhrase);

      return response;
    } catch (e) {
      print('Error: ${e.toString()}');
      return Future.error(e.toString());
    }
  }

  static Future<Response> update(Review ReviewData) async {
    try {
      var response = await put(Uri.http(url, '$endpoint/${ReviewData.id}'),
          headers: {"Content-Type": "application/json"},
          body: ReviewData.toRawJson());

      if (response.statusCode != 200) throw Exception(response.reasonPhrase);

      return response;
    } catch (e) {
      return Future.error(e.toString());
    }
  }

  static Future<Response> destroy(id) async {
    try {
      var response = await delete(Uri.https(url, '$endpoint/$id'));

      if (response.statusCode != 200) throw Exception(response.reasonPhrase);

      return response;
    } catch (e) {
      return Future.error(e.toString());
    }
  }

  static Future<double> getAverageRating(int idFilm) async {

    try {
      final response = await get(Uri.https(url, '$endpoint/rata/$idFilm'));

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);

        if (responseData['success'] == true) {
          if (responseData.containsKey('rerata') && responseData['rerata'] is num) {
            return (responseData['rerata'] as num).toDouble();
          } else {
            return 0.0;
          }
        } else {
          return 0.0;
        }
      } else {
        throw Exception('Failed to load average rating. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching average rating: $e');
    }
  }


}
