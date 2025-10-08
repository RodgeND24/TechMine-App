import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:techmine/features/root/utils.dart';

@RoutePage()
class ServerPage extends StatefulWidget {
  
  const ServerPage({super.key, @PathParam('name') required this.name});
  final String name;

  @override
  _ServerPageState createState() => _ServerPageState();
}
class _ServerPageState extends State<ServerPage> {


  @override
  Widget build(BuildContext context) {

    return DefaultEmptyPage(
      text: widget.name,
      child: Column(
        children: [

        ]
      ),
    );
  }
}