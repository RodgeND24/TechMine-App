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

    return DefaultEmptyPage(
            text: 'Start', 
            child: Container(),
          );
  }
}