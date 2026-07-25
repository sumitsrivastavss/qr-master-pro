import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../utils/storage_helper.dart'; // Storage helper connect kiya

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _darkMode = true;
  bool _scanSound = true;
  bool _vibration = false;
  bool _saveHistory = true;
  bool _autoCopy = true;
  final String _language = "English";

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  // SharedPreferences se saved settings load karna
  void _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _darkMode = prefs.getBool('dark_mode') ?? true;
      _scanSound = prefs.getBool('scan_sound') ?? true;
      _vibration = prefs.getBool('vibration') ?? false;
      _saveHistory = prefs.getBool('save_history') ?? true;
      _autoCopy = prefs.getBool('auto_copy') ?? true;
    });
  }

  // Koi bhi toggle change hone par setting update karna
  void _updateSetting(String key, bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(key, value);
  }

  // History saaf karne ka confirmation dialog box
  void _confirmClearHistory() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1E1E1E),
        title: const Text("Clear History?", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        content: const Text("Kya aap sach mein saari scan aur generate history mitaana chahte hain?", style: TextStyle(color: Colors.grey)),
        actions: [
          TextButton(
            child: const Text("Cancel", style: TextStyle(color: Colors.white)),
            onPressed: () => Navigator.pop(context),
          ),
          TextButton(
            child: const Text("Clear All", style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold)),
            onPressed: () async {
              await StorageHelper.clearAllHistory();
              if (mounted) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Poori history saaf kar di gayi hai.")),
                );
              }
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('⚙️ Settings', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        children: [
          // Toggles Setup
          _buildToggleTile("🌙 Dark Mode", _darkMode, (val) {
            setState(() => _darkMode = val);
            _updateSetting('dark_mode', val);
          }),
          _buildToggleTile("🔔 Scan Sound", _scanSound, (val) {
            setState(() => _scanSound = val);
            _updateSetting('scan_sound', val);
          }),
          _buildToggleTile("📳 Vibration", _vibration, (val) {
            setState(() => _vibration = val);
            _updateSetting('vibration', val);
          }),
          _buildToggleTile("📝 Save History", _saveHistory, (val) {
            setState(() => _saveHistory = val);
            _updateSetting('save_history', val);
          }),
          _buildToggleTile("📋 Auto Copy Result", _autoCopy, (val) {
            setState(() => _autoCopy = val);
            _updateSetting('auto_copy', val);
          }),
          
          const Divider(color: Colors.white10, height: 32),
          
          // Clickable Buttons Setup
          _buildActionTile("🌐 Language", trailingText: "$_language >", onTap: () {}),
          _buildActionTile("🗑️ Clear History", onTap: _confirmClearHistory),
          _buildActionTile("🔄 Reset Settings", onTap: () {}),
          _buildActionTile("📖 Privacy Policy", onTap: () {}),
          _buildActionTile("⭐ Rate App", onTap: () {}),
          _buildActionTile("📤 Share App", onTap: () {}),
          
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 24),
            child: Center(
              child: Text("ℹ️ Version 1.0.0", style: TextStyle(color: Colors.grey, fontSize: 14)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildToggleTile(String title, bool value, ValueChanged<bool> onChanged) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      decoration: BoxDecoration(color: const Color(0xFF1E1E1E), borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        title: Text(title, style: const TextStyle(color: Colors.white, fontSize: 15)),
        trailing: Switch(value: value, activeColor: const Color(0xFFFFB703), onChanged: onChanged),
      ),
    );
  }

  Widget _buildActionTile(String title, {String? trailingText, VoidCallback? onTap}) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      decoration: BoxDecoration(color: const Color(0xFF1E1E1E), borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        title: Text(title, style: const TextStyle(color: Colors.white, fontSize: 15)),
        trailing: Text(trailingText ?? ">", style: const TextStyle(color: Colors.grey, fontSize: 15)),
        onTap: onTap,
      ),
    );
  }
}




