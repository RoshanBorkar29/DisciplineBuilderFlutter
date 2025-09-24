import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_discplinebuilder/common/GlobalVariables.dart';
import 'package:flutter_discplinebuilder/common/errorhandling.dart';
import 'package:flutter_discplinebuilder/common/user_provider.dart';
import 'package:flutter_discplinebuilder/common/utils.dart';
import 'package:flutter_discplinebuilder/features/homescreen.dart';
import 'package:flutter_discplinebuilder/models/user.dart';
//import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService{

 void signUp( 
    BuildContext context,
     String email,
    String password,
     String name,)async{
        try{
        // ignore: unused_local_variable
        User user = User(
        id: '',
        name: name,
        email: email,
        password: password,
        token: '',
        streak:0,
        points:0,
        league:'Bronze',
      );
      http.Response res= await http.post(
         Uri.parse('$uri/auth/api/signup',),
         headers: <String,String>{
          'Content-Type':'application/json; charset=UTF-8',
         },
         body:jsonEncode({
               'name':name,
            'email':email,
            'password':password,
         }
         ),
      );
        httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () {
          showSnackBar(
            context,
            'Account created! Login with the same credentials',
          );
           Navigator.pushNamedAndRemoveUntil(
            context,
            Homescreen.routeName,
            (route) => false,
          );
        },
      );
      }
 catch(e){
   showSnackBar(context,e.toString());
 }
}

void signIn({
    required BuildContext context,
  required String email,
  required String password,
}
)async{
  try{
    http.Response res=await http.post(Uri.parse('$uri/auth/api/signin'),
    headers:<String,String>{
      'Content-Type':'application/json; charset=UTF-8',
    },
    body: jsonEncode({
        'email': email,
        'password': password,
      }),
    
    );
     httpErrorHandle(
        response: res,
        context: context,
// ...existing code...
// ...existing code...
onSuccess: () async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  final decoded = jsonDecode(res.body);
  prefs.setString('token', decoded['token']);
  prefs.setString('userId', decoded['user']['id']);
  prefs.setString('userName', decoded['user']['name']);   // <-- Save userName
  prefs.setString('userEmail', decoded['user']['email']); // <-- Save userEmail
  Provider.of<UserProvider>(context, listen: false).setUser(res.body);
  Navigator.pushNamedAndRemoveUntil(
    context,
    Homescreen.routeName,
    (route) => false,
  );
},
// ...existing code...
      );

  }
  catch(e){
    showSnackBar(context,e.toString());
  }
}

}