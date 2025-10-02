import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:techmine/features/routing/app_route.dart';
import 'package:provider/provider.dart';
import 'package:techmine/services/auth/auth_provider.dart';



var textColor = Colors.white;
var mainColor = Color.fromARGB(255, 13, 11, 14);
var foreignColor = Color.fromARGB(108, 36, 31, 39);
var acceptColorGradient1 = LinearGradient(colors: [const Color.fromARGB(255, 255, 20, 20), const Color.fromARGB(255, 255, 125, 19)]);
var acceptColorGradient2 = LinearGradient(colors: [Colors.cyan, Colors.green]);
var inputTextStyle = TextStyle(color: Colors.white);
var getStyleByParent = ElevatedButton.styleFrom(backgroundColor: Colors.transparent, shadowColor: Colors.transparent);
var accessButtonTextStyle = TextStyle(color: Colors.white, fontSize: 20);
bool isWidth = true;

var ButtonStyle = TextButton.styleFrom(
  foregroundColor: Colors.white ,
  padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
  shape: LinearBorder(),
  textStyle: TextStyle(fontSize: 20)
);



var topImage = Container(
        padding: EdgeInsets.only(top: 20, bottom: 5),
        child: Image.asset('images/icons/logo.png', scale: 3,),
    );
    


// convert topMenu into Class TopMenu extends StatefulWidget

class TopMenu extends StatefulWidget {
  const TopMenu({super.key});

  @override
  _TopMenuState createState() => _TopMenuState();
}

class _TopMenuState extends State<TopMenu> {

  final GlobalKey containerKey = GlobalKey();
  double containerWidth = 960;

