import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
// 🟢 Relative import ki jagah sahi package name import kiya
import '../screens/navigation_hub.dart'; 

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const QRMasterApp());
}

class QRMasterApp extends StatefulWidget {
  const QRMasterApp({super.key});

  @override
  State<QRMasterApp> createState() => _QRMasterAppState();
}

class _QRMasterAppState extends State<QRMasterApp> {
  bool _isDarkMode = true;

  @override
  void initState() {
    super.initState();
    _loadThemeSettings();
  }

  void _loadThemeSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _isDarkMode = prefs.getBool('dark_mode') ?? true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'QR Master Pro',
      debugShowCheckedModeBanner: false,
      themeMode: _isDarkMode ? ThemeMode.dark : ThemeMode.light,
      
      // Light Theme config
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        primaryColor: const Color(0xFFFFB703),
        scaffoldBackgroundColor: const Color(0xFFF8F9FA),
        textTheme: GoogleFonts.poppinsTextTheme(ThemeData.light().textTheme),
      ),
      
      // Premium Dark Theme Config
      darkTheme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        primaryColor: const Color(0xFFFFB703), // Gold Accent
        scaffoldBackgroundColor: const Color(0xFF121212), // Pure Deep Black
        cardColor: const Color(0xFF1E1E1E),
        textTheme: GoogleFonts.poppinsTextTheme(ThemeData.dark().textTheme),
      ),
      home: const MainNavigationScreen(),
    );
  }
}