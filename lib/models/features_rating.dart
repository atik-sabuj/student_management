const String tblRatingColFeaturesId='features_id';
const String tblRatingColUserId='user_id';
const String tblRatingColDate='rating_date';
const String tblRatingColUserReviews='user_reviews';
const String tblColRating='rating';
const String tableRating='tbl_rating';

class FeaturesRating{
  int features_id;
  int user_id;
  String rating_date;
  String user_reviews;
  double rating;

  FeaturesRating(
      {
        required this.features_id,
        required this.user_id,
        required this.rating_date,
        required this.user_reviews,
        required this.rating});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      tblRatingColFeaturesId : features_id,
      tblRatingColUserId : user_id,
      tblRatingColDate : rating_date,
      tblRatingColUserReviews : user_reviews,
      tblColRating : rating,
    };
  }

  factory FeaturesRating.fromMap(Map<String, dynamic> map) =>
      FeaturesRating(
        features_id : map[tblRatingColFeaturesId],
        user_id : map[tblRatingColUserId],
        rating_date : map[tblRatingColDate],
        user_reviews : map[tblRatingColUserReviews],
        rating : map[tblColRating],
      );

}