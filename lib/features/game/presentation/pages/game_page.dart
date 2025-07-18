import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:adisyonapp/features/game/domain/entities/game.dart';
import 'package:adisyonapp/features/game/domain/entities/player.dart';
import 'package:adisyonapp/features/game/presentation/controllers/game_controller.dart';
import 'package:adisyonapp/features/game/presentation/pages/game_setup_page.dart';
import 'package:adisyonapp/shared/widgets/app_button.dart';
import 'package:adisyonapp/shared/widgets/base_screen.dart';
import 'package:adisyonapp/shared/widgets/app_text_field.dart';
import 'package:share_plus/share_plus.dart';
import 'package:adisyonapp/features/game/presentation/pages/home_page.dart';

class GamePage extends ConsumerWidget {
  const GamePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gameState = ref.watch(gameControllerProvider);
    final showScores = ref.watch(showScoresProvider);

    return gameState.when(
      initial: () => const SizedBox(),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (failure) => Center(child: Text(failure.message)),
      success: (game) {
        return BaseScreen(
          title: game.name,
          actions: [
            IconButton(
              onPressed: () {
                if (game.tournamentId != null) {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) => HomePage(
                        initialTabIndex: 1,
                        tournamentId: game.tournamentId,
                      ),
                    ),
                  );
                } else {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) => const HomePage(initialTabIndex: 0),
                    ),
                  );
                }
              },
              icon: const Icon(Icons.home),
              tooltip: 'Anasayfa',
            ),
            IconButton(
              onPressed: () => _showResetConfirmation(context, ref),
              icon: const Icon(Icons.refresh),
              tooltip: 'Oyunu Sıfırla',
            ),
          ],
          body: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Text(
                      'El ${game.currentRound}/${game.totalRounds}',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 8),
                    LinearProgressIndicator(
                      value: game.currentRound / game.totalRounds,
                      backgroundColor: Colors.grey[200],
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    _buildScoreBoard(context, ref, game, showScores),
                    if (game.status == GameStatus.completed)
                      _buildWinnerCard(context, game)
                    else if (game.currentRound <= game.totalRounds)
                      Column(
                        children: [
                          _buildScoreInputs(context, ref, game),
                          if (ref.read(gameControllerProvider.notifier)
                              .canMoveToNextRound(game))
                            Padding(
                              padding: const EdgeInsets.only(top: 16.0),
                              child: AppButton(
                                text: game.currentRound == game.totalRounds
                                    ? 'Oyunu Bitir'
                                    : 'Sonraki El',
                                onPressed: () {
                                  ref
                                      .read(gameControllerProvider.notifier)
                                      .nextRound();
                                },
                                isFullWidth: true,
                                variant: game.currentRound == game.totalRounds
                                    ? AppButtonVariant.primary
                                    : AppButtonVariant.secondary,
                              ),
                            ),
                        ],
                      ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildScoreBoard(BuildContext context, WidgetRef ref, Game game, bool showScores) {
    final shouldSort = ref.watch(sortScoresProvider);
    
    // Oyuncuları puanlarına göre küçükten büyüğe sırala (sadece sıralama etkinse)
    final displayPlayers = shouldSort 
        ? (List.from(game.players)..sort((a, b) => a.totalScore.compareTo(b.totalScore)))
        : game.players;
    
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.leaderboard),
                const SizedBox(width: 8),
                Text(
                  'Skor Tablosu',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  onPressed: () {
                    ref.read(showScoresProvider.notifier).toggle();
                  },
                  icon: Icon(
                    showScores ? Icons.visibility : Icons.visibility_off,
                    size: 20,
                  ),
                  tooltip: showScores ? 'Puanları Gizle' : 'Puanları Göster',
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Table(
              columnWidths: const {
                0: FlexColumnWidth(2),
                1: FlexColumnWidth(1),
                2: FlexColumnWidth(3),
              },
              children: [
                TableRow(
                  children: [
                    Text(
                      'Oyuncu',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    Text(
                      'Toplam',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    Text(
                      'El Skorları',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ],
                ),
                ...displayPlayers.map((player) {
                  return TableRow(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        child: Row(
                          children: [
                            if (player.isDealer)
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                                decoration: BoxDecoration(
                                  color: Theme.of(context).colorScheme.primary,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  '🎯',
                                  style: const TextStyle(fontSize: 10),
                                ),
                              ),
                            const SizedBox(width: 6),
                            Expanded(
                              child: Text(
                                player.name,
                                style: const TextStyle(fontSize: 16),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        child: Text(
                          showScores ? player.totalScore.toString() : '***',
                          style: TextStyle(
                            fontSize: 16,
                            color: Theme.of(context).colorScheme.secondary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        child: Text(
                          player.roundScores.isEmpty
                              ? '-'
                              : player.roundScores.join(', '),
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                    ],
                  );
                }).toList(),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWinnerCard(BuildContext context, Game game) {
    final winner = game.players.firstWhere((p) => p.id == game.winnerId);
    return Card(
      color: Theme.of(context).colorScheme.secondary.withOpacity(0.1),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Icon(
              Icons.emoji_events,
              size: 64,
              color: Theme.of(context).colorScheme.secondary,
            ),
            const SizedBox(height: 16),
            Text(
              '${winner.name} Kazandı!',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Toplam Skor: ${winner.totalScore}',
              style: TextStyle(
                fontSize: 20,
                color: Theme.of(context).colorScheme.secondary,
                fontWeight: FontWeight.w600,
              ),
            ),
            if (game.currentRound >= game.totalRounds)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  'Tüm eller tamamlandı!',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary.withOpacity(0.7),
                  ),
                ),
              ),
            const SizedBox(height: 24),
            AppButton(
              text: 'Paylaş',
              onPressed: () => _shareToInstagram(context, game, winner),
              variant: AppButtonVariant.secondary,
              icon: Icons.share,
            ),
          ],
        ),
      ),
    );
  }

  void _shareToInstagram(BuildContext context, Game game, Player winner) {
    // Oyuncuları puanlarına göre sırala (küçükten büyüğe)
    final sortedPlayers = [...game.players]..sort((a, b) => a.totalScore.compareTo(b.totalScore));
    
    final message = '''
🎮 ${game.name}

🏆 ${winner.name} Kazandı!
📊 Toplam Skor: ${winner.totalScore}
🎯 ${game.totalRounds} El Oynandı

📋 Final Sıralaması:
${sortedPlayers.asMap().entries.map((entry) {
  final index = entry.key;
  final player = entry.value;
  final medal = index == 0 ? '🥇' : index == 1 ? '🥈' : index == 2 ? '🥉' : '${index + 1}.';
  return '$medal ${player.name}: ${player.totalScore}';
}).join('\n')}
''';

    Share.share(message, subject: '101 Oyunu Sonucu');
  }

  Widget _buildScoreInputs(BuildContext context, WidgetRef ref, Game game) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.add_circle_outline),
                const SizedBox(width: 8),
                Text(
                  'El ${game.currentRound} - Skor Girişi',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ...game.players.map((player) {
              final hasScoreForCurrentRound =
                  player.roundScores.length >= game.currentRound;
              return _buildPlayerScoreInput(
                context,
                ref,
                player,
                enabled: !hasScoreForCurrentRound,
              );
            }).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildPlayerScoreInput(
    BuildContext context,
    WidgetRef ref,
    Player player, {
    bool enabled = true,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: enabled 
            ? Theme.of(context).colorScheme.primary.withOpacity(0.1)
            : Theme.of(context).disabledColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                flex: 2,
                child: Text(
                  player.name,
                  style: TextStyle(
                    fontSize: 16,
                    color: enabled 
                        ? Theme.of(context).colorScheme.primary
                        : Theme.of(context).disabledColor,
                  ),
                ),
              ),
              if (enabled)
                Expanded(
                  flex: 2,
                  child: Row(
                    children: [
                      Expanded(
                        child: AppTextField(
                          controller: TextEditingController(),
                          keyboardType: TextInputType.number,
                          textAlign: TextAlign.center,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 8,
                          ),
                          onSubmitted: (value) {
                            final score = int.tryParse(value);
                            if (score != null) {
                              ref.read(gameControllerProvider.notifier).addScore(player.id, score);
                            }
                          },
                        ),
                      ),
                      const SizedBox(width: 8),
                      IconButton(
                        onPressed: () {
                          ref
                              .read(gameControllerProvider.notifier)
                              .undoLastScore(player.id);
                        },
                        icon: const Icon(Icons.undo),
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                    ],
                  ),
                )
              else
                Expanded(
                  flex: 2,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          player.roundScores.last.toString(),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Theme.of(context).colorScheme.secondary,
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          ref
                              .read(gameControllerProvider.notifier)
                              .undoLastScore(player.id);
                        },
                        icon: const Icon(Icons.undo),
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                    ],
                  ),
                ),
            ],
          ),
          if (enabled) ...[
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: _buildQuickScoreButton(
                    context,
                    ref,
                    player,
                    -101,
                    '-101',
                    Colors.red,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildQuickScoreButton(
                    context,
                    ref,
                    player,
                    202,
                    '202',
                    Colors.blue,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildQuickScoreButton(
    BuildContext context,
    WidgetRef ref,
    Player player,
    int score,
    String label,
    Color color,
  ) {
    return ElevatedButton(
      onPressed: () {
        ref.read(gameControllerProvider.notifier).addScore(player.id, score);
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: color.withOpacity(0.1),
        foregroundColor: color,
        padding: const EdgeInsets.symmetric(vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: BorderSide(color: color),
        ),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: color,
        ),
      ),
    );
  }

  void _showResetConfirmation(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Oyunu Sıfırla'),
        content: const Text('Oyunu sıfırlamak istediğinize emin misiniz?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('İptal'),
          ),
          TextButton(
            onPressed: () {
              ref.read(gameControllerProvider.notifier).resetGame();
              Navigator.pop(context);
            },
            child: const Text('Sıfırla'),
          ),
        ],
      ),
    );
  }

  void _showNewGameConfirmation(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Yeni Oyun'),
        content: const Text('Mevcut oyunu bitirip yeni bir oyun başlatmak istediğinize emin misiniz?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('İptal'),
          ),
          TextButton(
            onPressed: () async {
              final gameState = ref.read(gameControllerProvider);
              gameState.maybeWhen(
                success: (game) async {
                  if (game.status == GameStatus.inProgress) {
                    final winner = ref.read(gameControllerProvider.notifier).determineWinner(game.players);
                    final completedGame = game.copyWith(
                      status: GameStatus.completed,
                      winnerId: winner,
                    );
                    await ref.read(gameControllerProvider.notifier).saveGame(completedGame);
                    ref.invalidate(gameHistoryProvider);
                  }
                },
                orElse: () {},
              );
              if (context.mounted) {
                Navigator.pop(context);
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => const GameSetupPage(),
                  ),
                );
              }
            },
            child: const Text('Yeni Oyun'),
          ),
        ],
      ),
    );
  }
} 