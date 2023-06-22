import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'experience_controller.dart';

class ExperienceForm extends StatelessWidget {
  final ExperienceFormController controller =
      Get.put(ExperienceFormController());

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Obx(() => Form(
            key: controller.formKey,
            child: Column(
              children: [
                for (var i = 0; i < controller.experiences.length; i++) ...[
                  _buildExperienceFields(controller.experiences[i]),
                  SizedBox(height: 16.0),
                ],
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    GestureDetector(
                      onTap: () async {
                        await controller.addExperience;
                      },
                      child: Icon(Icons.add_circle),
                    ),
                  ],
                )
              ],
            ),
          )),
    );
  }

  Widget _buildExperienceFields(ExperienceFormData experience) {
    return Column(
      children: [
        TextFormField(
          controller: experience.positionController,
          decoration: InputDecoration(labelText: 'Position'),
          validator: (value) {
            if (value!.isEmpty) {
              return 'Please enter a position';
            }
            return null;
          },
        ),
        TextFormField(
          controller: experience.institutionController,
          decoration: InputDecoration(labelText: 'Institution'),
          validator: (value) {
            if (value!.isEmpty) {
              return 'Please enter an institution';
            }
            return null;
          },
        ),
        DateTimePicker(
          decoration: InputDecoration(labelText: 'Start Year'),
          initialValue: experience.startYear.toString(),
          firstDate: DateTime(1900),
          lastDate: DateTime.now(),
          onChanged: (value) {
            experience.startYear = DateTime.parse(value);
          },
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please select a start year';
            }
            return null;
          },
        ),
        if (!experience.isCurrentJob)
          DateTimePicker(
            decoration: InputDecoration(labelText: 'End Year'),
            initialValue: experience.endYear?.toString(),
            firstDate: experience.startYear,
            lastDate: DateTime.now(),
            onChanged: (value) {
              experience.endYear = DateTime.parse(value);
            },
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please select an end year';
              }
              return null;
            },
          ),
        CheckboxListTile(
          title: Text('I currently work here'),
          value: experience.isCurrentJob,
          onChanged: (bool? value) {
            if (value != null) {
              if (value) {
                experience.endYear = null;
              } else {
                experience.endYear = DateTime.now();
              }
            }
          },
          controlAffinity: ListTileControlAffinity.leading,
        ),
      ],
    );
  }
}