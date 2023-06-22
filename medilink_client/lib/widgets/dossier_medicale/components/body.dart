import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:medilink_client/models/user.dart';
import 'package:medilink_client/widgets/allergys/allergy.dart';
import 'package:medilink_client/widgets/allergys/user_alergys/user_alergys.dart';
import 'package:medilink_client/widgets/diseases/user_diseases/user_disease.dart';
import 'package:medilink_client/widgets/labresult/components/user_lab_results/user_lab_results.dart';
import 'package:medilink_client/widgets/prescriptions/prescriptions_screen.dart';
import 'package:medilink_client/widgets/prescriptions/user_prescriptions/user_prescriptions.dart';
import 'package:medilink_client/widgets/radiographie/user_radiographie/user_radiographie.dart';
import 'package:medilink_client/widgets/surgerys/surgerys_screen.dart';
import 'package:medilink_client/widgets/surgerys/user_surgerys/user_surgerys.dart';

import '../../../utils/size_config.dart';

class Body extends StatelessWidget {
  const Body({super.key, required this.user});
  final User user;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      child: Column(children: [
        SizedBox(height: SizeConfig.screenHeight * 0.04),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text("${user.name} medicale Fils : "),
          ],
        ),
        SizedBox(height: SizeConfig.screenHeight * 0.04),
        GestureDetector(
          onTap: () => Get.to(() => UserAllergeys(user: user)),
          child: ListTile(
            title: Text("Allergys  : "),
            trailing: Icon(Icons.arrow_forward_ios),
          ),
        ),
        GestureDetector(
          onTap: () => Get.to(() => UserLabs(user: user)),
          child: ListTile(
            title: Text("Lab  Results  : "),
            trailing: Icon(Icons.arrow_forward_ios),
          ),
        ),
        GestureDetector(
          onTap: () => Get.to(() => UserRadios(user: user)),
          child: ListTile(
            title: Text("Radiographies : "),
            trailing: Icon(Icons.arrow_forward_ios),
          ),
        ),
       GestureDetector(
        onTap: ()=> Get.to(()=>UserDiseases(user: user)),
        child: Text("Desieses")),
        GestureDetector(
           onTap: () => Get.to(() => SurgeryScreen(userId: user.id!)),
          child: ListTile(
            title: Text("Surgeries : "),
            trailing: Row(
              children: [
                GestureDetector(
                    onTap: () => Get.to(() => SurgeryScreen(userId: user.id!)),
                    child: Icon(Icons.add)),
                SizedBox(width: 5),
                GestureDetector(
                    onTap: () => Get.to(() => UserSurgerys(user: user)),
                    child: Icon(Icons.arrow_forward_ios)),
              ],
            ),
          ),
        ),
        GestureDetector(
           onTap: () => Get.to(() => Prescriptions(user: user)),
          child: ListTile(
            title: Text("Prescriptions : "),
            trailing: Row(
              children: [
                GestureDetector(
                    onTap: () => Get.to(() => Prescriptions(user: user)),
                    child: Icon(Icons.add)),
                SizedBox(width: 5),
                GestureDetector(
                    onTap: () => Get.to(() => UserPrescriptions(user: user)),
                    child: Icon(Icons.arrow_forward_ios)),
              ],
            ),
          ),
        )
      ]),
    );
  }
}
