import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../../utils/size_config.dart';
import 'availibility_controller.dart';

class AvailabiltyForm extends StatelessWidget {
  const AvailabiltyForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AvailabiltyController>(
        init: AvailabiltyController(),
        builder: (controller) {
          return Form(
            key: controller.formKeyAvailibility,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text("Select Day"),
                    SizedBox(width: 5),
                    buildDayFormField(controller),
                  ],
                ),
                SizedBox(height: getProportionateScreenHeight(15)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text("Select Start"),
                    SizedBox(width: 5),
                    buildStartFormField(controller),
                  ],
                ),
                SizedBox(height: getProportionateScreenHeight(15)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text("Select End"),
                    SizedBox(width: 5),
                    buildStartFormField(controller),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    GestureDetector(
                      onTap: () async {
                        await controller.addAvailability;
                      },
                      child: Icon(Icons.add_circle),
                    ),
                  ],
                )
              ],
            ),
          );
        });
  }
}

DropdownButtonFormField<String> buildDayFormField(
    AvailabiltyController controller) {
  assert(controller.typeValues.toSet().length == controller.typeValues.length);

  String? defaultValue = controller.typeValues.first;

  if (!controller.typeValues.contains(defaultValue)) {
    defaultValue = null;
  }

  return DropdownButtonFormField<String>(
    value: defaultValue,
    onChanged: (value) => controller.onChangedDay(value),
    items: controller.typeValues
        .map((type) => DropdownMenuItem(
              value: type,
              child: Text(type),
            ))
        .toList(),
    decoration: InputDecoration(
      labelText: "Day",
      floatingLabelBehavior: FloatingLabelBehavior.always,
    ),
  );
}

DropdownButtonFormField<String> buildStartFormField(
    AvailabiltyController controller) {
  assert(controller.times.toSet().length == controller.times.length);

  String? defaultValue = controller.times.first;

  if (!controller.times.contains(defaultValue)) {
    defaultValue = null;
  }

  return DropdownButtonFormField<String>(
    value: defaultValue,
    onChanged: (value) => controller.onChangedStart(value),
    items: controller.times
        .map((type) => DropdownMenuItem(
              value: type,
              child: Text(type),
            ))
        .toList(),
    decoration: InputDecoration(
      labelText: "Day",
      floatingLabelBehavior: FloatingLabelBehavior.always,
    ),
  );
}

DropdownButtonFormField<String> buildEndFormField(
    AvailabiltyController controller) {
  assert(controller.times.toSet().length == controller.times.length);

  String? defaultValue = controller.times.first;

  if (!controller.times.contains(defaultValue)) {
    defaultValue = null;
  }

  return DropdownButtonFormField<String>(
    value: defaultValue,
    onChanged: (value) => controller.onChangedEnd(value),
    items: controller.times
        .map((type) => DropdownMenuItem(
              value: type,
              child: Text(type),
            ))
        .toList(),
    decoration: InputDecoration(
      labelText: "Day",
      floatingLabelBehavior: FloatingLabelBehavior.always,
    ),
  );
}
