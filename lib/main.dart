import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kudiaccess/firebase_options.dart';
import 'package:kudiaccess/screens/splashscreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _fontFamily = '';

  @override
  void initState() {
    super.initState();
    _loadFontFamily();
  }

  Future<void> _loadFontFamily() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _fontFamily = prefs.getString('fontFamily') ?? 'Roboto';
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'kudiAccess',
      theme: ThemeData(
        fontFamily: _fontFamily,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const SplashScreen(),
    );
  }
}
