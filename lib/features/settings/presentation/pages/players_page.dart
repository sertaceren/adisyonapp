import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:adisyonapp/shared/widgets/base_screen.dart';
import 'package:adisyonapp/shared/widgets/app_button.dart';
import 'package:adisyonapp/shared/widgets/app_text_field.dart';
import 'package:adisyonapp/features/settings/presentation/controllers/players_controller.dart';
import 'package:adisyonapp/features/game/domain/entities/player.dart';

class PlayersPage extends ConsumerWidget {
  const PlayersPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final playersAsync = ref.watch(playersControllerProvider);

    return BaseScreen(
      title: 'Oyuncular',
      actions: [
        IconButton(
          onPressed: () => _showAddPlayerDialog(context, ref),
          icon: const Icon(Icons.add),
          tooltip: 'Oyuncu Ekle',
        ),
      ],
      body: playersAsync.when(
        initial: () => const Center(child: CircularProgressIndicator()),
        loading: () => const Center(child: CircularProgressIndicator()),
        success: (players) {
          if (players.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.people_outline,
                    size: 64,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Henüz oyuncu eklenmemiş',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Oyuncu eklemek için + butonuna tıklayın',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                  ),
                  const SizedBox(height: 24),
                  AppButton(
                    text: 'Oyuncu Ekle',
                    onPressed: () => _showAddPlayerDialog(context, ref),
                    icon: Icons.add,
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: players.length,
            itemBuilder: (context, index) {
              final player = players[index];
              return _buildPlayerCard(context, ref, player);
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
                onPressed: () => ref.refresh(playersControllerProvider),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPlayerCard(BuildContext context, WidgetRef ref, SavedPlayer player) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: player.isActive 
              ? Theme.of(context).colorScheme.primary
              : Theme.of(context).colorScheme.onSurfaceVariant,
          child: Text(
            player.name.isNotEmpty ? player.name[0].toUpperCase() : '?',
            style: TextStyle(
              color: player.isActive 
                  ? Theme.of(context).colorScheme.onPrimary
                  : Theme.of(context).colorScheme.surface,
            ),
          ),
        ),
        title: Text(
          player.name,
          style: TextStyle(
            decoration: player.isActive ? null : TextDecoration.lineThrough,
            color: player.isActive 
                ? Theme.of(context).colorScheme.onSurface
                : Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
        subtitle: Text(
          player.isActive ? 'Aktif' : 'Pasif',
          style: TextStyle(
            color: player.isActive 
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
        trailing: PopupMenuButton<String>(
          onSelected: (value) => _handlePlayerAction(context, ref, player, value),
          itemBuilder: (context) => [
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
            PopupMenuItem(
              value: player.isActive ? 'deactivate' : 'activate',
              child: Row(
                children: [
                  Icon(player.isActive ? Icons.block : Icons.check_circle),
                  const SizedBox(width: 8),
                  Text(player.isActive ? 'Pasif Yap' : 'Aktif Yap'),
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

  void _handlePlayerAction(BuildContext context, WidgetRef ref, SavedPlayer player, String action) {
    switch (action) {
      case 'edit':
        _showEditPlayerDialog(context, ref, player);
        break;
      case 'activate':
      case 'deactivate':
        ref.read(playersControllerProvider.notifier).togglePlayerStatus(player.id);
        break;
      case 'delete':
        _showDeleteConfirmation(context, ref, player);
        break;
    }
  }

  void _showAddPlayerDialog(BuildContext context, WidgetRef ref) {
    final nameController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Oyuncu Ekle'),
        content: AppTextField(
          controller: nameController,
          label: 'Oyuncu Adı',
          hint: 'Oyuncu adını girin',
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('İptal'),
          ),
          TextButton(
            onPressed: () {
              final name = nameController.text.trim();
              if (name.isNotEmpty) {
                ref.read(playersControllerProvider.notifier).addPlayer(name);
                Navigator.pop(context);
              }
            },
            child: const Text('Ekle'),
          ),
        ],
      ),
    );
  }

  void _showEditPlayerDialog(BuildContext context, WidgetRef ref, SavedPlayer player) {
    final nameController = TextEditingController(text: player.name);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Oyuncu Düzenle'),
        content: AppTextField(
          controller: nameController,
          label: 'Oyuncu Adı',
          hint: 'Oyuncu adını girin',
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('İptal'),
          ),
          TextButton(
            onPressed: () {
              final name = nameController.text.trim();
              if (name.isNotEmpty) {
                ref.read(playersControllerProvider.notifier).updatePlayer(
                  player.id,
                  name,
                );
                Navigator.pop(context);
              }
            },
            child: const Text('Kaydet'),
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context, WidgetRef ref, SavedPlayer player) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Oyuncu Sil'),
        content: Text('${player.name} oyuncusunu silmek istediğinize emin misiniz?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('İptal'),
          ),
          TextButton(
            onPressed: () {
              ref.read(playersControllerProvider.notifier).deletePlayer(player.id);
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
} 