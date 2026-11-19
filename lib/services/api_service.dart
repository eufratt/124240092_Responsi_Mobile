import 'dart:convert';
import 'package:http/http.dart' as http;

// Fetch + parse API Kitsu, dipisah dari UI. JSON dipakai langsung sebagai Map.
class ApiService {
  static const _base = 'https://kitsu.io/api/edge/anime';

  // Daftar anime: {"data": [ {id, attributes: {...}} ]}
  static Future<List<Map<String, dynamic>>> fetchAnimes() async {
    final res = await http.get(Uri.parse('$_base/?page[limit]=20&page[offset]=0'));
    if (res.statusCode != 200) throw Exception('Gagal memuat data (${res.statusCode})');
    return (jsonDecode(res.body)['data'] as List).cast<Map<String, dynamic>>();
  }

  // Detail anime: {"data": {id, attributes: {...}}} -> kembalikan isi 'data'.
  static Future<Map<String, dynamic>> fetchAnime(String id) async {
    final res = await http.get(Uri.parse('$_base/$id'));
    if (res.statusCode != 200) throw Exception('Gagal memuat detail (${res.statusCode})');
    return jsonDecode(res.body)['data'] as Map<String, dynamic>;
  }
}
