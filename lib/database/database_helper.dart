import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/user_model.dart';
import '../models/zekr_model.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'muslim_fortress.db');
    return await openDatabase(
      path,
      version: 2,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    // جدول المستخدمين
    await db.execute('''
      CREATE TABLE users (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        email TEXT UNIQUE NOT NULL,
        password TEXT NOT NULL,
        profile_image TEXT,
        created_at TEXT
      )
    ''');

    // جدول الأذكار
    await db.execute('''
      CREATE TABLE azkar (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        content TEXT NOT NULL,
        importance INTEGER DEFAULT 3,
        image_path TEXT,
        category TEXT,
        created_at TEXT NOT NULL,
        user_id INTEGER,
        FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE CASCADE
      )
    ''');

    // جدول الإحصائيات
    await db.execute('''
      CREATE TABLE statistics (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        user_id INTEGER,
        date TEXT NOT NULL,
        count INTEGER DEFAULT 0,
        FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE CASCADE
      )
    ''');

    // جدول الأذكار العامة
    await db.execute('''
      CREATE TABLE general_azkar (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        content_ar TEXT NOT NULL,
        content_en TEXT NOT NULL,
        type TEXT NOT NULL,
        count INTEGER DEFAULT 1,
        description TEXT
      )
    ''');

    // إدخال بيانات أولية
    await _insertInitialData(db);
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute('ALTER TABLE azkar ADD COLUMN category TEXT');
    }
  }

  Future<void> _insertInitialData(Database db) async {
    // أذكار الصباح
    await db.insert('general_azkar', {
      'content_ar': 'أصبحنا وأصبح الملك لله، والحمد لله، لا إله إلا الله وحده لا شريك له، له الملك وله الحمد وهو على كل شيء قدير',
      'content_en': 'We have reached the morning and the kingdom belongs to Allah',
      'type': 'morning',
      'count': 1,
      'description': 'مرة واحدة'
    });

    await db.insert('general_azkar', {
      'content_ar': 'اللهم بك أصبحنا، وبك أمسينا، وبك نحيا، وبك نموت، وإليك المصير',
      'content_en': 'O Allah, by You we enter the morning',
      'type': 'morning',
      'count': 1,
      'description': 'مرة واحدة'
    });

    // أذكار المساء
    await db.insert('general_azkar', {
      'content_ar': 'أمسينا وأمسى الملك لله، والحمد لله، لا إله إلا الله وحده لا شريك له',
      'content_en': 'We have reached the evening and the kingdom belongs to Allah',
      'type': 'evening',
      'count': 1,
      'description': 'مرة واحدة'
    });

    await db.insert('general_azkar', {
      'content_ar': 'اللهم بك أمسينا، وبك أصبحنا، وبك نحيا، وبك نموت، وإليك النشور',
      'content_en': 'O Allah, by You we enter the evening',
      'type': 'evening',
      'count': 1,
      'description': 'مرة واحدة'
    });

    // أذكار الصلاة
    await db.insert('general_azkar', {
      'content_ar': 'سبحان الله والحمد لله ولا إله إلا الله والله أكبر',
      'content_en': 'Glory be to Allah, all praise is for Allah',
      'type': 'prayer',
      'count': 33,
      'description': 'ثلاث وثلاثين مرة'
    });
  }

  // ========== User Operations ==========
  Future<int> insertUser(User user) async {
    Database db = await database;
    return await db.insert('users', user.toMap());
  }

  Future<User?> getUserByEmail(String email) async {
    Database db = await database;
    List<Map<String, dynamic>> results = await db.query(
      'users',
      where: 'email = ?',
      whereArgs: [email],
    );

    if (results.isNotEmpty) {
      return User.fromMap(results[0]);
    }
    return null;
  }

  Future<User?> login(String email, String password) async {
    Database db = await database;
    List<Map<String, dynamic>> results = await db.query(
      'users',
      where: 'email = ? AND password = ?',
      whereArgs: [email, password],
    );

    if (results.isNotEmpty) {
      return User.fromMap(results[0]);
    }
    return null;
  }

  // ========== Zekr Operations ==========
  Future<int> insertZekr(Zekr zekr) async {
    Database db = await database;
    try {
      print('🟡 إدراج ذكر في DB...');
      print('📋 البيانات: ${zekr.toMap()}');

      int newId = await db.insert('azkar', zekr.toMap());
      print('✅ تم الإدراج بنجاح، ID الجديد: $newId');

      return newId;
    } catch (e, stackTrace) {
      print('❌ خطأ في insertZekr: $e');
      print('🔍 StackTrace: $stackTrace');
      rethrow;
    }
  }

  Future<int> updateZekr(Zekr zekr) async {
    Database db = await database;
    try {
      print('🟡 تحديث ذكر في DB...');
      print('🔢 ID الذكر: ${zekr.id}');
      print('📋 البيانات: ${zekr.toMap()}');

      int rowsUpdated = await db.update(
        'azkar',
        zekr.toMap(),
        where: 'id = ?',
        whereArgs: [zekr.id],
      );

      print('✅ تم تحديث $rowsUpdated صف');
      return rowsUpdated;
    } catch (e, stackTrace) {
      print('❌ خطأ في updateZekr: $e');
      print('🔍 StackTrace: $stackTrace');
      rethrow;
    }
  }

  Future<Zekr?> getZekrById(int id) async {
    Database db = await database;
    List<Map<String, dynamic>> results = await db.query(
      'azkar',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (results.isNotEmpty) {
      return Zekr.fromMap(results[0]);
    }
    return null;
  }

  Future<List<Zekr>> getAzkarByUser(int userId) async {
    Database db = await database;
    List<Map<String, dynamic>> results = await db.query(
      'azkar',
      where: 'user_id = ?',
      whereArgs: [userId],
      orderBy: 'created_at DESC',
    );

    List<Zekr> azkarList = [];
    for (var row in results) {
      azkarList.add(Zekr.fromMap(row));
    }
    print('📥 تم جلب ${azkarList.length} ذكر للمستخدم $userId');
    return azkarList;
  }

  Future<int> deleteZekr(int id) async {
    Database db = await database;
    return await db.delete('azkar', where: 'id = ?', whereArgs: [id]);
  }

  Future<int> getTodayCount(int userId) async {
    Database db = await database;
    var today = DateTime.now().toIso8601String().split('T')[0];
    List<Map<String, dynamic>> results = await db.rawQuery(
      'SELECT COUNT(*) as count FROM azkar WHERE user_id = ? AND DATE(created_at) = ?',
      [userId, today],
    );

    if (results.isNotEmpty) {
      return results[0]['count'] as int;
    }
    return 0;
  }

  Future<int> getWeeklyCount(int userId) async {
    Database db = await database;
    var weekAgo = DateTime.now().subtract(Duration(days: 7)).toIso8601String();
    List<Map<String, dynamic>> results = await db.rawQuery(
      'SELECT COUNT(*) as count FROM azkar WHERE user_id = ? AND created_at >= ?',
      [userId, weekAgo],
    );

    if (results.isNotEmpty) {
      return results[0]['count'] as int;
    }
    return 0;
  }

  Future<Map<String, dynamic>> getAzkarStatistics(int userId) async {
    Database db = await database;
    List<Map<String, dynamic>> results = await db.rawQuery('''
      SELECT 
        COUNT(*) as total,
        COUNT(CASE WHEN DATE(created_at) = DATE('now') THEN 1 END) as today,
        COUNT(CASE WHEN created_at >= DATETIME('now', '-7 days') THEN 1 END) as weekly,
        COUNT(CASE WHEN created_at >= DATETIME('now', '-30 days') THEN 1 END) as monthly
      FROM azkar 
      WHERE user_id = ?
    ''', [userId]);

    if (results.isNotEmpty) {
      return {
        'total': results[0]['total'] as int,
        'today': results[0]['today'] as int,
        'weekly': results[0]['weekly'] as int,
        'monthly': results[0]['monthly'] as int,
      };
    }

    return {
      'total': 0,
      'today': 0,
      'weekly': 0,
      'monthly': 0,
    };
  }

  // ========== General Azkar ==========
  Future<List<Map<String, dynamic>>> getMorningAzkar() async {
    Database db = await database;
    return await db.query(
      'general_azkar',
      where: 'type = ?',
      whereArgs: ['morning'],
    );
  }

  Future<List<Map<String, dynamic>>> getEveningAzkar() async {
    Database db = await database;
    return await db.query(
      'general_azkar',
      where: 'type = ?',
      whereArgs: ['evening'],
    );
  }

  Future<List<Map<String, dynamic>>> getPrayerAzkar() async {
    Database db = await database;
    return await db.query(
      'general_azkar',
      where: 'type = ?',
      whereArgs: ['prayer'],
    );
  }

  Future close() async {
    Database db = await database;
    db.close();
  }
}