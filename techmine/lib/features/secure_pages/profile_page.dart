import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:techmine/features/root/utils.dart';

@RoutePage()
class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}
class _ProfilePageState extends State<ProfilePage> {


  @override
  Widget build(BuildContext context) {

    return DefaultEmptyPage(
            text: 'Profile', 
            child: Container(
              
            ),
          );
  }
}