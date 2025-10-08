import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:techmine/features/routing/app_route.dart';
import 'package:techmine/services/auth/auth_provider.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:techmine/features/root/utils.dart';

void main() {
  setUrlStrategy(PathUrlStrategy());
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  _MyAppState createState() => _MyAppState();


}


class _MyAppState extends State<MyApp> {

  final appRouter = AppRouter();

  // @override
  // void initState() {
  //   super.initState();
  //   _initializeApp();
    
  // }

  void _initializeApp() async {
    final authProvider = AuthProvider();
    await authProvider.initializeAuth();

  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AuthProvider()..initializeAuth(),
      child: MaterialApp.router(
          routerConfig: appRouter.config(),
          title: 'TechMine | Сервер',
          debugShowCheckedModeBanner: false,
        )
    );
  }
}

