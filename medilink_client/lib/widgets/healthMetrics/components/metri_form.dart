import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../components/default_button.dart';
import '../../../utils/constatnts.dart';
import '../../../utils/size_config.dart';
import '../health_metric_controller.dart';

class MetricForm extends StatelessWidget {
  const MetricForm({Key? key, required this.metric}) : super(key: key);
  final String metric;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SizedBox(
        width: double.infinity,
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: getProportionateScreenWidth(20),
          ),
          child: Column(
            children: [
              SizedBox(height: SizeConfig.screenHeight * 0.07),
              Center(
                child: Column(
                  children: [
                    Text("Add New ", style: headingStyle),
                    Text("${metric} value", style: headingStyle),
                  ],
                ),
              ),
              SizedBox(height: SizeConfig.screenHeight * 0.10),
              Expanded(
                child: GetBuilder<MetricController>(
                  init: MetricController(),
                  builder: (controller) {
                    controller.setMetric(metric);
                    return Form(
                      key: controller.formKeyMetric,
                      child: Column(
                        children: [
                          SizedBox(height: getProportionateScreenHeight(15)),
                          buildValueFormField(controller),
                          Spacer(),
                          Align(
                            alignment: Alignment.bottomCenter,
                            child: DefaultButton(
                              text: "Continue",
                              press: () {
                                controller.submitForm();
                              },
                            ),
                          ),
                          SizedBox(height: SizeConfig.screenHeight * 0.03),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  TextFormField buildValueFormField(MetricController controller) {
    return TextFormField(
      keyboardType: TextInputType.phone,
      onSaved: (newValue) => controller.valueController.text = newValue!,
      controller: controller.valueController,
      decoration: InputDecoration(
        labelText: metric,
        hintText: "Enter new ${metric} value",
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
    );
  }
}
