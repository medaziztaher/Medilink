import 'package:flutter/material.dart';


import '../../../../api/user.dart';
import '../../../../models/diseases.dart';
import '../../../../settings/path.dart';


class Body extends StatefulWidget {
  const Body({super.key, required this.diseasId});
 final String diseasId;

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  late Future<Disease?> disease;
  @override
  void initState() {
    super.initState();
    disease = getDisease();
  }

  Future<Disease?> getDisease() async {
    try {
      final response =
          await networkHandler.get("$disesePath/${widget.diseasId}");
      if (response['status'] == true) {
        return Disease.fromJson(response['data']);
      }
    } catch (e) {
      print(e);
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Disease?>(
      future: disease,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error fetching Disease data'));
        } else if (snapshot.hasData) {
          final disease = snapshot.data!;
          return Card(
            child: Column(
              children: [
                ListTile(
                  title: Text('Speciality : '),
                  subtitle: Text('${disease.speciality}'),
                ),
                SizedBox(height: 10),
                ListTile(
                  title: Text('Genetic : '),
                  subtitle: Text('${disease.genetic}'),
                ),
                SizedBox(height: 10),
                ListTile(
                  title: Text('ChronicDisease : '),
                  subtitle: Text('${disease.chronicDisease}'),
                ),
                SizedBox(height: 10),
                ListTile(
                  title: Text('DetectedIn : '),
                  subtitle: Text('${disease.detectedIn}'),
                ),
                 SizedBox(height: 10),
                ListTile(
                  title: Text('CuredIn : '),
                  subtitle: Text('${disease.curedIn}'),
                ),
                SizedBox(height: 10),
                ListTile(
                  title: Text('Notes : '),
                  subtitle: Text('${disease.notes}'),
                ),
              ],
            ),
          );
        } else {
          return Center(child: Text('No lab data available'));
        }
      },
    );
  }
}
