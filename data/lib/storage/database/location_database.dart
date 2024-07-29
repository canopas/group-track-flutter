import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class LocationDatabaseHelper {
  static const tableName = 'location_table_database';
  Database? _database;

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }
    _database = await initDataBase();
    return _database!;
  }

  Future<Database> initDataBase() async {
    String path = join(await getDatabasesPath(), 'database');
    return await openDatabase(path, version: 1, onCreate: (db, version) {
      return db.execute('''
        CREATE TABLE $tableName(
          userId TEXT PRIMARY KEY,
          lastFiveMinutesLocations TEXT,
          lastLocationJourney TEXT
       )
      ''');
    });
  }
}
