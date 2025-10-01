import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:techmine/features/root/utils.dart';

@RoutePage()
class NewsPage extends StatelessWidget {
  const NewsPage({super.key, @pathParam required this.id});
  
  final String id;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mainColor,
      body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Center(
            child: SingleChildScrollView(
              physics: ScrollPhysics(),
              scrollDirection: Axis.vertical,
              child: Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    topImage,
                    TopMenu(),
                    Text('new: $id', style: TextStyle(color: Colors.white)),
                    

                  ],
                ),
              )
            )
              
                
          ),
        )
        
      );
  }
}