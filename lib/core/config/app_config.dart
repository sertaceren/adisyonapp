import 'package:flutter/foundation.dart';

enum Environment { dev, staging, prod }

class AppConfig {
  static late final Environment environment;
  static late final String apiBaseUrl;
  static late final bool enableLogging;

  static void initialize({
    required Environment env,
    required String baseUrl,
    bool? logging,
  }) {
    environment = env;
    apiBaseUrl = baseUrl;
    enableLogging = logging ?? !kReleaseMode;
  }

  static bool get isDevelopment => environment == Environment.dev;
  static bool get isStaging => environment == Environment.staging;
  static bool get isProduction => environment == Environment.prod;
} 