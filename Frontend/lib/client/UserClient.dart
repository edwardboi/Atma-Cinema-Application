import 'package:main/entity/user.dart';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart';
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';

class UserClient {
  static final String url = 'ivory-stingray-881568.hostingersite.com';
  static final String endpoint = '/api/user';

  static Future<Response> updateFoto(File fotoFile) async {
    try {
      String? token = await getAuthToken();
      if (token == null) {
        throw Exception('User is not authenticated');
      }

      // Prepare the multipart request
      final Uri uri = Uri.https(url, '/api/user/updateFoto');
      var request = MultipartRequest('POST', uri);

      request.headers['Content-Type'] = 'multipart/form-data';
      request.headers['Authorization'] = 'Bearer $token';

      // Determine the mime type of the file
      final mimeType = lookupMimeType(fotoFile.path);
      final mimeTypeData = mimeType?.split('/') ?? ['image', 'jpeg'];

      request.files.add(
        await MultipartFile.fromPath(
          'foto',
          fotoFile.path,
          contentType: MediaType(mimeTypeData[0], mimeTypeData[1]),
        ),
      );

      // Send the request and follow redirects
      final streamedResponse = await request.send();

      // Handle the response
      final response = await Response.fromStream(streamedResponse);
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');
      
      if (response.statusCode == 200 || response.statusCode == 201) {
        // If the response is successful, parse the response
        var responseData = json.decode(response.body);
        print('Foto berhasil diperbarui: ${responseData['message']}');
        return response;
      } else {
        throw Exception('Failed to update photo: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error updating photo: $e');
    }
  }

  static Future<User> fetchCurrentUser() async {
    try {
      String? token = await getAuthToken();
      if (token == null) {
        throw Exception('User is not authenticated');
      }

      // Membuat request ke API untuk mengambil data user yang sedang login
      final response = await get(
        Uri.https(url, endpoint),
        headers: {
          'Authorization': 'Bearer $token', // Menambahkan token ke header
          'Accept': 'application/json',
        },
      );

      print(response.body);
      print(token);

      if (response.statusCode == 200 || response.statusCode == 201) {
        // Jika response berhasil, parse JSON menjadi objek User
        final data = json.decode(response.body);
        return User.fromJson(data); // Mengembalikan objek User
      } else {
        throw Exception('Failed to load user data');
      }
    } catch (e) {
      throw Exception('Error fetching user: $e');
    }
  }

  static Future<String?> getAuthToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs
        .getString('auth_token'); // Mengambil token dari SharedPreferences
  }

  static Future<Response> register(User user) async {
    try {
      var response = await post(Uri.https(url, '/api/register'),
          headers: {"Content-Type": "application/json"},
          body: user.toRawJson());

      if (response.statusCode != 201) throw Exception(response.reasonPhrase);

      return response;
    } catch (e) {
      return Future.error(e.toString());
    }
  }

  static Future<Map<String, dynamic>> login(
      String email, String password) async {
    try {
      // Mengirim data login
      var response = await post(
        Uri.https(url, '/api/login'),
        headers: {"Content-Type": "application/json"},
        body: json.encode({
          'email': email,
          'password': password,
        }),
      );

      if (response.statusCode != 200) {
        throw Exception('Invalid credentials');
      }

      var data = json.decode(response.body);

      String token = data['token'];
      print(token);

      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('username', data['detail']['nama']);
      await prefs.setString('auth_token', token);

      return {
        'user': User.fromJson(data['detail']),
        'token': data['token'],
        'statusCode': response.statusCode,
      };
    } catch (e) {
      return Future.error(e.toString());
    }
  }

  Future<void> saveAuthToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', token); // Simpan token baru
  }

  static Future<Response> update(User user, String token) async {
    try {
      var response = await put(Uri.https(url, '/api/user/update'),
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer $token",
          },
          body: user.toRawJson());

      print(token);
      print(response.body);
      print(response.statusCode);

      if (response.statusCode != 200) throw Exception(response.reasonPhrase);

      return response;
    } catch (e) {
      return Future.error(e.toString());
    }
  }

  static Future<void> logout(String token) async {
    try {
      var response = await post(
        Uri.https(url, '/api/logout'),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
      );

      if (response.statusCode != 200) {
        throw Exception('Logout failed: ${response.reasonPhrase}');
      }

      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.remove('auth_token');

      print('Logout successful');
    } catch (e) {
      return Future.error('Logout error: $e');
    }
  }
}
