import 'package:flutter/material.dart';
import 'package:flutter_discplinebuilder/common/leaderboard.dart';
import 'package:flutter_discplinebuilder/common/statusleague.dart';
import 'package:flutter_discplinebuilder/features/NameAgeScreen.dart';
import 'package:flutter_discplinebuilder/features/home.dart';
import 'package:flutter_discplinebuilder/features/homescreen.dart';
import 'package:flutter_discplinebuilder/features/loginScreen.dart';
import 'package:flutter_discplinebuilder/features/profilescreen.dart';
import 'package:flutter_discplinebuilder/features/register.dart';

Route<dynamic> generateRoute(RouteSettings routeSettings) {
  switch (routeSettings.name) {
    case Homescreen.routeName: // ✅ use the static routeName
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const Homescreen(),
      );
    case Nameagescreen.routeName:
      return MaterialPageRoute(
        settings:routeSettings,
        builder: (_)=>const Nameagescreen());
    case Home.routeName:
      return MaterialPageRoute(
        settings:routeSettings,
        builder: (_)=>const Home());
    case ProfileScreen.routeName:
      return MaterialPageRoute(
        settings:routeSettings,
        builder: (_)=>const ProfileScreen());

     case LoginScreen.routeName:
      return MaterialPageRoute(
        settings:routeSettings,
        builder: (_)=>const LoginScreen());

      case RegisterScreen.routeName:
      return MaterialPageRoute(
        settings:routeSettings,
        builder: (_)=>const RegisterScreen());
      
        case Status.routeName:
      return MaterialPageRoute(
        settings:routeSettings,
        builder: (_)=>const Status());

          case Leaderboard.routeName:
      return MaterialPageRoute(
        settings:routeSettings,
        builder: (_)=>const Leaderboard());
    default:
      return MaterialPageRoute(
        builder: (_) => const Scaffold(
          body: Center(
            child: Text('Screen does not exist'),
          ),
        ),
      );
  }
}
