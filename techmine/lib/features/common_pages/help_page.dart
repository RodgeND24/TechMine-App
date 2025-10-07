import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:techmine/features/root/utils.dart';

@RoutePage()
class HelpPage extends StatefulWidget {
  const HelpPage({super.key});

  @override
  _HelpPageState createState() => _HelpPageState();
}
class _HelpPageState extends State<HelpPage> {


  @override
  Widget build(BuildContext context) {

    return DefaultEmptyPage(
            text: 'Help', 
            child: Container(),
          );
  }
}