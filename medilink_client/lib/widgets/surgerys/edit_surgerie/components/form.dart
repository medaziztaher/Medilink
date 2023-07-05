import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:medilink_client/components/form_error.dart';
import 'package:medilink_client/models/surgery.dart';
import '../../../../components/default_button.dart';


import '../../../../utils/size_config.dart';
import '../../../search/search_screen.dart';

import '../edit_surgerie_controller.dart';
import 'files.dart';

class EditSurgerieForm extends StatelessWidget {
  const EditSurgerieForm(
      {super.key, required this.surgerie, required this.userId});
  final Surgerie surgerie;
  final String userId;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<EditSurgerieController>(
      init: EditSurgerieController(surgerie: surgerie),
      builder: (controller) {
        return Form(
          key: controller.formKeyEditSurgerie,
          child: Column(
            children: [
              Column(
                children: [
                  buildTypeFormField(controller),
                  SizedBox(height: getProportionateScreenWidth(15)),
                  builddescriptionFormField(controller),
                  SizedBox(height: getProportionateScreenWidth(15)),
                  buildcomplicationsFormField(controller),
                  SizedBox(height: getProportionateScreenWidth(15)),
                  buildDateFormField(context, controller),
                  if (userId == surgerie.patient) ...[
                    SizedBox(height: getProportionateScreenWidth(15)),
                    buildSharedWithFormField(controller),
                    buildSelectedUsersChips(controller),
                    SizedBox(height: getProportionateScreenWidth(15)),
                  ],
                  SizedBox(height: getProportionateScreenWidth(15)),
                ],
              ),
              EditSurgeryFile(surgerie: surgerie),
              SizedBox(height: getProportionateScreenWidth(15)),
              FormError(errors: controller.errors),
              SizedBox(height: getProportionateScreenWidth(40)),
              Obx(() {
                if (controller.isLoading.value == false) {
                  return DefaultButton(
                    text: "kbutton1".tr,
                    press: () async {
                      controller.updateSurgerie();
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

TextFormField buildTypeFormField(EditSurgerieController controller) {
  return TextFormField(
    controller: controller.typeController,
    decoration: InputDecoration(
      labelText: 'Type',
      hintText: 'Enter Type',
      floatingLabelBehavior: FloatingLabelBehavior.always,
    ),
    validator: (value) => controller.validatetype(value),
    onChanged: (value) => controller.onChangedtype(value),
  );
}

TextFormField builddescriptionFormField(EditSurgerieController controller) {
  return TextFormField(
    controller: controller.descriptionController,
    decoration: InputDecoration(
      labelText: 'description',
      hintText: 'Enter the description',
      floatingLabelBehavior: FloatingLabelBehavior.always,
    ),
    maxLines: 3,
    validator: (value) => controller.validatedescription(value),
    onChanged: (value) => controller.onChangeddescription(value),
  );
}

TextFormField buildcomplicationsFormField(EditSurgerieController controller) {
  return TextFormField(
    controller: controller.complicationsController,
    decoration: InputDecoration(
      labelText: 'complications',
      hintText: 'Enter the complications',
      floatingLabelBehavior: FloatingLabelBehavior.always,
    ),
    validator: (value) => controller.validatecomplications(value),
    onChanged: (value) => controller.onChangedcomplications(value),
  );
}

TypeAheadFormField<String> buildSharedWithFormField(
    EditSurgerieController controller) {
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
    BuildContext context, EditSurgerieController controller) {
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
      hintText: 'enter the date',
      floatingLabelBehavior: FloatingLabelBehavior.always,
    ),
    validator: (value) => controller.validatedate(value),
  );
}

Widget buildSelectedUsersChips(EditSurgerieController controller) {
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
