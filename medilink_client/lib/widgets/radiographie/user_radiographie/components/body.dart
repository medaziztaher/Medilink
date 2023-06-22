import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:medilink_client/widgets/radiographie/radio_result/radio_result.dart';

import '../../../../api/user.dart';
import '../../../../models/radiographie.dart';
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
  List<Radiographie>? radiographies;

  @override
  void initState() {
    super.initState();
    fetchradiographies();
  }

  Future<void> fetchradiographies() async {
    setState(() {
      isLoading = true;
    });

    try {
      final response = await networkHandler
          .get("${patientPath}/${widget.user.id}/radiographies");
      if (response['status'] == true) {
        final data = response['data'] as List<dynamic>;
        final radios = data
            .map((item) => Radiographie.fromJson(item))
            .toList(growable: false);
        setState(() {
          radiographies = radios;
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
    } else if (radiographies == null || radiographies!.isEmpty) {
      return Text('No lab results available.');
    } else {
      return ListView.builder(
        itemCount: radiographies!.length,
        itemBuilder: (context, index) {
          final radio = radiographies![index];
          return ListTile(
            title: Text(radio.type!),
            subtitle: Text(radio.date.toString()),
            onTap: () {
              Get.to(() => RadioResult(radioId: radio.id!));
            },
          );
        },
      );
    }
  }
}
