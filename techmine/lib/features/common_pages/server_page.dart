import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

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

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(widget.name)
          ],
        ),
      ),
    );
  }
}