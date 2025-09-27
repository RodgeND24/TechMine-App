class Token {
  final String access_token;
  final String refresh_token;
  final String token_type;

  Token({
    required this.access_token,
    required this.refresh_token,
    required this.token_type
  });

  factory Token.fromJson(Map<String, dynamic> jsonData) {
    return Token(
      access_token: jsonData['access_token'],
      refresh_token: jsonData['refresh_token'],
      token_type: jsonData['token_type'],
    );
  }
}