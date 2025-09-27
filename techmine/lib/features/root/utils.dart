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

var ButtonStyle = TextButton.styleFrom(
  foregroundColor: Colors.white ,
  padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
  shape: LinearBorder(),
  textStyle: TextStyle(fontSize: 20)
);



var topImage = Container(
        padding: EdgeInsets.only(top: 50, bottom: 50),
        child: Image.asset('images/icons/logo.png', scale: 2,),
    );
    


// convert topMenu into Class TopMenu extends StatefulWidget

class TopMenu extends StatefulWidget {
  const TopMenu({super.key});

  @override
  _TopMenuState createState() => _TopMenuState();
}

class _TopMenuState extends State<TopMenu> {

  @override
  void initState() {
    super.initState();
    // Инициализируем auth при создании меню
    WidgetsBinding.instance.addPostFrameCallback((_) {
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
    return Container(
      margin: EdgeInsets.fromLTRB(0, 20, 0, 20),
      decoration: BoxDecoration(
        color: foreignColor,
        borderRadius: BorderRadius.circular(10),
      ),

      child: Container(
        constraints: BoxConstraints(maxWidth: 1200),
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextButton(onPressed: () {}, style: ButtonStyle, child: Image.asset('images/icons/favicon.png', scale: 1.5,),),
            Flexible(
              child: Container(child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [ 
                    topMenuButton(text: 'Главная', page: MainRoute()),
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
                itemBuilder: (context) {
                  if (!authProvider.isInitialized || authProvider.isCheckingAuth) {
                    return [
                      
                    ];
                  }
                  if (authProvider.isLoggedIn) {
                    return [
                      _popupMenuItemCustom(value: 'profile', leftIcon: Icon(Icons.person_4), text: 'Profile'),
                      _popupMenuItemCustom(value: 'exit', leftIcon: Icon(Icons.person_4), text: 'Exit')
                    ];
                  }
                  else {
                    return [
                      PopupMenuItem(
                        value: 'login', 
                        child: Container(
                          decoration: BoxDecoration(border: Border(bottom: BorderSide())),
                          child: Row(
                            children: [
                              Icon(Icons.login),
                              SizedBox(width: 5,),
                              Text('Sign In')
                            ],
                          ),
                        )
                      ),
                      PopupMenuItem(
                        value: 'register', 
                        child: Container(
                          decoration: BoxDecoration(border: Border(bottom: BorderSide())),
                          child: Row(
                            children: [
                              Icon(Icons.key),
                              SizedBox(width: 5,),
                              Text('Sign Up')
                            ],
                          ),
                        )
                      ),
                    ];
                  }
                },
                elevation: 2,
                offset: Offset(0, 50),
                onSelected: (value) async {
                  // if (value == 'login') { context.pushRoute(LoginRoute()); }
                  // if (value == 'register') { context.pushRoute(RegisterRoute()); }
                  switch (value) {
                    case 'login': context.pushRoute(LoginRoute());
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
      )
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

  PopupMenuItem _popupMenuItemCustom({required String value, required Icon leftIcon, required String text}) {

    return PopupMenuItem(
                        value: value, 
                        child: Container(
                          decoration: BoxDecoration(border: Border(bottom: BorderSide())),
                          child: Row(
                            children: [
                              leftIcon,
                              SizedBox(width: 5,),
                              Text(text)
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




