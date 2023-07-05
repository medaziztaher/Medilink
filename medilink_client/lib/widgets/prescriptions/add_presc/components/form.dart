import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:medilink_client/components/form_error.dart';

import '../../../../components/default_button.dart';
import '../../../../models/user.dart';

import '../../../../utils/size_config.dart';
import '../../../search/search_screen.dart';
import '../add_presc_controller.dart';

class AddAnalyseForm extends StatelessWidget {
  const AddAnalyseForm({super.key, required this.user, required this.userId});
  final User user;
  final String userId;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AddPrescController>(
      init: AddPrescController(user: user),
      builder: (controller) {
        return Form(
          key: controller.formKeyPrescription,
          child: Column(
            children: [
              Column(
                children: [
                  buildmedicamentFormField(controller),
                  SizedBox(height: getProportionateScreenHeight(15)),
                  buildDosageFormField(controller),
                  SizedBox(height: getProportionateScreenHeight(15)),
                  buildFrequenceFormField(controller),
                  SizedBox(height: getProportionateScreenHeight(15)),
                  buildDatededebutFormField(context, controller),
                  SizedBox(height: getProportionateScreenHeight(15)),
                  buildDatededefinFormField(context, controller),
                  SizedBox(height: getProportionateScreenWidth(15)),
                ],
              ),
              SizedBox(height: getProportionateScreenWidth(15)),
              FormError(errors: controller.errors),
              SizedBox(height: getProportionateScreenWidth(40)),
              Obx(() {
                if (controller.isLoading.value == false) {
                  return DefaultButton(
                    text: "kbutton1".tr,
                    press: () async {
                      controller.addprescription();
                    },
                  );
                } else {
                  return const Center(child: CircularProgressIndicator());
                }
              }),
            ],
          ),
        );
      },
    );
  }
}

TextFormField buildmedicamentFormField(AddPrescController controller) {
  return TextFormField(
    onSaved: (newValue) => controller.medicamentController.text = newValue!,
    validator: (value) => controller.validatemedicament(value),
    controller: controller.medicamentController,
    decoration: InputDecoration(
      labelText: "Medicament",
      hintText: "Enter medicament name ",
      floatingLabelBehavior: FloatingLabelBehavior.always,
    ),
  );
}

DropdownButtonFormField<String> buildDosageFormField(
    AddPrescController controller) {
  final List<String> typeValues = [
    '1 pill',
    '2 pills',
    '1 tablet',
    '2 tablets',
    '1 capsule',
    '2 capsules'
  ];

  assert(typeValues.toSet().length == typeValues.length);

  String? defaultValue = typeValues.first;

  if (!typeValues.contains(defaultValue)) {
    defaultValue = null;
  }
  return DropdownButtonFormField<String>(
    value: defaultValue,
    onChanged: (value) => controller.onChangeddosage(value),
    validator: (value) => controller.validatedosage(value),
    items: typeValues
        .map((type) => DropdownMenuItem(
              value: type,
              child: Text(type),
            ))
        .toList(),
    decoration: InputDecoration(
      labelText: "Dosage",
      hintText: "Enter Dosage",
      floatingLabelBehavior: FloatingLabelBehavior.always,
    ),
  );
}

DropdownButtonFormField<String> buildFrequenceFormField(
    AddPrescController controller) {
  final List<String> typeValues = [
    'daily',
    'twice per day',
    'every 6 hours',
  ];

  assert(typeValues.toSet().length == typeValues.length);

  String? defaultValue = typeValues.first;

  if (!typeValues.contains(defaultValue)) {
    defaultValue = null;
  }

  return DropdownButtonFormField<String>(
    value: defaultValue,
    onChanged: (value) => controller.onChangedfrequence(value),
    validator: (value) => controller.validatefrequence(value),
    items: typeValues
        .map((type) => DropdownMenuItem(
              value: type,
              child: Text(type),
            ))
        .toList(),
    decoration: InputDecoration(
      labelText: "Frequence",
      hintText: "Enter frequence",
      floatingLabelBehavior: FloatingLabelBehavior.always,
    ),
  );
}

TextFormField buildDatededebutFormField(
    BuildContext context, AddPrescController controller) {
  return TextFormField(
      controller: controller.dateDebutController,
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
          controller.dateDebutController.text = formattedDate;
        }
      },
      decoration: InputDecoration(
        labelText: 'Start day',
        hintText: "Enter Start day",
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
      validator: (value) => controller.validatedateDebut(value));
}

TextFormField buildDatededefinFormField(
    BuildContext context, AddPrescController controller) {
  return TextFormField(
      controller: controller.dateFinController,
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
          controller.dateFinController.text = formattedDate;
        }
      },
      decoration: InputDecoration(
        labelText: 'End date',
        hintText: 'Enter End date',
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
      validator: (value) => controller.validatedateFin(value));
}
