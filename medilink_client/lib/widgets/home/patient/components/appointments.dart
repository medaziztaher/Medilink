import 'package:flutter/material.dart';
import 'package:medilink_client/api/user.dart';

import '../../../../components/appointment_card.dart';
import '../../../../models/appointment.dart';
import '../../../../settings/path.dart';
import '../../../../utils/size_config.dart';

class Appointments extends StatefulWidget {
  const Appointments({Key? key}) : super(key: key);

  @override
  State<Appointments> createState() => _AppointmentsState();
}

class _AppointmentsState extends State<Appointments> {
  bool isLoading = false;
  List<Appointment> appointments = [];

  Future<void> getAppointments() async {
    setState(() {
      isLoading = true;
    });

    try {
      final response =
          await networkHandler.get("$appointmentPath/appointments");
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
    getAppointments();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding:
              EdgeInsets.symmetric(horizontal: SizeConfig.screenHeight * 0.02),
          child: Text(
            "Upcoming Appointments",
            style: Theme.of(context).textTheme.titleLarge!.copyWith(
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1,
                ),
          ),
        ),
        SizedBox(height: SizeConfig.screenHeight * 0.01),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Container(
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
          ),
        ),
      ],
    );
  }
}
