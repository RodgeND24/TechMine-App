import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:techmine/features/root/utils.dart';

@RoutePage()
class ServersInfoPage extends StatefulWidget {
  const ServersInfoPage({super.key});

  @override
  _ServersInfoPageState createState() => _ServersInfoPageState();
}
class _ServersInfoPageState extends State<ServersInfoPage> {

  final List<String> _servers = ['TRPG', 'OOS', 'Create'];
  int serversCount = 0;

  final PageController _controller = PageController(viewportFraction: 0.8);
  int _currentServerCard = 0;

  void checkServers() {

  }

  @override
  void initState() {
    super.initState();

    checkServers();
    setState(() {
        serversCount = _servers.length;
      }
    );
  }


  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }
  

  @override
  Widget build(BuildContext context) {

    return DefaultEmptyPage(
            text: 'Servers', 
            child: Container(
              margin: EdgeInsets.fromLTRB(15, 20, 15, 20),
              color: Colors.white,
              constraints: BoxConstraints(maxWidth: 960, maxHeight: 500),
              width: double.infinity,
              child: (serversCount != 0) ?
                        ListView.builder(
                          scrollDirection: Axis.vertical,
                          itemCount: 5,
                          physics: NeverScrollableScrollPhysics(),
                          itemBuilder:(context, index) {
                            final actualIndex = index % _servers.length;
                            return Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                ServerCard(text: 'Server: $actualIndex')
                              ],
                            );
                          },
                        )
                      
                      : Center (child: Text('Информации о серверах нет'),) 

            )
            
            
          );
  }
}

class ServerCard extends StatelessWidget {

  ServerCard({required String this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: foreignColor,
      child: Container(
        constraints: BoxConstraints.expand(width: 400, height: 500),
      )
    );
  }
}