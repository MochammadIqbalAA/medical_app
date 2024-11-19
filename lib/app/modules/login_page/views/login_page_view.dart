import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myapp/app/controllers/auth_controller.dart';
import 'package:myapp/app/modules/register_page/views/register_page_view.dart'; // Pastikan jalur ini benar

class LoginPageView extends StatelessWidget {
  final AuthController _authController = Get.put(AuthController());
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFE5F2F8), // Background color
      appBar: AppBar(
        title: Text(
          'Login',
          style: TextStyle(
            color: Colors.white, // Change title color to white
            fontWeight: FontWeight.bold, // Make title bold
          ),
        ),
        backgroundColor: Color.fromARGB(244, 90, 97, 234), // Darker app bar color
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView( // Scrollable view for small screens
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: 20),
              Text(
                'Welcome Back!',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(244, 90, 97, 234),
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 40),
              _buildTextField(_emailController, 'Email', false),
              SizedBox(height: 16),
              _buildTextField(_passwordController, 'Password', true),
              SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  _authController.loginUser(
                    _emailController.text,
                    _passwordController.text,
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromARGB(244, 90, 97, 234), // Button color
                  padding: EdgeInsets.symmetric(vertical: 15),
                  textStyle: TextStyle(fontSize: 18),
                ),
                child: Text(
                  'Login',
                  style: TextStyle(
                    color: Colors.white, // Change text color to white
                    fontWeight: FontWeight.bold, // Make text bold
                  ),
                ),
              ),
              SizedBox(height: 24),
              // Teks untuk navigasi ke halaman register
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Belum memiliki akun? "),
                  GestureDetector(
                    onTap: () {
                      Get.to(RegisterPageView()); // Navigasi ke halaman Register
                    },
                    child: Text(
                      "Register",
                      style: TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Widget untuk membangun text field
  Widget _buildTextField(TextEditingController controller, String label, bool isObscure) {
    return TextField(
      controller: controller,
      obscureText: isObscure,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Color.fromARGB(244, 90, 97, 234)), // Label color
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12), // Rounded corners
          borderSide: BorderSide(color: Color.fromARGB(244, 90, 97, 234)), // Border color
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Color.fromARGB(244, 90, 97, 234)), // Focused border color
        ),
      ),
    );
  }
}