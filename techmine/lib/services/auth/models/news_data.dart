class NewsData {
  final String title;
  final String description;
  final String content;
  final String image_url; 
  final DateTime created_at;

  NewsData({required this.title, required this.description, required this.content, required this.image_url, required this.created_at});

  factory NewsData.fromJson(Map<String, dynamic> jsonData) {
    return NewsData(title: jsonData['title'], description: jsonData['description'], content: jsonData['content'], 
                    image_url: jsonData['image_url'], created_at: jsonData['created_at']);
  }
}