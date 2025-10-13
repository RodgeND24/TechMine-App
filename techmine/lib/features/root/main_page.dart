import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:techmine/features/common_pages/server_page.dart';
import 'package:techmine/features/root/utils.dart';
import 'package:techmine/features/routing/app_route.dart';
import 'package:techmine/services/auth/auth_service.dart';
import 'package:techmine/services/auth/models/news_data.dart';
import 'package:techmine/services/auth/models/servers_data.dart';

@RoutePage()
class MainPage extends StatefulWidget {
  const MainPage({super.key});
  

  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {

  int? _expandedCardIndex;

  double _scale = 1.0;

  List<dynamic> _onlineByServers = [];
  int _onlineUsers = 0;
  int _totalUsers = 0;
  String _serverInfoError = '';

  List<dynamic> _news = [];
  int _newsCount = 0;
  String _newsError = '';

  List<dynamic> _servers = [];
  int _serversCount = 0;
  String _serverError = '';

  final authService = AuthService();

  Future<void> checkNews() async {
    try {
      final news = await authService.getNews();
      setState(() {
        _news = news;
        _newsCount = _news.length;
        for (var i = 0; i < _newsCount; i++) {
          _news[i] = NewsData.fromJson(_news[i]);
        }
      });
    }
    catch (e) {
      setState(() {
        _newsError = e.toString();
        print(_newsError);
        _news = [];
        _newsCount = 0;
      });
    }
  }

  Future<void> checkServers() async {
    try {
      final servers = await authService.getServers();
      setState(() {
        _servers = servers;
        _serversCount = _servers.length;
        for (var i = 0; i < _serversCount; i++) {
          _servers[i] = ServersData.fromJson(_servers[i]);
        }
      });
    }
    catch (e) {
      setState(() {
        _serverError = e.toString();
        print(_serverError);
        _servers = [];
        _serversCount = 0;
      });
    }
  }

  Future<void> checkTotalOnline() async {
    try {
      List<dynamic> onlineData = [];
      int onlineUsers = 0;
      int totalUsers = 0;

      for (var server in _servers) {
        final result = await authService.getInfoAboutServer(ip: server.ip, port: server.port);

        final serverInfo = SingleServerInfo.fromJson(result);
        onlineData.add(serverInfo);
        onlineUsers += serverInfo.online_players;
        totalUsers += serverInfo.max_players;
      }

      setState(() {
        _onlineByServers = onlineData;
        _onlineUsers = onlineUsers;
        _totalUsers = totalUsers;
      });
    }
    catch (e) {
      setState(() {
        _serverInfoError = e.toString();
        print(_serverInfoError);
        _onlineByServers = [];
        _onlineUsers = 0;
        _totalUsers = 0;
      });
    }

  }

  Future<void> initializeData() async {
    await checkNews();
    await checkServers();
    await checkTotalOnline();
  }

  @override
  void initState() {
    super.initState();

    initializeData();
  }


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
                      Image.asset('assets/images/icons/logo.png', scale: 1.5,),
                      CustomMainText(text: 'Уникальное приключение, где технологии и творчество объединяются, чтобы создать незабываемый игровой опыт', size: 25, align: TextAlign.center),
                      SizedBox(height: 20,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          startGameButton(context: context, textSize: 30),
                          CustomAdditionalText(text: 'Текущий онлайн: ', size: 20),
                          OnlineIndicator,
                          CustomMainText(text: ' $_onlineUsers из $_totalUsers', size: 20)
                        ]
                      ),
                    ],
                  )
                ),
                
                CustomSection(
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          CustomMainText(text: 'Новости', size: 35),
                          SizedBox(width: 20),
                          commonUnderLineButton(context: context, text: 'все новости', textSize: 15, link: 'https://t.me/techmineserver'),
                          Icon(Icons.keyboard_arrow_right_outlined),
                        ],
                      ),
                      SizedBox(height: 16),
                      Container(
                        width: 960,
                        child: (_newsCount != 0) ?
                        ListView.builder(
                          scrollDirection: Axis.vertical, 
                          shrinkWrap: true, 
                          physics: NeverScrollableScrollPhysics(), 
                          itemCount: _newsCount,
                          itemBuilder: (context, index) {
                            return NewsCard(
                              news: _news[index],
                              onExpansionChanged: (isExpanded) {
                                setState(() {
                                  if (isExpanded) {
                                    _expandedCardIndex = index;
                                  } else if (_expandedCardIndex == index) {
                                    _expandedCardIndex = null;
                                  }
                                });
                              },
                              isExpanded: _expandedCardIndex == index,
                            );
                          },
                        )
                        : Center(
                            child: CustomMainText(
                              text: 'Новых новостей пока нет\n $_newsError', 
                              size: 25
                            ),
                          ) 
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
                        child: (_serversCount != 0 && _onlineByServers.length == _serversCount) ?
                        ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: _serversCount,
                          physics: ScrollPhysics(),
                          itemBuilder:(context, index) {
                            return ServerCard(server: _servers[index], onlineInfo: _onlineByServers[index], );
                            
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
                          commonUnderLineButton(context: context, text: 'x32'),
                          commonUnderLineButton(context: context, text: 'x64')
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




class NewsCard extends StatefulWidget {
  NewsCard({required NewsData this.news, required this.onExpansionChanged, required this.isExpanded});

  final NewsData news;
  final Function(bool) onExpansionChanged;
  final bool isExpanded;

  @override
  _NewsCardState createState() => _NewsCardState();
}

class _NewsCardState extends State<NewsCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final authService = AuthService();
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: () {
          widget.onExpansionChanged(!widget.isExpanded);
        },
        child: AnimatedContainer(
          duration: Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          width: double.infinity,
          child: AnimatedScale(
            scale: _isHovered ? 1.02 : 1.0, 
            duration: Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            child: Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              color: foreignColor,
              shadowColor: Colors.blueGrey,
              margin: EdgeInsets.all(10),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  Container(
                    width: double.infinity,
                    height: 200, 
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(15),
                        topRight: Radius.circular(15),
                      ),
                      image: DecorationImage(
                        image: NetworkImage(authService.getFileByUrl(widget.news.image_url)),
                        fit: BoxFit.cover
                      )
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomMainText(text: widget.news.title),
                            SizedBox(height: 8),
                            CustomAdditionalText(text: widget.news.description),
                          ],
                        ),
                        
                        if (widget.isExpanded) ...[
                          SizedBox(height: 16),
                          CustomAdditionalText(text: widget.news.content),
                        ],
                        
                        SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            CustomAdditionalText(text: getTimeData(widget.news.created_at)),
                            CustomAdditionalText(
                              text: widget.isExpanded ? 'Свернуть' : 'Читать далее',
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  String getTimeData(DateTime rawDateTime) {
    String result = '${rawDateTime.day}.${rawDateTime.month}.${rawDateTime.year}., ${rawDateTime.hour}:${rawDateTime.minute}';
    return result;
  }
}

class ServerCard extends StatefulWidget {

  ServerCard({required ServersData this.server, required SingleServerInfo this.onlineInfo});

  final ServersData server;
  final SingleServerInfo onlineInfo;
  @override
  _ServerCardState createState() => _ServerCardState();
}

class _ServerCardState extends State<ServerCard> {

  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final authService = AuthService();
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedScale(
        scale: _isHovered? 1.05 : 1.0, 
        duration: Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        child: Card(
          color: foreignColor,
          shadowColor: Colors.blueGrey,
          margin: EdgeInsets.all(10),
          child: Column(
            children: [
              // Image and short information
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(15),
                    topRight: Radius.circular(15)
                  ),
                  image: DecorationImage(
                    image: NetworkImage(authService.getFileByUrl(widget.server.image_url)),
                    fit: BoxFit.cover
                  )
                ),
                width: 300,
                height: 250,
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Title and version
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Image.asset('assets/images/icons/gear.png', color: Colors.red,),
                          Column(
                            children: [
                              CustomMainText(text: widget.server.name, size: 20),
                              Row(
                                children: [
                                  if (widget.onlineInfo.online == true) ...[
                                    CustomAdditionalText(text: 'Сервер онлайн '),
                                    OnlineIndicator
                                  ]
                                  else ...[
                                    CustomAdditionalText(text: 'Сервер оффлайн '),
                                    OfflineIndicator
                                  ]
                                ],
                              )
                            ],
                          ),
                          Column(
                            children: [
                              CustomAdditionalText(text: 'Версия игры:'),
                              CustomAdditionalText(text: widget.server.version)
                            ],
                          )
                        ],
                      ),
                      // Short description of server
                      SizedBox(height: 16,),
                      CustomAdditionalText(text: widget.server.short_description),
                    ],
                  )
                )
              ),

              // navigation to page with full info about server
              SizedBox(height: 16),
              commonUnderLineButton(context: context, text: 'Подробнее', navigateTo: ServerRoute(name: widget.server.name)),

              if (widget.onlineInfo.online == true) ...[
                SizedBox(height: 16),
                CustomAdditionalText(text: 'Сейчас играют: ${widget.onlineInfo.online_players} из ${widget.onlineInfo.max_players}'),
              ]

            ],
          )
        )
      ),
    );
    
    
  }
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