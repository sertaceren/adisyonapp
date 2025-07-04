import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:adisyonapp/shared/widgets/base_screen.dart';
import 'package:adisyonapp/shared/widgets/app_button.dart';
import 'package:adisyonapp/features/tournament/presentation/controllers/tournament_controller.dart';
import 'package:adisyonapp/features/tournament/domain/entities/tournament.dart';
import 'package:adisyonapp/features/game/domain/entities/player.dart';
import 'package:adisyonapp/features/settings/presentation/controllers/players_controller.dart';

class TournamentSetupPage extends ConsumerStatefulWidget {
  final Tournament? tournament;
  
  const TournamentSetupPage({super.key, this.tournament});

  @override
  ConsumerState<TournamentSetupPage> createState() => _TournamentSetupPageState();
}

class _TournamentSetupPageState extends ConsumerState<TournamentSetupPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  TournamentType _selectedType = TournamentType.individual;
  final List<SavedPlayer> _selectedParticipants = [];
  final List<TextEditingController> _participantControllers = [];

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  void _initializeData() {
    if (widget.tournament != null) {
      // Düzenleme modu
      _nameController.text = widget.tournament!.name;
      _selectedType = widget.tournament!.type;
      
      // Mevcut controller'ları temizle
      for (var controller in _participantControllers) {
        controller.dispose();
      }
      _participantControllers.clear();
      
      // Beklenen sayıda controller oluştur
      final expectedCount = _selectedType == TournamentType.individual ? 4 : 2;
      for (int i = 0; i < expectedCount; i++) {
        if (i < widget.tournament!.participants.length) {
          _participantControllers.add(TextEditingController(text: widget.tournament!.participants[i].name));
        } else {
          _participantControllers.add(TextEditingController());
        }
      }
    } else {
      // Yeni turnuva modu
      _updateParticipantFields();
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    for (var controller in _participantControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _updateParticipantFields() {
    final targetCount = _selectedType == TournamentType.individual ? 4 : 2;
    
    setState(() {
      // Mevcut controller'ları temizle
      for (var controller in _participantControllers) {
        controller.dispose();
      }
      _participantControllers.clear();
      
      // Yeni sayıda controller ekle
      for (int i = 0; i < targetCount; i++) {
        _participantControllers.add(TextEditingController());
      }
    });
  }

  void _saveTournament() {
    if (_formKey.currentState!.validate()) {
      final participants = <SavedPlayer>[];
      
      for (int i = 0; i < _participantControllers.length; i++) {
        final name = _participantControllers[i].text.trim();
        if (name.isNotEmpty) {
          participants.add(SavedPlayer(
            id: 'temp_$i',
            name: name,
            createdAt: DateTime.now().toIso8601String(),
          ));
        }
      }

      if (participants.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('En az bir katılımcı eklemelisiniz')),
        );
        return;
      }

      if (widget.tournament != null) {
        // Düzenleme modu
        final updatedTournament = widget.tournament!.copyWith(
          name: _nameController.text.trim(),
          type: _selectedType,
          participants: participants,
        );
        ref.read(tournamentsControllerProvider.notifier).updateTournament(updatedTournament);
      } else {
        // Yeni turnuva modu
        ref.read(tournamentsControllerProvider.notifier).addTournament(
          name: _nameController.text.trim(),
          type: _selectedType,
          participants: participants,
        );
      }

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final savedPlayersAsync = ref.watch(playersControllerProvider);

    return BaseScreen(
      title: widget.tournament != null ? 'Turnuva Düzenle' : 'Turnuva Oluştur',
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Turnuva Bilgileri',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _nameController,
                      decoration: const InputDecoration(
                        labelText: 'Turnuva Adı',
                        hintText: 'Örn: Bahar Turnuvası',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Turnuva adı gerekli';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Turnuva Türü',
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: RadioListTile<TournamentType>(
                            title: const Text('Bireysel'),
                            value: TournamentType.individual,
                            groupValue: _selectedType,
                            onChanged: widget.tournament != null ? null : (value) {
                              setState(() {
                                _selectedType = value!;
                              });
                              _updateParticipantFields();
                            },
                          ),
                        ),
                        Expanded(
                          child: RadioListTile<TournamentType>(
                            title: const Text('Takım'),
                            value: TournamentType.team,
                            groupValue: _selectedType,
                            onChanged: widget.tournament != null ? null : (value) {
                              setState(() {
                                _selectedType = value!;
                              });
                              _updateParticipantFields();
                            },
                          ),
                        ),
                      ],
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
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Katılımcılar',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                        ),
                        Text(
                          _selectedType == TournamentType.individual ? '4 Kişi' : '2 Takım',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: Theme.of(context).colorScheme.primary,
                                fontWeight: FontWeight.w500,
                              ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Kayıtlı oyuncuları seçebilir veya yeni isimler girebilirsiniz',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                    ),
                    const SizedBox(height: 16),
                    savedPlayersAsync.when(
                      initial: () => const Center(child: CircularProgressIndicator()),
                      loading: () => const Center(child: CircularProgressIndicator()),
                      success: (savedPlayers) {
                        return Column(
                          children: List.generate(_participantControllers.length, (index) {
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Autocomplete<String>(
                                      optionsBuilder: (TextEditingValue textEditingValue) {
                                        if (textEditingValue.text.isEmpty) {
                                          return savedPlayers.map((player) => player.name).toList();
                                        }
                                        return savedPlayers
                                            .where((player) => player.name
                                                .toLowerCase()
                                                .contains(textEditingValue.text.toLowerCase()))
                                            .map((player) => player.name)
                                            .toList();
                                      },
                                      onSelected: (String selection) {
                                        _participantControllers[index].text = selection;
                                      },
                                      fieldViewBuilder: (context, controller, focusNode, onFieldSubmitted) {
                                        // Controller'ı senkronize et
                                        if (controller.text != _participantControllers[index].text) {
                                          controller.text = _participantControllers[index].text;
                                          controller.selection = TextSelection.fromPosition(
                                            TextPosition(offset: controller.text.length),
                                          );
                                        }
                                        return TextFormField(
                                          controller: controller,
                                          focusNode: focusNode,
                                          decoration: InputDecoration(
                                            labelText: 'Katılımcı ${index + 1}',
                                            hintText: 'İsim girin veya seçin',
                                            border: const OutlineInputBorder(),
                                          ),
                                          validator: (value) {
                                            if (value == null || value.trim().isEmpty) {
                                              return 'Katılımcı adı gerekli';
                                            }
                                            return null;
                                          },
                                          onChanged: (value) {
                                            _participantControllers[index].text = value;
                                          },
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }),
                        );
                      },
                      error: (error) => Text('Hata: ${error.message}'),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            AppButton(
              text: widget.tournament != null ? 'Turnuvayı Güncelle' : 'Turnuva Oluştur',
              onPressed: _saveTournament,
              icon: widget.tournament != null ? Icons.save : Icons.save,
            ),
          ],
        ),
      ),
    );
  }
} 