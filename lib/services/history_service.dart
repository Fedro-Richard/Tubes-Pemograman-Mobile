import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class HistoryService {
  static const String _txKey = 'history_transactions';
  static const String _sysKey = 'history_system_updates';

  static String _formatAmount(int amount) {
    final s = amount.toString();
    final buffer = StringBuffer();
    int count = 0;
    for (int i = s.length - 1; i >= 0; i--) {
      buffer.write(s[i]);
      count++;
      if (count % 3 == 0 && i != 0) buffer.write('.');
    }
    return 'Rp ' + buffer.toString().split('').reversed.join('');
  }

  static Future<void> addTransaction({required String name, required int amount, required String date}) async {
    final prefs = await SharedPreferences.getInstance();
    final current = await getTransactions();
    final entry = {
      'date': date,
      'title': 'Pembayaran - $name',
      'desc': 'Pembayaran berhasil untuk $name (${_formatAmount(amount)})'
    };
    final updated = [entry, ...current];
    await prefs.setString(_txKey, jsonEncode(updated));
  }

  static Future<List<Map<String, String>>> getTransactions() async {
    final prefs = await SharedPreferences.getInstance();
    final s = prefs.getString(_txKey);
    if (s == null) return [];
    final List<dynamic> data = jsonDecode(s);
    return data.map((e) => Map<String, String>.from(e)).toList();
  }

  static Future<void> addSystemUpdate({required String date, required String title, required String desc}) async {
    final prefs = await SharedPreferences.getInstance();
    final current = await getSystemUpdates();
    final entry = {
      'date': date,
      'title': title,
      'desc': desc,
    };
    final updated = [entry, ...current];
    await prefs.setString(_sysKey, jsonEncode(updated));
  }

  static Future<List<Map<String, String>>> getSystemUpdates() async {
    final prefs = await SharedPreferences.getInstance();
    final s = prefs.getString(_sysKey);
    if (s == null) return [];
    final List<dynamic> data = jsonDecode(s);
    return data.map((e) => Map<String, String>.from(e)).toList();
  }
}

