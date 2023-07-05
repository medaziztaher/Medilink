import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../../components/default_button.dart';
import '../../../../components/form_error.dart';
import '../../../../utils/size_config.dart';
import '../add_disease_controller.dart';

class AddDiseaseForm extends StatelessWidget {
  const AddDiseaseForm({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AddDiseaseController>(
        init: AddDiseaseController(),
        builder: (controller) {
          return Form(
            key: controller.formKeyAddDisease,
            child: Column(
              children: [
                Column(children: [
                  buildspecialityFormField(controller),
                  SizedBox(height: getProportionateScreenHeight(15)),
                  Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text("genetic : "),
                        ],
                      ),
                      SizedBox(height: getProportionateScreenWidth(5)),
                      buildgeneticFormField(controller),
                    ],
                  ),
                  SizedBox(height: getProportionateScreenHeight(15)),
                  Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text("chronicDisease : "),
                        ],
                      ),
                      SizedBox(height: getProportionateScreenWidth(5)),
                      buildchronicDiseaseFormField(controller),
                    ],
                  ),
                  SizedBox(height: getProportionateScreenHeight(15)),
                  builddetectedFormField(context, controller),
                  SizedBox(height: getProportionateScreenHeight(15)),
                  buildcuredInFormField(context, controller),
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
                        controller.addDisease();
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

TextFormField buildspecialityFormField(AddDiseaseController controller) {
  return TextFormField(
    onSaved: (newValue) => controller.specialityController.text = newValue!,
    validator: (value) => controller.validatespeciality(value),
    onChanged: (value) => controller.onChangedspeciality(value),
    controller: controller.specialityController,
    decoration: InputDecoration(
      labelText: "speciality",
      hintText: "enter disease speciality ",
      floatingLabelBehavior: FloatingLabelBehavior.always,
    ),
  );
}

TextFormField buildcuredInFormField(
    BuildContext context, AddDiseaseController controller) {
  return TextFormField(
    controller: controller.curedInController,
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
        controller.curedInController.text = formattedDate;
      }
    },
    decoration: InputDecoration(
      labelText: "Cured In year",
      hintText: "Enter the Cured In year",
      floatingLabelBehavior: FloatingLabelBehavior.always,
    ),
    validator: (value) => controller.validatecuredIn(value),
  );
}

TextFormField builddetectedFormField(
    BuildContext context, AddDiseaseController controller) {
  return TextFormField(
    controller: controller.detectedInController,
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
        controller.detectedInController.text = formattedDate;
      }
    },
    decoration: InputDecoration(
      labelText: "Detection year",
      hintText: "Enter the year of detection",
      floatingLabelBehavior: FloatingLabelBehavior.always,
    ),
    validator: (value) => controller.validatedetectedIn(value),
  );
}

Row buildgeneticFormField(AddDiseaseController controller) {
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
              groupValue: controller.genetic.value,
              onChanged: (value) => controller.onChangedgenetic(value!),
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
              groupValue: controller.genetic.value,
              onChanged: (value) => controller.onChangedgenetic(value!),
            )),
      ),
    ],
  );
}

Row buildchronicDiseaseFormField(AddDiseaseController controller) {
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
              groupValue: controller.chronicDisease.value,
              onChanged: (value) => controller.onChangedchronicDisease(value!),
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
              groupValue: controller.chronicDisease.value,
              onChanged: (value) => controller.onChangedchronicDisease(value!),
            )),
      ),
    ],
  );
}

TextFormField buildnotesFormField(AddDiseaseController controller) {
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
