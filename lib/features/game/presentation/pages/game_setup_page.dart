import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:adisyonapp/features/game/domain/entities/game.dart';
import 'package:adisyonapp/features/game/presentation/controllers/game_controller.dart';
import 'package:adisyonapp/features/game/presentation/pages/game_page.dart';
import 'package:adisyonapp/shared/widgets/app_button.dart';
import 'package:adisyonapp/shared/widgets/app_text_field.dart';
import 'package:adisyonapp/shared/widgets/base_screen.dart';

class GameSetupPage extends ConsumerStatefulWidget {
  const GameSetupPage({super.key});

  @override
  ConsumerState<GameSetupPage> createState() => _GameSetupPageState();
}

class _GameSetupPageState extends ConsumerState<GameSetupPage> {
  final _formKey = GlobalKey<FormState>();
  final _gameNameController = TextEditingController();
  final _totalRoundsController = TextEditingController(text: '11');
  final _playerControllers = <TextEditingController>[];
  final _teamControllers = <TextEditingController>[];
  GameMode _selectedMode = GameMode.individual;

  @override
  void initState() {
    super.initState();
    _initializeDefaultPlayers();
  }

  void _initializeDefaultPlayers() {
    _playerControllers.clear();
    _teamControllers.clear();

    if (_selectedMode == GameMode.individual) {
      // 4 bireysel oyuncu
      for (int i = 0; i < 4; i++) {
        _playerControllers.add(TextEditingController());
      }
    } else {
      // 2 takım
      for (int i = 0; i < 2; i++) {
        _teamControllers.add(TextEditingController(text: 'Takım ${i + 1}'));
      }
    }
  }

  @override
  void dispose() {
    _gameNameController.dispose();
    _totalRoundsController.dispose();
    for (var controller in _playerControllers) {
      controller.dispose();
    }
    for (var controller in _teamControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _addPlayer() {
    setState(() {
      if (_selectedMode == GameMode.individual) {
        _playerControllers.add(TextEditingController());
      } else {
        _teamControllers.add(TextEditingController(text: 'Takım ${_teamControllers.length + 1}'));
      }
    });
  }

  void _removePlayer(int index) {
    setState(() {
      if (_selectedMode == GameMode.individual) {
        if (_playerControllers.length > 2) {
          _playerControllers[index].dispose();
          _playerControllers.removeAt(index);
        }
      } else {
        if (_teamControllers.length > 2) {
          _teamControllers[index].dispose();
          _teamControllers.removeAt(index);
        }
      }
    });
  }

  void _startGame() {
    if (_formKey.currentState!.validate()) {
      final names = _selectedMode == GameMode.individual
          ? _playerControllers
              .map((controller) => controller.text.trim())
              .where((name) => name.isNotEmpty)
              .toList()
          : _teamControllers
              .map((controller) => controller.text.trim())
              .where((name) => name.isNotEmpty)
              .toList();

      ref.read(gameControllerProvider.notifier).createGame(
            name: _gameNameController.text.trim(),
            mode: _selectedMode,
            playerNames: names,
            totalRounds: int.tryParse(_totalRoundsController.text) ?? 10,
          );

      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const GamePage(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      title: '101 Skor Takibi',
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Center(
              child: SvgPicture.asset(
                'assets/images/logo.svg',
                width: 120,
                height: 120,
              ),
            ),
            const SizedBox(height: 24),
            AppTextField(
              controller: _gameNameController,
              label: 'Oyun Adı',
              hint: 'Örn: Akşam Oyunu',
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Oyun adı gerekli';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            AppTextField(
              controller: _totalRoundsController,
              label: 'Toplam El',
              hint: '10',
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Toplam el sayısı gerekli';
                }
                final rounds = int.tryParse(value);
                if (rounds == null || rounds <= 0) {
                  return 'Geçerli bir el sayısı girin';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.group),
                        const SizedBox(width: 8),
                        Text(
                          'Oyun Modu',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    SegmentedButton<GameMode>(
                      segments: const [
                        ButtonSegment<GameMode>(
                          value: GameMode.individual,
                          label: Text('Bireysel'),
                          icon: Icon(Icons.person),
                        ),
                        ButtonSegment<GameMode>(
                          value: GameMode.team,
                          label: Text('Takım'),
                          icon: Icon(Icons.groups),
                        ),
                      ],
                      selected: {_selectedMode},
                      onSelectionChanged: (Set<GameMode> newSelection) {
                        setState(() {
                          _selectedMode = newSelection.first;
                          _initializeDefaultPlayers();
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(_selectedMode == GameMode.individual ? Icons.people : Icons.groups),
                        const SizedBox(width: 8),
                        Text(
                          _selectedMode == GameMode.individual ? 'Oyuncular' : 'Takımlar',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    ...(_selectedMode == GameMode.individual ? _playerControllers : _teamControllers)
                        .asMap()
                        .entries
                        .map((entry) {
                      final index = entry.key;
                      final controller = entry.value;
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Row(
                          children: [
                            Expanded(
                              child: AppTextField(
                                controller: controller,
                                label: _selectedMode == GameMode.individual
                                    ? '${index + 1}. Oyuncu'
                                    : '${index + 1}. Takım',
                                hint: _selectedMode == GameMode.individual
                                    ? 'Oyuncu adı'
                                    : 'Takım adı',
                                validator: (value) {
                                  if (value == null || value.trim().isEmpty) {
                                    return _selectedMode == GameMode.individual
                                        ? 'Oyuncu adı gerekli'
                                        : 'Takım adı gerekli';
                                  }
                                  return null;
                                },
                              ),
                            ),
                            const SizedBox(width: 8),
                            if ((_selectedMode == GameMode.individual && _playerControllers.length > 2) ||
                                (_selectedMode == GameMode.team && _teamControllers.length > 2))
                              IconButton(
                                onPressed: () => _removePlayer(index),
                                icon: const Icon(Icons.remove_circle),
                                color: Theme.of(context).colorScheme.error,
                              ),
                          ],
                        ),
                      );
                    }).toList(),
                    const SizedBox(height: 8),
                    Center(
                      child: TextButton.icon(
                        onPressed: _addPlayer,
                        icon: const Icon(Icons.add),
                        label: Text(_selectedMode == GameMode.individual
                            ? 'Oyuncu Ekle'
                            : 'Takım Ekle'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            AppButton(
              text: 'Oyunu Başlat',
              onPressed: _startGame,
              isFullWidth: true,
            ),
          ],
        ),
      ),
    );
  }
} 