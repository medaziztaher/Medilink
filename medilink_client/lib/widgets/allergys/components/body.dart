import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:medilink_client/components/default_button.dart';
import 'package:medilink_client/widgets/allergys/allergy_controller.dart';

import '../../../utils/size_config.dart';
import '../../diseases/diseases_controller.dart';

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
                    GetBuilder<AllergyController>(
                        init: AllergyController(),
                        builder: (controller) {
                          return Form(
                            key: controller.allergyformKey,
                            child: Column(
                              children: [
                                SizedBox(
                                    height: getProportionateScreenWidth(10)),
                                buildtypeFormField(controller),
                                SizedBox(
                                    height: getProportionateScreenWidth(15)),
                                buildfollowupStatusFormField(controller),
                                SizedBox(
                                    height: getProportionateScreenWidth(15)),
                                Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Text("hereditary disease : "),
                                      ],
                                    ),
                                    SizedBox(
                                        height:
                                            getProportionateScreenWidth(15)),
                                    buildFamilyHistoryFormField(controller),
                                  ],
                                ),
                                SizedBox(
                                    height: getProportionateScreenWidth(15)),
                                buildyearOfDicoveryFormField(context,controller),
                                SizedBox(
                                    height: getProportionateScreenWidth(15)),
                                buildnotesFormField(controller),
                                SizedBox(
                                    height: getProportionateScreenWidth(40)),
                                DefaultButton(
                                    text: 'Save',
                                    press: () async {
                                      controller.addAllergy();
                                    })
                              ],
                            ),
                          );
                        })
                  ],
                )))));
  }
}

TextFormField buildtypeFormField(AllergyController controller) {
  return TextFormField(
    onSaved: (newValue) => controller.typeController.text = newValue!,
    controller: controller.typeController,
    decoration: InputDecoration(
      labelText: "type",
      hintText: "please add type",
      floatingLabelBehavior: FloatingLabelBehavior.always,
    ),
  );
}

TextFormField buildyearOfDicoveryFormField(
    BuildContext context, AllergyController controller) {
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


TextFormField buildfollowupStatusFormField(AllergyController controller) {
  return TextFormField(
    onSaved: (newValue) => controller.followupStatusController.text = newValue!,
    controller: controller.followupStatusController,
    maxLines: 3,
    decoration: InputDecoration(
      labelText: "Follow-up status",
      hintText: "add follow up status",
      floatingLabelBehavior: FloatingLabelBehavior.always,
    ),
  );
}

Row buildFamilyHistoryFormField(AllergyController controller) {
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
          groupValue: controller.famillyhistory,
          onChanged: (value) => controller.onChangedfamillhistory(value!),
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
          groupValue: controller.famillyhistory,
          onChanged: (value) => controller.onChangedfamillhistory(value!),
        ),
      ),
    ],
  );
}

TextFormField buildnotesFormField(AllergyController controller) {
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
