import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:medilink_client/api/user.dart';
import 'package:medilink_client/models/labresult.dart';
import 'package:medilink_client/widgets/labresult/components/lab_result/user_lab_result.dart';

import '../../../../../models/user.dart';
import '../../../../../settings/path.dart';

class Body extends StatefulWidget {
  const Body({super.key, required this.user});
  final User user;

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  bool isLoading = false;
  List<Labresult>? labresults;

  @override
  void initState() {
    super.initState();
    fetchLabResults();
  }

  Future<void> fetchLabResults() async {
    setState(() {
      isLoading = true;
    });

    try {
      final response = await networkHandler
          .get("${patientPath}/${widget.user.id}/labresult");
      if (response['status'] == true) {
        final data = response['data'] as List<dynamic>;
        final labresult = data
            .map((item) => Labresult.fromJson(item))
            .toList(growable: false);
        setState(() {
          labresults = labresult;
        });
      }
    } catch (e) {
      print(e);
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return CircularProgressIndicator();
    } else if (labresults == null || labresults!.isEmpty) {
      return Text('No lab results available.');
    } else {
      return ListView.builder(
        itemCount: labresults!.length,
        itemBuilder: (context, index) {
          final labResult = labresults![index];
          return ListTile(
            title: Text(labResult.test!),
            subtitle: Text(labResult.date.toString()),
            onTap: () {
              Get.to(() => LabResult(labid: labResult.id!));
            },
          );
        },
      );
    }
  }
}
