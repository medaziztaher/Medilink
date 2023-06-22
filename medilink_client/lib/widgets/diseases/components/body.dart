import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:medilink_client/widgets/diseases/diseases_controller.dart';

import '../../../components/default_button.dart';
import '../../../utils/size_config.dart';

class Body extends StatelessWidget {
  const Body({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: SizedBox(
            width: double.infinity,
            child: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: getProportionateScreenWidth(20)),
                child: SingleChildScrollView(
                    child: Column(
                  children: [
                    SizedBox(height: SizeConfig.screenHeight * 0.03),
                    GetBuilder<DiseaseController>(
                        init: DiseaseController(),
                        builder: (controller) {
                          return Form(
                            key: controller.diseasesformKey,
                            child: Column(
                              children: [
                                SizedBox(
                                    height: getProportionateScreenWidth(10)),
                                buildtypeFormField(controller),
                                SizedBox(
                                    height: getProportionateScreenWidth(15)),
                                builddetectedInFormField(context, controller),
                                SizedBox(
                                    height: getProportionateScreenWidth(15)),
                                buildcuredInFormField(context, controller),
                                SizedBox(
                                    height: getProportionateScreenWidth(15)),
                                Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Text("genetic : "),
                                      ],
                                    ),
                                    SizedBox(
                                        height:
                                            getProportionateScreenWidth(15)),
                                    buildgeneticFormField(controller),
                                  ],
                                ),
                                SizedBox(
                                    height: getProportionateScreenWidth(15)),
                                Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Text("chronicDisease : "),
                                      ],
                                    ),
                                    SizedBox(
                                        height:
                                            getProportionateScreenWidth(15)),
                                    buildchronicFormField(controller),
                                  ],
                                ),
                                SizedBox(
                                    height: getProportionateScreenWidth(15)),
                                buildnotesFormField(controller),
                                SizedBox(
                                    height: getProportionateScreenWidth(40)),
                                DefaultButton(
                                    text: 'Save',
                                    press: () async {
                                      controller.addDisease();
                                    })
                              ],
                            ),
                          );
                        })
                  ],
                )))));
  }
}

TextFormField buildtypeFormField(DiseaseController controller) {
  return TextFormField(
    onSaved: (newValue) => controller.specialityController.text = newValue!,
    controller: controller.specialityController,
    decoration: InputDecoration(
      labelText: "type",
      hintText: "add type",
      floatingLabelBehavior: FloatingLabelBehavior.always,
    ),
  );
}



TextFormField builddetectedInFormField(
    BuildContext context, DiseaseController controller) {
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
      labelText: "Year of detection",
      hintText: "add the year of detection",
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

TextFormField buildcuredInFormField(
    BuildContext context, DiseaseController controller) {
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
      labelText: "healed in",
      hintText: "add the year",
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

Row buildgeneticFormField(DiseaseController controller) {
  return Row(
    children: [
      Expanded(
        flex: 2,
        child: RadioListTile<bool>(
          title: Text(
            "Yes",
            style: TextStyle(fontSize: getProportionateScreenWidth(11)),
          ),
          value: true,
          groupValue: controller.genetic,
          onChanged: (value) => controller.onChangedgentic(value!),
        ),
      ),
      Expanded(
        flex: 3,
        child: RadioListTile<bool>(
          title: Text(
            'No',
            style: TextStyle(fontSize: getProportionateScreenWidth(11)),
          ),
          value: false,
          groupValue: controller.genetic,
          onChanged: (value) => controller.onChangedgentic(value!),
        ),
      ),
    ],
  );
}

Row buildchronicFormField(DiseaseController controller) {
  return Row(
    children: [
      Expanded(
        flex: 2,
        child: RadioListTile<bool>(
          title: Text(
            "Yes",
            style: TextStyle(fontSize: getProportionateScreenWidth(11)),
          ),
          value: true,
          groupValue: controller.chronicDisease,
          onChanged: (value) => controller.onChangedchronic(value!),
        ),
      ),
      Expanded(
        flex: 3,
        child: RadioListTile<bool>(
          title: Text(
            'No',
            style: TextStyle(fontSize: getProportionateScreenWidth(11)),
          ),
          value: false,
          groupValue: controller.chronicDisease,
          onChanged: (value) => controller.onChangedchronic(value!),
        ),
      ),
    ],
  );
}

TextFormField buildnotesFormField(DiseaseController controller) {
  return TextFormField(
    onSaved: (newValue) => controller.notesController.text = newValue!,
    controller: controller.notesController,
    maxLines: 3,
    decoration: InputDecoration(
      labelText: 'notes',
      hintText: "Enter notes",
      floatingLabelBehavior: FloatingLabelBehavior.always,
    ),
  );
}
