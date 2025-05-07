import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:adisyonapp/features/game/presentation/pages/game_setup_page.dart';
import 'package:adisyonapp/features/game/presentation/pages/game_history_page.dart';
import 'package:adisyonapp/features/game/presentation/pages/game_page.dart';
import 'package:adisyonapp/features/game/presentation/controllers/game_controller.dart';
import 'package:adisyonapp/shared/widgets/app_button.dart';
import 'package:adisyonapp/shared/widgets/base_screen.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.invalidate(ongoingGameProvider);
    final ongoingGameAsync = ref.watch(ongoingGameProvider);

    return BaseScreen(
      title: '101 Skor Takibi',
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  'assets/images/logo.svg',
                  width: 200,
                  height: 200,
                ),
                const SizedBox(height: 48),
                ongoingGameAsync.when(
                  data: (ongoingGame) {
                    if (ongoingGame != null) {
                      return Column(
                        children: [
                          _buildMenuCard(
                            context,
                            title: 'Devam Eden Oyun',
                            icon: Icons.play_circle_outline,
                            description: 'Kaldığın yerden devam et',
                            onTap: () {
                              ref.read(gameControllerProvider.notifier).createGame(
                                name: ongoingGame.name,
                                mode: ongoingGame.mode,
                                playerNames: ongoingGame.players.map((p) => p.name).toList(),
                                totalRounds: ongoingGame.totalRounds,
                                existingGame: ongoingGame,
                              );
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const GamePage(),
                                ),
                              );
                            },
                          ),
                          const SizedBox(height: 16),
                        ],
                      );
                    }
                    return const SizedBox.shrink();
                  },
                  loading: () => const CircularProgressIndicator(),
                  error: (_, __) => const SizedBox.shrink(),
                ),
                _buildMenuCard(
                  context,
                  title: 'Yeni Oyun',
                  icon: Icons.add_circle_outline,
                  description: 'Yeni bir oyun başlat',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const GameSetupPage(),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 16),
                _buildMenuCard(
                  context,
                  title: 'Oyun Geçmişi',
                  icon: Icons.history,
                  description: 'Geçmiş oyunları görüntüle',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const GameHistoryPage(),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMenuCard(
    BuildContext context, {
    required String title,
    required IconData icon,
    required String description,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Row(
            children: [
              Icon(
                icon,
                size: 40,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                color: Theme.of(context).colorScheme.primary,
              ),
            ],
          ),
        ),
      ),
    );
  }
} 