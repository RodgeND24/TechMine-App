import 'dart:convert';
import 'package:http/http.dart' as http;

Future<http.Response> _get(String endpoint) async {
  return http.get(
    Uri.parse('http://localhost:8800/api/$endpoint'),
  );
}

void main() async {
  final response = await _get('news/get');
  print(json.decode(response.body));
}