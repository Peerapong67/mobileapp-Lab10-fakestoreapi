import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'product_list_screen.dart';
import 'admin_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _userController = TextEditingController();
  final _passController = TextEditingController();
  bool _isLoading = false;

  Future<void> _login() async {
    setState(() => _isLoading = true);
    if (_userController.text == "johnd" && _passController.text == "m38rmn=") {
      if (!mounted) return;
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const AdminScreen()));
      setState(() => _isLoading = false);
      return;
    }
    final res = await http.get(Uri.parse('https://fakestoreapi.com/users'));
    if (res.statusCode == 200) {
      List users = json.decode(res.body);
      var user = users.firstWhere(
        (u) => u['username'] == _userController.text && u['password'] == _passController.text,
        orElse: () => null,
      );

      if (!mounted) return;
      if (user != null) {
        if (user['username'] == 'johnd') {
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const AdminScreen()));
        } else {
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const ProductListScreen()));
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("ชื่อผู้ใช้หรือรหัสผ่านไม่ถูกต้อง")));
      }
    }
    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(30),
          child: Column(
            children: [
              const Icon(Icons.lock_outline, size: 80, color: Colors.deepPurple),
              const SizedBox(height: 20),
              const Text("Barrel Store Login", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              const SizedBox(height: 30),
              TextField(controller: _userController, decoration: const InputDecoration(labelText: "Username", border: OutlineInputBorder())),
              const SizedBox(height: 15),
              TextField(controller: _passController, obscureText: true, decoration: const InputDecoration(labelText: "Password", border: OutlineInputBorder())),
              const SizedBox(height: 25),
              _isLoading
                  ? const CircularProgressIndicator()
                  : SizedBox(width: double.infinity, height: 50, child: ElevatedButton(onPressed: _login, child: const Text("LOGIN")))
            ],
          ),
        ),
      ),
    );
  }
}
