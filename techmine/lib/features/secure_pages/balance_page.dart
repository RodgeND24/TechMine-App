import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

@RoutePage()
class BalancePage extends StatefulWidget {
  const BalancePage({super.key});

  @override
  _BalancePageState createState() => _BalancePageState();
}
class _BalancePageState extends State<BalancePage> {


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Column(
        children: [
          Text('Profile Page'),
          
          Expanded(
            child: AutoRouter()
          ),
        ],
      ),
    );
  }
}