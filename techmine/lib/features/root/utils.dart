import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:techmine/features/routing/app_route.dart';
import 'package:provider/provider.dart';
import 'package:techmine/services/auth/auth_provider.dart';
import 'package:web/web.dart' as web;



var textColor = Colors.white;
var mainColor = Color.fromARGB(255, 13, 11, 14);
var foreignColor = Color.fromARGB(108, 36, 31, 39);
var acceptColorGradient1 = LinearGradient(colors: [const Color.fromARGB(255, 255, 20, 20), const Color.fromARGB(255, 255, 125, 19)]);
var acceptColorGradient2 = LinearGradient(colors: [Colors.cyan, Colors.green]);
var inputTextStyle = TextStyle(color: Colors.white);
var getStyleByParent = ElevatedButton.styleFrom(
    backgroundColor: Colors.transparent,
    shadowColor: Colors.transparent,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(3))
  );
var accessButtonTextStyle = TextStyle(color: Colors.white, fontSize: 20);
var startGameButtonTextStyle = TextStyle(color: Colors.white, fontSize: 20);
bool isWidth = true;

var ButtonStyle = TextButton.styleFrom(
  foregroundColor: Colors.white ,
  padding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
  shape: LinearBorder(),
  textStyle: TextStyle(fontSize: 20)
);

var topImage = Container(
        padding: EdgeInsets.only(top: 20, bottom: 5),
        child: Image.asset('assets/images/icons/logo-mini.png', scale: 0.8,),
    );

var logoFull = Container(
        padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
        child: Image.asset('assets/images/icons/logo-full.png', scale: 2,),
    );

// default Empty page for every page
class DefaultEmptyPage extends StatefulWidget {
  DefaultEmptyPage({super.key, required this.text, required this.child});

  final String text;
  final Widget child;

  @override
  _DefaultEmptyPageState createState() => _DefaultEmptyPageState();
}

