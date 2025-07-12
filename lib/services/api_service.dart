import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/klinik_model.dart';

class ApiService {
  static const String baseUrl = 'http://192.168.18.72:8000/api/klinik'; // ganti IP sesuai server lokal kamu

  /// ✅ Ambil semua data klinik
  static Future<List<KlinikModel>> fetchKlinik() async {
    try {
      final response = await http.get(Uri.parse(baseUrl));
      if (response.statusCode == 200) {
        final List data = json.decode(response.body);
        return data.map((item) => KlinikModel.fromJson(item)).toList();
      } else {
        throw Exception('Gagal memuat data klinik');
      }
    } catch (e) {
      throw Exception('Terjadi kesalahan: $e');
    }
  }

  /// ➕ Tambah data klinik
  static Future<bool> addKlinik(KlinikModel klinik) async {
    try {
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(klinik.toJson()),
      );
      return response.statusCode == 201;
    } catch (e) {
      return false;
    }
  }

  /// 📝 Update data klinik
 static Future<bool> updateKlinik(int id, KlinikModel klinik) async {
  try {
    final url = Uri.parse('$baseUrl/$id');
    final response = await http.put(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode(klinik.toJson()),
    );

    print('RESPONSE UPDATE: ${response.statusCode} - ${response.body}');

    return response.statusCode == 200;
  } catch (e) {
    print('ERROR updateKlinik: $e');
    return false;
  }
}


  /// ❌ Hapus data klinik
  static Future<bool> deleteKlinik(int id) async {
    try {
      final response = await http.delete(Uri.parse('$baseUrl/$id'));
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  /// 📍 Ambil detail klinik
  static Future<KlinikModel?> getKlinikById(int id) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/$id'));
      if (response.statusCode == 200) {
        return KlinikModel.fromJson(json.decode(response.body));
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }
}
