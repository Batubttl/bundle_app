import 'package:bundle_app/views/currency_view_model.dart';
import 'package:bundle_app/views/weather_viewmodel.dart';
import 'package:bundle_app/widgets/navigation_controller.dart';
import 'package:get_it/get_it.dart';
import '../../services/news_service.dart';
import '../../services/currency_service.dart';
import '../../services/weather_service.dart';
import '../network/api_client.dart';
import '../../views/home/home_view_model.dart';
import '../../views/search/search_view_model.dart';

final locator = GetIt.instance;

void setupLocator() {
  locator.registerLazySingleton(() => ApiClient());

  locator.registerLazySingleton(() => NewsService(locator<ApiClient>()));
  locator.registerLazySingleton(() => NavigationController());
  locator.registerLazySingleton(() => WeatherService());
  locator.registerLazySingleton(() => CurrencyService());

  // ViewModels
  locator.registerFactory(() => HomeViewModel(locator()));
  locator.registerFactory(() => SearchViewModel(locator()));
  locator.registerFactory(() => WeatherViewModel(locator()));
  locator.registerFactory(() => CurrencyViewModel(locator<CurrencyService>()));
}
