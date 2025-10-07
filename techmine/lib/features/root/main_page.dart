import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:techmine/features/root/utils.dart';

@RoutePage()
class MainPage extends StatefulWidget {
  const MainPage({super.key});
  

  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {

  // final List<String> _infoCards = ['Серверы', 'Помощь', 'Донат'];
  // int _infoCardsCount = 0;
  // final PageController _controller = PageController(viewportFraction: 1);
  // int _currentInfoCard = 0;

  double _scale = 1.0;

  int _onlineUsers = 0;
  int _totalUsers = 0;

  List<String> _news = [];
  int _newsCount = 0;

  List<String> _servers = [];
  int _serversCount = 0;

  

  void checkNews() {
    _news = ['Наполнение сайта', 'Доработка лаунчера', 'Создание сборки'];
    _newsCount = _news.length;
  }

  void checkServers() {
    _servers = ['TechnoRPG', 'OOS'];
    _serversCount = _servers.length;
  }


  @override
  void initState() {
    super.initState();

    checkNews();
    checkServers();

    // setState(() {
    //     _infoCardsCount = _infoCards.length;
    //   }
    // );

    // startAutoScroll();
  }

  // void startAutoScroll() {
  //   Future.delayed(Duration(seconds: 3), () {
  //     if (_controller.hasClients) {
  //       final nextPage = _currentInfoCard + 1;
  //       if (nextPage >= _infoCardsCount) {
  //         _controller.animateToPage(0, duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
  //       }
  //       else {
  //         _controller.nextPage(duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
  //       }
  //       startAutoScroll();
  //     }
  //   });
  // }

  // @override
  // void dispose() {
  //   super.dispose();
  //   _controller.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    return DefaultEmptyPage(
            text: '', 
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomSection(
                  content: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset('assets/images/icons/logo-mini.png', scale: 0.7,),
                      SizedBox(height: 20,),
                      CustomMainText(text: 'Уникальное приключение, где технологии и творчество объединяются, чтобы создать незабываемый игровой опыт', size: 25, align: TextAlign.center),
                      SizedBox(height: 20,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          startGameButton(context: context, textSize: 30),
                          CustomAdditionalText(text: 'Сейчас онлайн: ', size: 20),
                          DecoratedBox(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(color: Colors.lightGreenAccent, blurRadius: 5),
                              ]
                            ),
                            child: Icon(Icons.circle, color: Colors.green, size: 15,),
                          ),
                          CustomMainText(text: ' $_onlineUsers из $_totalUsers', size: 20)
                        ]
                      ),
                    ],
                  )
                ),
                
                CustomSection(
                  content: Column(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          CustomMainText(text: 'Новости',size: 35),
                          SizedBox(width: 20,),
                          commonUnderLineButton(text: 'все новости', textSize: 15, link: 'https://t.me/techmineserver'),
                          Icon(Icons.keyboard_arrow_right_outlined),
                        ],
                      ),
                      Container(
                        constraints: BoxConstraints(minHeight: 200, maxHeight: 400),
                        width: 960,
                        child: (_newsCount != 0) ?
                        ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: _newsCount,
                          physics: ScrollPhysics(),
                          itemBuilder:(context, index) {
                            return NewsCard(text: 'News: ${_news[index]}');
                          },
                        )
                      
                      : Center (child: CustomMainText(text: 'Новый новостей пока нет', size: 25),) 
                      )
                    ],
                  )
                ),

                CustomSection(
                  content: Column(
                    children: [
                      CustomMainText(text: 'Наши сервера', size: 40),

                      Container(
                        constraints: BoxConstraints(minHeight: 200, maxHeight: 400),
                        width: 960,
                        child: (_serversCount != 0) ?
                        ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: _serversCount,
                          physics: ScrollPhysics(),
                          itemBuilder:(context, index) {
                            return ServerCard(text: 'Server: ${_servers[index]}');
                            
                          },
                        )
                      : Center (child: CustomMainText(text: 'Список серверов пуст. Вернитесь позже', size: 25),)
                      )
                    ],
                  )
                ),

                CustomSection(
                  content: Column(
                    
                    children: [
                      CustomMainText(text: 'Не терпится начать?', size: 35),
                      CustomMainText(text: 'Скачивай наш лаунчер!', size: 25),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CustomAdditionalText(text: 'Не забудь установить java:', size: 15),
                          commonUnderLineButton(text: 'x32'),
                          commonUnderLineButton(text: 'x64')
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          launcherButton(text: 'Windows'),
                          launcherButton(text: 'Linux'),
                          launcherButton(text: 'MacOS')
                        ],
                      )
                    ],
                  )
                )
              ],
            )
          );
  }
}

