import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:techmine/features/root/utils.dart';
import 'package:techmine/services/auth/auth_provider.dart';

@RoutePage()
class MainPage extends StatelessWidget {
  const MainPage({super.key});
  

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
                    Text('main', style: TextStyle(color: Colors.white))
                  ],
                ),
              )
                
          ),
        )
        
      );
  }
}