import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:techmine/features/root/utils.dart';

@RoutePage()
class StartGamePage extends StatefulWidget {
  const StartGamePage({super.key});

  @override
  _StartGamePageState createState() => _StartGamePageState();
}
class _StartGamePageState extends State<StartGamePage> {


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: mainColor,
      body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Center(
              child: Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    topImage,
                    TopMenu(),
                    Text('Start game', style: TextStyle(color: Colors.white))
                  ],
                ),
              )
                
          ),
        )
        
      );
  }
}