import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:adisyonapp/features/game/domain/entities/game.dart';
import 'package:adisyonapp/features/game/domain/entities/player.dart';

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
      version: 1,
      onCreate: _onCreate,
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
        createdAt TEXT
      )
    ''');

    // Oyuncu tablosu
    await db.execute('''
      CREATE TABLE players(
        id TEXT PRIMARY KEY,
        gameId TEXT,
        name TEXT,
        totalScore INTEGER,
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
    final List<Map<String, dynamic>> gameMaps = await db.query('games');
    
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
} 