import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'main_activity.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  Future<void> login() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? username = prefs.getString('email');
    String? password = prefs.getString('password');

    // Perform your login logic here (for example, checking the credentials)
    // This is just a dummy check, replace it with actual validation
    if (username == emailController.text && password == passwordController.text) {
      SharedPreferences prefs = await SharedPreferences.getInstance();

      // Save the login state in SharedPreferences
      await prefs.setBool('log_in', true);

      // Navigate to the main activity page
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => MainActivity()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Invalid credentials.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: passwordController,
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            ElevatedButton(
              onPressed: login,
              child: Text('Login'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pushNamed('/signup');
              },
              child: Text('Don\'t have an account? Sign up'),
            ),
          ],
        ),
      ),
    );
  }
}
