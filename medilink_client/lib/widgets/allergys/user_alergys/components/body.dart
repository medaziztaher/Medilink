import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:medilink_client/models/allergy.dart';
import 'package:medilink_client/widgets/allergys/allergy/allergy_file.dart';

import '../../../../api/user.dart';
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
  List<Allergy>? allergys;

  @override
  void initState() {
    super.initState();
    fetchdallergys();
  }

  Future<void> fetchdallergys() async {
    setState(() {
      isLoading = true;
    });

    try {
      final response = await networkHandler
          .get("${patientPath}/${widget.user.id}/allergies");
      if (response['status'] == true) {
        final data = response['data'] as List<dynamic>;
        final allergy =
            data.map((item) => Allergy.fromJson(item)).toList(growable: false);
        setState(() {
          allergys = allergy;
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
    } else if (allergys == null || allergys!.isEmpty) {
      return Text('No lab results available.');
    } else {
      return ListView.builder(
        itemCount: allergys!.length,
        itemBuilder: (context, index) {
          final allergy = allergys![index];
          return ListTile(
            title: Text(allergy.type!),
            subtitle: Text(allergy.yearOfDiscovery.toString()),
            onTap: () {
              Get.to(() => AllergyFile(alergId: allergy.id!));
            },
          );
        },
      );
    }
  }
}
