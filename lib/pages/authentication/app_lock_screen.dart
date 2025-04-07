import 'package:flutter/material.dart';
import 'package:otm_inventory/utils/auth_service.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: AppLockScreen(),
    );
  }
}

class AppLockScreen extends StatefulWidget {
  @override
  _AppLockScreenState createState() => _AppLockScreenState();
}

class _AppLockScreenState extends State<AppLockScreen> {
  final AuthService _authService = AuthService();
  bool _authenticated = false;

  @override
  void initState() {
    super.initState();
    _authenticate();
  }

  void _authenticate() async {
    bool success = await _authService.authenticate();
    if (success) {
      setState(() => _authenticated = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_authenticated) {
      return const HomeScreen();
    } else {
      return const Scaffold(
        body: Center(child: Text("Authenticating...")),
      );
    }
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text("🔓 Welcome to your secure app!", style: TextStyle(fontSize: 24)),
      ),
    );
  }
}