class _DefaultEmptyPageState extends State<DefaultEmptyPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
            constraints: BoxConstraints.expand(width: double.infinity, height: double.infinity),
            decoration: BoxDecoration(
                          image: DecorationImage(image: AssetImage('assets/images/bg/bg_factory_main.jpg'), fit: BoxFit.cover),
                        ),
            child: CustomScrollView(
              slivers: [
                SliverList(
                  delegate: SliverChildListDelegate(
                    [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          // topImage,
                          TopMenu(),
                          Text(widget.text, style: TextStyle(color: Colors.white)),
                          widget.child
                        ],
                      ),
                    ]
                  )
                ),
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: Container(
                    constraints: BoxConstraints(maxHeight: 300),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        // Row(
                        //   mainAxisAlignment: MainAxisAlignment.center,
                        //   children: [
                        //     Text('© TechMine 2025. Все права защищены'),
                        //   ],
                        // ),
                        // Row(
                        //   mainAxisAlignment: MainAxisAlignment.center,
                        //   children: [
                        //     Text('ИП'),
                        //     Text('Почта')
                        //   ],
                        // ),
                      ],
                      
                    )
                  ),
                )
              ],
            ),
      ),
    );
  }
}

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
      // print('ширина: ${containerWidth.toStringAsFixed(2)}; isWidth:${isWidth}');
    }
  }

  @override
  void initState() {
    super.initState();
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
                  EdgeInsets.fromLTRB(0, 20, 0, 0) :
                  EdgeInsets.fromLTRB(15, 20, 15, 0),
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
                TextButton(onPressed: () {context.router.push(MainRoute());}, style: ButtonStyle, child: Image.asset('assets/images/icons/logo-full.png', scale: 1.5,),),
                Flexible(
                  child: Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [ 
                          TextButton(
                              onPressed: () {},
                              style: ButtonStyle,
                              child: PopupMenuButton(
                                color: foreignColor,
                                tooltip: '',
                                itemBuilder:(context) {
                                  return [
                                    _popupTopMenuButton(value: 'TRPG', text: 'TechnoRPG'),
                                    _popupTopMenuButton(value: 'OOS', text: 'OOS'),
                                    _popupTopMenuButton(value: 'Create', text: 'Create'),
                                  ];
                                },
                                elevation: 2,
                                offset: Offset(-80, 50),
                                child: Text('Сервера', overflow: TextOverflow.ellipsis),
                                onSelected: (value) {
                                  switch (value) {
                                    case 'TRPG': context.router.push(ServerRoute(name: 'TechnoRPG'));
                                    case 'OOS': context.router.push(ServerRoute(name: 'OOS'));
                                    case 'Create': context.router.push(ServerRoute(name: 'Create'));
                                  }
                                },
                              ),
                          ),
                          topMenuButton(context: context, text: 'Донат', page: DonateRoute()),
                          topMenuButton(context: context, text: 'Помощь', page: HelpRoute()),
                          topMenuButton(context: context, text: 'Соцсети', page: ContactsRoute()),
                          startGameButton(context: context)
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
                    offset: Offset(0, 60),
                    onSelected: (value) async {
                      switch (value) {
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
                    TextButton(onPressed: () {context.router.push(MainRoute());}, style: ButtonStyle, child: Image.asset('images/icons/logo-full.png', scale: 2,),),
                    PopupMenuButton(
                      icon: Icon(Icons.format_list_bulleted, color: Colors.white,),
                      color: foreignColor,
                      tooltip: '',
                      itemBuilder: (context) {
                        return [
                            _popupTopMenuButton(value: 'main', text: 'Главная'),
                            _popupTopMenuButton(value: 'servers', text: 'Сервера'),
                            _popupTopMenuButton(value: 'donate', text: 'Донат'),
                            _popupTopMenuButton(value: 'help', text: 'Помощь'),
                            _popupTopMenuButton(value: 'contacts', text: 'Контакты'),
                          ];
                      },
                      elevation: 2,
                      offset: Offset(0, 50),
                      onSelected: (value) {
                        switch (value) {
                          case 'main': context.router.push(MainRoute());
                          case 'servers': context.router.push(ServersInfoRoute());
                          case 'donate': context.router.push(DonateRoute());
                          case 'help': context.router.push(HelpRoute());
                          case 'contacts': context.router.push(ContactsRoute());
                        }
                      },
                      
                    ),
                    
                  ],
                ),
                startGameButton(context: context),
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
                      switch (value) {
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





  

}

Widget topMenuButton({required BuildContext context, required String text, page}) {
    return Flexible(
        child: TextButton(
            onPressed: () {
              if (page != null) {context.router.push(page);}
            },
            style: ButtonStyle,
            child: Text(text, overflow: TextOverflow.ellipsis,)
          )
      );
  }

Widget startGameButton({required BuildContext context, double textSize = 22}) {
  return Flexible(
      child: Container(
        
        margin: EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
                      gradient: acceptColorGradient2,
                      // border: Border.all(),
                      borderRadius: BorderRadius.circular(3),
                      boxShadow: [BoxShadow(color: Colors.white70, blurRadius: 5)]
                    ),
        child: ElevatedButton(
                onPressed: () {context.router.push(StartGameRoute());},
                style: getStyleByParent,
                child: Text('Начать', style: TextStyle(color: Colors.white, fontSize: textSize),)
              ),
      )
    );
}

Widget commonUnderLineButton({String text ='', double textSize = 15, String link = ''}) {
  return Flexible(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          border: Border(bottom: BorderSide(width: 5, color: foreignColor)),
          boxShadow: [
            BoxShadow(color: foreignColor)
          ]
        ),
        child: ElevatedButton(
          onPressed: () {
            if (link != '') {
              web.window.open(link, '_blank');
            }
          },
          style: getStyleByParent,
          child: Text(text, 
            style: TextStyle(
              color: Colors.white70,
              fontSize: textSize,
            ),
          )
        ),
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




