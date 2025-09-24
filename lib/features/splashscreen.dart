import 'dart:async';
import 'package:flutter/material.dart';
//import 'package:flutter_discplinebuilder/features/home.dart';
import 'package:flutter_discplinebuilder/features/homescreen.dart';
//import 'package:flutter_discplinebuilder/features/NameAgeScreen.dart';
//import 'package:flutter_discplinebuilder/features/homescreen.dart';
import 'package:flutter_discplinebuilder/features/loginScreen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
//import 'package:shared_preferences/shared_preferences.dart';

class Splashscreen extends StatefulWidget {
  
  const Splashscreen({super.key});

  @override
  State<Splashscreen> createState() => _SplashscreenState();
}

class _SplashscreenState extends State<Splashscreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    // Animation setup
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    )..forward();

    _scaleAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );

    // Navigate after 3 sec
    Timer(const Duration(seconds: 6), () async{
      final prefs=await SharedPreferences.getInstance();
      final token=prefs.getString('token');
      if(token!=null && token.isNotEmpty){
        Navigator.pushReplacementNamed(context,Homescreen.routeName);
      }else{
        Navigator.pushReplacementNamed(context, LoginScreen.routeName);
      }
        

    
  
    });
  }

  @override
  void dispose() {
    _controller.dispose(); // cleanup
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.black, Colors.deepPurple],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: ScaleTransition(
            scale: _scaleAnimation,
            child: Column(
              mainAxisSize: MainAxisSize.min, // centers content vertically
              children: [
                const Icon(
                  Icons.bolt,
                  size: 70,
                  color: Colors.white,
                ),
                const SizedBox(height: 20),
                Text(
                  'Discipline Builder',
                  style: GoogleFonts.orbitron( // custom font
                    fontSize: 28,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'Level Up Your Discipline',
                  style: GoogleFonts.robotoCondensed(
                    fontSize: 18,
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
