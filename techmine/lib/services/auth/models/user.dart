class User {
  final String username;
  final String email;
  final int id;
  final DateTime created_at;
  final dynamic uuid;

  User({
    required this.username, 
    required this.email,
    required this.id,
    required this.created_at,
    required this.uuid
  });

  factory User.fromJson(Map<String, dynamic> jsonData) {
    return User(
      username: jsonData['username'],
      email: jsonData['email'],
      id: jsonData['id'],
      created_at: DateTime.parse(jsonData['created_at']),
      uuid: jsonData['uuid']
    );
  }
}