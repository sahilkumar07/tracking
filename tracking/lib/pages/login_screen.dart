import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:tracking/auth/auth_service.dart';
import 'package:tracking/pages/dashboard_screen.dart';
import 'signup_screen.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final AuthService _authService = AuthService();

  Future<void> login() async {
    User? user = await _authService.signIn(
        emailController.text, passwordController.text);
    if (user != null) {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => DashboardScreen()));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Login failed! Check credentials.")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/login.jpg', 
                height: 400,
                fit: BoxFit.contain,
              ),
              SizedBox(height: 20),

              Text(
                "Welcome",
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
              SizedBox(height: 40),

              // Email Field
              _buildTextField(
                controller: emailController,
                label: "Email",
                icon: Icons.email,
                isPassword: false,
              ),

              SizedBox(height: 20),

              // Password Field
              _buildTextField(
                controller: passwordController,
                label: "Password",
                icon: Icons.lock,
                isPassword: true,
              ),

              SizedBox(height: 40),

              ElevatedButton(
                onPressed: login,
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
                child: Text("Login", style: TextStyle(fontSize: 18)),
              ),

              SizedBox(height: 20),

              TextButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => SignupScreen()));
                },
                child: Text(
                  "Don't have an account? Sign up",
                  style: TextStyle(
                      fontSize: 16,
                      color: const Color.fromARGB(255, 237, 16, 16)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required bool isPassword,
  }) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      padding: EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 8,
            offset: Offset(0, 4), 
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        obscureText: isPassword,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: Colors.blue),
          prefixIcon: Icon(icon, color: Colors.blue),
          border: InputBorder.none,
        ),
      ),
    );
  }
}
