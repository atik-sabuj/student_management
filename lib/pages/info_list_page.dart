import 'dart:io';
import 'package:flutter/material.dart';
import 'package:student_management/models/features_model.dart';
import 'package:student_management/pages/launcher_page.dart';
import 'package:student_management/providers/user_provider.dart';
import 'package:student_management/utils/helper_functions.dart';
import 'package:provider/provider.dart';

import '../providers/features_provider.dart';
import 'features_details.dart';

import 'add_features.dart';

class InfoListPage extends StatefulWidget {
  static const String routeName='/home';
  const InfoListPage ({Key? key}) : super(key: key);

  @override
  State<InfoListPage > createState() => _InfoListPageState();
}

class _InfoListPageState extends State<InfoListPage> {
  late FeaturesProvider provider;
  late UserProvider userProvider;

  @override
  void didChangeDependencies() {
    provider = Provider.of<FeaturesProvider>(context, listen: false);
    userProvider = Provider.of<UserProvider>(context, listen: false);
    provider.getAllFeatures();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: userProvider.userModel.isAdmin ? FloatingActionButton(
        onPressed: (){
          Navigator.pushNamed(context, AddFeaturesPage.routeName);
        },
        child: const Icon(Icons.add),
      ): null,
      appBar: AppBar(
        title: const Text('SMS Profile'),
        actions: [
          IconButton(
            onPressed: () async {
              await setLoginStatus(false);
              Navigator.pushReplacementNamed(context, LauncherPage.routeName);
            },
            icon: const Icon(Icons.logout),
          )
        ],
      ),
      body: Consumer<FeaturesProvider>(
        builder: (context, provider, child) => ListView.builder(
          itemCount: provider.featuresList.length,
          itemBuilder: (context, index) {
            final features = provider.featuresList[index];
            return FeaturesItem(features: features);
          },
        ),
      ),
    );
  }
}

class FeaturesItem extends StatelessWidget {
  const FeaturesItem({
    Key? key,
    required this.features,
  }) : super(key: key);

  final FeaturesModel features;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.pushNamed(context, FeaturesDetailsPage.routeName,
          arguments: [features.id, features.name]),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Image.file(
                File(features.image),
                width: double.infinity,
                height: 50,
                //fit: BoxFit.cover,
              ),
              ListTile(
                title: Text(features.name),
                subtitle: Text(features.type),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
