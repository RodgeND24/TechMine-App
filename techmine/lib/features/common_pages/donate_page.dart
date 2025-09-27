import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:techmine/features/root/utils.dart';

@RoutePage()
class DonatePage extends StatefulWidget {
  const DonatePage({super.key});

  @override
  _DonatePageState createState() => _DonatePageState();
}
class _DonatePageState extends State<DonatePage> {


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
                    Text('donate', style: TextStyle(color: Colors.white))
                  ],
                ),
              )
                
          ),
        )
        
      );
  }
}