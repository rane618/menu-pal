class Article {
  String title;
  String author;
  String description;
  String url;
  String urlToImage;
  String publishedAt;
  String content;
  String sourceName;
  String image;

  Article({
    required this.title,
    required this.author,
    required this.description,
    required this.url,
    required this.urlToImage,
    required this.publishedAt,
    required this.content,
    required this.sourceName,
    required this.image,
  });

  factory Article.fromJson(Map<String, dynamic> json) {
    return Article(
      title: json['title'],
      author: json['author'],
      description: json['description'],
      url: json['url'],
      urlToImage: json['urlToImage'],
      publishedAt: json['publishedAt'],
      content: json['content'],
      sourceName: json['source']['name'],
      image: json['urlToImage'] != null ? json['urlToImage'] : "",
    );
  }
}
