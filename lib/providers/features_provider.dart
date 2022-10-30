import 'package:flutter/material.dart';

import '../db/db_helper.dart';
import '../models/features_model.dart';

class FeaturesProvider extends ChangeNotifier {
  List<FeaturesModel> featuresList = [];

  Future<int> insertFeatures(FeaturesModel featuresModel) =>
      DbHelper.insertFeatures(featuresModel);

  Future<void> updateFeatures(FeaturesModel featuresModel) async {
    await DbHelper.updateFeatures(featuresModel);
    getAllFeatures();
  }

  void getAllFeatures() async {
    featuresList = await DbHelper.getAllFeatures();
    notifyListeners();
  }

  Future<FeaturesModel> getFeaturesById(int featuresId) =>
      DbHelper.getFeaturesById(featuresId);

  FeaturesModel getFeaturesFromList(int id) =>
      featuresList.firstWhere((element) => element.id == id);

  void deleteFeatures(int id) async {
    await DbHelper.deleteFeatures(id);
    getAllFeatures();
  }
}