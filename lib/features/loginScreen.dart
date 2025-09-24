import 'package:flutter/material.dart';
import 'package:flutter_discplinebuilder/common/mytexfiled.dart';
import 'package:flutter_discplinebuilder/features/register.dart';
import 'package:flutter_discplinebuilder/services/authService.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginScreen extends StatefulWidget {
  static const String routeName = '/login-screen';
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final AuthService _authService=AuthService();

  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }
  void signInUser(){
    _authService.signIn(context: context, email: emailController.text, password: passwordController.text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.deepPurple, Colors.purpleAccent],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Card(
              // color:Colors.deepPurple,
              elevation: 8,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Padding(
                padding: const EdgeInsets.all(25),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // App title
                    Text(
                      "Welcome Back 👋",
                      style: GoogleFonts.poppins(
                        textStyle: const TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: Colors.deepPurple,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Login to continue",
                      style: GoogleFonts.poppins(
                        textStyle: const TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),

                    // Email field
                    MyTextField(
                      controller: emailController,
                      hintText: "Enter your email",
                      obscureText: false,
                    ),
                    const SizedBox(height: 15),

                    // Password field
                    MyTextField(
                      controller: passwordController,
                      hintText: "Enter your password",
                      obscureText: true,
                    ),
                    const SizedBox(height: 10),

                    // Forgot password
                    Align(
                      alignment: Alignment.centerRight,
                      child: GestureDetector(
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Forgot Password Clicked"),
                            ),
                          );
                        },
                        child: Text(
                          "Forgot Password?",
                          style: GoogleFonts.poppins(
                            textStyle: const TextStyle(
                              color: Colors.deepPurple,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 25),

                    // Login button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: (){
                          signInUser();
                          

                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.deepPurple,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          "LOGIN",
                          style: GoogleFonts.poppins(
                            textStyle: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                   // Text('Or If you dont have account')
                    // Register button (outlined)
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(
                        onPressed: () {
                          Navigator.pushNamed(context, RegisterScreen.routeName);
                        },
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          side: const BorderSide(color: Colors.deepPurple),
                        ),
                        child: Text(
                          "REGISTER ",
                          style: GoogleFonts.poppins(
                            textStyle: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Colors.deepPurple,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Divider
                    Row(
                      children: [
                        Expanded(child: Divider(color: Colors.grey[400])),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          child: Text("Or continue with"),
                        ),
                        Expanded(child: Divider(color: Colors.grey[400])),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // Social icons row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildSocialIcon(Icons.g_mobiledata, Colors.red),
                        const SizedBox(width: 20),
                        _buildSocialIcon(Icons.facebook, Colors.blue),
                        const SizedBox(width: 20),
                        _buildSocialIcon(Icons.apple, Colors.black),
                        const SizedBox(width: 20),
                        _buildSocialIcon(Icons.alternate_email, Colors.lightBlue),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSocialIcon(IconData icon, Color color) {
    return CircleAvatar(
      radius: 25,
      backgroundColor: color.withOpacity(0.1),
      child: IconButton(
        onPressed: () {},
        icon: Icon(icon, color: color, size: 28),
      ),
    );
  }
}
