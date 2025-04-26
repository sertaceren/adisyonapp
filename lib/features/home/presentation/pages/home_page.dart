import 'package:flutter/material.dart';
import 'package:adisyonapp/features/game/presentation/pages/game_setup_page.dart';
import 'package:adisyonapp/shared/widgets/base_screen.dart';
import 'package:adisyonapp/shared/widgets/app_button.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      title: '101 Oyunu',
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.sports_esports,
              size: 100,
              color: Colors.blue,
            ),
            const SizedBox(height: 24),
            const Text(
              '101 Oyununa Hoş Geldiniz',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Yeni bir oyun başlatmak için aşağıdaki butona tıklayın.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 32),
            AppButton(
              text: 'Yeni Oyun Başlat',
              onPressed: () {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => const GameSetupPage(),
                  ),
                );
              },
              isFullWidth: true,
              variant: AppButtonVariant.primary,
            ),
          ],
        ),
      ),
    );
  }
} 