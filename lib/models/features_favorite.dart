const String tableFavorite =
    'tbl_favorite';
const String tblFavColFeaturesId =
    'features_id';
const String tblFavColUserId =
    'user_id';
const String tblFavColFavorite =
    'favorite';

class FeaturesFavorite {
  int featuresId;
  int userId;
  bool favorite;

  FeaturesFavorite({
    required this.featuresId,
    required this.userId,
    this.favorite = false,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      tblFavColFeaturesId : featuresId,
      tblFavColUserId : userId,
      tblFavColFavorite : favorite ? 1 : 0,
    };
  }

  factory FeaturesFavorite.fromMap(Map<String, dynamic> map) => FeaturesFavorite(
    featuresId : map[tblFavColFeaturesId],
    userId : map[tblFavColUserId],
    favorite : map[tblFavColFavorite] == 0 ? false : true,
  );
}
