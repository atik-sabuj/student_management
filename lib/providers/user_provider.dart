import 'package:flutter/material.dart';
import 'package:student_management/db/db_helper.dart';

import '../models/features_favorite.dart';
import '../models/features_rating.dart';
import '../models/user_model.dart';

class UserProvider extends ChangeNotifier {
  late UserModel userModel;
  Future<UserModel?> getUserByEmail(String email) =>
      DbHelper.getUserByEmail(email);

  Future<int> insertUser(UserModel userModel) =>
      DbHelper.insertUser(userModel);

  Future<int> insertRating(FeaturesRating featuresRating) =>
      DbHelper.insertRating(featuresRating);

  Future<int> insertFavorite(FeaturesFavorite featuresFavorite) =>
      DbHelper.insertFavorite(featuresFavorite);

  Future<int> updateRating(FeaturesRating featuresRating) =>
      DbHelper.updateRating(featuresRating);

  Future<void> getUserById(int id) async {
    userModel = await DbHelper.getUserById(id);
  }

  Future<Map<String, dynamic>> getAvgRatingByFeaturesId(int id) =>
      DbHelper.getAvgRatingByFeaturesId(id);

  Future<List<Map<String, dynamic>>> getCommentsByFeaturesId(int id) =>
      DbHelper.getCommentsByFeaturesId(id);

  Future<bool> didUserRate(int featuresId) =>
      DbHelper.didUserRate(featuresId, userModel.userId!);

  Future<bool> didUserFavorite(int featuresId) =>
      DbHelper.didUserFavorite(featuresId, userModel.userId!);

  Future<int> deleteFavorite(int featuresId) =>
      DbHelper.deleteFavorite(featuresId, userModel.userId!);
}