import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:tracking/auth/auth_service.dart';
import 'package:tracking/pages/dashboard_screen.dart';
import 'login_screen.dart';

class SignupScreen extends StatefulWidget {
  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final AuthService _authService = AuthService();

  Future<void> signUp() async {
    User? user = await _authService.signUp(
      nameController.text.trim(),
      emailController.text.trim(),
      passwordController.text.trim(),
      phoneController.text.trim(),
    );

    if (user != null) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => DashboardScreen()));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Signup failed! Try again.")));
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
              Container(
                height: 400, 
                width: double.infinity,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/signup.jpg'), 
                    fit: BoxFit.contain, 
                  ),
                ),
              ),
              SizedBox(height: 30),

              _buildTextField(
                controller: nameController,
                label: "Full Name",
                icon: Icons.person,
                isPassword: false,
              ),

              _buildTextField(
                controller: emailController,
                label: "Email",
                icon: Icons.email,
                isPassword: false,
              ),

              _buildTextField(
                controller: phoneController,
                label: "Phone Number",
                icon: Icons.phone,
                isPassword: false,
              ),

              _buildTextField(
                controller: passwordController,
                label: "Password",
                icon: Icons.lock,
                isPassword: true,
              ),

              SizedBox(height: 20),

              Container(
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
              ),

              SizedBox(height: 20),

              ElevatedButton(
                onPressed: signUp,
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 15, horizontal: 30), 
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                child: Text("Sign Up", style: TextStyle(fontSize: 18)),
              ),

              SizedBox(height: 20),

              TextButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => LoginScreen()));
                },
                child: Text(
                  "Already have an account? Login",
                  style: TextStyle(fontSize: 16, color: Color.fromARGB(255, 196, 19, 25)),
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
