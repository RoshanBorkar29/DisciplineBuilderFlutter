import 'package:flutter/material.dart';
import 'package:flutter_discplinebuilder/common/leaguehierarchy.dart';
import 'package:flutter_discplinebuilder/common/pointsystem.dart';
import 'package:flutter_discplinebuilder/services/authService.dart';
import 'package:lottie/lottie.dart';

class Status extends StatefulWidget {
  static const String routeName='/status';
  const Status({super.key});

  @override
  State<Status> createState() => _StatusState();
}

class _StatusState extends State<Status> {
    String userName = 'Loading...';
  String userEmail = '';
  int points = 0;
  int currentStreak = 0;
  int maxStreak = 0;
  String league = 'Bronze';
  bool loading = true;
  String? error;
  int maxStreakStored=0;
  
  final AuthService _authService=AuthService();
Future<void> _loadProfile() async {
  final data = await _authService.fetchUserProfile(context);
  if (data != null) {
    setState(() {
      

  if(currentStreak>maxStreak){
    maxStreakStored=currentStreak;
  }
      userName = data['name'] ?? 'Unknown';
      userEmail = data['email'] ?? '';
      points = data['points'] ?? 0;
      currentStreak = data['streak'] ?? 0;
      maxStreak = maxStreakStored;
      league = data['league'] ?? 'Bronze';
      loading = false;
    });
  } else {
    setState(() => loading = false);
  }
}
 @override
  void initState() {
    super.initState();
    _loadProfile(); // ✅ Fetch profile as soon as widget is created
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(
        title: const Text(
          'LEAGUE',
          style: TextStyle(fontSize: 20, color: Colors.white),
        ),
        
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.deepPurple, Colors.purpleAccent],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body:Container(
         decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.deepPurple, Colors.purpleAccent],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment:CrossAxisAlignment.start,
            children: [
              //current status/league 
        
              Row(
                mainAxisAlignment:MainAxisAlignment.start,
                children: [
                //Icon 
               Lottie.asset(
                "assets/animations/Trophy.json",
                width:150,
                height:150,
                repeat:true,
               ),
                const SizedBox(height:5,),
                //Points
                Card(
                  color:Colors.green,
                  shape: RoundedRectangleBorder(borderRadius:BorderRadius.circular(16),
                  ),
                  elevation:5,
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      children: [
                        Text('TOTAL POINTS',style:TextStyle(fontSize:15,fontWeight:FontWeight.bold),),
                        Text(points.toString(),style:TextStyle(fontSize:60,fontWeight:FontWeight.bold),),
                      ],
                    ),
                  )),
              ],),
              const SizedBox(height: 30,),
              Leaguehierarchy(currentLeague: league,),
              const SizedBox(height: 30,),
              PointSystemCard(),
              //in row we will have  current status/league and beside that points
              //here we will have hierarchy of league
              //below point system working
          ],),
        ),
      )
       
      
    );
  }
}