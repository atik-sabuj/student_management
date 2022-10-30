import 'package:flutter/material.dart';
import 'package:student_management/models/features_rating.dart';
import 'package:student_management/models/user_model.dart';

class CommentItem extends StatelessWidget {
  final Map<String, dynamic> featuresRating;
  const CommentItem({Key? key, required this.featuresRating}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListTile(
          leading: const Icon(Icons.person),
          title: Text(featuresRating[tblUserColEmail]),
          subtitle: Text(featuresRating[tblRatingColDate]),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.star, color: Colors.amber,),
              Text(featuresRating[tblColRating].toString())
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Text(featuresRating[tblRatingColUserReviews]),
        ),
      ],
    );
  }
}
