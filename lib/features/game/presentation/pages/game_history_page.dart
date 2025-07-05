import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:adisyonapp/features/game/domain/entities/game.dart';
import 'package:adisyonapp/features/game/presentation/controllers/game_controller.dart';
import 'package:adisyonapp/shared/widgets/base_screen.dart';
import 'package:intl/intl.dart';

class GameHistoryPage extends ConsumerWidget {
  final String? tournamentId;
  
  const GameHistoryPage({super.key, this.tournamentId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gamesAsync = ref.watch(gameHistoryProvider);

    return BaseScreen(
      title: tournamentId != null ? 'Turnuva Oyun Geçmişi' : 'Oyun Geçmişi',
      body: gamesAsync.when(
        data: (games) {
          // Turnuva ID'si varsa sadece o turnuvanın oyunlarını göster
          final filteredGames = tournamentId != null 
              ? games.where((game) => game.tournamentId == tournamentId).toList()
              : games.where((game) => game.tournamentId == null).toList();
          
          if (filteredGames.isEmpty) {
            return Center(
              child: Text(
                tournamentId != null 
                    ? 'Bu turnuvada henüz oyun bulunmuyor.'
                    : 'Henüz kaydedilmiş oyun bulunmuyor.',
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: filteredGames.length,
            itemBuilder: (context, index) {
              final game = filteredGames[index];
              final winner = game.players.firstWhere(
                (p) => p.id == game.winnerId,
                orElse: () => game.players.first,
              );

              return Card(
                margin: const EdgeInsets.only(bottom: 16),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  game.name,
                                  style: Theme.of(context).textTheme.titleLarge,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  game.mode == GameMode.individual
                                      ? 'Bireysel Oyun'
                                      : 'Takım Oyunu',
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  game.createdAt.isNotEmpty 
                                      ? DateFormat('dd.MM.yyyy HH:mm').format(DateTime.parse(game.createdAt).toLocal())
                                      : 'Tarih bilgisi yok',
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () => _showDeleteConfirmation(
                              context,
                              ref,
                              game,
                            ),
                          ),
                        ],
                      ),
                      const Divider(),
                      Text(
                        'Kazanan: ${winner.name}',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              color: Theme.of(context).colorScheme.primary,
                            ),
                      ),
                      const SizedBox(height: 8),
                      Text('Toplam Skor: ${winner.totalScore}'),
                      const SizedBox(height: 16),
                      Text(
                        'Tüm Oyuncular:',
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                      const SizedBox(height: 8),
                      ...(() {
                        final sortedPlayers = [...game.players]..sort((a, b) => a.totalScore.compareTo(b.totalScore));
                        return sortedPlayers.map((player) => Padding(
                          padding: const EdgeInsets.only(bottom: 4),
                          child: Text('${player.name}: ${player.totalScore}'),
                        ));
                      })(),
                    ],
                  ),
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Hata: $error'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => ref.refresh(gameHistoryProvider),
                child: const Text('Tekrar Dene'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showDeleteConfirmation(
    BuildContext context,
    WidgetRef ref,
    Game game,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Oyunu Sil'),
        content: Text('${game.name} oyununu silmek istediğinize emin misiniz?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('İptal'),
          ),
          TextButton(
            onPressed: () async {
              try {
                await ref.read(gameControllerProvider.notifier).deleteGame(game.id);
                if (context.mounted) {
                  Navigator.pop(context);
                  ref.invalidate(gameHistoryProvider);
                }
              } catch (e) {
                if (context.mounted) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Oyun silinirken bir hata oluştu: $e'),
                      backgroundColor: Theme.of(context).colorScheme.error,
                    ),
                  );
                }
              }
            },
            child: const Text('Sil'),
          ),
        ],
      ),
    );
  }
} 