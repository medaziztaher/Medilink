import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:medilink_client/models/diseases.dart';
import 'package:medilink_client/widgets/diseases/disease/disease_file.dart';

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
  List<Disease>? diseases;

  @override
  void initState() {
    super.initState();
    fetchdDiseases();
  }

  Future<void> fetchdDiseases() async {
    setState(() {
      isLoading = true;
    });

    try {
      final response =
          await networkHandler.get("${patientPath}/${widget.user.id}/diseases");
      if (response['status'] == true) {
        final data = response['data'] as List<dynamic>;
        final disease =
            data.map((item) => Disease.fromJson(item)).toList(growable: false);
        setState(() {
          diseases = disease;
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
    } else if (diseases == null || diseases!.isEmpty) {
      return Text('No lab results available.');
    } else {
      return ListView.builder(
        itemCount: diseases!.length,
        itemBuilder: (context, index) {
          final disease = diseases![index];
          return ListTile(
            title: Text(disease.speciality!),
            subtitle: Text(disease.detectedIn.toString()),
            onTap: () {
              Get.to(() => DiseaseFile(diseasId: disease.id!));
            },
          );
        },
      );
    }
  }
}
