import 'dart:io';

import 'package:flutter/material.dart';
import 'package:student_management/models/features_favorite.dart';
import 'package:student_management/pages/add_features.dart';
import 'package:student_management/providers/features_provider.dart';
import 'package:student_management/providers/user_provider.dart';
import 'package:provider/provider.dart';

import '../customwidgets/all_comments_widget.dart';
import '../customwidgets/rating_comment_widget.dart';
import '../models/features_model.dart';
import '../utils/utils.dart';


class FeaturesDetailsPage extends StatefulWidget {
  static const String routeName='/features_details';

  const FeaturesDetailsPage({Key? key}) : super(key: key);

  @override
  State<FeaturesDetailsPage> createState() => _FeaturesDetailsPageState();
}

class _FeaturesDetailsPageState extends State<FeaturesDetailsPage> {
  int? id;
  late String name;
  late FeaturesProvider provider;
  late UserProvider userProvider;

  @override
  void didChangeDependencies() {
    provider = Provider.of<FeaturesProvider>(context, listen: false);
    userProvider = Provider.of<UserProvider>(context, listen: false);
    final argList = ModalRoute.of(context)!.settings.arguments as List;
    id = argList[0];
    name = argList[1];
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(name),
        actions: userProvider.userModel.isAdmin
            ? [
          IconButton(
            onPressed: () => Navigator.pushNamed(
                context, AddFeaturesPage.routeName,
                arguments: id)
                .then((value) => setState(() {
              name = value as String;
            })),
            icon: const Icon(Icons.edit),
          ),
          IconButton(
            onPressed: _deleteFeatures,
            icon: const Icon(Icons.delete),
          ),
        ]
            : null,
      ),
      body: Center(
        child: FutureBuilder<FeaturesModel>(
          future: provider.getFeaturesById(id!),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final features = snapshot.data!;
              return ListView(
                children: [
                  Image.file(
                    File(features.image),
                    width: double.infinity,
                    height: 250,
                    fit: BoxFit.cover,
                  ),
                  FutureBuilder<bool>(
                    future: userProvider.didUserFavorite(id!),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        final isFavorite = snapshot.data!;
                        return TextButton.icon(
                          onPressed: () {
                            _favoriteFeatures(isFavorite);
                          },
                          icon: Icon(isFavorite
                              ? Icons.favorite
                              : Icons.favorite_border),
                          label: Text(isFavorite
                              ? 'Remove from Favorite'
                              : 'Add to Favorite'),
                        );
                      }
                      if (snapshot.hasError) {
                        print(snapshot.error.toString());
                        return const Text('Failed to load favorite');
                      }
                      return const Text('Loading');
                    },
                  ),
                  ListTile(
                      title: Text(features.name),
                      subtitle: Text(features.type),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.star,
                            color: Colors.amber,
                          ),
                          FutureBuilder<Map<String, dynamic>>(
                            future: userProvider.getAvgRatingByFeaturesId(id!),
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                final map = snapshot.data!;
                                return Text('${map[avgRating] ?? 0.0}');
                              }
                              if (snapshot.hasError) {
                                return const Text('Error loading');
                              }
                              return const Text('Loading');
                            },
                          ),
                        ],
                      )),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('Course: \$${features.course}'),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(features.details),
                  ),
                  if (!userProvider.userModel.isAdmin)
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: RatingCommentWidget(
                        featuresId: id!,
                        onComplete: () {
                          setState(() {});
                        },
                      ),
                    ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: const Text(
                      'All Comments',
                      style: TextStyle(fontSize: 25),
                    ),
                  ),
                  AllCommentsWidget(
                    featuresId: id!,
                  )
                ],
              );
            }
            if (snapshot.hasError) {
              return const Text('Failed to load data');
            }
            return const CircularProgressIndicator();
          },
        ),
      ),
    );
  }

  void _deleteFeatures() {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Delete $name?'),
          content: Text('Are you sure to delete $name?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('NO'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                provider.deleteFeatures(id!);
                Navigator.pop(context);
              },
              child: const Text('YES'),
            )
          ],
        ));
  }

  void _favoriteFeatures(bool isFavorite) async {
    final featuresFavorite = FeaturesFavorite(
      featuresId: id!,
      userId: userProvider.userModel.userId!,
    );
    if(isFavorite) {
      await userProvider.deleteFavorite(id!);
    } else {
      await userProvider.insertFavorite(featuresFavorite);
    }
    setState(() {

    });
  }
}

