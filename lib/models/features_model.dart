import 'package:student_management/models/features_favorite.dart';

const String tableFeatures='tbl_features';
const String tblFeaturesColId='id';
const String tblFeaturesColName='name';
const String tblFeaturesFeaturesColTitle='title';
const String tblFeaturesColImage='image';
const String tblFeaturesColDetails='details';
const String tblFeaturesColCourse='course';
const String tblFeaturesColType='type';
const String tblFeaturesColAdmission='admission_date';



class FeaturesModel {
  int? id;
  String name;
  String image;
  String details;
  int course;
  String type;
  String admission_date;
  bool favorite;

  FeaturesModel(
      {
        this.id,
        required this.name,
        required this.image,
        required this.details,
        required this.course,
        required this.type,
        required this.admission_date,
        this.favorite=false
      });

  Map<String,dynamic> toMap(){
    final map=<String,dynamic>{
      tblFeaturesColName:name,
      tblFeaturesColDetails:details,
      tblFeaturesColImage:image,
      tblFeaturesColCourse:course,
      tblFeaturesColType:type,
      tblFeaturesColAdmission:admission_date,
    };

    if(id!=null){
      map[tblFeaturesColId]=id;
    }
    return map;
  }

  factory FeaturesModel.fromMap(Map<String,dynamic> map)=>
      FeaturesModel(
          id: map[tblFeaturesColId],
          name: map[tblFeaturesColName],
          image: map[tblFeaturesColImage],
          details: map[tblFeaturesColDetails],
          course: map[tblFeaturesColCourse],
          type: map[tblFeaturesColType],
          admission_date: map[tblFeaturesColAdmission],
          favorite: map[tblFavColFavorite] == null ? false :
             map[tblFavColFavorite] == 0 ? false : true,

      );
}
