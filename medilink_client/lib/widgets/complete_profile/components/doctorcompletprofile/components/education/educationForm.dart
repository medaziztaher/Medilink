import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:medilink_client/widgets/complete_profile/components/doctorcompletprofile/components/education/education_controller.dart';

class EducationForm extends StatelessWidget {
  final EducationFormController controller = Get.put(EducationFormController());

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Obx(() => Form(
            key: controller.formKey,
            child: Column(
              children: [
                for (var i = 0; i < controller.educations.length; i++) ...[
                  _buildEducationFields(controller.educations[i]),
                  SizedBox(height: 16.0),
                ],
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    GestureDetector(
                      onTap: () async {
                        await controller.addeducation;
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

  Widget _buildEducationFields(EducationFormData education) {
    return Column(
      children: [
        TextFormField(
          controller: education.degreeController,
          decoration: InputDecoration(labelText: 'Position'),
          validator: (value) {
            if (value!.isEmpty) {
              return 'Please enter a position';
            }
            return null;
          },
        ),
        TextFormField(
          controller: education.institutionController,
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
          initialValue: education.startYear.toString(),
          firstDate: DateTime(1900),
          lastDate: DateTime.now(),
          onChanged: (value) {
            education.startYear = DateTime.parse(value);
          },
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please select a start year';
            }
            return null;
          },
        ),
        DateTimePicker(
          decoration: InputDecoration(labelText: 'End Year'),
          initialValue: education.endYear?.toString(),
          firstDate: education.startYear,
          lastDate: DateTime.now(),
          onChanged: (value) {
            education.endYear = DateTime.parse(value);
          },
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please select an end year';
            }
            return null;
          },
        ),
      ],
    );
  }
}
