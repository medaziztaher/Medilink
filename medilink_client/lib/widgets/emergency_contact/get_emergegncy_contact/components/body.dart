import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:medilink_client/models/emergency_contact.dart';
import 'package:medilink_client/utils/size_config.dart';

import '../../../../models/user.dart';
import '../get_emergency_contact_controller.dart';

class Body extends StatelessWidget {
  const Body({super.key, required this.user, this.userId});
  final User user;
  final String? userId;

  @override
  Widget build(BuildContext context) {
    final userDiseaseController =
        Get.put(UserEmergencyContactController(userId: user.id!));
    userDiseaseController.getUserEmergencyContacts();

    return Obx(() {
      if (userDiseaseController.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      } else if (userDiseaseController.emergencyContacts.isNotEmpty) {
        final emergencyContacts = userDiseaseController.emergencyContacts;
        return ListView.builder(
          itemCount: emergencyContacts.length,
          itemBuilder: (context, index) {
            final emergencyContact = emergencyContacts[index];
            return ListTile(
              title: Text(emergencyContact.name!),
              subtitle: Column(
                children: [
                  Text(emergencyContact.relationship.toString()),
                  SizedBox(
                    height: getProportionateScreenWidth(10),
                  ),
                  Text(emergencyContact.phoneNumber.toString())
                ],
              ),
            );
          },
        );
      } else {
        return Center(
            child: userId == user.id
                ? Text('You don\'t have any emergencyContacts')
                : Text('this ${user.name} don\'t have any emergencyContacts'));
      }
    });
  }
}
