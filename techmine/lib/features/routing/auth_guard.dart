import 'package:auto_route/auto_route.dart';
import 'package:techmine/features/routing/app_route.dart';
import 'package:techmine/services/auth/auth_provider.dart';
import 'package:provider/provider.dart';
import 'package:techmine/services/auth/auth_service.dart';


class AuthGuard extends AutoRouteGuard {
  @override
  void onNavigation(NavigationResolver resolver, StackRouter router) async {
    final context = router.navigatorKey.currentContext;
    if (context == null) {
      resolver.next(false);
      return;
    }

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final authService = AuthService();

    if (!authProvider.isInitialized) {
      await authProvider.initializeAuth();
    }

    // check auth
    if (authProvider.isCheckingAuth) {
      resolver.next(false);
      // await Future.delayed(Duration(seconds: 1));
      // onNavigation(resolver, router);
      return;
    }


    // check token in Storage
    final bool hasValidToken = await authService.hasValidToken();
    final bool isActualyLoggedIn = authProvider.isLoggedIn && hasValidToken;


    if (isActualyLoggedIn) {
      resolver.next(true);
    }
    else {
      if (authProvider.isLoggedIn && !hasValidToken) {
        await authProvider.logout();
      }

      resolver.redirectUntil(
          LoginRoute(
            onNavigationResult: (success) {
              if (success) {resolver.next(true);}
              else {
                (router.replaceAll([LoginRoute()]));
              }
            }
        )
      );
    }
  }
}

class GuestGuard extends AutoRouteGuard {
  @override
  void onNavigation(NavigationResolver resolver, StackRouter router) async {
    final context = router.navigatorKey.currentContext;
    if (context == null) {
      resolver.next(false);
      return;
    }
    
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final authService = AuthService();

    if (!authProvider.isInitialized) {
      await authProvider.initializeAuth();
    }

    // check auth
    if (authProvider.isCheckingAuth) {
      resolver.next(false);
      // await Future.delayed(Duration(seconds: 1));
      // onNavigation(resolver, router);
      return;
    }

    // check token in Storage
    final bool hasValidToken = await authService.hasValidToken();
    final bool isActualyLoggedIn = authProvider.isLoggedIn && hasValidToken;
    
    
    if (!isActualyLoggedIn) {
      resolver.next(true);
    }
    else {
      if (!authProvider.isLoggedIn && hasValidToken) {
        await authProvider.checkAuthStatus();
      }

      router.replaceAll([MainRoute()]);
    }

    
  

    

  }
}