import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_discplinebuilder/common/GlobalVariables.dart';
import 'package:flutter_discplinebuilder/common/errorhandling.dart';
import 'package:flutter_discplinebuilder/common/user_provider.dart';
import 'package:flutter_discplinebuilder/common/utils.dart';
import 'package:flutter_discplinebuilder/features/homescreen.dart';
import 'package:flutter_discplinebuilder/features/loginScreen.dart';
import 'package:flutter_discplinebuilder/models/user.dart';
import 'package:google_sign_in/google_sign_in.dart';
//import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';


const String YOUR_CLIENT_SERVER_ID='1095715791482-3isruo3p83p1c3p81l8dl50gs6nj8ac6.apps.googleusercontent.com';
const String BACKEND_URL = 'http://10.115.144.193:3000/api/auth/google';
class AuthService{
 Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }
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
  prefs.setString('userEmail', decoded['user']['email']);
  prefs.setInt('streak',decoded['user']['streak']);
  prefs.setInt('points',decoded['user']['points']);
  prefs.setString('league',decoded['user']['league']); // <-- Save userEmail
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
Future<Map<String, dynamic>?> fetchUserProfile(BuildContext context) async {
  try {
    final token = await _getToken();
    if (token == null) {
      // You might want to navigate to the sign-in screen here
      return null;
    }

    final response = await http.get(
      Uri.parse("$uri/auth/api/current"),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
    );

    // 💡 Add mounted check before using context after await
    if (!context.mounted) return null; 

    // The httpErrorHandle must return the data map on success
    final decodedData = httpErrorHandle(
      response: response,
      context: context,
      onSuccess: () {
        final data = jsonDecode(response.body);
        
        // 💡 OPTIONAL: Update the UserProvider here with the latest data
        // Provider.of<UserProvider>(context, listen: false).setUser(response.body);

        return data as Map<String, dynamic>; 
      },
    );
    
    // httpErrorHandle returns null if there was an error
    return decodedData;

  } catch (e) {
    debugPrint('Error fetching user profile: $e');
    // 💡 Add mounted check before using context
    if (!context.mounted) return null;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Failed to fetch user profile: ${e.toString()}')),
    );
    return null;
  }
}
 void logout(BuildContext context) async {
    // 1. Clear data from SharedPreferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    await prefs.remove('userId');
    await prefs.remove('userName');
    await prefs.remove('userEmail');
    await prefs.remove('streak');
    await prefs.remove('points');
    await prefs.remove('league');
    
    // 2. Clear global state provider
    Provider.of<UserProvider>(context, listen: false).clearUser();
    
    // 3. Navigate to the Login/Initial screen and remove all previous routes
    // NOTE: You must have a route defined for your login screen.
    if (context.mounted) {
      Navigator.pushNamedAndRemoveUntil(
        context,
       LoginScreen.routeName, // Use your actual login screen route name
        (route) => false, // Clears the entire navigation stack
      );
    }
  }
  // ignore: unused_field
 final GoogleSignIn _googleSignIn = GoogleSignIn(
    serverClientId: YOUR_CLIENT_SERVER_ID, // FIXED LINE
    scopes: ['email', 'profile'],
  );
}