import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:medilink_client/models/labresult.dart';

import '../../../../components/default_button.dart';
import '../../../../components/form_error.dart';
import '../../../../utils/size_config.dart';
import '../../../search/search_screen.dart';
import '../edit_analyse_controller.dart';
import 'files.dart';

class EditAnalyseForm extends StatelessWidget {
  const EditAnalyseForm(
      {super.key, required this.analyse, required this.userId});
  final Labresult analyse;
  final String userId;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<EditAnalyseController>(
      init: EditAnalyseController(analyse: analyse),
      builder: (controller) {
        return Form(
          key: controller.formKeyEditAnalyse,
          child: Column(
            children: [
              Column(
                children: [
                  buildTestFormField(controller),
                  SizedBox(height: getProportionateScreenWidth(15)),
                  buildReasonFormField(controller),
                  SizedBox(height: getProportionateScreenWidth(15)),
                  buildResultFormField(controller),
                  SizedBox(height: getProportionateScreenWidth(15)),
                  buildDateFormField(context, controller),
                  if (userId == analyse.patient) ...[
                    SizedBox(height: getProportionateScreenWidth(15)),
                    buildSharedWithFormField(controller),
                    buildSelectedUsersChips(controller),
                    SizedBox(height: getProportionateScreenWidth(15)),
                  ],
                  SizedBox(height: getProportionateScreenWidth(15)),
                ],
              ),
              EditAnalyseFiles(analyse: analyse),
              SizedBox(height: getProportionateScreenWidth(15)),
              FormError(errors: controller.errors),
              SizedBox(height: getProportionateScreenWidth(40)),
              Obx(() {
                if (controller.isLoading.value == false) {
                  return DefaultButton(
                    text: "kbutton1".tr,
                    press: () async {
                      controller.updateAnalyese();
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

TextFormField buildTestFormField(EditAnalyseController controller) {
  return TextFormField(
    controller: controller.testController,
    decoration: InputDecoration(
      labelText: 'Test',
      hintText: 'Enter the test name',
      floatingLabelBehavior: FloatingLabelBehavior.always,
    ),
    validator: (value) => controller.validatetest(value),
    onChanged: (value) => controller.onChangedtest(value),
  );
}

TextFormField buildResultFormField(EditAnalyseController controller) {
  return TextFormField(
    controller: controller.resultController,
    decoration: InputDecoration(
      labelText: 'Result',
      hintText: 'Enter the lab result',
      floatingLabelBehavior: FloatingLabelBehavior.always,
    ),
    maxLines: 3,
    validator: (value) => controller.validateresult(value),
    onChanged: (value) => controller.onChangedresult(value),
  );
}

TextFormField buildReasonFormField(EditAnalyseController controller) {
  return TextFormField(
    controller: controller.reasonController,
    decoration: InputDecoration(
      labelText: 'Reason',
      hintText: 'Enter the reason',
      floatingLabelBehavior: FloatingLabelBehavior.always,
    ),
    validator: (value) => controller.validatereason(value),
    onChanged: (value) => controller.onChangedreason(value),
  );
}

TypeAheadFormField<String> buildSharedWithFormField(
    EditAnalyseController controller) {
  return TypeAheadFormField<String>(
    textFieldConfiguration: TextFieldConfiguration(
      controller: controller.selectedUsersController,
      decoration: InputDecoration(
        labelText: 'Shared With (Doctors)',
        hintText: 'Search and select doctors',
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
    ),
    suggestionsCallback: (pattern) async {
      final suggestions = await controller.fetchHealthcareProviders(pattern);
      return suggestions;
    },
    itemBuilder: (context, suggestion) {
      return ListTile(
        title: Text(suggestion),
      );
    },
    onSuggestionSelected: (suggestion) {
      controller.addUserToSharedWith(suggestion);
      controller.selectedUsersController.clear();
    },
    noItemsFoundBuilder: (context) {
      return ListTile(
        title: SingleChildScrollView(
          child: Column(
            children: [
              Text("You don't have any doctors"),
              SizedBox(height: getProportionateScreenWidth(10)),
              GestureDetector(
                child: Text(
                  "Add doctor",
                  style: TextStyle(
                    color: Colors.blue,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onTap: () => Get.off(() => SearchScreen()),
              ),
            ],
          ),
        ),
      );
    },
  );
}

TextFormField buildDateFormField(
    BuildContext context, EditAnalyseController controller) {
  return TextFormField(
    controller: controller.dateController,
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
        controller.dateController.text = formattedDate;
      }
    },
    decoration: InputDecoration(
      labelText: 'Date',
      hintText: 'Enter the date',
      floatingLabelBehavior: FloatingLabelBehavior.always,
    ),
    validator: (value) => controller.validatedate(value),
  );
}

Widget buildSelectedUsersChips(EditAnalyseController controller) {
  return Wrap(
    spacing: 8.0,
    runSpacing: 4.0,
    children: controller.selectedUsers.map((user) {
      return Chip(
        label: Text(user),
        onDeleted: () => controller.removeUserFromSharedWith(user),
        backgroundColor: Colors.blue,
        deleteIconColor: Colors.white,
        labelStyle: TextStyle(color: Colors.white),
      );
    }).toList(),
  );
}
