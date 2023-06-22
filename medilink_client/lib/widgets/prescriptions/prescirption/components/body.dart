import 'package:flutter/material.dart';
import 'package:medilink_client/models/prescription.dart';

import '../../../../api/user.dart';
import '../../../../settings/path.dart';

class Body extends StatefulWidget {
  const Body({super.key, required this.presId});
  final String presId;

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  late Future<Prescription?> prescription;
  late String? provider = null;
  @override
  void initState() {
    super.initState();
    prescription = getPrescription();
    getProviderName();
  }

  Future<Prescription?> getPrescription() async {
    try {
      final response =
          await networkHandler.get("$prescriptionsPath/${widget.presId}");
      if (response['status'] == true) {
        return Prescription.fromJson(response['data']);
      }
    } catch (e) {
      print(e);
    }
    return null;
  }

  Future<void> getProviderName() async {
    try {
      final response = await networkHandler
          .get("$prescriptionsPath/${widget.presId}/provider");
      if (response['status'] == true) {
        print("${response['data']['provider']}");
        setState(() {
          provider = response['data']['provider'];
        });
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Prescription?>(
      future: prescription,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error fetching lab data'));
        } else if (snapshot.hasData) {
          final prescription = snapshot.data!;
          return Card(
            child: Column(
              children: [
                ListTile(
                  title: Text('Medicament'),
                  subtitle: Text('${prescription.medication}'),
                ),
                SizedBox(height: 10),
                ListTile(
                  title: Text('Dosage: '),
                  subtitle: Text('${prescription.dosage}'),
                ),
                SizedBox(height: 10),
                ListTile(
                  title: Text('Frequence: '),
                  subtitle: Text('${prescription.frequency}'),
                ),
                SizedBox(height: 10),
                ListTile(
                  title: Text('Start Date: '),
                  subtitle: Text('${prescription.startDate}'),
                ),
                SizedBox(height: 10),
                ListTile(
                  title: Text('Date: '),
                  subtitle: Text('${prescription.endDate}'),
                ),
                SizedBox(height: 10),
                if (provider != null) ...[
                  ListTile(
                    title: Text('Provider: '),
                    subtitle: Text(provider!),
                  ),
                ],
                SizedBox(height: 10),
              ],
            ),
          );
        } else {
          return Center(child: Text('No prescription data available'));
        }
      },
    );
  }
}
