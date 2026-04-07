import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../constants.dart';

class UserModel {
  final int id;
  final String fullName;
  final String email;
  final String accountNumber;
  final double balance;

  UserModel({
    required this.id,
    required this.fullName,
    required this.email,
    required this.accountNumber,
    required this.balance,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id:            json['id'] ?? 0,
      fullName:      json['full_name'] ?? '',
      email:         json['email'] ?? '',
      accountNumber: json['account_number'] ?? '',
      balance:       (json['balance'] ?? 0).toDouble(),
    );
  }

  UserModel copyWith({double? balance}) => UserModel(
    id: id, fullName: fullName, email: email,
    accountNumber: accountNumber, balance: balance ?? this.balance,
  );
}

class Transaction {
  final int id;
  final String type;
  final double amount;
  final String description;
  final DateTime createdAt;

  Transaction({
    required this.id, required this.type, required this.amount,
    required this.description, required this.createdAt,
  });

  factory Transaction.fromJson(Map<String, dynamic> j) => Transaction(
    id:          j['id'] ?? 0,
    type:        j['type'] ?? 'credit',
    amount:      (j['amount'] ?? 0).toDouble(),
    description: j['description'] ?? '',
    createdAt:   DateTime.parse(j['created_at']),
  );

  bool get isCredit => type == 'credit';
}

class AuthService {
  static const _tokenKey = 'auth_token';

  // ── Persist / retrieve token ───────────────────────────────────────────
  static Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
  }

  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }

  static Future<void> clearToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
  }

  static Future<bool> isLoggedIn() async => (await getToken()) != null;

  // ── Signup ─────────────────────────────────────────────────────────────
  static Future<Map<String, dynamic>> signup({
    required String fullName,
    required String email,
    required String password,
    required String pin,
  }) async {
    try {
      final res = await http.post(
        Uri.parse('$kWorkerBaseUrl/signup'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'full_name': fullName,
          'email': email,
          'password': password,
          'pin': pin,
        }),
      );
      final data = jsonDecode(res.body);
      if (res.statusCode == 201) {
        await saveToken(data['token']);
        return {'success': true, 'user': UserModel.fromJson(data['user'])};
      }
      return {'success': false, 'error': data['error'] ?? 'Signup failed'};
    } catch (e) {
      return {'success': false, 'error': 'Connection error'};
    }
  }

  // ── Login ──────────────────────────────────────────────────────────────
  static Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    try {
      final res = await http.post(
        Uri.parse('$kWorkerBaseUrl/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      );
      final data = jsonDecode(res.body);
      if (res.statusCode == 200) {
        await saveToken(data['token']);
        return {'success': true, 'user': UserModel.fromJson(data['user'])};
      }
      return {'success': false, 'error': data['error'] ?? 'Login failed'};
    } catch (e) {
      return {'success': false, 'error': 'Connection error'};
    }
  }

  // ── Balance ────────────────────────────────────────────────────────────
  static Future<double?> getBalance() async {
    final token = await getToken();
    if (token == null) return null;
    try {
      final res = await http.get(
        Uri.parse('$kWorkerBaseUrl/balance'),
        headers: {'Authorization': 'Bearer $token'},
      );
      if (res.statusCode == 200) {
        return (jsonDecode(res.body)['balance'] as num).toDouble();
      }
    } catch (_) {}
    return null;
  }

  // ── Transactions ───────────────────────────────────────────────────────
  static Future<List<Transaction>> getTransactions() async {
    final token = await getToken();
    if (token == null) return [];
    try {
      final res = await http.get(
        Uri.parse('$kWorkerBaseUrl/transactions'),
        headers: {'Authorization': 'Bearer $token'},
      );
      if (res.statusCode == 200) {
        final list = jsonDecode(res.body)['transactions'] as List;
        return list.map((t) => Transaction.fromJson(t)).toList();
      }
    } catch (_) {}
    return [];
  }

  // ── Transfer ───────────────────────────────────────────────────────────
  static Future<Map<String, dynamic>> transfer({
    required String toAccount,
    required double amount,
    String? description,
  }) async {
    final token = await getToken();
    if (token == null) return {'success': false, 'error': 'Not authenticated'};
    try {
      final res = await http.post(
        Uri.parse('$kWorkerBaseUrl/transfer'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'to_account': toAccount,
          'amount': amount,
          'description': description,
        }),
      );
      final data = jsonDecode(res.body);
      if (res.statusCode == 200) {
        return {'success': true, 'new_balance': data['new_balance']};
      }
      return {'success': false, 'error': data['error'] ?? 'Transfer failed'};
    } catch (e) {
      return {'success': false, 'error': 'Connection error'};
    }
  }
}
