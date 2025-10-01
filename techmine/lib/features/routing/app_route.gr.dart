// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

part of 'app_route.dart';

/// generated route for
/// [AllNewsPage]
class AllNewsRoute extends PageRouteInfo<void> {
  const AllNewsRoute({List<PageRouteInfo>? children})
    : super(AllNewsRoute.name, initialChildren: children);

  static const String name = 'AllNewsRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const AllNewsPage();
    },
  );
}

/// generated route for
/// [BalancePage]
class BalanceRoute extends PageRouteInfo<void> {
  const BalanceRoute({List<PageRouteInfo>? children})
    : super(BalanceRoute.name, initialChildren: children);

  static const String name = 'BalanceRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const BalancePage();
    },
  );
}

/// generated route for
/// [ContactsPage]
class ContactsRoute extends PageRouteInfo<void> {
  const ContactsRoute({List<PageRouteInfo>? children})
    : super(ContactsRoute.name, initialChildren: children);

  static const String name = 'ContactsRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const ContactsPage();
    },
  );
}

/// generated route for
/// [DonatePage]
class DonateRoute extends PageRouteInfo<void> {
  const DonateRoute({List<PageRouteInfo>? children})
    : super(DonateRoute.name, initialChildren: children);

  static const String name = 'DonateRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const DonatePage();
    },
  );
}

/// generated route for
/// [ErrorPage]
class ErrorRoute extends PageRouteInfo<void> {
  const ErrorRoute({List<PageRouteInfo>? children})
    : super(ErrorRoute.name, initialChildren: children);

  static const String name = 'ErrorRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const ErrorPage();
    },
  );
}

/// generated route for
/// [LoginPage]
class LoginRoute extends PageRouteInfo<LoginRouteArgs> {
  LoginRoute({
    Key? key,
    void Function(bool)? onNavigationResult,
    List<PageRouteInfo>? children,
  }) : super(
         LoginRoute.name,
         args: LoginRouteArgs(key: key, onNavigationResult: onNavigationResult),
         initialChildren: children,
       );

  static const String name = 'LoginRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<LoginRouteArgs>(
        orElse: () => const LoginRouteArgs(),
      );
      return LoginPage(
        key: args.key,
        onNavigationResult: args.onNavigationResult,
      );
    },
  );
}

class LoginRouteArgs {
  const LoginRouteArgs({this.key, this.onNavigationResult});

  final Key? key;

  final void Function(bool)? onNavigationResult;

  @override
  String toString() {
    return 'LoginRouteArgs{key: $key, onNavigationResult: $onNavigationResult}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! LoginRouteArgs) return false;
    return key == other.key;
  }

  @override
  int get hashCode => key.hashCode;
}

/// generated route for
/// [MainPage]
class MainRoute extends PageRouteInfo<void> {
  const MainRoute({List<PageRouteInfo>? children})
    : super(MainRoute.name, initialChildren: children);

  static const String name = 'MainRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const MainPage();
    },
  );
}

/// generated route for
/// [NewsPage]
class NewsRoute extends PageRouteInfo<NewsRouteArgs> {
  NewsRoute({Key? key, required String id, List<PageRouteInfo>? children})
    : super(
        NewsRoute.name,
        args: NewsRouteArgs(key: key, id: id),
        rawPathParams: {'id': id},
        initialChildren: children,
      );

  static const String name = 'NewsRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final pathParams = data.inheritedPathParams;
      final args = data.argsAs<NewsRouteArgs>(
        orElse: () => NewsRouteArgs(id: pathParams.getString('id')),
      );
      return NewsPage(key: args.key, id: args.id);
    },
  );
}

class NewsRouteArgs {
  const NewsRouteArgs({this.key, required this.id});

  final Key? key;

  final String id;

  @override
  String toString() {
    return 'NewsRouteArgs{key: $key, id: $id}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! NewsRouteArgs) return false;
    return key == other.key && id == other.id;
  }

  @override
  int get hashCode => key.hashCode ^ id.hashCode;
}

/// generated route for
/// [ProfilePage]
class ProfileRoute extends PageRouteInfo<void> {
  const ProfileRoute({List<PageRouteInfo>? children})
    : super(ProfileRoute.name, initialChildren: children);

  static const String name = 'ProfileRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const ProfilePage();
    },
  );
}

/// generated route for
/// [RegisterPage]
class RegisterRoute extends PageRouteInfo<void> {
  const RegisterRoute({List<PageRouteInfo>? children})
    : super(RegisterRoute.name, initialChildren: children);

  static const String name = 'RegisterRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const RegisterPage();
    },
  );
}

/// generated route for
/// [RememberPasswordPage]
class RememberPasswordRoute extends PageRouteInfo<void> {
  const RememberPasswordRoute({List<PageRouteInfo>? children})
    : super(RememberPasswordRoute.name, initialChildren: children);

  static const String name = 'RememberPasswordRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const RememberPasswordPage();
    },
  );
}

/// generated route for
/// [ServerPage]
class ServerRoute extends PageRouteInfo<ServerRouteArgs> {
  ServerRoute({Key? key, required String name, List<PageRouteInfo>? children})
    : super(
        ServerRoute.name,
        args: ServerRouteArgs(key: key, name: name),
        rawPathParams: {'name': name},
        initialChildren: children,
      );

  static const String name = 'ServerRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final pathParams = data.inheritedPathParams;
      final args = data.argsAs<ServerRouteArgs>(
        orElse: () => ServerRouteArgs(name: pathParams.getString('name')),
      );
      return ServerPage(key: args.key, name: args.name);
    },
  );
}

class ServerRouteArgs {
  const ServerRouteArgs({this.key, required this.name});

  final Key? key;

  final String name;

  @override
  String toString() {
    return 'ServerRouteArgs{key: $key, name: $name}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! ServerRouteArgs) return false;
    return key == other.key && name == other.name;
  }

  @override
  int get hashCode => key.hashCode ^ name.hashCode;
}

/// generated route for
/// [ServersInfoPage]
class ServersInfoRoute extends PageRouteInfo<void> {
  const ServersInfoRoute({List<PageRouteInfo>? children})
    : super(ServersInfoRoute.name, initialChildren: children);

  static const String name = 'ServersInfoRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const ServersInfoPage();
    },
  );
}

/// generated route for
/// [SkinPage]
class SkinRoute extends PageRouteInfo<void> {
  const SkinRoute({List<PageRouteInfo>? children})
    : super(SkinRoute.name, initialChildren: children);

  static const String name = 'SkinRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const SkinPage();
    },
  );
}

/// generated route for
/// [StartGamePage]
class StartGameRoute extends PageRouteInfo<void> {
  const StartGameRoute({List<PageRouteInfo>? children})
    : super(StartGameRoute.name, initialChildren: children);

  static const String name = 'StartGameRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const StartGamePage();
    },
  );
}
