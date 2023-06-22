import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:medilink_client/widgets/prescriptions/prescirption/prescription.dart';

import '../../../../api/user.dart';
import '../../../../models/prescription.dart';
import '../../../../models/user.dart';
import '../../../../settings/path.dart';

class Body extends StatefulWidget {
  const Body({super.key, required this.user});
  final User user;

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  bool isLoading = false;
  List<Prescription>? prescriptions;

  @override
  void initState() {
    super.initState();
    fetchPrescriptions();
  }

  Future<void> fetchPrescriptions() async {
    setState(() {
      isLoading = true;
    });

    try {
      final response = await networkHandler
          .get("${patientPath}/${widget.user.id}/prescriptions");
      if (response['status'] == true) {
        final data = response['data'] as List<dynamic>;
        final prescription = data
            .map((item) => Prescription.fromJson(item))
            .toList(growable: false);
        setState(() {
          prescriptions = prescription;
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
    } else if (prescriptions == null || prescriptions!.isEmpty) {
      return Text('No lab results available.');
    } else {
      return ListView.builder(
        itemCount: prescriptions!.length,
        itemBuilder: (context, index) {
          final prescription = prescriptions![index];
          return ListTile(
            title: Text(prescription.medication!),
            subtitle: Text(prescription.createdAt.toString()),
            onTap: () {
              Get.off(() => PrescriptionFile(presId: prescription.id!));
            },
          );
        },
      );
    }
  }
}
