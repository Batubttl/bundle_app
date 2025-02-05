import 'package:bundle_app/core/navigation/navigation_controller.dart';
import 'package:get_it/get_it.dart';
import '../../services/news_service.dart';
import '../network/api_client.dart';
import '../../views/home/home_view_model.dart';
import '../../views/search/search_view_model.dart';

final locator = GetIt.instance;

void setupLocator() {
  // Singleton Services
  locator.registerLazySingleton(() => ApiClient());
  locator.registerLazySingleton(() => NewsService(locator()));
  locator.registerLazySingleton(() => NavigationController());

  // ViewModels
  locator.registerFactory(() => HomeViewModel(locator()));
  locator.registerFactory(() => SearchViewModel(locator()));
}
