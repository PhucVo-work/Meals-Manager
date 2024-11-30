import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  // Hàm lấy dữ liệu từ API
  Future<Map<String, dynamic>> fetchData(String apiUrl) async {
    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to load data from API');
      }
    } catch (e) {
      throw Exception('Error occurred: $e');
    }
  }
}
