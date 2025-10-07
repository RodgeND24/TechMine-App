import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:techmine/features/root/utils.dart';

@RoutePage()
class AllNewsPage extends StatelessWidget {
  const AllNewsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultEmptyPage(
            text: 'All news', 
            child: Container(),
          );
  }
}