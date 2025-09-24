import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_discplinebuilder/features/home.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Homescreen extends StatefulWidget {
  static const String routeName = '/homeScreen'; // ✅ define route here
  const Homescreen({super.key});

  @override
  State<Homescreen> createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> {
  String Username="";
  @override
  void initState(){
    super.initState();
    _loadUser();
  }
  void _loadUser() async{
    final prefs=await SharedPreferences.getInstance();
   setState(() {
     Username=prefs.getString('name') ?? 'User';
   });
  }
  void navigateToMainScreen(){
    Navigator.pushReplacementNamed(context, Home.routeName);
  }
  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      //theme:ThemeData.light(),
      
    body:Container(
      decoration:BoxDecoration(
        gradient: LinearGradient(colors: [Colors.black,Colors.deepPurple],
        begin: Alignment.topCenter,
        end:Alignment.bottomCenter,
        ),
      ),
      child:Column(
        mainAxisAlignment:MainAxisAlignment.center,
        children: [ 
            Text('Welcome ${Username}!!',
            style:TextStyle(fontSize: 22,color:Colors.black,fontWeight: FontWeight.bold)),

            const SizedBox(height:40),

               AnimatedTextKit(
                repeatForever: false,
                totalRepeatCount: 1,
                animatedTexts: [
                  TyperAnimatedText("✅ Complete tasks → Earn EXP",
                      textStyle: const TextStyle(color: Colors.white, fontSize: 20)),
                  TyperAnimatedText("🔥 Maintain streaks → Bonus EXP",
                      textStyle: const TextStyle(color: Colors.white, fontSize: 20)),
                  TyperAnimatedText("📊 Weekly insights → Track growth",
                      textStyle: const TextStyle(color: Colors.white, fontSize: 20)),
                  TyperAnimatedText("🏆 Unlock Ranks → Beginner → Pro → Master",
                      textStyle: const TextStyle(color: Colors.white, fontSize: 20)),
                ],
              ),

              const SizedBox(height:40),

              ElevatedButton(onPressed: navigateToMainScreen, 
              style:ElevatedButton.styleFrom(
               backgroundColor: Colors.deepPurpleAccent,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  shape:RoundedRectangleBorder(
                    borderRadius:BorderRadius.circular(10),
                  ),
                  elevation: 8,

              ),
              child: const Text('Continue',style:TextStyle(fontSize: 20,color: Colors.white)))
        ],
      )
    ),
    
    );
  }
}