import 'package:cloud_firestore/cloud_firestore.dart';

class NotificationModel {
  final String id;
  final String title;
  final String message;
  final String? imageUrl;
  final String category;
  final DateTime timestamp;
  final bool isRead;
  final String source;
  final String? sourceImageUrl;

  NotificationModel({
    required this.id,
    required this.title,
    required this.message,
    this.imageUrl,
    required this.category,
    required this.timestamp,
    this.isRead = false,
    required this.source,
    this.sourceImageUrl,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      message: json['message']?.toString() ?? '',
      imageUrl: json['imageUrl']?.toString(),
      category: json['category']?.toString() ?? '',
      timestamp: (json['timestamp'] as Timestamp).toDate(),
      isRead: json['isRead'] as bool? ?? false,
      source: json['source']?.toString() ?? '',
      sourceImageUrl: json['sourceImageUrl']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'message': message,
      'imageUrl': imageUrl,
      'category': category,
      'timestamp': Timestamp.fromDate(timestamp),
      'isRead': isRead,
      'source': source,
      'sourceImageUrl': sourceImageUrl,
    };
  }
}
