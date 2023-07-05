import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:medilink_client/models/diseases.dart';

import '../../../../api/user.dart';
import '../../../../settings/path.dart';
import '../../../../utils/global.dart';
import '../../edit_disease/edit_disease_screen.dart';

class Body extends StatefulWidget {
  const Body({super.key, required this.disease});
  final Disease disease;

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  late String? userRole;

  @override
  void initState() {
    super.initState();
    _initializeUser();
  }

  void _initializeUser() async {
    userRole = globalRole;
    if (userRole == null) {
      userRole = await queryUserRole();
    }
    print(userRole);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Column(
      children: [
        if (userRole == 'Patient') ...[
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(
                  onPressed: () =>
                      Get.off(() => EditDiseaseScreen(disease: widget.disease)),
                  icon: Icon(Icons.edit_outlined)),
              IconButton(
                  onPressed: () async {
                    try {
                      final response = await networkHandler
                          .delete("$disesePath/${widget.disease.id}");
                      final responseData = json.decode(response.body);
                      if (response.statusCode == 200) {
                        final message = responseData['message'];
                        Get.back();
                        Get.snackbar("Disease Deleted", message);
                      } else if (response.statusCode == 500) {
                        final message = responseData['error'];
                        Get.snackbar("Error Deleting Disease", message);
                      }
                    } catch (e) {
                      print(e);
                    } finally {}
                  },
                  icon: Icon(Icons.delete_outline)),
            ],
          ),
        ],
        Card(
          child: Column(
            children: [
              ListTile(
                title: Text('Speciality : '),
                subtitle: Text('${widget.disease.speciality}'),
              ),
              SizedBox(height: 10),
              ListTile(
                title: Text('Genetic : '),
                subtitle: Text('${widget.disease.genetic}'),
              ),
              SizedBox(height: 10),
              ListTile(
                title: Text('ChronicDisease : '),
                subtitle: Text('${widget.disease.chronicDisease}'),
              ),
              SizedBox(height: 10),
              ListTile(
                title: Text('DetectedIn : '),
                subtitle: Text('${widget.disease.detectedIn}'),
              ),
              SizedBox(height: 10),
              ListTile(
                title: Text('CuredIn : '),
                subtitle: Text('${widget.disease.curedIn}'),
              ),
              SizedBox(height: 10),
              ListTile(
                title: Text('Notes : '),
                subtitle: Text('${widget.disease.notes}'),
              ),
            ],
          ),
        )
      ],
    ));
  }
}
