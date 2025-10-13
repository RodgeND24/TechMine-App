class ServersData {
  final String name;
  final String short_description;
  final String description;
  final String version;
  final String image_url; 
  final String ip;
  final String port;

  ServersData({required this.name, required this.short_description,
               required this.description, required this.version, 
               required this.image_url, required this.ip, required this.port});

  factory ServersData.fromJson(Map<String, dynamic> jsonData) {
    return ServersData(name: jsonData['name'], short_description: jsonData['short_description'],
                       description: jsonData['description'], version: jsonData['version'], 
                       image_url: jsonData['image_url'], ip: jsonData['ip'], port: jsonData['port']);
  }
}

class SingleServerInfo {

  final bool online;
  final int online_players;
  final int max_players;

  SingleServerInfo({required this.online, required this.online_players, required this.max_players});

  factory SingleServerInfo.fromJson(Map<String, dynamic> jsonData) {
    return SingleServerInfo(online: jsonData['online'], online_players: jsonData['online_players'], max_players: jsonData['max_players']);
  }




}