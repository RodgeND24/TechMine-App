import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'package:techmine/services/auth/models/news_data.dart';
import 'package:techmine/services/auth/models/profile_data.dart';
import 'dart:convert';

import 'package:techmine/services/auth/models/token.dart';
import 'package:techmine/services/auth/models/user.dart';

class AuthService {

  // final Dio dio = Dio(BaseOptions(baseUrl: 'http://localhost:8800/api/'));
  // final _baseUrl = '/api';
  final _baseUrl = 'http://localhost:8800/api';
  final FlutterSecureStorage _storage = FlutterSecureStorage();

  static bool get _isWeb => identical(0, 0.0);

  Future<Token?> login(String username, String password) async {
    try {
      final response = await http.post(
          Uri.parse('$_baseUrl/auth/login'),
          headers: {'Content-Type': 'application/json'},
          body: json.encode({'username': username, 'password': password})
        );
      
      if (response.statusCode == 200) {
        Token token = Token.fromJson(json.decode(response.body));
        await saveTokens(token);
        return token;
      }
      else {
        return null;
      }
      
    }
     catch (e) {
      print('Login service error: ${e.toString()}'); //replace in prod
      throw Exception('Login error: ${e.toString()}');
    }
  }

  Future<User?> register(String email, String username, String password) async {
    try{
      final response = await http.post(
          Uri.parse('$_baseUrl/auth/register'),
          headers: {'Content-Type': 'application/json'},
          body: json.encode({'email': email, 'username': username, 'password': password})
        );
      
      if (response.statusCode == 200) {
        final user = User.fromJson(json.decode(response.body));
        return user;
      }
      return null;
    }
    catch (e) {
      print(e); //replace in prod
      return null;
    }
  }

  /* make a rememberPassword function */
  // Future<bool> rememberPassword(String username) await {
  //   return false;
  // }

  Future<void> logout() async {
    await _storage.deleteAll();
    if (_isWeb) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('accessToken');
      await prefs.remove('refreshToken');
    }
    
    try {
      await http.post(Uri.parse('$_baseUrl/auth/logout'));
    } catch (e) {
      print('Logout error: $e');
    }
  }

  /* Functions for tokens */
  Future<void> saveTokens(Token token) async {
    if (_isWeb) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('accessToken', token.access_token);
      await prefs.setString('refreshToken', token.refresh_token);
    }
    else {
      await _storage.write(key: 'accessToken', value: token.access_token);
      await _storage.write(key: 'refreshToken', value: token.refresh_token);
    }
  }

  Future<String?> getAccessToken() async {
    if (_isWeb) {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString('accessToken');
    }
    return await _storage.read(key: 'accessToken');
  }

  Future<String?> getRefreshToken() async {
    if (_isWeb) {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString('refreshToken');
    }
    return await _storage.read(key: 'refreshToken');
  }

  Future<bool> isTokenExpired() async {
    final accessToken = await getAccessToken();
    if (accessToken == null) return true;
    
    final response = await http.post(
        Uri.parse('$_baseUrl/auth/verify-token'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'token': accessToken!, 'is_refresh': '0'})
      );
    
    if (response.statusCode == 200) { return false; }

    return true;
  }

  Future<Token?> refresh() async {
    try {
      final refreshToken = await getRefreshToken();
      if (refreshToken == null) {
        return null;
      }

      final response = await http.post(
        Uri.parse('$_baseUrl/auth/refresh'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'refresh_token': refreshToken})
      );

      if (response.statusCode == 200) {
        final token = Token.fromJson(json.decode(response.body));
        await saveTokens(token);
        return token;
      }
      else {
        throw Exception('Failed to refresh token');
      }

    }
    on Exception {
      throw Exception('No refresh token');
    }

  }

  Future<bool> hasValidToken() async {
    final accessToken = await getAccessToken();
    if (accessToken == null) {return false;}
    
    return (!await isTokenExpired());
  }

  /* Function for current user */
  Future<User?> getCurrentUser() async {
    
    if (!await hasValidToken()) {return null;}

    try {
      final response = await _get('users/me');
      
      if (response.statusCode == 200) {
        return User.fromJson(json.decode(response.body));
      }
      else if (response.statusCode == 401) {
        // No authorized
        return null;
      }
    }
    catch (e) {
      // throw Exception('Error: $e');
      return null;
    }
    return null;
  }





  /* Functions to make secure requests with accessToken */
  Future<http.Response> _get(String endpoint) async {

    return await _makeRequest(() async {
        final token = await getAccessToken();
        return http.get(
          Uri.parse('$_baseUrl/$endpoint'),
          headers: _buildHeaders(token)
        );
      }
    );

  }

  Future<http.Response> _post(String endpoint, dynamic data) async {

    return await _makeRequest(() async {
        final token = await getAccessToken();
        return http.post(
          Uri.parse('$_baseUrl/$endpoint'),
          headers: _buildHeaders(token),
          body: json.encode(data)
        );
      }

    );
  }

  Future<http.Response> _makeRequest(Future<http.Response> Function() request) async {
    // Try refresh a saved token if expired
    if (await isTokenExpired()) {
      await refresh();
    }

    // Try request
    var response = await request();

    // If accessToken not valid - try refresh again
    if (response.statusCode == 401) {
      await refresh();
      response = await request();
    }

    return response;
  }

  Map<String, String> _buildHeaders(String? token) {
    final headers = { 'Content-Type': 'application/json' };

    // If accessToken exist - add the last one in headers
    if (token != null) { headers['Authorization'] = 'Bearer $token'; }

    return headers;
  }

  // Functions to get user profile
  Future<ProfileData?> getProfile() async {
    
    if (!await hasValidToken()) {return null;}

    try {
      final response = await _get('users/profile/get');
      
      if (response.statusCode == 200) {
        return ProfileData.fromJson(json.decode(response.body));
      }
      else if (response.statusCode == 401) {
        return null;
      }
    }
    catch (e) {
      // throw Exception('Error: $e');
      return null;
    }
    return null;
  }

  String getFileByName(String? name, String type) {
    return 'https://techmineserver.ru/api/download/$type/$name';
  }

  String getFileByUrl(String? path) {
    return 'https://techmineserver.ru/$path';
  }

  // Function to get News
  Future<List> getNews() async {
    final response = await _get('news/get');
    final newsList = json.decode(response.body);
    return newsList;
  }

  // Function to get Servers
  Future<List> getServers() async {
    final response = await _get('servers/get');
    final serversList = json.decode(response.body);
    return serversList;
  }


  Future<Map<String, dynamic>> getInfoAboutServer({String ip = '', String port = ''}) async {
    // print(Uri.parse('https://api.mcstatus.io/v2/status/java/$ip:$port'));
    final response = await http.get(Uri.parse('https://api.mcstatus.io/v2/status/java/$ip:$port'));
    return json.decode(response.body);
  }







}