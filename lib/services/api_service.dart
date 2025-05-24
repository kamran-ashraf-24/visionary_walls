import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'package:visionary_walls/models/info_model.dart';

class ApiService {
  static const String baseUrl = 'https://picsum.photos/v2/list';

  Future<List<Info>> fetchItems(int page, int limit) async {
    final random = Random().nextInt(100);

    final response = await http.get(
      Uri.parse('$baseUrl?page=${page + random}&limit=$limit'),
    );

    if (response.statusCode == 200) {
      final List data = json.decode(response.body);

      return data.map((json) => Info.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load items');
    }
  }
}
