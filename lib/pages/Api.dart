import 'dart:convert';
import 'package:http/http.dart' as http;

///class for fetching data from an API

class ApiService {
  final String baseUrl;

  ApiService({required this.baseUrl});

  /// Fetches data from the API with pagination parameters.

  Future<Map<String, dynamic>> fetchData(int page, int limit) async {
    final response = await http.get(Uri.parse('$baseUrl?skip=${(page - 1) * limit}&limit=$limit'));

    /// Checks if the HTTP response status code is 200 (OK).

    if (response.statusCode == 200) {
      /// Decodes the JSON response body
      return json.decode(response.body);
    } else {
      /// Throws an exception
      throw Exception('Failed to load data');
    }
  }
}
