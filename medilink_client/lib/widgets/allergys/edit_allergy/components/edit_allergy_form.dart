import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:medilink_client/models/allergy.dart';

import '../../../../components/default_button.dart';
import '../../../../components/form_error.dart';
import '../../../../utils/size_config.dart';
import '../edit_allergy_controller.dart';

class EditAllergyForm extends StatelessWidget {
  const EditAllergyForm({super.key, required this.allergie});
  final Allergy allergie;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<EditAllergyController>(
        init: EditAllergyController(allergy: allergie),
        builder: (controller) {
          return Form(
            key: controller.formKeyEditAllergy,
            child: Column(
              children: [
                Column(children: [
                  buildtypeFormField(controller),
                  SizedBox(height: getProportionateScreenHeight(15)),
                  buildfollowupStatusFormField(controller),
                  SizedBox(height: getProportionateScreenHeight(15)),
                  buildyearOfDicoveryFormField(context, controller),
                  Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text("hereditary disease : "),
                        ],
                      ),
                      SizedBox(height: getProportionateScreenWidth(5)),
                      buildFamilyHistoryFormField(controller),
                    ],
                  ),
                  SizedBox(height: getProportionateScreenHeight(15)),
                  buildnotesFormField(controller),
                  SizedBox(height: getProportionateScreenHeight(15)),
                ]),
                FormError(errors: controller.errors),
                SizedBox(height: getProportionateScreenWidth(40)),
                Obx(() {
                  if (controller.isLoading.value == false) {
                    return DefaultButton(
                      text: "kbutton1".tr,
                      press: () async {
                        controller.updateAllergy();
                      },
                    );
                  } else {
                    return const Center(child: CircularProgressIndicator());
                  }
                }),
              ],
            ),
          );
        });
  }
}

TextFormField buildtypeFormField(EditAllergyController controller) {
  return TextFormField(
    onSaved: (newValue) => controller.typeController.text = newValue!,
    validator: (value) => controller.validatetype(value),
    onChanged: (value) => controller.onChangedtype(value),
    controller: controller.typeController,
    decoration: InputDecoration(
      labelText: "type",
      hintText: "enter allergy type ",
      floatingLabelBehavior: FloatingLabelBehavior.always,
    ),
  );
}

TextFormField buildyearOfDicoveryFormField(
    BuildContext context, EditAllergyController controller) {
  return TextFormField(
    controller: controller.yearOfDiscoveryController,
    readOnly: true,
    onTap: () async {
      final DateTime? selectedDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(1900),
        lastDate: DateTime(2100),
      );

      if (selectedDate != null) {
        final DateFormat formatter = DateFormat('yyyy-MM-dd');
        final String formattedDate = formatter.format(selectedDate);
        controller.yearOfDiscoveryController.text = formattedDate;
      }
    },
    decoration: InputDecoration(
      labelText: "year of dicovery",
      hintText: "Enter the year of dicovery",
      floatingLabelBehavior: FloatingLabelBehavior.always,
    ),
    validator: (value) => controller.validateyearOfDiscovery(value),
  );
}

TextFormField buildfollowupStatusFormField(EditAllergyController controller) {
  return TextFormField(
    onSaved: (newValue) => controller.followupStatusController.text = newValue!,
    validator: (value) => controller.validatefollowupStatus(value),
    onChanged: (value) => controller.onChangedfollowupStatus(value),
    controller: controller.followupStatusController,
    maxLines: 3,
    decoration: InputDecoration(
      labelText: "Follow-up status",
      hintText: "add follow up status",
      floatingLabelBehavior: FloatingLabelBehavior.always,
    ),
  );
}

Row buildFamilyHistoryFormField(EditAllergyController controller) {
  return Row(
    children: [
      Expanded(
        flex: 2,
        child: Obx(() => RadioListTile<bool>(
              title: Text(
                "Yes",
                style: TextStyle(fontSize: getProportionateScreenWidth(11)),
              ),
              value: true,
              groupValue: controller.familyHistory.value,
              onChanged: (value) => controller.onChangedfamilyHistory(value!),
            )),
      ),
      Expanded(
        flex: 3,
        child: Obx(() => RadioListTile<bool>(
              title: Text(
                'No',
                style: TextStyle(fontSize: getProportionateScreenWidth(11)),
              ),
              value: false,
              groupValue: controller.familyHistory.value,
              onChanged: (value) => controller.onChangedfamilyHistory(value!),
            )),
      ),
    ],
  );
}

TextFormField buildnotesFormField(EditAllergyController controller) {
  return TextFormField(
    onSaved: (newValue) => controller.notesController.text = newValue!,
    validator: (value) => controller.validatenotes(value),
    onChanged: (value) => controller.onChangednotes(value),
    controller: controller.notesController,
    maxLines: 3,
    decoration: InputDecoration(
      labelText: 'notes',
      hintText: "Enter notes",
      floatingLabelBehavior: FloatingLabelBehavior.always,
    ),
  );
}
