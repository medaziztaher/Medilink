import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:medilink_client/api/user.dart';
import 'package:medilink_client/models/allergy.dart';

import '../../../../settings/path.dart';
import '../../../../utils/global.dart';
import '../../edit_allergy/edit_allergy_screen.dart';

class Body extends StatefulWidget {
  const Body({super.key, required this.allergy});
  final Allergy allergy;

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
                  onPressed: () => Get.off(
                      () => EditAllergyScreen(allergie: widget.allergy)),
                  icon: Icon(Icons.edit_outlined)),
              IconButton(
                  onPressed: () async {
                    try {
                      final response = await networkHandler
                          .delete("$allergysPath/${widget.allergy.id}");
                      final responseData = json.decode(response.body);
                      if (response.statusCode == 200) {
                        final message = responseData['message'];
                        Get.back();
                        Get.snackbar("Allergy Deleted", message);
                      } else if (response.statusCode == 500) {
                        final message = responseData['error'];
                        Get.snackbar("Error Deleting Allergy", message);
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
              title: Text('Type : '),
              subtitle: Text('${widget.allergy.type}'),
            ),
            SizedBox(height: 10),
            ListTile(
              title: Text('Followup Status: '),
              subtitle: Text('${widget.allergy.followupStatus}'),
            ),
            SizedBox(height: 10),
            ListTile(
              title: Text('Year Of Discovery : '),
              subtitle: Text('${widget.allergy.yearOfDiscovery}'),
            ),
            SizedBox(height: 10),
            ListTile(
              title: Text('Family History: '),
              subtitle: Text('${widget.allergy.familyHistory}'),
            ),
            SizedBox(height: 10),
            ListTile(
              title: Text('Notes: '),
              subtitle: Text('${widget.allergy.notes}'),
            ),
          ],
        )),
      ],
    ));
  }
}
