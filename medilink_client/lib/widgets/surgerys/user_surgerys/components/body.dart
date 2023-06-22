import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:medilink_client/models/surgery.dart';

import '../../../../api/user.dart';
import '../../../../models/user.dart';
import '../../../../settings/path.dart';
import '../../surgery/surgery_file.dart';

class Body extends StatefulWidget {
  const Body({super.key, required this.user});
  final User user;

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  bool isLoading = false;
  List<Surgerie>? surgeries;

  @override
  void initState() {
    super.initState();
    fetchSurgeries();
  }

  Future<void> fetchSurgeries() async {
    setState(() {
      isLoading = true;
    });

    try {
      final response = await networkHandler
          .get("${patientPath}/${widget.user.id}/surgeries");
      if (response['status'] == true) {
        final data = response['data'] as List<dynamic>;
        final surgerie =
            data.map((item) => Surgerie.fromJson(item)).toList(growable: false);
        setState(() {
          surgeries = surgerie;
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
    } else if (surgeries == null || surgeries!.isEmpty) {
      return Text('No lab results available.');
    } else {
      return ListView.builder(
        itemCount: surgeries!.length,
        itemBuilder: (context, index) {
          final surgerie = surgeries![index];
          return ListTile(
            title: Text(surgerie.type!),
            subtitle: Text(surgerie.date.toString()),
            onTap: () {
              Get.to(() => SurgeryFile(surgId: surgerie.id!));
            },
          );
        },
      );
    }
  }
}
