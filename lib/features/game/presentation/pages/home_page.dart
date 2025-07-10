import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:adisyonapp/features/game/presentation/pages/game_setup_page.dart';
import 'package:adisyonapp/features/game/presentation/pages/game_history_page.dart';
import 'package:adisyonapp/features/game/presentation/pages/game_page.dart';
import 'package:adisyonapp/features/game/presentation/controllers/game_controller.dart';
import 'package:adisyonapp/features/game/domain/entities/game.dart';
import 'package:adisyonapp/shared/widgets/app_button.dart';
import 'package:adisyonapp/shared/widgets/base_screen.dart';
import 'package:adisyonapp/features/settings/presentation/pages/settings_page.dart';
import 'package:adisyonapp/features/tournament/presentation/controllers/tournament_controller.dart';
import 'package:adisyonapp/features/tournament/domain/entities/tournament.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HomePage extends ConsumerStatefulWidget {
  final int initialTabIndex;
  final String? tournamentId;
  
  const HomePage({super.key, this.initialTabIndex = 0, this.tournamentId});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  Tournament? _selectedTournament;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      // Turnuva sekmesine geçildiğinde provider'ları yenile
      if (_tabController.index == 1 && _selectedTournament != null) {
        ref.invalidate(ongoingTournamentGameProvider(_selectedTournament!.id));
        Future.delayed(const Duration(milliseconds: 100), () {
          if (mounted) {
            ref.refresh(ongoingTournamentGameProvider(_selectedTournament!.id));
          }
        });
      }
    });
    
    // Initial tab index'i ayarla
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.initialTabIndex < _tabController.length) {
        _tabController.animateTo(widget.initialTabIndex);
      }
      
      // Eğer tournamentId verilmişse, o turnuvayı seç
      if (widget.tournamentId != null) {
        _selectTournamentById(widget.tournamentId!);
      }
    });
  }

  void _selectTournamentById(String tournamentId) {
    final tournamentsAsync = ref.read(tournamentsControllerProvider);
    tournamentsAsync.when(
      initial: () {},
      loading: () {},
      success: (tournaments) {
        final tournament = tournaments.firstWhere(
          (t) => t.id == tournamentId,
          orElse: () => tournaments.first,
        );
        setState(() {
          _selectedTournament = tournament;
        });
        // Provider'ı invalidate et ve hemen refresh et
        ref.invalidate(ongoingTournamentGameProvider(tournament.id));
        Future.delayed(const Duration(milliseconds: 100), () {
          if (mounted) {
            ref.refresh(ongoingTournamentGameProvider(tournament.id));
          }
        });
      },
      error: (error) {},
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      title: '101 Skor Takibi',
      automaticallyImplyLeading: false,
      actions: [
        IconButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const SettingsPage(),
              ),
            );
          },
          icon: const Icon(Icons.settings),
          tooltip: 'Ayarlar',
        ),
      ],
      body: Column(
        children: [
          // Tab Bar
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: TabBar(
              controller: _tabController,
              indicator: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Theme.of(context).colorScheme.primary,
                boxShadow: [
                  BoxShadow(
                    color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
                    blurRadius: 4,
                    offset: const Offset(0, 1),
                  ),
                ],
              ),
              labelColor: Theme.of(context).colorScheme.onPrimary,
              unselectedLabelColor: Theme.of(context).colorScheme.onSurfaceVariant,
              labelStyle: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
              unselectedLabelStyle: const TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 16,
              ),
              indicatorSize: TabBarIndicatorSize.tab,
              dividerColor: Colors.transparent,
              tabs: [
                Tab(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.games,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      const Text('Oyun'),
                    ],
                  ),
                ),
                Tab(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.emoji_events,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      const Text('Turnuva'),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Tab Bar View
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildGameTab(),
                _buildTournamentTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGameTab() {
    final ongoingGameAsync = ref.watch(ongoingRegularGameProvider);

    return SingleChildScrollView(
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
    );
  }

  Widget _buildTournamentTab() {
    final tournamentsAsync = ref.watch(tournamentsControllerProvider);
    
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            tournamentsAsync.when(
              initial: () => const Center(child: CircularProgressIndicator()),
              loading: () => const Center(child: CircularProgressIndicator()),
              success: (tournaments) {
                final activeTournaments = tournaments.where((t) => 
                  t.status == TournamentStatus.inProgress
                ).toList();
                
                if (activeTournaments.isEmpty) {
                  return SizedBox(
                    height: MediaQuery.of(context).size.height * 0.6,
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.emoji_events,
                            size: 120,
                            color: Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                          const SizedBox(height: 24),
                          Text(
                            'Başlatılan Turnuva Yok',
                            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                                ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Ayarlar > Turnuvalar menüsünden turnuva oluşturabilirsiniz',
                            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                                ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  );
                }
                
                return Column(
                  children: [
                    SvgPicture.asset(
                      'assets/images/logo.svg',
                      width: 200,
                      height: 200,
                    ),
                    const SizedBox(height: 32),
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            DropdownButtonFormField<Tournament>(
                              decoration: const InputDecoration(
                                labelText: 'Turnuva Seçin',
                                border: OutlineInputBorder(),
                              ),
                              value: activeTournaments.contains(_selectedTournament) ? _selectedTournament : null,
                              hint: const Text('Turnuva seçin'),
                              items: activeTournaments.map((tournament) {
                                return DropdownMenuItem<Tournament>(
                                  value: tournament,
                                  child: Text(
                                    tournament.name,
                                    style: const TextStyle(fontWeight: FontWeight.w600),
                                  ),
                                );
                              }).toList(),
                              onChanged: (Tournament? selectedTournament) {
                                setState(() {
                                  _selectedTournament = selectedTournament;
                                });
                                if (selectedTournament != null) {
                                  // Provider'ı invalidate et ve hemen refresh et
                                  ref.invalidate(ongoingTournamentGameProvider(selectedTournament.id));
                                  Future.delayed(const Duration(milliseconds: 100), () {
                                    if (mounted) {
                                      ref.refresh(ongoingTournamentGameProvider(selectedTournament.id));
                                    }
                                  });
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    if (_selectedTournament != null) ...[
                      Consumer(
                        builder: (context, ref, child) {
                          final scoresAsync = ref.watch(tournamentScoresProvider(_selectedTournament!.id));
                          
                          return scoresAsync.when(
                            data: (scores) {
                              if (scores.isNotEmpty) {
                                return Column(
                                  children: [
                                    Card(
                                      child: Padding(
                                        padding: const EdgeInsets.all(16),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Turnuva Puan Tablosu',
                                              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            const SizedBox(height: 16),
                                            // Başlık satırı
                                            Container(
                                              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                                              decoration: BoxDecoration(
                                                color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                                                borderRadius: BorderRadius.circular(8),
                                              ),
                                              child: Row(
                                                children: [
                                                  SizedBox(
                                                    width: 40,
                                                    child: Text(
                                                      'Sıra',
                                                      style: TextStyle(
                                                        fontWeight: FontWeight.bold,
                                                        color: Theme.of(context).colorScheme.primary,
                                                      ),
                                                    ),
                                                  ),
                                                  Expanded(
                                                    flex: 2,
                                                    child: Text(
                                                      'Oyuncu',
                                                      style: TextStyle(
                                                        fontWeight: FontWeight.bold,
                                                        color: Theme.of(context).colorScheme.primary,
                                                      ),
                                                    ),
                                                  ),
                                                  Expanded(
                                                    child: Text(
                                                      'O',
                                                      textAlign: TextAlign.center,
                                                      style: TextStyle(
                                                        fontWeight: FontWeight.bold,
                                                        color: Theme.of(context).colorScheme.primary,
                                                      ),
                                                    ),
                                                  ),
                                                  Expanded(
                                                    child: Text(
                                                      '1.',
                                                      textAlign: TextAlign.center,
                                                      style: TextStyle(
                                                        fontWeight: FontWeight.bold,
                                                        color: Theme.of(context).colorScheme.primary,
                                                      ),
                                                    ),
                                                  ),
                                                  Expanded(
                                                    child: Text(
                                                      '2.',
                                                      textAlign: TextAlign.center,
                                                      style: TextStyle(
                                                        fontWeight: FontWeight.bold,
                                                        color: Theme.of(context).colorScheme.primary,
                                                      ),
                                                    ),
                                                  ),
                                                  Expanded(
                                                    child: Text(
                                                      '3.',
                                                      textAlign: TextAlign.center,
                                                      style: TextStyle(
                                                        fontWeight: FontWeight.bold,
                                                        color: Theme.of(context).colorScheme.primary,
                                                      ),
                                                    ),
                                                  ),
                                                  Expanded(
                                                    child: Text(
                                                      '4.',
                                                      textAlign: TextAlign.center,
                                                      style: TextStyle(
                                                        fontWeight: FontWeight.bold,
                                                        color: Theme.of(context).colorScheme.primary,
                                                      ),
                                                    ),
                                                  ),
                                                  Expanded(
                                                    child: Text(
                                                      'P',
                                                      textAlign: TextAlign.center,
                                                      style: TextStyle(
                                                        fontWeight: FontWeight.bold,
                                                        color: Theme.of(context).colorScheme.primary,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            const SizedBox(height: 8),
                                            // Oyuncu satırları
                                            ...scores.asMap().entries.map((entry) {
                                              final index = entry.key;
                                              final score = entry.value;
                                              final fourthPlaceCount = score.gamesPlayed - score.firstPlaceCount - score.secondPlaceCount - score.thirdPlaceCount;
                                              
                                              return Container(
                                                margin: const EdgeInsets.only(bottom: 4),
                                                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
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
                                                    width: 1,
                                                  ),
                                                ),
                                                child: Row(
                                                  children: [
                                                    SizedBox(
                                                      width: 40,
                                                      child: Container(
                                                        width: 24,
                                                        height: 24,
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
                                                              fontSize: 12,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    Expanded(
                                                      flex: 2,
                                                      child: Text(
                                                        score.playerName,
                                                        style: const TextStyle(
                                                          fontWeight: FontWeight.w600,
                                                        ),
                                                      ),
                                                    ),
                                                    Expanded(
                                                      child: Text(
                                                        '${score.gamesPlayed}',
                                                        textAlign: TextAlign.center,
                                                        style: const TextStyle(
                                                          fontWeight: FontWeight.w600,
                                                        ),
                                                      ),
                                                    ),
                                                    Expanded(
                                                      child: Text(
                                                        '${score.firstPlaceCount}',
                                                        textAlign: TextAlign.center,
                                                        style: const TextStyle(
                                                          fontWeight: FontWeight.w600,
                                                          color: Colors.amber,
                                                        ),
                                                      ),
                                                    ),
                                                    Expanded(
                                                      child: Text(
                                                        '${score.secondPlaceCount}',
                                                        textAlign: TextAlign.center,
                                                        style: const TextStyle(
                                                          fontWeight: FontWeight.w600,
                                                          color: Colors.grey,
                                                        ),
                                                      ),
                                                    ),
                                                    Expanded(
                                                      child: Text(
                                                        '${score.thirdPlaceCount}',
                                                        textAlign: TextAlign.center,
                                                        style: const TextStyle(
                                                          fontWeight: FontWeight.w600,
                                                          color: Colors.brown,
                                                        ),
                                                      ),
                                                    ),
                                                    Expanded(
                                                      child: Text(
                                                        '$fourthPlaceCount',
                                                        textAlign: TextAlign.center,
                                                        style: const TextStyle(
                                                          fontWeight: FontWeight.w600,
                                                          color: Colors.grey,
                                                        ),
                                                      ),
                                                    ),
                                                    Expanded(
                                                      child: Text(
                                                        '${score.totalPoints}',
                                                        textAlign: TextAlign.center,
                                                        style: TextStyle(
                                                          fontWeight: FontWeight.bold,
                                                          fontSize: 16,
                                                          color: Theme.of(context).colorScheme.primary,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              );
                                            }),
                                          ],
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                  ],
                                );
                              }
                              return const SizedBox.shrink();
                            },
                            loading: () => const CircularProgressIndicator(),
                            error: (_, __) => const SizedBox.shrink(),
                          );
                        },
                      ),
                      Consumer(
                        builder: (context, ref, child) {
                          final ongoingGameAsync = ref.watch(ongoingTournamentGameProvider(_selectedTournament!.id));
                          
                          return ongoingGameAsync.when(
                            data: (ongoingGame) {
                              if (ongoingGame != null && ongoingGame.status == GameStatus.inProgress) {
                                return Column(
                                  children: [
                                    _buildMenuCard(
                                      context,
                                      title: 'Devam Eden Turnuva Oyunu',
                                      icon: Icons.play_circle_outline,
                                      description: 'Kaldığın yerden devam et',
                                      onTap: () async {
                                        ref.read(gameControllerProvider.notifier).createGame(
                                          name: ongoingGame.name,
                                          mode: ongoingGame.mode,
                                          playerNames: ongoingGame.players.map((p) => p.name).toList(),
                                          totalRounds: ongoingGame.totalRounds,
                                          existingGame: ongoingGame,
                                        );
                                        await Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => const GamePage(),
                                          ),
                                        );
                                        // Geri dönüşte provider'ı yenile
                                        if (mounted && _selectedTournament != null) {
                                          ref.invalidate(ongoingTournamentGameProvider(_selectedTournament!.id));
                                          ref.refresh(ongoingTournamentGameProvider(_selectedTournament!.id));
                                        }
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
                          );
                        },
                      ),
                      _buildMenuCard(
                        context,
                        title: 'Yeni Turnuva Oyunu',
                        icon: Icons.add_circle_outline,
                        description: 'Turnuva için yeni oyun başlat',
                        onTap: () async {
                          _showNewTournamentGameDialog(context);
                        },
                      ),
                      const SizedBox(height: 16),
                      _buildMenuCard(
                        context,
                        title: 'Turnuva Oyun Geçmişi',
                        icon: Icons.history,
                        description: 'Turnuva oyunlarını görüntüle',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => GameHistoryPage(
                                tournamentId: _selectedTournament!.id,
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ],
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
          ],
        ),
      ),
    );
  }

  void _showNewTournamentGameDialog(BuildContext context) {
    final gameNameController = TextEditingController();
    final roundCountController = TextEditingController(text: '11');
    final formKey = GlobalKey<FormState>();
    
    // Oyuncuları sürükleyip bırakabilmek için state
    List<String> playerNames = _selectedTournament!.participants.map((p) => p.name).toList();
    
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('Yeni Turnuva Oyunu'),
          content: SizedBox(
            width: double.maxFinite,
            height: MediaQuery.of(context).size.height * 0.7,
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: gameNameController,
                    decoration: const InputDecoration(
                      labelText: 'Oyun Adı',
                      hintText: 'Örn: 1. El, Final Oyunu',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Oyun adı gerekli';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: roundCountController,
                    decoration: const InputDecoration(
                      labelText: 'El Sayısı',
                      hintText: '11',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'El sayısı gerekli';
                      }
                      final roundCount = int.tryParse(value);
                      if (roundCount == null || roundCount <= 0) {
                        return 'Geçerli bir el sayısı girin';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  // Oyuncu sıralaması
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surface,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Theme.of(context).colorScheme.outline.withOpacity(0.3),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(16),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.people,
                                  size: 20,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'Oyuncu Sıralaması',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: Theme.of(context).colorScheme.primary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: ReorderableListView.builder(
                              shrinkWrap: true,
                              itemCount: playerNames.length,
                              onReorder: (oldIndex, newIndex) {
                                setState(() {
                                  if (oldIndex < newIndex) {
                                    newIndex -= 1;
                                  }
                                  final item = playerNames.removeAt(oldIndex);
                                  playerNames.insert(newIndex, item);
                                });
                              },
                              itemBuilder: (context, index) {
                                return Container(
                                  key: ValueKey(playerNames[index]),
                                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).colorScheme.surface,
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(
                                      color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.05),
                                        blurRadius: 2,
                                        offset: const Offset(0, 1),
                                      ),
                                    ],
                                  ),
                                  child: ListTile(
                                    leading: Container(
                                      width: 32,
                                      height: 32,
                                      decoration: BoxDecoration(
                                        color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                                        shape: BoxShape.circle,
                                      ),
                                      child: Center(
                                        child: Text(
                                          '${index + 1}',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Theme.of(context).colorScheme.primary,
                                            fontSize: 14,
                                          ),
                                        ),
                                      ),
                                    ),
                                    title: Text(
                                      playerNames[index],
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 16,
                                      ),
                                    ),
                                    trailing: Icon(
                                      Icons.drag_handle,
                                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                                    ),
                                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('İptal'),
            ),
            TextButton(
              onPressed: () async {
                if (formKey.currentState!.validate()) {
                  final roundCount = int.parse(roundCountController.text);
                  ref.read(gameControllerProvider.notifier).createGame(
                    name: gameNameController.text.trim(),
                    mode: _selectedTournament!.type == TournamentType.individual 
                        ? GameMode.individual 
                        : GameMode.team,
                    playerNames: playerNames, // Sıralanmış oyuncu listesi
                    totalRounds: roundCount,
                    tournamentId: _selectedTournament!.id,
                  );
                  Navigator.pop(context);
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const GamePage(),
                    ),
                  );
                  // Geri dönüşte provider'ı yenile
                  if (mounted && _selectedTournament != null) {
                    ref.invalidate(ongoingTournamentGameProvider(_selectedTournament!.id));
                    ref.refresh(ongoingTournamentGameProvider(_selectedTournament!.id));
                  }
                }
              },
              child: const Text('Başlat'),
            ),
          ],
        ),
      ),
    );
  }

  void _showTournamentDetails(BuildContext context, Tournament tournament) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(tournament.name),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${tournament.type == TournamentType.individual ? 'Bireysel' : 'Takım'} Turnuvası',
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text('Durum: ${_getStatusText(tournament.status)}'),
            const SizedBox(height: 8),
            Text('Katılımcılar:'),
            const SizedBox(height: 4),
            ...tournament.participants.map((participant) => 
              Padding(
                padding: const EdgeInsets.only(left: 8),
                child: Text('• ${participant.name}'),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Kapat'),
          ),
          if (tournament.status == TournamentStatus.upcoming)
            TextButton(
              onPressed: () async {
                await ref.read(tournamentsControllerProvider.notifier).startTournament(tournament.id);
                Navigator.pop(context);
              },
              child: const Text('Başlat'),
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