import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class StorageHelper {
  static const String _historyKey = 'qr_history_list';

  // Universal Save/Add Method
  static Future<void> addToHistory(String type, String value) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> history = prefs.getStringList(_historyKey) ?? [];
    
    Map<String, dynamic> newItem = {
      'id': DateTime.now().millisecondsSinceEpoch.toString(),
      'value': value,
      'type': type,
      'timestamp': DateTime.now().toIso8601String(),
    };

    history.insert(0, json.encode(newItem));
    await prefs.setStringList(_historyKey, history);
  }

  // Load History
  static Future<List<Map<String, dynamic>>> getHistory() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> history = prefs.getStringList(_historyKey) ?? [];
    
    return history.map((item) => json.decode(item) as Map<String, dynamic>).toList();
  }

  // Delete Individual Item
  static Future<void> deleteHistoryItem(String id) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> history = prefs.getStringList(_historyKey) ?? [];
    
    history.removeWhere((item) {
      final decoded = json.decode(item) as Map<String, dynamic>;
      return decoded['id'] == id;
    });

    await prefs.setStringList(_historyKey, history);
  }

  // Clear All History
  static Future<void> clearAllHistory() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_historyKey);
  }
}