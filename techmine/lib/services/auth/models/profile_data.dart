class ProfileData {
  final String firstname;
  final String lastname;
  final String description;
  final String launguage;
  final String country;
  final String username;
  final String email;
  final int balance;
  final DateTime created_at;

  ProfileData({required this.firstname, required this.lastname, required this.description,
               required this.launguage, required this.country, required this.username, 
               required this.email, required this.balance, required this.created_at});  
  factory ProfileData.fromJson(Map<String, dynamic> jsonData) {
    return ProfileData(
      firstname: jsonData['firstname'], 
      lastname: jsonData['lastname'],
      description: jsonData['description'],
      launguage: jsonData['language'],
      country: jsonData['country'],
      username: jsonData['username'],
      email: jsonData['email'],
      balance: jsonData['balance'],
      created_at: jsonData['created_at']
    );
  }
}