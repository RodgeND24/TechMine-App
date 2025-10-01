import 'package:flutter/widgets.dart';
import 'package:techmine/features/common_pages/all_news_page.dart';
import 'package:techmine/features/common_pages/news_page.dart';
import 'package:techmine/features/common_pages/contacts.dart';
import 'package:techmine/features/common_pages/donate_page.dart';
import 'package:techmine/features/common_pages/server_page.dart';
import 'package:techmine/features/root/error_page.dart';
import 'package:techmine/features/secure_pages/balance_page.dart';
import 'package:techmine/features/secure_pages/skin_page.dart';
// auth pages
import '../auth/login_page.dart';
import '../auth/register_page.dart';
import '../auth/remember_password_page.dart';
// secure pages
import '../secure_pages/profile_page.dart';
// common pages
import '../common_pages/servers_info_page.dart';
import '../common_pages/start_game_page.dart';
// main page
import '../root/main_page.dart';

// import 'package:go_router/go_router.dart';
import 'package:techmine/features/routing/auth_guard.dart';
import 'package:auto_route/auto_route.dart';
part 'package:techmine/features/routing/app_route.gr.dart';




@AutoRouterConfig(replaceInRouteName: 'Page,Route')
class AppRouter extends RootStackRouter {
  // @override
  // RouteType get defaultRouteType => RouteType.adaptive();

  @override
  List<AutoRoute> get routes => [
    

    // public pages
    CustomRoute(page: MainRoute.page, path: '/', transitionsBuilder: TransitionsBuilders.fadeIn),
    CustomRoute(page: ServersInfoRoute.page, path: '/servers', transitionsBuilder: TransitionsBuilders.fadeIn),
    CustomRoute(page: ServerRoute.page, path: '/server/:name', transitionsBuilder: TransitionsBuilders.fadeIn),
    CustomRoute(page: DonateRoute.page, path: '/donate', transitionsBuilder: TransitionsBuilders.fadeIn),
    CustomRoute(page: StartGameRoute.page, path: '/start', transitionsBuilder: TransitionsBuilders.fadeIn),
    CustomRoute(page: ContactsRoute.page, path: '/contacts', transitionsBuilder: TransitionsBuilders.fadeIn),
    CustomRoute(page: AllNewsRoute.page, path: '/news', transitionsBuilder: TransitionsBuilders.fadeIn),
    CustomRoute(page: NewsRoute.page, path: '/news/:id', transitionsBuilder: TransitionsBuilders.fadeIn),

    // only guests pages
    CustomRoute(page: LoginRoute.page, path: '/login', guards: [GuestGuard()], transitionsBuilder: TransitionsBuilders.fadeIn, /* duration: Duration(milliseconds: 1000) */),
    CustomRoute(page: RegisterRoute.page, path: '/register', guards: [GuestGuard()], transitionsBuilder: TransitionsBuilders.fadeIn),
    CustomRoute(page: RememberPasswordRoute.page, path: '/rememberpassword', guards: [GuestGuard()], transitionsBuilder: TransitionsBuilders.fadeIn),

    // protected pages
    CustomRoute(
      path: '/profile',
      page: ProfileRoute.page,
      guards: [AuthGuard()],
      transitionsBuilder: TransitionsBuilders.slideLeft,
      children: [
        CustomRoute(path: 'balance', page: BalanceRoute.page, transitionsBuilder: TransitionsBuilders.fadeIn),
        CustomRoute(path: 'skin', page: SkinRoute.page, transitionsBuilder: TransitionsBuilders.fadeIn)
      ]
    ),

    // RedirectRoute(path: '*', redirectTo: '/')
      
    
    
    
    

    

    // error page
    RedirectRoute(path: '*', redirectTo: '/404'),
    AutoRoute(path: '/404', page: ErrorRoute.page)
  ];
  
}

class AppTransitions {
  static Widget slideRightAndFade(BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation, Widget child) {
    return SlideTransition(
      position: Tween(begin: Offset(1, 0), end: Offset.zero).animate(CurvedAnimation(parent: animation, curve: Curves.easeOut)),
      child: FadeTransition(opacity: animation, child: child),
    );
  }
}