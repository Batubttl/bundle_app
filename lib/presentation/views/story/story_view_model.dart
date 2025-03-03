import 'package:flutter/material.dart';
import '../../../model/article_model.dart';

class StoryViewModel extends ChangeNotifier {
  final List<Article> stories;
  int _currentIndex = 0;
  bool _isLoading = false;

  StoryViewModel({required this.stories});

  int get currentIndex => _currentIndex;
  bool get isLoading => _isLoading;
  Article get currentStory => stories[_currentIndex];
  bool get isFirstStory => _currentIndex == 0;
  bool get isLastStory => _currentIndex == stories.length - 1;
  bool get hasStories => stories.isNotEmpty;

  void nextStory() {
    if (_currentIndex < stories.length - 1) {
      _currentIndex++;
      notifyListeners();
    }
  }

  void previousStory() {
    if (_currentIndex > 0) {
      _currentIndex--;
      notifyListeners();
    }
  }

  void markStoryAsViewed() {}

  Future<void> navigateToNewsDetail(BuildContext context) async {
    _isLoading = true;
    notifyListeners();

    try {} catch (e) {
      debugPrint('Error navigating to news detail: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
