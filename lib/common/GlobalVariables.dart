import 'package:flutter/material.dart';
String uri = 'http://10.115.144.193:3000';
class MyWidget extends StatelessWidget {
 

  MyWidget({super.key, });

  @override
  Widget build(BuildContext context) {
    return Text('Using URI: $uri');
  }
}
