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
    await db.insert('teachers', {
      'name': 'සවනි', //1
      'subject': 'බුද්ධ ධර්මය, නැටුම්, පුස්තකාල',
    });
    await db.insert('teachers', {
      'name': 'ප්‍රියංගි', //2
      'subject': 'බුද්ධ ධර්මය, ඉතිහාසය, පුරවැසි',
    });
    await db.insert('teachers', {'name': 'අයිරාංගනී', 'subject': 'සිංහල'}); //3
    await db.insert('teachers', {'name': 'නවෝදනී', 'subject': 'ඉංග්‍රීසි'}); //4
    await db.insert('teachers', {'name': 'වරාහේන', 'subject': 'ගණිතය'}); //5
    await db.insert('teachers', {'name': 'ජිනදාස', 'subject': 'විද්‍යාව'}); //6
    await db.insert('teachers', {
      'name': 'සදීපා(x)', //7
      'subject': 'භූගෝලය, බුද්ධ ධර්මය, IT',
    });
    await db.insert('teachers', {
      'name': 'වින්ද්‍යා', //8
      'subject': 'ප්‍රා.තා.කු., සංගීතය',
    });
    await db.insert('teachers', {'name': 'සුනේත්‍රා', 'subject': 'චිත්‍ර'}); //9
    await db.insert('teachers', {'name': 'සුදර්ශන(Y)', 'subject': 'දෙමළ'}); //10
    await db.insert('teachers', {'name': 'රාජිකා', 'subject': 'PT'}); //11

    //Teacher 1 - Monday
    await db.insert('timetable', {
      'teacher_id': 1,
      'day': 'Monday',
      'period': 3,
      'grade': '9',
    });
    await db.insert('timetable', {
      'teacher_id': 1,
      'day': 'Monday',
      'period': 4,
      'grade': '6',
    });
    await db.insert('timetable', {
      'teacher_id': 1,
      'day': 'Monday',
      'period': 6,
      'grade': '8',
    });
    await db.insert('timetable', {
      'teacher_id': 1,
      'day': 'Monday',
      'period': 7,
      'grade': '7',
    });
    await db.insert('timetable', {
      'teacher_id': 1,
      'day': 'Monday',
      'period': 8,
      'grade': '10',
    });

    //Teacher 2 - Monday
    await db.insert('timetable', {
      'teacher_id': 2,
      'day': 'Monday',
      'period': 1,
      'grade': '6',
    });
    await db.insert('timetable', {
      'teacher_id': 2,
      'day': 'Monday',
      'period': 2,
      'grade': '7',
    });
    await db.insert('timetable', {
      'teacher_id': 2,
      'day': 'Monday',
      'period': 4,
      'grade': '9',
    });
    await db.insert('timetable', {
      'teacher_id': 2,
      'day': 'Monday',
      'period': 5,
      'grade': '10',
    });
    await db.insert('timetable', {
      'teacher_id': 2,
      'day': 'Monday',
      'period': 6,
      'grade': '11',
    });
    await db.insert('timetable', {
      'teacher_id': 2,
      'day': 'Monday',
      'period': 8,
      'grade': '8',
    });

    //Teacher 3 - Monday
    await db.insert('timetable', {
      'teacher_id': 3,
      'day': 'Monday',
      'period': 1,
      'grade': '10',
    });
    await db.insert('timetable', {
      'teacher_id': 3,
      'day': 'Monday',
      'period': 3,
      'grade': '11',
    });
    await db.insert('timetable', {
      'teacher_id': 3,
      'day': 'Monday',
      'period': 5,
      'grade': '6',
    });
    await db.insert('timetable', {
      'teacher_id': 3,
      'day': 'Monday',
      'period': 6,
      'grade': '9',
    });
    await db.insert('timetable', {
      'teacher_id': 3,
      'day': 'Monday',
      'period': 7,
      'grade': '8',
    });
    await db.insert('timetable', {
      'teacher_id': 3,
      'day': 'Monday',
      'period': 8,
      'grade': '7',
    });

    //Teacher 4 - Monday
    await db.insert('timetable', {
      'teacher_id': 4,
      'day': 'Monday',
      'period': 1,
      'grade': '8',
    });
    await db.insert('timetable', {
      'teacher_id': 4,
      'day': 'Monday',
      'period': 2,
      'grade': '9',
    });
    await db.insert('timetable', {
      'teacher_id': 4,
      'day': 'Monday',
      'period': 4,
      'grade': '7',
    });
    await db.insert('timetable', {
      'teacher_id': 4,
      'day': 'Monday',
      'period': 5,
      'grade': '11',
    });
    await db.insert('timetable', {
      'teacher_id': 4,
      'day': 'Monday',
      'period': 6,
      'grade': '6',
    });
    await db.insert('timetable', {
      'teacher_id': 4,
      'day': 'Monday',
      'period': 7,
      'grade': '10',
    });

    //Teacher 5 - Monday
    await db.insert('timetable', {
      'teacher_id': 5,
      'day': 'Monday',
      'period': 1,
      'grade': '11',
    });
    await db.insert('timetable', {
      'teacher_id': 5,
      'day': 'Monday',
      'period': 5,
      'grade': '11',
    });
    await db.insert('timetable', {
      'teacher_id': 5,
      'day': 'Monday',
      'period': 3,
      'grade': '8',
    });
    await db.insert('timetable', {
      'teacher_id': 5,
      'day': 'Monday',
      'period': 4,
      'grade': '10',
    });
    await db.insert('timetable', {
      'teacher_id': 5,
      'day': 'Monday',
      'period': 5,
      'grade': '7',
    });
    await db.insert('timetable', {
      'teacher_id': 5,
      'day': 'Monday',
      'period': 7,
      'grade': '9',
    });
    await db.insert('timetable', {
      'teacher_id': 5,
      'day': 'Monday',
      'period': 8,
      'grade': '6',
    });

    //Teacher 6 - Monday
    await db.insert('timetable', {
      'teacher_id': 6,
      'day': 'Monday',
      'period': 1,
      'grade': '9',
    });
    await db.insert('timetable', {
      'teacher_id': 6,
      'day': 'Monday',
      'period': 2,
      'grade': '10',
    });
    await db.insert('timetable', {
      'teacher_id': 6,
      'day': 'Monday',
      'period': 3,
      'grade': '10',
    });
    await db.insert('timetable', {
      'teacher_id': 6,
      'day': 'Monday',
      'period': 4,
      'grade': '11',
    });
    await db.insert('timetable', {
      'teacher_id': 6,
      'day': 'Monday',
      'period': 5,
      'grade': '8',
    });
    await db.insert('timetable', {
      'teacher_id': 6,
      'day': 'Monday',
      'period': 6,
      'grade': '7',
    });
    await db.insert('timetable', {
      'teacher_id': 6,
      'day': 'Monday',
      'period': 7,
      'grade': '6',
    });

    //Teacher 7 - Monday
    await db.insert('timetable', {
      'teacher_id': 7,
      'day': 'Monday',
      'period': 6,
      'grade': '11',
    });

    //Teacher 8 - Monday
    await db.insert('timetable', {
      'teacher_id': 8,
      'day': 'Monday',
      'period': 1,
      'grade': '7',
    });
    await db.insert('timetable', {
      'teacher_id': 8,
      'day': 'Monday',
      'period': 2,
      'grade': '8',
    });
    await db.insert('timetable', {
      'teacher_id': 8,
      'day': 'Monday',
      'period': 3,
      'grade': '6',
    });
    await db.insert('timetable', {
      'teacher_id': 8,
      'day': 'Monday',
      'period': 8,
      'grade': '9',
    });

    //Teacher 11 - Monday
    await db.insert('timetable', {
      'teacher_id': 11,
      'day': 'Monday',
      'period': 2,
      'grade': '6',
    });
    await db.insert('timetable', {
      'teacher_id': 11,
      'day': 'Monday',
      'period': 3,
      'grade': '7',
    });
    await db.insert('timetable', {
      'teacher_id': 11,
      'day': 'Monday',
      'period': 4,
      'grade': '8',
    });
    await db.insert('timetable', {
      'teacher_id': 11,
      'day': 'Monday',
      'period': 5,
      'grade': '9',
    });
    await db.insert('timetable', {
      'teacher_id': 11,
      'day': 'Monday',
      'period': 6,
      'grade': '10',
    });
    await db.insert('timetable', {
      'teacher_id': 11,
      'day': 'Monday',
      'period': 7,
      'grade': '11',
    });
    await db.insert('timetable', {
      'teacher_id': 11,
      'day': 'Monday',
      'period': 8,
      'grade': '11',
    });

    //Teacher 1 - Tuesday
    await db.insert('timetable', {
      'teacher_id': 1,
      'day': 'Tuesday',
      'period': 1,
      'grade': '7',
    });
    await db.insert('timetable', {
      'teacher_id': 1,
      'day': 'Tuesday',
      'period': 4,
      'grade': '6',
    });
    await db.insert('timetable', {
      'teacher_id': 1,
      'day': 'Tuesday',
      'period': 5,
      'grade': '7',
    });
    await db.insert('timetable', {
      'teacher_id': 1,
      'day': 'Tuesday',
      'period': 8,
      'grade': '6',
    });

    //Teacher 2 - Tuesday
    await db.insert('timetable', {
      'teacher_id': 2,
      'day': 'Tuesday',
      'period': 2,
      'grade': '11',
    });
    await db.insert('timetable', {
      'teacher_id': 2,
      'day': 'Tuesday',
      'period': 3,
      'grade': '8',
    });
    await db.insert('timetable', {
      'teacher_id': 2,
      'day': 'Tuesday',
      'period': 4,
      'grade': '7',
    });
    await db.insert('timetable', {
      'teacher_id': 2,
      'day': 'Tuesday',
      'period': 5,
      'grade': '10',
    });
    await db.insert('timetable', {
      'teacher_id': 2,
      'day': 'Tuesday',
      'period': 6,
      'grade': '9',
    });
    await db.insert('timetable', {
      'teacher_id': 2,
      'day': 'Tuesday',
      'period': 8,
      'grade': '9',
    });

    //Teacher 3 - Tuesday
    await db.insert('timetable', {
      'teacher_id': 3,
      'day': 'Tuesday',
      'period': 1,
      'grade': '10',
    });
    await db.insert('timetable', {
      'teacher_id': 3,
      'day': 'Tuesday',
      'period': 3,
      'grade': '9',
    });
    await db.insert('timetable', {
      'teacher_id': 3,
      'day': 'Tuesday',
      'period': 5,
      'grade': '11',
    });
    await db.insert('timetable', {
      'teacher_id': 3,
      'day': 'Tuesday',
      'period': 6,
      'grade': '6',
    });
    await db.insert('timetable', {
      'teacher_id': 3,
      'day': 'Tuesday',
      'period': 7,
      'grade': '7',
    });
    await db.insert('timetable', {
      'teacher_id': 3,
      'day': 'Tuesday',
      'period': 8,
      'grade': '8',
    });

    //Teacher 4 - Tuesday
    await db.insert('timetable', {
      'teacher_id': 4,
      'day': 'Tuesday',
      'period': 1,
      'grade': '8',
    });
    await db.insert('timetable', {
      'teacher_id': 4,
      'day': 'Tuesday',
      'period': 8,
      'grade': '7',
    });
    await db.insert('timetable', {
      'teacher_id': 4,
      'day': 'Tuesday',
      'period': 3,
      'grade': '6',
    });
    await db.insert('timetable', {
      'teacher_id': 4,
      'day': 'Tuesday',
      'period': 4,
      'grade': '9',
    });
    await db.insert('timetable', {
      'teacher_id': 4,
      'day': 'Tuesday',
      'period': 6,
      'grade': '11',
    });
    await db.insert('timetable', {
      'teacher_id': 4,
      'day': 'Tuesday',
      'period': 8,
      'grade': '10',
    });

    //Teacher 5 - Tuesday
    await db.insert('timetable', {
      'teacher_id': 5,
      'day': 'Tuesday',
      'period': 1,
      'grade': '11',
    });
    await db.insert('timetable', {
      'teacher_id': 5,
      'day': 'Tuesday',
      'period': 2,
      'grade': '9',
    });
    await db.insert('timetable', {
      'teacher_id': 5,
      'day': 'Tuesday',
      'period': 3,
      'grade': '10',
    });
    await db.insert('timetable', {
      'teacher_id': 5,
      'day': 'Tuesday',
      'period': 4,
      'grade': '10',
    });
    await db.insert('timetable', {
      'teacher_id': 5,
      'day': 'Tuesday',
      'period': 5,
      'grade': '6',
    });
    await db.insert('timetable', {
      'teacher_id': 5,
      'day': 'Tuesday',
      'period': 7,
      'grade': '8',
    });
    await db.insert('timetable', {
      'teacher_id': 5,
      'day': 'Tuesday',
      'period': 8,
      'grade': '7',
    });

    //Teacher 6 - Tuesday
    await db.insert('timetable', {
      'teacher_id': 6,
      'day': 'Tuesday',
      'period': 1,
      'grade': '9',
    });
    await db.insert('timetable', {
      'teacher_id': 6,
      'day': 'Tuesday',
      'period': 2,
      'grade': '10',
    });
    await db.insert('timetable', {
      'teacher_id': 6,
      'day': 'Tuesday',
      'period': 3,
      'grade': '11',
    });
    await db.insert('timetable', {
      'teacher_id': 6,
      'day': 'Tuesday',
      'period': 4,
      'grade': '11',
    });
    await db.insert('timetable', {
      'teacher_id': 6,
      'day': 'Tuesday',
      'period': 5,
      'grade': '8',
    });
    await db.insert('timetable', {
      'teacher_id': 6,
      'day': 'Tuesday',
      'period': 6,
      'grade': '7',
    });
    await db.insert('timetable', {
      'teacher_id': 6,
      'day': 'Tuesday',
      'period': 7,
      'grade': '6',
    });

    //Teacher 7 - Tuesday
    await db.insert('timetable', {
      'teacher_id': 7,
      'day': 'Tuesday',
      'period': 7,
      'grade': '11',
    });

    //Teacher 8 - Tuesday
    await db.insert('timetable', {
      'teacher_id': 8,
      'day': 'Tuesday',
      'period': 1,
      'grade': '6',
    });
    await db.insert('timetable', {
      'teacher_id': 8,
      'day': 'Tuesday',
      'period': 6,
      'grade': '8',
    });
    await db.insert('timetable', {
      'teacher_id': 8,
      'day': 'Tuesday',
      'period': 6,
      'grade': '8',
    });
    await db.insert('timetable', {
      'teacher_id': 8,
      'day': 'Tuesday',
      'period': 7,
      'grade': '9',
    });

    //Teacher 11 - Tuesday
    await db.insert('timetable', {
      'teacher_id': 11,
      'day': 'Tuesday',
      'period': 2,
      'grade': '6',
    });
    await db.insert('timetable', {
      'teacher_id': 11,
      'day': 'Tuesday',
      'period': 3,
      'grade': '7',
    });
    await db.insert('timetable', {
      'teacher_id': 11,
      'day': 'Tuesday',
      'period': 4,
      'grade': '8',
    });
    await db.insert('timetable', {
      'teacher_id': 11,
      'day': 'Tuesday',
      'period': 5,
      'grade': '9',
    });
    await db.insert('timetable', {
      'teacher_id': 11,
      'day': 'Tuesday',
      'period': 6,
      'grade': '10',
    });
    await db.insert('timetable', {
      'teacher_id': 11,
      'day': 'Tuesday',
      'period': 7,
      'grade': '10',
    });
    await db.insert('timetable', {
      'teacher_id': 11,
      'day': 'Tuesday',
      'period': 8,
      'grade': '11',
    });

    //Teacher 1 - Wednesday
    await db.insert('timetable', {
      'teacher_id': 1,
      'day': 'Wednesday',
      'period': 1,
      'grade': '7',
    });
    await db.insert('timetable', {
      'teacher_id': 1,
      'day': 'Wednesday',
      'period': 2,
      'grade': '7',
    });
    await db.insert('timetable', {
      'teacher_id': 1,
      'day': 'Wednesday',
      'period': 5,
      'grade': '6',
    });
    await db.insert('timetable', {
      'teacher_id': 1,
      'day': 'Wednesday',
      'period': 6,
      'grade': '11',
    });
    await db.insert('timetable', {
      'teacher_id': 1,
      'day': 'Wednesday',
      'period': 7,
      'grade': '11',
    });
    await db.insert('timetable', {
      'teacher_id': 1,
      'day': 'Wednesday',
      'period': 8,
      'grade': '9',
    });

    //Teacher 2 - Wednesday
    await db.insert('timetable', {
      'teacher_id': 2,
      'day': 'Wednesday',
      'period': 1,
      'grade': '6',
    });
    await db.insert('timetable', {
      'teacher_id': 2,
      'day': 'Wednesday',
      'period': 2,
      'grade': '8',
    });
    await db.insert('timetable', {
      'teacher_id': 2,
      'day': 'Wednesday',
      'period': 3,
      'grade': '8',
    });
    await db.insert('timetable', {
      'teacher_id': 2,
      'day': 'Wednesday',
      'period': 4,
      'grade': '7',
    });
    await db.insert('timetable', {
      'teacher_id': 2,
      'day': 'Wednesday',
      'period': 5,
      'grade': '10',
    });
    await db.insert('timetable', {
      'teacher_id': 2,
      'day': 'Wednesday',
      'period': 6,
      'grade': '10',
    });
    await db.insert('timetable', {
      'teacher_id': 2,
      'day': 'Wednesday',
      'period': 8,
      'grade': '11',
    });

    //Teacher 3 - Wednesday
    await db.insert('timetable', {
      'teacher_id': 3,
      'day': 'Wednesday',
      'period': 1,
      'grade': '10',
    });
    await db.insert('timetable', {
      'teacher_id': 3,
      'day': 'Wednesday',
      'period': 2,
      'grade': '6',
    });
    await db.insert('timetable', {
      'teacher_id': 3,
      'day': 'Wednesday',
      'period': 3,
      'grade': '11',
    });
    await db.insert('timetable', {
      'teacher_id': 3,
      'day': 'Wednesday',
      'period': 4,
      'grade': '9',
    });
    await db.insert('timetable', {
      'teacher_id': 3,
      'day': 'Wednesday',
      'period': 6,
      'grade': '7',
    });
    await db.insert('timetable', {
      'teacher_id': 3,
      'day': 'Wednesday',
      'period': 7,
      'grade': '8',
    });
    await db.insert('timetable', {
      'teacher_id': 3,
      'day': 'Wednesday',
      'period': 8,
      'grade': '10',
    });

    //Teacher 4 - Wednesday
    await db.insert('timetable', {
      'teacher_id': 4,
      'day': 'Wednesday',
      'period': 2,
      'grade': '9',
    });
    await db.insert('timetable', {
      'teacher_id': 4,
      'day': 'Wednesday',
      'period': 4,
      'grade': '8',
    });
    await db.insert('timetable', {
      'teacher_id': 4,
      'day': 'Wednesday',
      'period': 5,
      'grade': '11',
    });
    await db.insert('timetable', {
      'teacher_id': 4,
      'day': 'Wednesday',
      'period': 6,
      'grade': '6',
    });
    await db.insert('timetable', {
      'teacher_id': 4,
      'day': 'Wednesday',
      'period': 7,
      'grade': '10',
    });
    await db.insert('timetable', {
      'teacher_id': 4,
      'day': 'Wednesday',
      'period': 8,
      'grade': '7',
    });

    //Teacher 5 - Wednesday
    await db.insert('timetable', {
      'teacher_id': 5,
      'day': 'Wednesday',
      'period': 1,
      'grade': '11',
    });
    await db.insert('timetable', {
      'teacher_id': 5,
      'day': 'Wednesday',
      'period': 2,
      'grade': '11',
    });
    await db.insert('timetable', {
      'teacher_id': 5,
      'day': 'Wednesday',
      'period': 3,
      'grade': '9',
    });
    await db.insert('timetable', {
      'teacher_id': 5,
      'day': 'Wednesday',
      'period': 4,
      'grade': '10',
    });
    await db.insert('timetable', {
      'teacher_id': 5,
      'day': 'Wednesday',
      'period': 5,
      'grade': '8',
    });
    await db.insert('timetable', {
      'teacher_id': 5,
      'day': 'Wednesday',
      'period': 7,
      'grade': '7',
    });
    await db.insert('timetable', {
      'teacher_id': 5,
      'day': 'Wednesday',
      'period': 8,
      'grade': '6',
    });

    //Teacher 6 - Wednesday
    await db.insert('timetable', {
      'teacher_id': 6,
      'day': 'Wednesday',
      'period': 1,
      'grade': '9',
    });
    await db.insert('timetable', {
      'teacher_id': 6,
      'day': 'Wednesday',
      'period': 2,
      'grade': '10',
    });
    await db.insert('timetable', {
      'teacher_id': 6,
      'day': 'Wednesday',
      'period': 3,
      'grade': '10',
    });
    await db.insert('timetable', {
      'teacher_id': 6,
      'day': 'Wednesday',
      'period': 4,
      'grade': '11',
    });
    await db.insert('timetable', {
      'teacher_id': 6,
      'day': 'Wednesday',
      'period': 5,
      'grade': '7',
    });
    await db.insert('timetable', {
      'teacher_id': 6,
      'day': 'Wednesday',
      'period': 6,
      'grade': '8',
    });
    await db.insert('timetable', {
      'teacher_id': 6,
      'day': 'Wednesday',
      'period': 7,
      'grade': '6',
    });

    //Teacher 7 - Wednesday
    await db.insert('timetable', {
      'teacher_id': 7,
      'day': 'Wednesday',
      'period': 1,
      'grade': '8',
    });
    await db.insert('timetable', {
      'teacher_id': 7,
      'day': 'Wednesday',
      'period': 2,
      'grade': '6',
    });
    await db.insert('timetable', {
      'teacher_id': 7,
      'day': 'Wednesday',
      'period': 6,
      'grade': '9',
    });
    await db.insert('timetable', {
      'teacher_id': 7,
      'day': 'Wednesday',
      'period': 8,
      'grade': '8',
    });

    //Teacher 8 - Wednesday
    await db.insert('timetable', {
      'teacher_id': 8,
      'day': 'Wednesday',
      'period': 1,
      'grade': '7',
    });
    await db.insert('timetable', {
      'teacher_id': 8,
      'day': 'Wednesday',
      'period': 2,
      'grade': '7',
    });
    await db.insert('timetable', {
      'teacher_id': 8,
      'day': 'Wednesday',
      'period': 4,
      'grade': '6',
    });
    await db.insert('timetable', {
      'teacher_id': 8,
      'day': 'Wednesday',
      'period': 5,
      'grade': '9',
    });
    await db.insert('timetable', {
      'teacher_id': 8,
      'day': 'Wednesday',
      'period': 6,
      'grade': '11',
    });
    await db.insert('timetable', {
      'teacher_id': 8,
      'day': 'Wednesday',
      'period': 7,
      'grade': '11',
    });
    await db.insert('timetable', {
      'teacher_id': 8,
      'day': 'Wednesday',
      'period': 8,
      'grade': '9',
    });

    //Teacher 9 - Wednesday
    await db.insert('timetable', {
      'teacher_id': 9,
      'day': 'Wednesday',
      'period': 1,
      'grade': '7',
    });
    await db.insert('timetable', {
      'teacher_id': 9,
      'day': 'Wednesday',
      'period': 2,
      'grade': '7',
    });
    await db.insert('timetable', {
      'teacher_id': 9,
      'day': 'Wednesday',
      'period': 6,
      'grade': '11',
    });
    await db.insert('timetable', {
      'teacher_id': 9,
      'day': 'Wednesday',
      'period': 7,
      'grade': '11',
    });
    await db.insert('timetable', {
      'teacher_id': 9,
      'day': 'Wednesday',
      'period': 8,
      'grade': '9',
    });

    //Teacher 10 - Wednesday
    await db.insert('timetable', {
      'teacher_id': 10,
      'day': 'Wednesday',
      'period': 3,
      'grade': '7',
    });
    await db.insert('timetable', {
      'teacher_id': 10,
      'day': 'Wednesday',
      'period': 7,
      'grade': '9',
    });

    //Teacher 1 - Thursday
    await db.insert('timetable', {
      'teacher_id': 1,
      'day': 'Thursday',
      'period': 1,
      'grade': '8',
    });
    await db.insert('timetable', {
      'teacher_id': 1,
      'day': 'Thursday',
      'period': 2,
      'grade': '6',
    });
    await db.insert('timetable', {
      'teacher_id': 1,
      'day': 'Thursday',
      'period': 3,
      'grade': '6',
    });
    await db.insert('timetable', {
      'teacher_id': 1,
      'day': 'Thursday',
      'period': 4,
      'grade': '7',
    });
    await db.insert('timetable', {
      'teacher_id': 1,
      'day': 'Thursday',
      'period': 5,
      'grade': '11',
    });
    await db.insert('timetable', {
      'teacher_id': 1,
      'day': 'Thursday',
      'period': 7,
      'grade': '10',
    });
    await db.insert('timetable', {
      'teacher_id': 1,
      'day': 'Thursday',
      'period': 8,
      'grade': '10',
    });

    //Teacher 2 - Thursday
    await db.insert('timetable', {
      'teacher_id': 2,
      'day': 'Thursday',
      'period': 1,
      'grade': '6',
    });
    await db.insert('timetable', {
      'teacher_id': 2,
      'day': 'Thursday',
      'period': 2,
      'grade': '7',
    });
    await db.insert('timetable', {
      'teacher_id': 2,
      'day': 'Thursday',
      'period': 3,
      'grade': '9',
    });
    await db.insert('timetable', {
      'teacher_id': 2,
      'day': 'Thursday',
      'period': 4,
      'grade': '11',
    });
    await db.insert('timetable', {
      'teacher_id': 2,
      'day': 'Thursday',
      'period': 6,
      'grade': '8',
    });
    await db.insert('timetable', {
      'teacher_id': 2,
      'day': 'Thursday',
      'period': 7,
      'grade': '9',
    });
    await db.insert('timetable', {
      'teacher_id': 2,
      'day': 'Thursday',
      'period': 8,
      'grade': '11',
    });

    //Teacher 3 - Thursday
    await db.insert('timetable', {
      'teacher_id': 3,
      'day': 'Thursday',
      'period': 1,
      'grade': '10',
    });
    await db.insert('timetable', {
      'teacher_id': 3,
      'day': 'Thursday',
      'period': 2,
      'grade': '8',
    });
    await db.insert('timetable', {
      'teacher_id': 3,
      'day': 'Thursday',
      'period': 3,
      'grade': '7',
    });
    await db.insert('timetable', {
      'teacher_id': 3,
      'day': 'Thursday',
      'period': 4,
      'grade': '6',
    });
    await db.insert('timetable', {
      'teacher_id': 3,
      'day': 'Thursday',
      'period': 6,
      'grade': '11',
    });
    await db.insert('timetable', {
      'teacher_id': 3,
      'day': 'Thursday',
      'period': 8,
      'grade': '9',
    });

    //Teacher 4 - Thursday
    await db.insert('timetable', {
      'teacher_id': 4,
      'day': 'Thursday',
      'period': 1,
      'grade': '7',
    });
    await db.insert('timetable', {
      'teacher_id': 4,
      'day': 'Thursday',
      'period': 7,
      'grade': '9',
    });
    await db.insert('timetable', {
      'teacher_id': 4,
      'day': 'Thursday',
      'period': 5,
      'grade': '10',
    });
    await db.insert('timetable', {
      'teacher_id': 4,
      'day': 'Thursday',
      'period': 6,
      'grade': '6',
    });
    await db.insert('timetable', {
      'teacher_id': 4,
      'day': 'Thursday',
      'period': 7,
      'grade': '11',
    });
    await db.insert('timetable', {
      'teacher_id': 4,
      'day': 'Thursday',
      'period': 8,
      'grade': '8',
    });

    //Teacher 5 - Thursday
    await db.insert('timetable', {
      'teacher_id': 5,
      'day': 'Thursday',
      'period': 1,
      'grade': '11',
    });
    await db.insert('timetable', {
      'teacher_id': 5,
      'day': 'Thursday',
      'period': 2,
      'grade': '9',
    });
    await db.insert('timetable', {
      'teacher_id': 5,
      'day': 'Thursday',
      'period': 3,
      'grade': '10',
    });
    await db.insert('timetable', {
      'teacher_id': 5,
      'day': 'Thursday',
      'period': 4,
      'grade': '10',
    });
    await db.insert('timetable', {
      'teacher_id': 5,
      'day': 'Thursday',
      'period': 5,
      'grade': '8',
    });
    await db.insert('timetable', {
      'teacher_id': 5,
      'day': 'Thursday',
      'period': 7,
      'grade': '7',
    });
    await db.insert('timetable', {
      'teacher_id': 5,
      'day': 'Thursday',
      'period': 8,
      'grade': '6',
    });

    //Teacher 6 - Thursday
    await db.insert('timetable', {
      'teacher_id': 6,
      'day': 'Thursday',
      'period': 1,
      'grade': '9',
    });
    await db.insert('timetable', {
      'teacher_id': 6,
      'day': 'Thursday',
      'period': 2,
      'grade': '11',
    });
    await db.insert('timetable', {
      'teacher_id': 6,
      'day': 'Thursday',
      'period': 3,
      'grade': '8',
    });
    await db.insert('timetable', {
      'teacher_id': 6,
      'day': 'Thursday',
      'period': 5,
      'grade': '7',
    });
    await db.insert('timetable', {
      'teacher_id': 6,
      'day': 'Thursday',
      'period': 6,
      'grade': '10',
    });
    await db.insert('timetable', {
      'teacher_id': 6,
      'day': 'Thursday',
      'period': 7,
      'grade': '6',
    });

    //Teacher 7 - Thursday
    await db.insert('timetable', {
      'teacher_id': 7,
      'day': 'Thursday',
      'period': 2,
      'grade': '10',
    });
    await db.insert('timetable', {
      'teacher_id': 7,
      'day': 'Thursday',
      'period': 3,
      'grade': '11',
    });
    await db.insert('timetable', {
      'teacher_id': 7,
      'day': 'Thursday',
      'period': 4,
      'grade': '11',
    });
    await db.insert('timetable', {
      'teacher_id': 7,
      'day': 'Thursday',
      'period': 5,
      'grade': '6',
    });
    await db.insert('timetable', {
      'teacher_id': 7,
      'day': 'Thursday',
      'period': 6,
      'grade': '9',
    });
    await db.insert('timetable', {
      'teacher_id': 7,
      'day': 'Thursday',
      'period': 7,
      'grade': '8',
    });
    await db.insert('timetable', {
      'teacher_id': 7,
      'day': 'Thursday',
      'period': 8,
      'grade': '7',
    });

    //Teacher 8 - Thursday
    await db.insert('timetable', {
      'teacher_id': 8,
      'day': 'Thursday',
      'period': 1,
      'grade': '8',
    });
    await db.insert('timetable', {
      'teacher_id': 8,
      'day': 'Thursday',
      'period': 2,
      'grade': '6',
    });
    await db.insert('timetable', {
      'teacher_id': 8,
      'day': 'Thursday',
      'period': 3,
      'grade': '6',
    });
    await db.insert('timetable', {
      'teacher_id': 8,
      'day': 'Thursday',
      'period': 4,
      'grade': '7',
    });
    await db.insert('timetable', {
      'teacher_id': 8,
      'day': 'Thursday',
      'period': 5,
      'grade': '11',
    });
    await db.insert('timetable', {
      'teacher_id': 8,
      'day': 'Thursday',
      'period': 6,
      'grade': '7',
    });
    await db.insert('timetable', {
      'teacher_id': 8,
      'day': 'Thursday',
      'period': 7,
      'grade': '10',
    });
    await db.insert('timetable', {
      'teacher_id': 8,
      'day': 'Thursday',
      'period': 8,
      'grade': '10',
    });

    //Teacher 9 - Thursday
    await db.insert('timetable', {
      'teacher_id': 9,
      'day': 'Thursday',
      'period': 1,
      'grade': '8',
    });
    await db.insert('timetable', {
      'teacher_id': 9,
      'day': 'Thursday',
      'period': 2,
      'grade': '6',
    });
    await db.insert('timetable', {
      'teacher_id': 9,
      'day': 'Thursday',
      'period': 3,
      'grade': '6',
    });
    await db.insert('timetable', {
      'teacher_id': 9,
      'day': 'Thursday',
      'period': 4,
      'grade': '7',
    });
    await db.insert('timetable', {
      'teacher_id': 9,
      'day': 'Thursday',
      'period': 5,
      'grade': '11',
    });
    await db.insert('timetable', {
      'teacher_id': 9,
      'day': 'Thursday',
      'period': 7,
      'grade': '10',
    });
    await db.insert('timetable', {
      'teacher_id': 9,
      'day': 'Thursday',
      'period': 8,
      'grade': '10',
    });

    //Teacher 10 - Thursday
    await db.insert('timetable', {
      'teacher_id': 10,
      'day': 'Thursday',
      'period': 4,
      'grade': '8',
    });
    await db.insert('timetable', {
      'teacher_id': 10,
      'day': 'Thursday',
      'period': 5,
      'grade': '9',
    });

    //Teacher 1 - Friday
    await db.insert('timetable', {
      'teacher_id': 1,
      'day': 'Friday',
      'period': 1,
      'grade': '8',
    });
    await db.insert('timetable', {
      'teacher_id': 1,
      'day': 'Friday',
      'period': 2,
      'grade': '8',
    });
    await db.insert('timetable', {
      'teacher_id': 1,
      'day': 'Friday',
      'period': 3,
      'grade': '6',
    });
    await db.insert('timetable', {
      'teacher_id': 1,
      'day': 'Friday',
      'period': 4,
      'grade': '6',
    });
    await db.insert('timetable', {
      'teacher_id': 1,
      'day': 'Friday',
      'period': 5,
      'grade': '11',
    });
    await db.insert('timetable', {
      'teacher_id': 1,
      'day': 'Friday',
      'period': 6,
      'grade': '10',
    });
    await db.insert('timetable', {
      'teacher_id': 1,
      'day': 'Friday',
      'period': 7,
      'grade': '9',
    });
    await db.insert('timetable', {
      'teacher_id': 1,
      'day': 'Friday',
      'period': 8,
      'grade': '9',
    });

    //Teacher 2 - Friday
    await db.insert('timetable', {
      'teacher_id': 2,
      'day': 'Friday',
      'period': 1,
      'grade': '6',
    });
    await db.insert('timetable', {
      'teacher_id': 2,
      'day': 'Friday',
      'period': 2,
      'grade': '11',
    });
    await db.insert('timetable', {
      'teacher_id': 2,
      'day': 'Friday',
      'period': 3,
      'grade': '10',
    });
    await db.insert('timetable', {
      'teacher_id': 2,
      'day': 'Friday',
      'period': 4,
      'grade': '9',
    });
    await db.insert('timetable', {
      'teacher_id': 2,
      'day': 'Friday',
      'period': 6,
      'grade': '8',
    });
    await db.insert('timetable', {
      'teacher_id': 2,
      'day': 'Friday',
      'period': 7,
      'grade': '11',
    });
    await db.insert('timetable', {
      'teacher_id': 2,
      'day': 'Friday',
      'period': 8,
      'grade': '10',
    });

    //Teacher 3 - Friday
    await db.insert('timetable', {
      'teacher_id': 3,
      'day': 'Friday',
      'period': 1,
      'grade': '10',
    });
    await db.insert('timetable', {
      'teacher_id': 3,
      'day': 'Friday',
      'period': 2,
      'grade': '7',
    });
    await db.insert('timetable', {
      'teacher_id': 3,
      'day': 'Friday',
      'period': 5,
      'grade': '9',
    });
    await db.insert('timetable', {
      'teacher_id': 3,
      'day': 'Friday',
      'period': 6,
      'grade': '11',
    });
    await db.insert('timetable', {
      'teacher_id': 3,
      'day': 'Friday',
      'period': 7,
      'grade': '6',
    });
    await db.insert('timetable', {
      'teacher_id': 3,
      'day': 'Friday',
      'period': 8,
      'grade': '8',
    });

    //Teacher 4 - Friday
    await db.insert('timetable', {
      'teacher_id': 4,
      'day': 'Friday',
      'period': 1,
      'grade': '7',
    });
    await db.insert('timetable', {
      'teacher_id': 4,
      'day': 'Friday',
      'period': 2,
      'grade': '10',
    });
    await db.insert('timetable', {
      'teacher_id': 4,
      'day': 'Friday',
      'period': 3,
      'grade': '9',
    });
    await db.insert('timetable', {
      'teacher_id': 4,
      'day': 'Friday',
      'period': 4,
      'grade': '8',
    });
    await db.insert('timetable', {
      'teacher_id': 4,
      'day': 'Friday',
      'period': 5,
      'grade': '6',
    });
    await db.insert('timetable', {
      'teacher_id': 4,
      'day': 'Friday',
      'period': 8,
      'grade': '11',
    });

    //Teacher 5 - Friday
    await db.insert('timetable', {
      'teacher_id': 5,
      'day': 'Friday',
      'period': 1,
      'grade': '11',
    });
    await db.insert('timetable', {
      'teacher_id': 5,
      'day': 'Friday',
      'period': 2,
      'grade': '9',
    });
    await db.insert('timetable', {
      'teacher_id': 5,
      'day': 'Friday',
      'period': 3,
      'grade': '8',
    });
    await db.insert('timetable', {
      'teacher_id': 5,
      'day': 'Friday',
      'period': 4,
      'grade': '10',
    });
    await db.insert('timetable', {
      'teacher_id': 5,
      'day': 'Friday',
      'period': 6,
      'grade': '6',
    });
    await db.insert('timetable', {
      'teacher_id': 5,
      'day': 'Friday',
      'period': 7,
      'grade': '7',
    });

    //Teacher 6 - Friday
    await db.insert('timetable', {
      'teacher_id': 6,
      'day': 'Friday',
      'period': 1,
      'grade': '9',
    });
    await db.insert('timetable', {
      'teacher_id': 6,
      'day': 'Friday',
      'period': 2,
      'grade': '6',
    });
    await db.insert('timetable', {
      'teacher_id': 6,
      'day': 'Friday',
      'period': 3,
      'grade': '11',
    });
    await db.insert('timetable', {
      'teacher_id': 6,
      'day': 'Friday',
      'period': 4,
      'grade': '11',
    });
    await db.insert('timetable', {
      'teacher_id': 6,
      'day': 'Friday',
      'period': 5,
      'grade': '10',
    });
    await db.insert('timetable', {
      'teacher_id': 6,
      'day': 'Friday',
      'period': 6,
      'grade': '7',
    });
    await db.insert('timetable', {
      'teacher_id': 6,
      'day': 'Friday',
      'period': 7,
      'grade': '8',
    });

    //Teacher 7 - Friday
    await db.insert('timetable', {
      'teacher_id': 7,
      'day': 'Friday',
      'period': 2,
      'grade': '11',
    });
    await db.insert('timetable', {
      'teacher_id': 7,
      'day': 'Friday',
      'period': 3,
      'grade': '7',
    });
    await db.insert('timetable', {
      'teacher_id': 7,
      'day': 'Friday',
      'period': 5,
      'grade': '7',
    });
    await db.insert('timetable', {
      'teacher_id': 7,
      'day': 'Friday',
      'period': 6,
      'grade': '9',
    });
    await db.insert('timetable', {
      'teacher_id': 7,
      'day': 'Friday',
      'period': 7,
      'grade': '10',
    });
    await db.insert('timetable', {
      'teacher_id': 7,
      'day': 'Friday',
      'period': 8,
      'grade': '6',
    });

    //Teacher 8 - Friday
    await db.insert('timetable', {
      'teacher_id': 8,
      'day': 'Friday',
      'period': 1,
      'grade': '8',
    });
    await db.insert('timetable', {
      'teacher_id': 8,
      'day': 'Friday',
      'period': 2,
      'grade': '8',
    });
    await db.insert('timetable', {
      'teacher_id': 8,
      'day': 'Friday',
      'period': 3,
      'grade': '6',
    });
    await db.insert('timetable', {
      'teacher_id': 8,
      'day': 'Friday',
      'period': 4,
      'grade': '7',
    });
    await db.insert('timetable', {
      'teacher_id': 8,
      'day': 'Friday',
      'period': 6,
      'grade': '10',
    });
    await db.insert('timetable', {
      'teacher_id': 8,
      'day': 'Friday',
      'period': 7,
      'grade': '9',
    });
    await db.insert('timetable', {
      'teacher_id': 8,
      'day': 'Friday',
      'period': 8,
      'grade': '9',
    });

    //Teacher 9 - Friday
    await db.insert('timetable', {
      'teacher_id': 9,
      'day': 'Friday',
      'period': 1,
      'grade': '8',
    });
    await db.insert('timetable', {
      'teacher_id': 9,
      'day': 'Friday',
      'period': 2,
      'grade': '8',
    });
    await db.insert('timetable', {
      'teacher_id': 9,
      'day': 'Friday',
      'period': 3,
      'grade': '6',
    });
    await db.insert('timetable', {
      'teacher_id': 9,
      'day': 'Friday',
      'period': 6,
      'grade': '10',
    });
    await db.insert('timetable', {
      'teacher_id': 9,
      'day': 'Friday',
      'period': 7,
      'grade': '9',
    });
    await db.insert('timetable', {
      'teacher_id': 9,
      'day': 'Friday',
      'period': 8,
      'grade': '9',
    });

    //Teacher 10 - Friday
    await db.insert('timetable', {
      'teacher_id': 10,
      'day': 'Friday',
      'period': 5,
      'grade': '8',
    });
    await db.insert('timetable', {
      'teacher_id': 10,
      'day': 'Friday',
      'period': 8,
      'grade': '7',
    });
  }
}
