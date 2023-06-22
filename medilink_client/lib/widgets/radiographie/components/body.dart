import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:medilink_client/widgets/radiographie/radiographie_controller.dart';

import '../../../components/default_button.dart';
import '../../../utils/size_config.dart';
import '../../search/search_screen.dart';
import 'file.dart';

class Body extends StatelessWidget {
  const Body({super.key, required this.userId});
  final String userId;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SizedBox(
        width: double.infinity,
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: getProportionateScreenWidth(20),
          ),
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: SizeConfig.screenHeight * 0.03),
                GetBuilder<RadiographieController>(
                  init: RadiographieController(userId: userId),
                  builder: (controller) {
                    return Form(
                      key: controller.radioformKey,
                      child: Column(
                        children: [
                          SizedBox(height: getProportionateScreenWidth(10)),
                          buildTypeFormField(controller),
                          SizedBox(height: getProportionateScreenWidth(15)),
                          buildReasonFormField(controller),
                          SizedBox(height: getProportionateScreenWidth(15)),
                          builddescriptionFormField(controller),
                          SizedBox(height: getProportionateScreenWidth(15)),
                          buildDateFormField(context, controller),
                          SizedBox(height: getProportionateScreenWidth(15)),
                          buildSharedWithFormField(controller),
                          buildSelectedUsersChips(controller),
                          SizedBox(height: getProportionateScreenWidth(15)),
                          RadioUpload(userId: userId),
                          SizedBox(height: getProportionateScreenWidth(40)),
                          DefaultButton(
                            text: "Save",
                            press: () async {
                              await controller.addRadio();
                            },
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  TextFormField buildTypeFormField(RadiographieController controller) {
    return TextFormField(
      controller: controller.typeController,
      decoration: InputDecoration(
        labelText: 'Type',
        hintText: 'Enter the type',
        border: OutlineInputBorder(),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter the type';
        }
        return null;
      },
    );
  }

  TextFormField builddescriptionFormField(RadiographieController controller) {
    return TextFormField(
      controller: controller.descriptionController,
      decoration: InputDecoration(
        labelText: 'description',
        hintText: 'Enter the description',
        border: OutlineInputBorder(),
      ),
      maxLines: 3,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter the description';
        }
        return null;
      },
    );
  }

  TextFormField buildReasonFormField(RadiographieController controller) {
    return TextFormField(
      controller: controller.reasonController,
      decoration: InputDecoration(
        labelText: 'Reason',
        hintText: 'Enter the reason',
        border: OutlineInputBorder(),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter the reason';
        }
        return null;
      },
    );
  }

  TypeAheadFormField<String> buildSharedWithFormField(
      RadiographieController controller) {
    return TypeAheadFormField<String>(
      textFieldConfiguration: TextFieldConfiguration(
        controller: controller.selectedUsersController,
        decoration: InputDecoration(
          labelText: 'Shared With (Doctors)',
          hintText: 'Search and select doctors',
          border: OutlineInputBorder(),
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
      /*validator: (value) {
        if (controller.selectedUsers.isEmpty) {
          return 'Please select at least one doctor';
        }
        return null;
      },*/
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
      BuildContext context, RadiographieController controller) {
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

  Widget buildSelectedUsersChips(RadiographieController controller) {
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
}
