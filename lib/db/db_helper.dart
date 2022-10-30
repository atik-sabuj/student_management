
import 'package:student_management/utils/utils.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as Path;

import '../models/features_favorite.dart';
import '../models/features_model.dart';
import '../models/features_rating.dart';
import '../models/user_model.dart';


class DbHelper {
  static const String createTableFeatures = '''create table $tableFeatures(
  $tblFeaturesColId integer primary key autoincrement,
  $tblFeaturesColName text,
  $tblFeaturesColDetails text,
  $tblFeaturesColType text,
  $tblFeaturesColImage text,
  $tblFeaturesColAdmission text,
  $tblFeaturesColCourse integer)''';

  static const String createTableUser = '''create table $tableUser(
  $tblUserColId integer primary key autoincrement,
  $tblUserColEmail text,
  $tblUserColPassword text,
  $tblUserColAdmin integer)''';

  static const String createTableRating = '''create table $tableRating(
  $tblRatingColFeaturesId integer,
  $tblRatingColUserId integer,
  $tblRatingColDate text,
  $tblRatingColUserReviews text,
  $tblColRating real)''';

  static const String createTableFavorite = '''create table $tableFavorite(
  $tblFavColFeaturesId integer,
  $tblFavColUserId integer,
  $tblFavColFavorite integer)''';


  static Future<Database> open() async {

    final rootPath = await getDatabasesPath();
    final dbPath = Path.join(rootPath, 'features_db');

    return openDatabase(dbPath, version: 2, onCreate: (db, version) async {
      await db.execute(createTableFeatures);
      await db.execute(createTableUser);
      await db.execute(createTableRating);
      await db.execute(createTableFavorite);
    }, onUpgrade: (db, oldVersion, newVersion) async {
      if(newVersion == 2) {
        db.execute('alter table $tableUser add column $tblUserColAdmin integer');
      }
    });
  }

  static Future<int> insertFeatures(FeaturesModel featuresModel) async {
    final db = await open();
    return db.insert(tableFeatures, featuresModel.toMap());
  }

  static Future<int> insertUser(UserModel userModel) async {
    final db = await open();
    return db.insert(tableUser, userModel.toMap());
  }

  static Future<int> insertRating(FeaturesRating featuresRating) async {
    final db = await open();
    return db.insert(tableRating, featuresRating.toMap());
  }

  static Future<int> insertFavorite(FeaturesFavorite featuresFavorite) async {
    final db = await open();
    return db.insert(tableFavorite, featuresFavorite.toMap());
  }

  static Future<int> updateFeatures(FeaturesModel featuresModel) async {
    final db = await open();
    return db.update(tableFeatures, featuresModel.toMap(),
      where: '$tblFeaturesColId = ?', whereArgs: [featuresModel.id],);
  }

  static Future<int> updateRating(FeaturesRating featuresRating) async {
    final db = await open();
    return db.update(tableRating, featuresRating.toMap(),
        where: '$tblRatingColFeaturesId = ? and $tblRatingColUserId = ?',
        whereArgs: [featuresRating.features_id, featuresRating.user_id]);
  }

  static Future<List<FeaturesModel>> getAllFeatures() async {
    final db = await open();
    final mapList = await db.query(tableFeatures);
    return List.generate(mapList.length, (index) =>
        FeaturesModel.fromMap(mapList[index]));
  }

  static Future<FeaturesModel> getFeaturesById(int id) async {
    final db = await open();
    final mapList = await db.query(tableFeatures,
      where: '$tblFeaturesColId = ?', whereArgs: [id],);
    return FeaturesModel.fromMap(mapList.first);
  }

  static Future<bool> didUserRate(int featuresId, int userId) async {
    final db = await open();
    final mapList = await db.query(tableRating,
        where: '$tblRatingColFeaturesId = ? and $tblRatingColUserId = ?',
        whereArgs: [featuresId, userId]);
    return mapList.isNotEmpty;
  }

  static Future<UserModel?> getUserByEmail(String email) async {
    final db = await open();
    final mapList = await db.query(tableUser,
      where: '$tblUserColEmail = ?', whereArgs: [email],);
    if(mapList.isEmpty) return null;
    return UserModel.fromMap(mapList.first);
  }

  static Future<UserModel> getUserById(int id) async {
    final db = await open();
    final mapList = await db.query(tableUser,
      where: '$tblUserColId = ?', whereArgs: [id],);
    return UserModel.fromMap(mapList.first);
  }

  static Future<List<Map<String, dynamic>>> getCommentsByFeaturesId(int id) async {
    final db = await open();
    return db.rawQuery('select a.features_id, a.user_id, a.rating, a.rating_date, a.user_reviews, b.email from $tableRating a inner join $tableUser b where a.user_id = b.user_id and a.features_id = $id');
  }

  static Future<bool> didUserFavorite(int featuresId, int userId) async {
    final db = await open();
    final mapList = await db.query(tableFavorite,
        where: '$tblFavColFeaturesId = ? and $tblFavColUserId = ?',
        whereArgs: [featuresId, userId]);
    return mapList.isNotEmpty;
  }

  static Future<Map<String, dynamic>> getAvgRatingByFeaturesId(int id) async {
    final db = await open();
    final mapList = await db.rawQuery('SELECT AVG($tblColRating) as $avgRating FROM $tableRating WHERE $tblRatingColFeaturesId = $id');
    return mapList.first;
  }

  static Future<int> deleteFeatures(int id) async {
    final db = await open();
    return db.delete(tableFeatures,
      where: '$tblFeaturesColId = ?', whereArgs: [id],);
  }

  static Future<int> deleteFavorite(int featuresId, userId) async {
    final db = await open();
    return db.delete(tableFavorite,
      where: '$tblFavColFeaturesId = ? and $tblFavColUserId = ?',
      whereArgs: [featuresId, userId],);
  }
}