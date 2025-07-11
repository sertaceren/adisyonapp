import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:adisyonapp/features/game/domain/entities/game.dart';
import 'package:adisyonapp/features/game/domain/entities/player.dart';
import 'package:adisyonapp/features/tournament/domain/entities/tournament.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  factory DatabaseHelper() => _instance;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'game_history.db');
    return await openDatabase(
      path,
      version: 7,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    // Oyun tablosu
    await db.execute('''
      CREATE TABLE games(
        id TEXT PRIMARY KEY,
        name TEXT,
        mode TEXT,
        totalRounds INTEGER,
        currentRound INTEGER,
        status TEXT,
        winnerId TEXT,
        createdAt TEXT,
        currentDealerIndex INTEGER DEFAULT 0,
        tournamentId TEXT
      )
    ''');

    // Oyuncu tablosu
    await db.execute('''
      CREATE TABLE players(
        id TEXT PRIMARY KEY,
        gameId TEXT,
        name TEXT,
        totalScore INTEGER,
        isDealer INTEGER DEFAULT 0,
        FOREIGN KEY (gameId) REFERENCES games (id)
      )
    ''');

    // Skor tablosu
    await db.execute('''
      CREATE TABLE scores(
        id TEXT PRIMARY KEY,
        playerId TEXT,
        gameId TEXT,
        value INTEGER,
        roundNumber INTEGER,
        createdAt TEXT,
        FOREIGN KEY (playerId) REFERENCES players (id),
        FOREIGN KEY (gameId) REFERENCES games (id)
      )
    ''');

    // Kayıtlı oyuncular tablosu
    await db.execute('''
      CREATE TABLE saved_players(
        id TEXT PRIMARY KEY,
        name TEXT,
        isActive INTEGER DEFAULT 1,
        createdAt TEXT
      )
    ''');

    // Turnuva tablosu
    await db.execute('''
      CREATE TABLE tournaments(
        id TEXT PRIMARY KEY,
        name TEXT,
        type TEXT,
        status TEXT,
        createdAt TEXT,
        updatedAt TEXT
      )
    ''');

    // Turnuva katılımcıları tablosu
    await db.execute('''
      CREATE TABLE tournament_participants(
        id TEXT PRIMARY KEY,
        tournamentId TEXT,
        name TEXT,
        createdAt TEXT,
        FOREIGN KEY (tournamentId) REFERENCES tournaments (id)
      )
    ''');

    // Turnuva puanları tablosu
    await db.execute('''
      CREATE TABLE tournament_scores(
        id TEXT PRIMARY KEY,
        tournamentId TEXT,
        playerName TEXT,
        totalPoints INTEGER DEFAULT 0,
        gamesPlayed INTEGER DEFAULT 0,
        firstPlaceCount INTEGER DEFAULT 0,
        secondPlaceCount INTEGER DEFAULT 0,
        thirdPlaceCount INTEGER DEFAULT 0,
        createdAt TEXT,
        FOREIGN KEY (tournamentId) REFERENCES tournaments (id)
      )
    ''');
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      // Yeni sütunları ekle
      await db.execute('ALTER TABLE games ADD COLUMN currentDealerIndex INTEGER DEFAULT 0');
      await db.execute('ALTER TABLE players ADD COLUMN isDealer INTEGER DEFAULT 0');
    }
    
    if (oldVersion < 3) {
      // Kayıtlı oyuncular tablosunu ekle
      await db.execute('''
        CREATE TABLE saved_players(
          id TEXT PRIMARY KEY,
          name TEXT,
          isActive INTEGER DEFAULT 1,
          createdAt TEXT
        )
      ''');
    }

    if (oldVersion < 4) {
      // Turnuva tablolarını ekle
      await db.execute('''
        CREATE TABLE tournaments(
          id TEXT PRIMARY KEY,
          name TEXT,
          type TEXT,
          status TEXT,
          createdAt TEXT,
          updatedAt TEXT
        )
      ''');

      await db.execute('''
        CREATE TABLE tournament_participants(
          id TEXT PRIMARY KEY,
          tournamentId TEXT,
          name TEXT,
          createdAt TEXT,
          FOREIGN KEY (tournamentId) REFERENCES tournaments (id)
        )
      ''');
    }

    if (oldVersion < 5) {
      // Games tablosuna tournamentId sütunu ekle
      await db.execute('ALTER TABLE games ADD COLUMN tournamentId TEXT');
    }

    if (oldVersion < 6) {
      // Turnuva puanları tablosunu ekle
      await db.execute('''
        CREATE TABLE tournament_scores(
          id TEXT PRIMARY KEY,
          tournamentId TEXT,
          playerName TEXT,
          totalPoints INTEGER DEFAULT 0,
          gamesPlayed INTEGER DEFAULT 0,
          firstPlaceCount INTEGER DEFAULT 0,
          secondPlaceCount INTEGER DEFAULT 0,
          thirdPlaceCount INTEGER DEFAULT 0,
          createdAt TEXT,
          FOREIGN KEY (tournamentId) REFERENCES tournaments (id)
        )
      ''');
    }

    if (oldVersion < 7) {
      // Turnuva tablosuna başlangıç ve bitiş tarihleri sütunlarını ekle
      await db.execute('ALTER TABLE tournaments ADD COLUMN startedAt TEXT DEFAULT ""');
      await db.execute('ALTER TABLE tournaments ADD COLUMN completedAt TEXT DEFAULT ""');
    }
  }

  Future<void> saveGame(Game game) async {
    final db = await database;
    await db.transaction((txn) async {
      // Oyunu kaydet
      await txn.insert(
        'games',
        {
          'id': game.id,
          'name': game.name,
          'mode': game.mode.toString(),
          'totalRounds': game.totalRounds,
          'currentRound': game.currentRound,
          'status': game.status.toString(),
          'winnerId': game.winnerId,
          'createdAt': DateTime.now().toIso8601String(),
          'currentDealerIndex': game.currentDealerIndex,
          'tournamentId': game.tournamentId,
        },
        conflictAlgorithm: ConflictAlgorithm.replace,
      );

      // Oyuncuları kaydet
      for (var player in game.players) {
        await txn.insert(
          'players',
          {
            'id': player.id,
            'gameId': game.id,
            'name': player.name,
            'totalScore': player.totalScore,
            'isDealer': player.isDealer ? 1 : 0,
          },
          conflictAlgorithm: ConflictAlgorithm.replace,
        );

        // Skorları kaydet
        for (int i = 0; i < player.roundScores.length; i++) {
          await txn.insert(
            'scores',
            {
              'id': '${player.id}_${i + 1}',
              'playerId': player.id,
              'gameId': game.id,
              'value': player.roundScores[i],
              'roundNumber': i + 1,
              'createdAt': DateTime.now().toIso8601String(),
            },
            conflictAlgorithm: ConflictAlgorithm.replace,
          );
        }
      }
    });
  }

  Future<List<Game>> getAllGames() async {
    final db = await database;
    final List<Map<String, dynamic>> gameMaps = await db.query(
      'games',
      orderBy: 'createdAt DESC',
    );
    
    return Future.wait(gameMaps.map((gameMap) async {
      final List<Map<String, dynamic>> playerMaps = await db.query(
        'players',
        where: 'gameId = ?',
        whereArgs: [gameMap['id']],
      );

      final players = await Future.wait(playerMaps.map((playerMap) async {
        final List<Map<String, dynamic>> scoreMaps = await db.query(
          'scores',
          where: 'playerId = ?',
          whereArgs: [playerMap['id']],
          orderBy: 'roundNumber ASC',
        );

        final roundScores = scoreMaps.map((score) => score['value'] as int).toList();

        return Player(
          id: playerMap['id'],
          name: playerMap['name'],
          totalScore: playerMap['totalScore'],
          roundScores: roundScores,
          isDealer: (playerMap['isDealer'] as int?) == 1,
        );
      }));

      return Game(
        id: gameMap['id'],
        name: gameMap['name'],
        mode: GameMode.values.firstWhere(
          (e) => e.toString() == gameMap['mode'],
        ),
        totalRounds: gameMap['totalRounds'],
        currentRound: gameMap['currentRound'],
        status: GameStatus.values.firstWhere(
          (e) => e.toString() == gameMap['status'],
        ),
        winnerId: gameMap['winnerId'],
        players: players,
        createdAt: gameMap['createdAt'] as String? ?? DateTime.now().toIso8601String(),
        currentDealerIndex: gameMap['currentDealerIndex'] as int? ?? 0,
        tournamentId: gameMap['tournamentId'],
      );
    }));
  }

  Future<void> deleteGame(String gameId) async {
    final db = await database;
    await db.transaction((txn) async {
      await txn.delete(
        'scores',
        where: 'gameId = ?',
        whereArgs: [gameId],
      );
      await txn.delete(
        'players',
        where: 'gameId = ?',
        whereArgs: [gameId],
      );
      await txn.delete(
        'games',
        where: 'id = ?',
        whereArgs: [gameId],
      );
    });
  }

  // Kayıtlı oyuncular için metodlar
  Future<void> saveSavedPlayer(SavedPlayer player) async {
    final db = await database;
    await db.insert(
      'saved_players',
      {
        'id': player.id,
        'name': player.name,
        'isActive': player.isActive ? 1 : 0,
        'createdAt': player.createdAt,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<SavedPlayer>> getAllSavedPlayers() async {
    final db = await database;
    final List<Map<String, dynamic>> playerMaps = await db.query(
      'saved_players',
      orderBy: 'name ASC',
    );

    return playerMaps.map((playerMap) => SavedPlayer(
      id: playerMap['id'],
      name: playerMap['name'],
      isActive: (playerMap['isActive'] as int?) == 1,
      createdAt: playerMap['createdAt'] as String? ?? DateTime.now().toIso8601String(),
    )).toList();
  }

  Future<void> deleteSavedPlayer(String playerId) async {
    final db = await database;
    await db.delete(
      'saved_players',
      where: 'id = ?',
      whereArgs: [playerId],
    );
  }

  // Turnuva metodları
  Future<void> saveTournament(Tournament tournament) async {
    final db = await database;
    await db.transaction((txn) async {
      // Turnuvayı kaydet
      await txn.insert(
        'tournaments',
        {
          'id': tournament.id,
          'name': tournament.name,
          'type': tournament.type.toString(),
          'status': tournament.status.toString(),
          'createdAt': tournament.createdAt,
          'updatedAt': tournament.updatedAt,
          'startedAt': tournament.startedAt,
          'completedAt': tournament.completedAt,
        },
        conflictAlgorithm: ConflictAlgorithm.replace,
      );

      // Önce eski katılımcıları sil
      await txn.delete(
        'tournament_participants',
        where: 'tournamentId = ?',
        whereArgs: [tournament.id],
      );

      // Yeni katılımcıları kaydet
      for (var participant in tournament.participants) {
        await txn.insert(
          'tournament_participants',
          {
            'id': '${tournament.id}_${participant.id}',
            'tournamentId': tournament.id,
            'name': participant.name,
            'createdAt': participant.createdAt,
          },
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      }
    });
  }

  Future<List<Tournament>> getAllTournaments() async {
    final db = await database;
    final List<Map<String, dynamic>> tournamentMaps = await db.query(
      'tournaments',
      orderBy: 'createdAt DESC',
    );
    
    return Future.wait(tournamentMaps.map((tournamentMap) async {
      final List<Map<String, dynamic>> participantMaps = await db.query(
        'tournament_participants',
        where: 'tournamentId = ?',
        whereArgs: [tournamentMap['id']],
      );

      final participants = participantMaps.map((participantMap) => SavedPlayer(
        id: participantMap['id'],
        name: participantMap['name'],
        createdAt: participantMap['createdAt'] as String? ?? DateTime.now().toIso8601String(),
      )).toList();

      return Tournament(
        id: tournamentMap['id'],
        name: tournamentMap['name'],
        type: TournamentType.values.firstWhere(
          (e) => e.toString() == tournamentMap['type'],
        ),
        status: TournamentStatus.values.firstWhere(
          (e) => e.toString() == tournamentMap['status'],
        ),
        participants: participants,
        createdAt: tournamentMap['createdAt'] as String? ?? DateTime.now().toIso8601String(),
        updatedAt: tournamentMap['updatedAt'] as String? ?? DateTime.now().toIso8601String(),
        startedAt: tournamentMap['startedAt'] as String? ?? '',
        completedAt: tournamentMap['completedAt'] as String? ?? '',
      );
    }));
  }

  Future<void> deleteTournament(String tournamentId) async {
    final db = await database;
    await db.transaction((txn) async {
      await txn.delete(
        'tournament_participants',
        where: 'tournamentId = ?',
        whereArgs: [tournamentId],
      );
      await txn.delete(
        'tournament_scores',
        where: 'tournamentId = ?',
        whereArgs: [tournamentId],
      );
      await txn.delete(
        'tournaments',
        where: 'id = ?',
        whereArgs: [tournamentId],
      );
    });
  }

  // Turnuva puanları metodları
  Future<void> saveTournamentScore(TournamentScore score) async {
    final db = await database;
    await db.insert(
      'tournament_scores',
      {
        'id': score.id,
        'tournamentId': score.tournamentId,
        'playerName': score.playerName,
        'totalPoints': score.totalPoints,
        'gamesPlayed': score.gamesPlayed,
        'firstPlaceCount': score.firstPlaceCount,
        'secondPlaceCount': score.secondPlaceCount,
        'thirdPlaceCount': score.thirdPlaceCount,
        'createdAt': score.createdAt,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<TournamentScore>> getTournamentScores(String tournamentId) async {
    final db = await database;
    final List<Map<String, dynamic>> scoreMaps = await db.query(
      'tournament_scores',
      where: 'tournamentId = ?',
      whereArgs: [tournamentId],
      orderBy: 'totalPoints DESC, firstPlaceCount DESC, secondPlaceCount DESC',
    );

    return scoreMaps.map((scoreMap) => TournamentScore(
      id: scoreMap['id'],
      tournamentId: scoreMap['tournamentId'],
      playerName: scoreMap['playerName'],
      totalPoints: scoreMap['totalPoints'] as int? ?? 0,
      gamesPlayed: scoreMap['gamesPlayed'] as int? ?? 0,
      firstPlaceCount: scoreMap['firstPlaceCount'] as int? ?? 0,
      secondPlaceCount: scoreMap['secondPlaceCount'] as int? ?? 0,
      thirdPlaceCount: scoreMap['thirdPlaceCount'] as int? ?? 0,
      createdAt: scoreMap['createdAt'] as String? ?? DateTime.now().toIso8601String(),
    )).toList();
  }

  Future<void> updateTournamentScores(String tournamentId, Game game) async {
    if (game.tournamentId != tournamentId || game.status != GameStatus.completed) {
      return;
    }

    // Oyuncuları puanına göre sırala (küçükten büyüğe)
    final sortedPlayers = [...game.players]..sort((a, b) => a.totalScore.compareTo(b.totalScore));
    
    // Puanları hesapla: 1. 5 puan, 2. 3 puan, 3. 1 puan
    final points = [5, 3, 1];
    
    for (int i = 0; i < sortedPlayers.length; i++) {
      final player = sortedPlayers[i];
      final earnedPoints = i < points.length ? points[i] : 0;
      
      // Mevcut skoru al veya yeni oluştur
      final existingScores = await getTournamentScores(tournamentId);
      final existingScore = existingScores.firstWhere(
        (score) => score.playerName == player.name,
        orElse: () => TournamentScore(
          id: '${tournamentId}_${player.name}',
          tournamentId: tournamentId,
          playerName: player.name,
        ),
      );

      // Yeni skoru hesapla
      final newTotalPoints = existingScore.totalPoints + earnedPoints;
      final newGamesPlayed = existingScore.gamesPlayed + 1;
      
      // Sıralama sayılarını güncelle
      int newFirstPlaceCount = existingScore.firstPlaceCount;
      int newSecondPlaceCount = existingScore.secondPlaceCount;
      int newThirdPlaceCount = existingScore.thirdPlaceCount;
      
      if (i == 0) newFirstPlaceCount++;
      else if (i == 1) newSecondPlaceCount++;
      else if (i == 2) newThirdPlaceCount++;

      final updatedScore = existingScore.copyWith(
        totalPoints: newTotalPoints,
        gamesPlayed: newGamesPlayed,
        firstPlaceCount: newFirstPlaceCount,
        secondPlaceCount: newSecondPlaceCount,
        thirdPlaceCount: newThirdPlaceCount,
      );

      await saveTournamentScore(updatedScore);
    }
  }
} 