import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Timestamp için import ekledik

class StoryModel {
  final String id;
  final String title;
  String imagePath; // final kaldırıldı, değiştirilebilir yapıldı
  final Color color;
  final int order;
  final bool isViewed;
  final List<StoryContent> stories; // Her kategorinin story'leri

  StoryModel({
    required this.id,
    required this.title,
    required this.imagePath,
    required this.color,
    required this.order,
    this.isViewed = false,
    this.stories = const [],
  });

  // Firestore'dan veri dönüşümü için
  factory StoryModel.fromJson(Map<String, dynamic> json) {
    return StoryModel(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      imagePath: json['imagePath'] ?? '',
      color: Color(int.parse(json['color'], radix: 16)),
      order: json['order'] ?? 0,
      isViewed: false, // Başlangıçta görüntülenmemiş
    );
  }
}

// Her bir story içeriği için model
class StoryContent {
  final String id;
  final String title;
  final String source;
  final String imagePath;
  final String newsUrl;
  final DateTime publishedAt;
  final String category;
  final bool isActive;
  final int viewCount;

  StoryContent({
    required this.id,
    required this.title,
    required this.source,
    required this.imagePath,
    required this.newsUrl,
    required this.publishedAt,
    required this.category,
    required this.isActive,
    required this.viewCount,
  });

  // Firestore'dan veri dönüşümü için
  factory StoryContent.fromJson(Map<String, dynamic> json) {
    return StoryContent(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      source: json['source'] ?? '',
      imagePath: json['imagePath'] ?? '',
      newsUrl: json['newsUrl'] ?? '',
      publishedAt: (json['publishedAt'] as Timestamp).toDate(),
      category: json['category'] ?? '',
      isActive: json['isActive'] ?? false,
      viewCount: json['viewCount'] ?? 0,
    );
  }
}
