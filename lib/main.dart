import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:adisyonapp/core/config/app_config.dart';
import 'package:adisyonapp/core/config/injection.dart';
import 'package:adisyonapp/core/theme/app_theme.dart';
import 'package:adisyonapp/features/game/presentation/pages/home_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize app configuration
  AppConfig.initialize(
    env: Environment.dev,
    baseUrl: 'https://api.adisyon.dev',
  );

  // Initialize dependencies
  await initializeDependencies();
  
  runApp(
    const ProviderScope(
      child: AdisyonApp(),
    ),
  );
}

class AdisyonApp extends StatelessWidget {
  const AdisyonApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '101 Skor Takibi',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      home: const HomePage(),
    );
  }
}
