import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;
  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('school.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE teachers (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        subject TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE timetable (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        teacher_id INTEGER,
        day TEXT,
        period INTEGER,
        grade TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE attendance (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        teacher_id INTEGER,
        date TEXT,
        is_present INTEGER,
        UNIQUE(teacher_id, date)
      )
    ''');

    await db.execute('''
      CREATE TABLE substitutions (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        date TEXT,
        day TEXT,
        period INTEGER,
        grade TEXT,
        absent_teacher_id INTEGER,
        substitute_teacher_id INTEGER
      )
    ''');

    // Insert sample data
    await db.insert('teachers', {'name': 'Mr. Saman', 'subject': 'Math'});
    await db.insert('teachers', {'name': 'Ms. Kumari', 'subject': 'Science'});
    await db.insert('teachers', {'name': 'Mr. Nimal', 'subject': 'English'});
    await db.insert('teachers', {'name': 'Ms. Tharushi', 'subject': 'History'});

    await db.insert('timetable', {
      'teacher_id': 1,
      'day': 'Sunday',
      'period': 1,
      'grade': '9',
    });
    await db.insert('timetable', {
      'teacher_id': 2,
      'day': 'Sunday',
      'period': 2,
      'grade': '9',
    });
    await db.insert('timetable', {
      'teacher_id': 3,
      'day': 'Sunday',
      'period': 3,
      'grade': '9',
    });
    await db.insert('timetable', {
      'teacher_id': 4,
      'day': 'Sunday',
      'period': 4,
      'grade': '9',
    });

    //10
    await db.insert('timetable', {
      'teacher_id': 1,
      'day': 'Sunday',
      'period': 5,
      'grade': '10',
    });
    await db.insert('timetable', {
      'teacher_id': 2,
      'day': 'Sunday',
      'period': 6,
      'grade': '10',
    });
    await db.insert('timetable', {
      'teacher_id': 3,
      'day': 'Sunday',
      'period': 7,
      'grade': '10',
    });
    await db.insert('timetable', {
      'teacher_id': 4,
      'day': 'Sunday',
      'period': 8,
      'grade': '10',
    });
  }
}
