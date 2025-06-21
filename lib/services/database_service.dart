import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/medicine.dart';

class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal();
  factory DatabaseService() => _instance;
  DatabaseService._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('farmacias_el_sol.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE medicines (
        id TEXT PRIMARY KEY,
        nombre TEXT NOT NULL,
        principioActivo TEXT NOT NULL,
        requiereReceta INTEGER NOT NULL
      )
    ''');
  }

  Future<void> insertMedicine(Medicine medicine) async {
    final db = await database;
    await db.insert(
      'medicines',
      medicine.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Medicine>> getMedicines() async {
    final db = await database;
    final maps = await db.query('medicines');

    if (maps.isEmpty) return [];

    return List.generate(maps.length, (i) {
      return Medicine.fromMap(maps[i]);
    });
  }

  Future<void> updateMedicine(Medicine medicine) async {
    final db = await database;
    await db.update(
      'medicines',
      medicine.toMap(),
      where: 'id = ?',
      whereArgs: [medicine.id],
    );
  }

  Future<void> deleteMedicine(String id) async {
    final db = await database;
    await db.delete(
      'medicines',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
