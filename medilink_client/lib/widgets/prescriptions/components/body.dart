import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../components/default_button.dart';
import '../../../utils/size_config.dart';
import '../prescriptions_controller.dart';

class Body extends StatelessWidget {
  const Body({super.key, required this.userId});
  final String userId;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SizedBox(
        width: double.infinity,
        child: Padding(
          padding:
              EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20)),
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: SizeConfig.screenHeight * 0.03),
                SizedBox(height: SizeConfig.screenHeight * 0.02),
                GetBuilder<PrescriptionsController>(
                    init: PrescriptionsController(userId: userId),
                    builder: (controller) {
                      return Form(
                          key: controller.formKeyPrescription,
                          child: Column(
                            children: [
                              buildmedicamentFormField(controller),
                              SizedBox(
                                  height: getProportionateScreenHeight(15)),
                              buildDosageFormField(controller),
                              SizedBox(
                                  height: getProportionateScreenHeight(15)),
                              buildFrequenceFormField(controller),
                              SizedBox(
                                  height: getProportionateScreenHeight(15)),
                              buildDatededebutFormField(context, controller),
                              SizedBox(
                                  height: getProportionateScreenHeight(15)),
                              buildDatededefinFormField(context, controller),
                              SizedBox(
                                  height: getProportionateScreenHeight(10)),
                              SizedBox(
                                  height: getProportionateScreenHeight(40)),
                              DefaultButton(
                                text: "Continue",
                                press: () {
                                  controller.addprescription();
                                },
                              ),
                            ],
                          ));
                    }),
              ],
            ),
          ),
        ),
      ),
    );
  }

  TextFormField buildmedicamentFormField(PrescriptionsController controller) {
    return TextFormField(
      onSaved: (newValue) => controller.medicamentController.text = newValue!,
      controller: controller.medicamentController,
      decoration: InputDecoration(
        labelText: "Medicament",
        hintText: "Enter medicament name ",
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
    );
  }

  DropdownButtonFormField<String> buildDosageFormField(
      PrescriptionsController controller) {
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
      items: typeValues
          .map((type) => DropdownMenuItem(
                value: type,
                child: Text(type),
              ))
          .toList(),
      decoration: InputDecoration(
        labelText: "Dosage",
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
    );
  }

  DropdownButtonFormField<String> buildFrequenceFormField(
      PrescriptionsController controller) {
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
      items: typeValues
          .map((type) => DropdownMenuItem(
                value: type,
                child: Text(type),
              ))
          .toList(),
      decoration: InputDecoration(
        labelText: "Frequence",
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
    );
  }

  TextFormField buildDatededebutFormField(
      BuildContext context, PrescriptionsController controller) {
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
        border: OutlineInputBorder(),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter the date';
        }
        return null;
      },
    );
  }

  TextFormField buildDatededefinFormField(
      BuildContext context, PrescriptionsController controller) {
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
        border: OutlineInputBorder(),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter the date';
        }
        return null;
      },
    );
  }
}
