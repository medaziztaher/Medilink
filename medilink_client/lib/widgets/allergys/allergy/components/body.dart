import 'package:flutter/material.dart';
import 'package:medilink_client/models/allergy.dart';

import '../../../../api/user.dart';
import '../../../../settings/path.dart';

class Body extends StatefulWidget {
  const Body({super.key, required this.alergId});
  final String alergId;

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  late Future<Allergy?> allergy;
  @override
  void initState() {
    super.initState();
    allergy = getAllergy();
  }

  Future<Allergy?> getAllergy() async {
    try {
      final response =
          await networkHandler.get("$allergysPath/${widget.alergId}");
      if (response['status'] == true) {
        return Allergy.fromJson(response['data']);
      }
    } catch (e) {
      print(e);
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Allergy?>(
      future: allergy,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error fetching allergy data'));
        } else if (snapshot.hasData) {
          final allergy = snapshot.data!;
          return Card(
            child: Column(
              children: [
                ListTile(
                  title: Text('Type : '),
                  subtitle: Text('${allergy.type}'),
                ),
                SizedBox(height: 10),
                ListTile(
                  title: Text('Followup Status: '),
                  subtitle: Text('${allergy.followupStatus}'),
                ),
                SizedBox(height: 10),
                ListTile(
                  title: Text('Year Of Discovery : '),
                  subtitle: Text('${allergy.yearOfDiscovery}'),
                ),
                SizedBox(height: 10),
                ListTile(
                  title: Text('Family History: '),
                  subtitle: Text('${allergy.familyHistory}'),
                ),
                SizedBox(height: 10),
                ListTile(
                  title: Text('Notes: '),
                  subtitle: Text('${allergy.notes}'),
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