Container CustomSection({Widget? content}) {
    return Container(
      // constraints: BoxConstraints( maxWidth: 960),
      width: 960,
      // height: height,
      margin: EdgeInsets.only(bottom: 30),
      padding: EdgeInsets.only(top: 50, bottom: 50),
      decoration: BoxDecoration(
        // color: Colors.white,
        border: Border(bottom: BorderSide(color: mainColor, width: 2))
      ),
      child: content,
    );
}


class NewsCard extends StatefulWidget {

  NewsCard({required String this.text});

  final String text;
  @override
  _NewsCardState createState() => _NewsCardState();
}

class _NewsCardState extends State<NewsCard> {

  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedScale(
        scale: _isHovered? 1.1 : 1.0, 
        duration: Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        child: Card(
          color: foreignColor,
          shadowColor: Colors.blueGrey,
          margin: EdgeInsets.all(10),
          child: SizedBox(
            // constraints: BoxConstraints.expand(width: 400, height: 200),
            width: 300,
            child: CustomMainText(text: widget.text, size: 20),
          )
        )
      ),
    );
    
    
  }
}

class ServerCard extends StatefulWidget {

  ServerCard({required String this.text});

  final String text;
  @override
  _ServerCardState createState() => _ServerCardState();
}

class _ServerCardState extends State<ServerCard> {

  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedScale(
        scale: _isHovered? 1.1 : 1.0, 
        duration: Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        child: Card(
          color: foreignColor,
          shadowColor: Colors.blueGrey,
          margin: EdgeInsets.all(10),
          child: SizedBox(
            // constraints: BoxConstraints.expand(width: 400, height: 200),
            width: 300,
            child: CustomMainText(text: widget.text, size: 20),
          )
        )
      ),
    );
    
    
  }
}

Widget CustomMainText({String text ='', double size = 20, TextAlign align = TextAlign.start}) {
  return Container(
    child: Text(text,
      textAlign: align,
      style: TextStyle(
          color: Colors.white, 
          fontSize: size, fontFamily: 'Nunito', fontWeight: FontWeight.w600,
          shadows: [Shadow(color: Colors.black, blurRadius: 10, offset: Offset(0, 10))]
        )
      )
    );
}

Text CustomAdditionalText({String text ='', double size = 15, TextAlign align = TextAlign.start}) {
  return Text(text, 
    textAlign: align,
    style: TextStyle(
      color: Colors.white, 
      fontSize: size, fontFamily: 'Nunito', fontWeight: FontWeight.w500,
      shadows: [Shadow(color: Colors.black, blurRadius: 10, offset: Offset(0, 10))]
    )
  );
}

Widget launcherButton({String text = ''}) {
  return Container(
    width: 200,
    height: 75,
    margin: EdgeInsets.all(20),
    decoration: BoxDecoration(
      gradient: acceptColorGradient2,
      borderRadius: BorderRadius.circular(5),
      boxShadow: [BoxShadow(color: Colors.white70, blurRadius: 5)]
    ),
    child: ElevatedButton(
          onPressed: () {},
          style: getStyleByParent,
          child: Text(text, style: TextStyle(color: Colors.black, fontSize: 30, fontFamily: 'Nunito'))
        ),
  );
}

// scroll carousel
// Container(
//               margin: EdgeInsets.fromLTRB(15, 20, 15, 20),
//               color: foreignColor,
//               constraints: BoxConstraints(maxWidth: 650, maxHeight: 250),
//               width: double.infinity,
//               child: (infoCardsCount != 0) ?
//                   PageView.builder(
//                     controller: _controller,
//                     itemCount: infoCardsCount,
//                     onPageChanged: (index) {
//                       setState(() {
//                         _currentInfoCard = index;
//                       });
//                     },
//                     itemBuilder: (context, index) {
//                       return Container(
//                         // duration: Duration(milliseconds: 3000),
//                         // margin: EdgeInsets.fromLTRB(0, 5, 50, 5),
//                         decoration: BoxDecoration(border: Border.all(width: 3), color: foreignColor),
//                         child: Text('$index'),
//                       );
//                     }
//                   )
                
//                 : Center(
//                     child: Container(
//                       alignment: Alignment(0, 0),
//                       constraints: BoxConstraints.expand(),
//                       decoration: BoxDecoration(color: Colors.white),
//                       child: Text('Информации нет', style: TextStyle(color: mainColor, fontSize: 20),),
//                     ),
//                   ) 
//             )