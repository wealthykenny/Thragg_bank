import 'dart:convert';
import 'package:http/http.dart' as http;
import '../constants.dart';

class AuthService {
  // ─── Dual Worker Endpoints ───────────────────────────────────────────────
  // Points to: thragg-bank-api.tekbizz.workers.dev
  static const String bankUrl = 'https://thragg-bank-api.tekbizz.workers.dev';
  
  // Points to: huggingface-backend.tekbizz.workers.dev
  static const String aiUrl = 'https://huggingface-backend.tekbizz.workers.dev';

  // ─── Banking Actions (thragg-bank-api) ──────────────────────────────────
  
  static Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final res = await http.post(
        Uri.parse('$bankUrl/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      );
      return jsonDecode(res.body);
    } catch (e) {
      return {'error': 'Bank connection failed'};
    }
  }

  // ─── AI Edit Actions (huggingface-backend) ──────────────────────────────
  
  static Future<Map<String, dynamic>> processImageEdit({
    required String prompt,
    required String base64Image,
  }) async {
    try {
      // Note: Ensure your huggingface-backend Worker has an '/edit' or '/generate' route
      final res = await http.post(
        Uri.parse('$aiUrl/edit'), 
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'prompt': prompt,
          'image': base64Image,
        }),
      );
      return jsonDecode(res.body);
    } catch (e) {
      return {'error': 'AI Backend unreachable'};
    }
  }

  // ─── Health Check Utility ───────────────────────────────────────────────
  
  static Future<bool> checkSystems() async {
    try {
      final res = await http.get(Uri.parse('$bankUrl/health'));
      return res.statusCode == 200;
    } catch (_) {
      return false;
    }
  }
}
