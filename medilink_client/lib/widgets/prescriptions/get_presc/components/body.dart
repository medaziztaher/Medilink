import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:medilink_client/models/prescription.dart';
import 'package:medilink_client/settings/path.dart';

import '../../../../api/user.dart';
import '../../edit_presc/edit_presc_screen.dart';

class Body extends StatelessWidget {
  const Body(
      {Key? key,
      required this.prescription,
      required this.userId,
      this.provider})
      : super(key: key);

  final Prescription prescription;
  final String userId;
  final String? provider;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          if (userId == prescription.patient ||
              userId == prescription.provider) ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  onPressed: () => Get.off(() => EditPrescScreen(
                        prescription: prescription,
                        userId: userId,
                      )),
                  icon: Icon(Icons.edit_outlined),
                ),
                IconButton(
                  onPressed: () async {
                    try {
                      final response = await networkHandler
                          .delete("$prescriptionsPath/${prescription.id}");
                      final responseData = json.decode(response.body);
                      print(responseData);
                      if (response.statusCode == 200) {
                        final message = responseData['message'];
                        Get.back();
                        Get.snackbar("prescription Deleted", message);
                      } else if (response.statusCode == 500) {
                        final message = responseData['error'];
                        Get.snackbar("Error Deleting prescription", message);
                      }
                    } catch (e) {
                      print(e);
                    }
                  },
                  icon: Icon(Icons.delete_outline),
                ),
              ],
            ),
          ],
          Card(
            child: Column(
              children: [
                ListTile(
                  title: Text('Medicament'),
                  subtitle: Text('${prescription.medication}'),
                ),
                SizedBox(height: 10),
                ListTile(
                  title: Text('Dosage: '),
                  subtitle: Text('${prescription.dosage}'),
                ),
                SizedBox(height: 10),
                ListTile(
                  title: Text('Frequence: '),
                  subtitle: Text('${prescription.frequency}'),
                ),
                SizedBox(height: 10),
                ListTile(
                  title: Text('Start Date: '),
                  subtitle: Text('${prescription.startDate}'),
                ),
                SizedBox(height: 10),
                ListTile(
                  title: Text('Date: '),
                  subtitle: Text('${prescription.endDate}'),
                ),
                SizedBox(height: 10),
                if (prescription.provider != null) ...[
                  ListTile(
                    title: Text('Provider: '),
                    subtitle: Text('$provider'),
                  ),
                ],
                SizedBox(height: 10),
              ],
            ),
          )
        ],
      ),
    );
  }
}
