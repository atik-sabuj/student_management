import 'package:flutter/material.dart';
import 'package:student_management/models/features_rating.dart';
import 'package:provider/provider.dart';

import '../providers/user_provider.dart';
import 'comment_item.dart';

class AllCommentsWidget extends StatelessWidget {
  final int featuresId;
  const AllCommentsWidget({Key? key, required this.featuresId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<UserProvider>(context, listen: false);
    return Center(
      child: FutureBuilder<List<Map<String, dynamic>>>(
        future: provider.getCommentsByFeaturesId(featuresId),
        builder: (context, snapshot) {
          if(snapshot.hasData) {
            final commentMapList = snapshot.data!;
            return ListView.builder(
              shrinkWrap: true,
              itemCount: commentMapList.length,
              itemBuilder: (context, index) {
                final ratingMap = commentMapList[index];
                return CommentItem(featuresRating: ratingMap,);
              },
            );
          }
          if(snapshot.hasError) {
            return const Text('Failed to load comments');
          }
          return const CircularProgressIndicator();
        },
      ),
    );
  }
}
