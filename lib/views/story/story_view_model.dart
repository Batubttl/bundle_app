import 'package:flutter/material.dart';
import '../../model/article_model.dart';

class StoryViewModel extends ChangeNotifier {
  final List<Article> stories;
  int _currentIndex = 0;
  bool _isLoading = false;

  StoryViewModel({required this.stories});

  // Getter'lar
  int get currentIndex => _currentIndex;
  bool get isLoading => _isLoading;
  Article get currentStory => stories[_currentIndex];
  bool get isFirstStory => _currentIndex == 0;
  bool get isLastStory => _currentIndex == stories.length - 1;
  bool get hasStories => stories.isNotEmpty;

  // Story'ler arası geçiş
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

  // Story görüntülenme durumu
  void markStoryAsViewed() {
    // Burada story'nin görüntülenme durumunu kaydedebiliriz
    // Örneğin: Firebase'e log gönderme, local storage'a kaydetme vs.
  }

  // Haber detayına gitme
  Future<void> navigateToNewsDetail(BuildContext context) async {
    _isLoading = true;
    notifyListeners();

    try {
      // Haber detayına yönlendirme işlemleri
      // Örneğin: URL'i açma, detay sayfasına yönlendirme vs.
    } catch (e) {
      print('Error navigating to news detail: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