  void _checkContainerWidth(context) {
    
    final renderBox = containerKey.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox != null) {
      final width = renderBox.size.width;
      containerWidth = width;
      if (containerWidth < 960) {
        if (isWidth) {
          setState(() {
            isWidth = false;
          });
        }
      }
      else {
        if (!isWidth) {
          setState(() {
            isWidth = true;
          });
        }
      }
      

      print('ширина: ${containerWidth.toStringAsFixed(2)}; isWidth:${isWidth}');
    }
  }

  

  @override
  void initState() {
    super.initState();
    // Инициализируем auth при создании меню
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkContainerWidth(context);

      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      if (!authProvider.isInitialized) {
        authProvider.initializeAuth();
      }
    });
  }
  
  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    return buildMenu(authProvider);
  }

  Widget buildMenu(AuthProvider authProvider) {
    return LayoutBuilder(
      builder: (context, constraints) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
            _checkContainerWidth(context);
        });

        return Container(
          key: containerKey,
          margin: isWidth ?
                  EdgeInsets.fromLTRB(0, 20, 0, 20) :
                  EdgeInsets.fromLTRB(15, 20, 15, 20),
          decoration: BoxDecoration(
            color: foreignColor,
            borderRadius: BorderRadius.circular(10),
          ),
        
          child: isWidth ?
                widthTopMenu() :
                tightTopMenu()
        );
      }
    );
  }

  Widget widthTopMenu() {
    return Container(
            constraints: BoxConstraints(maxWidth: 960),
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(onPressed: () {}, style: ButtonStyle, child: Image.asset('images/icons/favicon.png', scale: 1.5,),),
                Flexible(
                  child: Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [ 
                          topMenuButton(text: 'Главная', page: MainRoute()),
                          topMenuButton(text: 'Новости', page: AllNewsRoute()),
                          topMenuButton(text: 'Начать', page: StartGameRoute()),
                          topMenuButton(text: 'Серверы', page: ServersInfoRoute()),
                          topMenuButton(text: 'Донат', page: DonateRoute()),
                          topMenuButton(text: 'Контакты', page: ContactsRoute()),
                        ],
                    ),
                  ),
                ),
                PopupMenuButton(
                    icon: Icon(Icons.person, color: Colors.white,),
                    color: foreignColor,
                    tooltip: '',
                    itemBuilder: (context) {
                      if (context.read<AuthProvider>().isLoggedIn) {
                        return [
                          _popupMenuItemAuth(value: 'profile', leftIcon: Icons.person_4, text: 'Профиль'),
                          _popupMenuItemAuth(value: 'exit', leftIcon: Icons.person_4, text: 'Выход')
                        ];
                      }
                      else {
                        return [
                          _popupMenuItemAuth(value: 'login', leftIcon: Icons.login, text: 'Вход'),
                          _popupMenuItemAuth(value: 'register', leftIcon: Icons.key, text: 'Регистрация')
                        ];
                      }
                    },
                    elevation: 2,
                    offset: Offset(0, 50),
                    onSelected: (value) async {
                      // if (value == 'login') { context.pushRoute(LoginRoute()); }
                      // if (value == 'register') { context.pushRoute(RegisterRoute()); }
                      switch (value) {
                        // case 'login': context.pushRoute(LoginRoute());
                        case 'login': context.router.push(LoginRoute());
                        case 'register': context.router.push(RegisterRoute());
                        case 'profile': context.router.push(ProfileRoute());
                        case 'exit': {
                            
                            await context.read<AuthProvider>().logout();
                            context.router.replaceAll([MainRoute()]);
                          }
                      }
                    },
                  )
              ],
            ),
          );
  }

  Widget tightTopMenu() {
    return Container(
            constraints: BoxConstraints(minWidth: 500),
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    PopupMenuButton(
                      icon: Icon(Icons.format_list_bulleted, color: Colors.white,),
                      color: foreignColor,
                      tooltip: '',
                      itemBuilder: (context) {
                        return [
                            _popupTopMenuButton(value: 'main', text: 'Главная'),
                            _popupTopMenuButton(value: 'news', text: 'Новости'),
                            _popupTopMenuButton(value: 'start', text: 'Начать'),
                            _popupTopMenuButton(value: 'servers', text: 'Серверы'),
                            _popupTopMenuButton(value: 'donate', text: 'Донат'),
                            _popupTopMenuButton(value: 'contacts', text: 'Контакты'),
                          ];
                      },
                      elevation: 2,
                      offset: Offset(0, 50),
                      onSelected: (value) {
                        switch (value) {
                          case 'main': context.router.push(MainRoute());
                          case 'news': context.router.push(AllNewsRoute());
                          case 'start': context.router.push(StartGameRoute());
                          case 'servers': context.router.push(ServersInfoRoute());
                          case 'donate': context.router.push(DonateRoute());
                          case 'contacts': context.router.push(ContactsRoute());
                        }
                      },
                      
                    ),
                    // TextButton(onPressed: () {}, style: ButtonStyle, child: Image.asset('images/icons/favicon.png', scale: 1.5,),),
                  ],
                ),
                PopupMenuButton(
                    icon: Icon(Icons.person, color: Colors.white,),
                    color: foreignColor,
                    tooltip: '',
                    itemBuilder: (context) {
                      
                      // if (!authProvider.isInitialized || authProvider.isCheckingAuth) {
                      //   return [
                          
                      //   ];
                      // }
                      if (context.read<AuthProvider>().isLoggedIn) {
                        return [
                          _popupMenuItemAuth(value: 'profile', leftIcon: Icons.person_4, text: 'Профиль'),
                          _popupMenuItemAuth(value: 'exit', leftIcon: Icons.person_4, text: 'Выход')
                        ];
                      }
                      else {
                        return [
                          _popupMenuItemAuth(value: 'login', leftIcon: Icons.login, text: 'Вход'),
                          _popupMenuItemAuth(value: 'register', leftIcon: Icons.key, text: 'Регистрация')
                        ];
                      }
                    },
                    elevation: 2,
                    offset: Offset(0, 50),
                    onSelected: (value) async {
                      // if (value == 'login') { context.pushRoute(LoginRoute()); }
                      // if (value == 'register') { context.pushRoute(RegisterRoute()); }
                      switch (value) {
                        // case 'login': context.pushRoute(LoginRoute());
                        case 'login': context.router.push(LoginRoute());
                        case 'register': context.pushRoute(RegisterRoute());
                        case 'profile': context.pushRoute(ProfileRoute());
                        case 'exit': {
                            
                            await context.read<AuthProvider>().logout();
                            context.router.replaceAll([MainRoute()]);
                          }
                      }
                    },
                  )
              ],
            ),
          );
  }





  Widget topMenuButton({required String text, required page}) {
    return Flexible(
        child: TextButton(
            onPressed: () {context.router.push(page);},
            style: ButtonStyle,
            child: Text(text, overflow: TextOverflow.ellipsis,)
          )
      );
  }

  PopupMenuItem _popupTopMenuButton({required String value, required String text}) {
    return PopupMenuItem(
                        value: value,
                        padding: EdgeInsets.fromLTRB(10, 0, 5, 0),
                        child: Container(
                          decoration: BoxDecoration(border: Border(bottom: BorderSide())),
                          child: Row(
                            children: [
                              // SizedBox(width: 20,),
                              Text(text, style: TextStyle(color: Colors.white, fontSize: 20))
                            ],
                          ),
                        ),
                        
                      );
  }

  PopupMenuItem _popupMenuItemAuth({required String value, required IconData leftIcon, required String text}) {

    return PopupMenuItem(
                        value: value, 
                        padding: EdgeInsets.fromLTRB(10, 0, 5, 0),
                        child: Container(
                          decoration: BoxDecoration(border: Border(bottom: BorderSide())),
                          child: Row(
                            children: [
                              Icon(leftIcon, color: Colors.white,),
                              SizedBox(width: 5,),
                              Text(text, style: TextStyle(color: Colors.white, fontSize: 20))
                            ],
                          ),
                        ),
                      );

  }

}

Future<void> errorAlertDialog(BuildContext context, String error) {
  
  return showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        icon: Icon(Icons.error),
        title: Text('Error!'),
        content: Text(error),
        actions: [
          ElevatedButton(
            onPressed: () {context.pop();},
            style: getStyleByParent,
            child: Text('Try again', style: TextStyle(color: Colors.white, fontSize: 20),)
          )
        ],
      );
    }
  );
}




