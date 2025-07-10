import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:adisyonapp/features/tournament/domain/entities/tournament.dart';
import 'package:adisyonapp/features/tournament/presentation/controllers/tournament_controller.dart';
import 'package:adisyonapp/shared/widgets/base_screen.dart';
import 'package:intl/intl.dart';

class TournamentDetailPage extends ConsumerWidget {
  final Tournament tournament;
  
  const TournamentDetailPage({super.key, required this.tournament});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scoresAsync = ref.watch(tournamentScoresProvider(tournament.id));

    return BaseScreen(
      title: tournament.name,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Turnuva bilgileri
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Turnuva Bilgileri',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildInfoRow('Durum', _getStatusText(tournament.status)),
                    if (tournament.startedAt.isNotEmpty)
                      _buildInfoRow('Başlangıç', DateFormat('dd.MM.yyyy HH:mm').format(DateTime.parse(tournament.startedAt).toLocal())),
                    if (tournament.completedAt.isNotEmpty)
                      _buildInfoRow('Bitiş', DateFormat('dd.MM.yyyy HH:mm').format(DateTime.parse(tournament.completedAt).toLocal())),
                    _buildInfoRow('Katılımcı Sayısı', '${tournament.participants.length}'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            
            // Puan tablosu
            scoresAsync.when(
              data: (scores) {
                if (scores.isNotEmpty) {
                  return Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Final Sıralaması',
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 16),
                          ...scores.asMap().entries.map((entry) {
                            final index = entry.key;
                            final score = entry.value;
                            return Container(
                              margin: const EdgeInsets.only(bottom: 8),
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: index == 0 
                                    ? Colors.amber.withOpacity(0.1)
                                    : index == 1 
                                        ? Colors.grey.withOpacity(0.1)
                                        : index == 2 
                                            ? Colors.brown.withOpacity(0.1)
                                            : Colors.grey.withOpacity(0.05),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: index == 0 
                                      ? Colors.amber 
                                      : index == 1 
                                          ? Colors.grey 
                                          : index == 2 
                                              ? Colors.brown 
                                              : Colors.grey.withOpacity(0.3),
                                ),
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    width: 40,
                                    height: 40,
                                    decoration: BoxDecoration(
                                      color: index == 0 
                                          ? Colors.amber 
                                          : index == 1 
                                              ? Colors.grey[400] 
                                              : index == 2 
                                                  ? Colors.brown[300] 
                                                  : Colors.grey[200],
                                      shape: BoxShape.circle,
                                    ),
                                    child: Center(
                                      child: Text(
                                        '${index + 1}',
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          score.playerName,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 16,
                                          ),
                                        ),
                                        Text(
                                          '${score.totalPoints} puan • ${score.gamesPlayed} oyun',
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Theme.of(context).colorScheme.onSurfaceVariant,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          '${score.firstPlaceCount} kez 1. • ${score.secondPlaceCount} kez 2. • ${score.thirdPlaceCount} kez 3.',
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Theme.of(context).colorScheme.onSurfaceVariant,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }),
                        ],
                      ),
                    ),
                  );
                }
                return const SizedBox.shrink();
              },
              loading: () => const Card(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Center(child: CircularProgressIndicator()),
                ),
              ),
              error: (_, __) => const SizedBox.shrink(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              '$label:',
              style: const TextStyle(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Expanded(
            child: Text(value),
          ),
        ],
      ),
    );
  }

  String _getStatusText(TournamentStatus status) {
    switch (status) {
      case TournamentStatus.upcoming:
        return 'Yakında';
      case TournamentStatus.inProgress:
        return 'Devam Ediyor';
      case TournamentStatus.completed:
        return 'Tamamlandı';
    }
  }
} 