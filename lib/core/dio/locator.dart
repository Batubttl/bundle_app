import 'package:bundle_app/widgets/navigation_controller.dart';
import 'package:get_it/get_it.dart';
import '../../services/news_service.dart';
import '../network/api_client.dart';
import '../../views/home/home_view_model.dart';
import '../../views/search/search_view_model.dart';

final locator = GetIt.instance;

void setupLocator() {
  // Singleton olarak ApiClient'ı kaydet
  GetIt.I.registerLazySingleton(() => ApiClient());

  // NewsService'i ApiClient bağımlılığıyla kaydet
  GetIt.I.registerLazySingleton(() => NewsService(GetIt.I<ApiClient>()));
  locator.registerLazySingleton(() => NavigationController());

  // ViewModels
  locator.registerFactory(() => HomeViewModel(locator()));
  locator.registerFactory(() => SearchViewModel(locator()));
}
