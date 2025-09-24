// ignore_for_file: unused_field

import 'package:flutter/material.dart';
//import 'package:flutter_discplinebuilder/common/mytexfiled.dart';
import 'package:flutter_discplinebuilder/features/homescreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Nameagescreen extends StatefulWidget {
   static const String routeName = '/nameagescreen';
  const Nameagescreen({super.key});

  @override
  State<Nameagescreen> createState() => _NameagescreenState();
}

class _NameagescreenState extends State<Nameagescreen> {
  final TextEditingController _nameController=TextEditingController();
  final TextEditingController _ageController=TextEditingController();

  void _saveData() async{
    final prefs=await SharedPreferences.getInstance();
    await prefs.setString('name',_nameController.text);
    await prefs.setInt('age',int.parse(_ageController.text));

    Navigator.pushReplacementNamed(context, Homescreen.routeName);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:Container(
        decoration:const BoxDecoration(
          gradient: LinearGradient(   
            colors: [Colors.black, Colors.deepPurple],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            ),
            
        ),
        child: Center(
          child:Container(
            height:320,

            margin:const EdgeInsets.symmetric(horizontal: 20),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color:  Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color:Colors.black.withOpacity(0.3),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
          child:Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
            // MyTextField(controller: _nameController, hintText: 'Enter your name'),
            // const SizedBox(height: 15,),
            // MyTextField(controller: _ageController, hintText:'Enter your age'),
            const SizedBox(height: 15,),
            ElevatedButton(onPressed: _saveData, 
            style:ElevatedButton.styleFrom(
              backgroundColor: Colors.deepPurpleAccent,
              foregroundColor: Colors.white,
              padding:const EdgeInsets.symmetric(horizontal: 40,vertical: 15),
              shape:RoundedRectangleBorder(
                borderRadius:BorderRadius.circular(12),
              ),
              elevation:8,
            ),
            child: const Text('Confirm',style:TextStyle(fontSize: 22,fontWeight: FontWeight.bold,color:Colors.white),)
            ),

          ],),
          ) ,
          ),
        
       
      ),
      );
  }
}