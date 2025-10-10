import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:techmine/features/routing/app_route.dart';
import 'package:techmine/services/auth/auth_provider.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:techmine/features/root/utils.dart';

void main() {
  setUrlStrategy(PathUrlStrategy());

  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AuthProvider())
      ],
      child: MyApp(),
    )
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  _MyAppState createState() => _MyAppState();
}


class _MyAppState extends State<MyApp> {

  final appRouter = AppRouter();

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: appRouter.config(),
      title: 'TechMine | Сервер',
      debugShowCheckedModeBanner: false,
      
      builder: (context, child) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          final authProvider = context.read<AuthProvider>();
          if (!authProvider.isInitialized) {
            authProvider.initializeAuth();
          }
        });
        return child!;
      },      
    );
  }
}

