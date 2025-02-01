import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:adisyonapp/core/network/api_client.dart';

final GetIt getIt = GetIt.instance;

Future<void> initializeDependencies() async {
  // Core
  final sharedPreferences = await SharedPreferences.getInstance();
  getIt.registerLazySingleton(() => sharedPreferences);
  getIt.registerLazySingleton(() => ApiClient());

  // Features
  await _initializeAuthDependencies();
  await _initializeMenuDependencies();
  await _initializeOrdersDependencies();
}

Future<void> _initializeAuthDependencies() async {
  // TODO: Register auth dependencies
}

Future<void> _initializeMenuDependencies() async {
  // TODO: Register menu dependencies
}

Future<void> _initializeOrdersDependencies() async {
  // TODO: Register orders dependencies
} 