import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:student_management/models/features_model.dart';
import 'package:student_management/providers/features_provider.dart';
import 'package:provider/provider.dart';

import '../models/features_model.dart';
import '../utils/helper_functions.dart';
import '../utils/utils.dart';

class AddFeaturesPage extends StatefulWidget {
  static const String routeName='/add_features';

  const AddFeaturesPage({Key? key}) : super(key: key);

  @override
  State<AddFeaturesPage> createState() => _AddFeaturesPageState();
}

class _AddFeaturesPageState extends State<AddFeaturesPage> {

  late FeaturesProvider featuresProvider;
  final _fromKey=GlobalKey<FormState>();
  final nameController = TextEditingController();
  final detailsController = TextEditingController();
  final courseController = TextEditingController();
  String? selectedType;
  DateTime? admissionDate;
  String? imagePath;
  int? id;

  @override
  void didChangeDependencies() {
    featuresProvider=Provider.of(context,listen: false);
    id = ModalRoute.of(context)!.settings.arguments as int?;
    if(id != null) {
      _setData();
    }
    super.didChangeDependencies();
  }


  @override
  void dispose() {
    nameController.dispose();
    detailsController.dispose();
    courseController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(id == null ? 'Create Profile' : 'Update Features'),
        actions: [
          IconButton(
              onPressed: saveFeatures,
              icon: Icon(id == null ? Icons.save : Icons.update))
        ],
      ),
      body: Form(
          key: _fromKey,
          child: ListView(
            children: [
              Image.asset("images/sms.png",height: 250,fit: BoxFit.cover,),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(6),
                            borderSide:
                            BorderSide(color: Colors.blue, width: 1))),
                    hint: Text('Select Features'),
                    items: featureTypes
                        .map((e) => DropdownMenuItem(value: e, child: Text(e!)))
                        .toList(),
                    value: selectedType,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please select a type';
                      }
                      return null;
                    },
                    onChanged: (value) {
                      setState(() {
                        selectedType = value;
                      });
                    }),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: nameController,
                  decoration: InputDecoration(
                      hintText: 'Enter Name',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6),
                          borderSide:
                          BorderSide(color: Colors.blue, width: 1))),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'This field must not be empty';
                    }
                    return null;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: detailsController,
                  decoration: InputDecoration(
                      hintText: 'Enter Details',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6),
                          borderSide:
                          BorderSide(color: Colors.blue, width: 1))),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'This field must not be empty';
                    }
                    return null;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  keyboardType: TextInputType.number,
                  controller: courseController,
                  decoration: InputDecoration(
                      hintText: 'Enter Course',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6),
                          borderSide:
                          BorderSide(color: Colors.blue, width: 1))),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'This field must not be empty';
                    }
                    return null;
                  },
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton.icon(
                      onPressed: selectDate,
                      icon: const Icon(Icons.calendar_month),
                      label: const Text('Select Admission Date'),
                    ),
                    Text(admissionDate == null
                        ? 'No date chosen'
                        : getFormattedDate(admissionDate!, 'dd/MM/yyyy'))
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    imagePath == null
                        ? const Icon(
                      Icons.photo,
                      size: 100,
                    )
                        : Image.file(
                      File(imagePath!),
                      width: 100,
                      height: 100,
                      fit: BoxFit.cover,
                    ),
                    TextButton.icon(
                      onPressed: getImage,
                      icon: const Icon(Icons.photo),
                      label: const Text('Select from Gallery'),
                    )
                  ],
                ),
              ),
            ],
          )),
    );
  }
  void selectDate() async {
    final selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (selectedDate != null) {
      setState(() {
        admissionDate = selectedDate;
      });
    }
  }

  void getImage() async {
    final file = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (file != null) {
      setState(() {
        imagePath = file.path;
      });
    }
  }

  void saveFeatures() {
    if (admissionDate == null) {
      showMsg(context, 'Please select a date');
      return;
    }
    if (imagePath == null) {
      showMsg(context, 'Please select an image');
      return;
    }
    if (_fromKey.currentState!.validate()) {

      final features = FeaturesModel(
        name: nameController.text,
        image: imagePath!,
        details: detailsController.text,
        course: int.parse(courseController.text),
        type: selectedType!,
        admission_date: getFormattedDate(admissionDate!, datePattern),
      );

      if(id != null) {
        features.id = id;
        featuresProvider
            .updateFeatures(features)
            .then((value) {
          Navigator.pop(context, features.name);
        }).catchError((error) {
          print(error.toString());
        });
      } else {
        featuresProvider
            .insertFeatures(features)
            .then((value) {
          featuresProvider.getAllFeatures();
          Navigator.pop(context);
        }).catchError((error) {
          print(error.toString());
        });
      }
    }
  }

  void _setData() {
    final features = featuresProvider.getFeaturesFromList(id!);
    nameController.text = features.name;
    detailsController.text = features.details;
    courseController.text = features.course.toString();
    selectedType = features.type;
    imagePath = features.image;
    admissionDate = DateFormat(datePattern).parse(features.admission_date);

  }
}

