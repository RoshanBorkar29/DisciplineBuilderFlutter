import 'package:flutter/material.dart';
import 'package:flutter_discplinebuilder/common/user_provider.dart';
import 'package:flutter_discplinebuilder/constrainst/router.dart';
import 'package:flutter_discplinebuilder/features/splashscreen.dart';
import 'package:provider/provider.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => UserProvider(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Discipline Builder',
        theme: ThemeData.dark(),
        onGenerateRoute: generateRoute, // ✅ connects your routes
        home: const Splashscreen(), // ✅ first screen
      ),
    );
  }
}
