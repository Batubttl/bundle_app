import '../core/constants/app_constants.dart';

class Article {
  final String title;
  final String? description;
  final String? urlToImage;
  final String? content;
  final String url;
  final String publishedAt;
  final String? author;
  final NewsCategory category;
  final String source;

  Article({
    this.content,
    required this.title,
    this.description,
    this.urlToImage,
    required this.url,
    required this.publishedAt,
    this.author,
    required this.category,
    required this.source,
  });

  factory Article.fromJson(Map<String, dynamic> json, NewsCategory category) {
    return Article(
      title: json['title'] ?? '',
      description: json['description'],
      urlToImage: json['urlToImage'],
      url: json['url'] ?? '',
      publishedAt: json['publishedAt'] ?? DateTime.now().toIso8601String(),
      author: json['author'],
      category: category,
      source: json['source']?['name'] ?? 'Bilinmeyen Kaynak',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'urlToImage': urlToImage,
      'url': url,
      'publishedAt': publishedAt,
      'author': author,
      'source': {
        'name': source,
      },
      'category': category.title,
    };
  }
}
