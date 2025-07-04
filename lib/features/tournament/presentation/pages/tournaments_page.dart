import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:adisyonapp/shared/widgets/base_screen.dart';
import 'package:adisyonapp/shared/widgets/app_button.dart';
import 'package:adisyonapp/features/tournament/presentation/controllers/tournament_controller.dart';
import 'package:adisyonapp/features/tournament/domain/entities/tournament.dart';
import 'package:adisyonapp/features/tournament/presentation/pages/tournament_setup_page.dart';
import 'package:intl/intl.dart';

class TournamentsPage extends ConsumerWidget {
  const TournamentsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tournamentsAsync = ref.watch(tournamentsControllerProvider);

    return BaseScreen(
      title: 'Turnuvalar',
      actions: [
        IconButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const TournamentSetupPage(),
              ),
            );
          },
          icon: const Icon(Icons.add),
          tooltip: 'Turnuva Ekle',
        ),
      ],
      body: tournamentsAsync.when(
        initial: () => const Center(child: CircularProgressIndicator()),
        loading: () => const Center(child: CircularProgressIndicator()),
        success: (tournaments) {
          if (tournaments.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.emoji_events_outlined,
                    size: 64,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Henüz turnuva oluşturulmamış',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Turnuva oluşturmak için + butonuna tıklayın',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                  ),
                  const SizedBox(height: 24),
                  AppButton(
                    text: 'Turnuva Ekle',
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const TournamentSetupPage(),
                        ),
                      );
                    },
                    icon: Icons.add,
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: tournaments.length,
            itemBuilder: (context, index) {
              final tournament = tournaments[index];
              return _buildTournamentCard(context, ref, tournament);
            },
          );
        },
        error: (error) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Hata: ${error.message}'),
              const SizedBox(height: 16),
              AppButton(
                text: 'Tekrar Dene',
                onPressed: () => ref.refresh(tournamentsControllerProvider),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTournamentCard(BuildContext context, WidgetRef ref, Tournament tournament) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: _getStatusColor(tournament.status),
          child: Icon(
            _getStatusIcon(tournament.status),
            color: Colors.white,
          ),
        ),
        title: Text(
          tournament.name,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${tournament.type == TournamentType.individual ? 'Bireysel' : 'Takım'} Turnuvası',
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '${tournament.participants.length} katılımcı',
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              _getStatusText(tournament.status),
              style: TextStyle(
                color: _getStatusColor(tournament.status),
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        trailing: PopupMenuButton<String>(
          onSelected: (value) => _handleTournamentAction(context, ref, tournament, value),
          itemBuilder: (context) => [
            if (tournament.status == TournamentStatus.upcoming) ...[
              const PopupMenuItem(
                value: 'start',
                child: Row(
                  children: [
                    Icon(Icons.play_arrow),
                    SizedBox(width: 8),
                    Text('Başlat'),
                  ],
                ),
              ),
            ],
            if (tournament.status == TournamentStatus.inProgress) ...[
              const PopupMenuItem(
                value: 'complete',
                child: Row(
                  children: [
                    Icon(Icons.check_circle),
                    SizedBox(width: 8),
                    Text('Tamamla'),
                  ],
                ),
              ),
            ],
            const PopupMenuItem(
              value: 'edit',
              child: Row(
                children: [
                  Icon(Icons.edit),
                  SizedBox(width: 8),
                  Text('Düzenle'),
                ],
              ),
            ),
            const PopupMenuItem(
              value: 'delete',
              child: Row(
                children: [
                  Icon(Icons.delete, color: Colors.red),
                  SizedBox(width: 8),
                  Text('Sil', style: TextStyle(color: Colors.red)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _handleTournamentAction(BuildContext context, WidgetRef ref, Tournament tournament, String action) {
    switch (action) {
      case 'start':
        ref.read(tournamentsControllerProvider.notifier).startTournament(tournament.id);
        break;
      case 'complete':
        ref.read(tournamentsControllerProvider.notifier).completeTournament(tournament.id);
        break;
      case 'edit':
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TournamentSetupPage(tournament: tournament),
          ),
        );
        break;
      case 'delete':
        _showDeleteConfirmation(context, ref, tournament);
        break;
    }
  }

  void _showDeleteConfirmation(BuildContext context, WidgetRef ref, Tournament tournament) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Turnuva Sil'),
        content: Text('${tournament.name} turnuvasını silmek istediğinize emin misiniz?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('İptal'),
          ),
          TextButton(
            onPressed: () {
              ref.read(tournamentsControllerProvider.notifier).deleteTournament(tournament.id);
              Navigator.pop(context);
            },
            style: TextButton.styleFrom(
              foregroundColor: Colors.red,
            ),
            child: const Text('Sil'),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(TournamentStatus status) {
    switch (status) {
      case TournamentStatus.upcoming:
        return Colors.orange;
      case TournamentStatus.inProgress:
        return Colors.blue;
      case TournamentStatus.completed:
        return Colors.green;
    }
  }

  IconData _getStatusIcon(TournamentStatus status) {
    switch (status) {
      case TournamentStatus.upcoming:
        return Icons.schedule;
      case TournamentStatus.inProgress:
        return Icons.play_arrow;
      case TournamentStatus.completed:
        return Icons.check_circle;
    }
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