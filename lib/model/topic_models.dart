class TopicItem {
  final String title;
  final String imageUrl;
  final bool isAddable;

  TopicItem({
    required this.title,
    required this.imageUrl,
    this.isAddable = false,
  });
}

class InterestArea {
  final String title;
  final String imageUrl;

  InterestArea({
    required this.title,
    required this.imageUrl,
  });
}