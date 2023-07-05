import 'package:flutter/material.dart';
import 'package:medilink_client/api/user.dart';

import '../../../components/appointment_card.dart';
import '../../../models/appointment.dart';
import '../../../settings/path.dart';

class ComplutedAppointments extends StatefulWidget {
  const ComplutedAppointments({super.key});

  @override
  State<ComplutedAppointments> createState() => _ComplutedAppointmentsState();
}

class _ComplutedAppointmentsState extends State<ComplutedAppointments> {
  bool isLoading = false;
  List<Appointment> appointments = [];

  Future<void> getComplutedAppointments() async {
    setState(() {
      isLoading = true;
    });
    try {
      var response = await networkHandler.get("$appointmentPath/compluted");
      print(response);
      if (response['status'] == true) {
        final data = response['data'] as List<dynamic>;
        final appointment = data
            .map((item) => Appointment.fromJson(item))
            .toList(growable: false);
        setState(() {
          appointments = appointment;
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
  void initState() {
    super.initState();
    getComplutedAppointments();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: [
          if (isLoading) ...[
            CircularProgressIndicator(),
          ] else if (appointments.isEmpty) ...[
            Center(child: Text('No appointments today')),
          ] else ...[
            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                physics: const ClampingScrollPhysics(),
                itemCount: appointments.length,
                itemBuilder: (context, index) {
                  final appointment = appointments[index];
                  return AppointmentCard(appointment: appointment);
                },
              ),
            ),
          ],
        ],
      ),
    );
  }
}
