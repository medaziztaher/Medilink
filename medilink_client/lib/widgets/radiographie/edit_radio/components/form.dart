import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:medilink_client/components/form_error.dart';
import 'package:medilink_client/models/radiographie.dart';
import 'package:medilink_client/widgets/radiographie/add_radio/components/files.dart';

import '../../../../components/default_button.dart';
import '../../../../models/user.dart';

import '../../../../utils/size_config.dart';
import '../../../search/search_screen.dart';
import '../edit_radio_controller.dart';
import 'files.dart';

class EditRadioForm extends StatelessWidget {
  const EditRadioForm(
      {super.key, required this.radiographie, required this.userId});
  final Radiographie radiographie;
  final String userId;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<EditRadioController>(
      init: EditRadioController(radiographie: radiographie),
      builder: (controller) {
        return Form(
          key: controller.formKeyEditRadio,
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
                  if (userId == radiographie.patient) ...[
                    SizedBox(height: getProportionateScreenWidth(15)),
                    buildSharedWithFormField(controller),
                    buildSelectedUsersChips(controller),
                    SizedBox(height: getProportionateScreenWidth(15)),
                  ],
                  SizedBox(height: getProportionateScreenWidth(15)),
                ],
              ),
              EditradiographieFiles(radiographie: radiographie),
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

TextFormField buildTestFormField(EditRadioController controller) {
  return TextFormField(
    controller: controller.typeController,
    decoration: InputDecoration(
      labelText: 'Type',
      hintText: 'Enter the type',
      floatingLabelBehavior: FloatingLabelBehavior.always,
    ),
    validator: (value) => controller.validatetype(value),
    onChanged: (value) => controller.onChangedtype(value),
  );
}

TextFormField buildResultFormField(EditRadioController controller) {
  return TextFormField(
    controller: controller.descriptionController,
    decoration: InputDecoration(
      labelText: 'descrip^ion',
      hintText: 'Enter description',
      floatingLabelBehavior: FloatingLabelBehavior.always,
    ),
    maxLines: 3,
    validator: (value) => controller.validatedescription(value),
    onChanged: (value) => controller.onChangeddescription(value),
  );
}

TextFormField buildReasonFormField(EditRadioController controller) {
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
    EditRadioController controller) {
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
    BuildContext context, EditRadioController controller) {
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

Widget buildSelectedUsersChips(EditRadioController controller) {
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
