import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:medilink_client/api/user.dart';
import 'package:medilink_client/settings/path.dart';

import '../../payment/payment_screen.dart';
import '../../user/user_screen.dart';

class Body extends StatefulWidget {
  const Body({Key? key, required this.providerId, required this.price})
      : super(key: key);

  final String providerId;
  final int? price;

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool isLoading = false;
  List<DateTime> days = [
    DateTime.now().add(Duration(days: 1)),
    DateTime.now().add(Duration(days: 2)),
    DateTime.now().add(Duration(days: 3)),
    DateTime.now().add(Duration(days: 4)),
    DateTime.now().add(Duration(days: 5)),
    DateTime.now().add(Duration(days: 6)),
  ];
  List<String> availability = [
    "07:00 am",
    "08:00 am",
    "09:00 am",
    "10:00 am",
    "11:00 am",
    "12:00 pm",
    "01:00 pm",
    "02:00 pm",
    "03:00 pm",
    "04:00 pm",
    "05:00 pm"
  ];
  late String appointmentId;
  late DateTime selectedDay;
  late String selectedTime;
  late String reason;
  String? patientId;
  int selectedDayIndex = -1;
  int selectedTimeIndex = -1;

  String? validateEmptyField(String? value) {
    if (value == null || value.isEmpty) {
      return 'This field cannot be empty';
    }
    return null;
  }

  Future<void> bookAppointment() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      isLoading = true;
    });

    Map<String, dynamic> requestData = {
      'date': selectedDay.toString(),
      'time': selectedTime,
      'reason': reason,
    };

    try {
      final response = await networkHandler.post(
          '$appointmentPath/healthcareProvider/${widget.providerId}',
          requestData);
      print(json.decode(response.body));
      print(requestData);
      if (response.statusCode == 201 || response.statusCode == 200) {
        final responseData = json.decode(response.body);
        print(responseData);
        final id = responseData['_id'];
        final patient = responseData['patientId'];
        setState(() {
          appointmentId = id;
          patientId = patient;
        });

        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Booking Successful'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('You can make the payment online.'),
                Text("${widget.price} TND")
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Get.off(() => UserScreen(userId: widget.providerId));
                },
                child: Text(
                  'Skip',
                  style: TextStyle(color: Colors.blue),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  Get.off(() => PaymentScreen(
                        appointmentId: appointmentId,
                        patientId: patientId!,
                        providerId: widget.providerId,
                      ));
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                ),
                child: Text('Pay Now'),
              ),
            ],
          ),
        );
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
    return Form(
      key: _formKey,
      child: Column(
        children: [
          Text("Choose day"),
          SizedBox(height: 8),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: List.generate(
                days.length,
                (index) => GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedDay = days[index];
                      ;
                      selectedDayIndex = index;
                    });
                  },
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    child: Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: selectedDayIndex == index
                            ? Colors.blue
                            : Colors.grey[200],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        days[index].toLocal().toString().split(' ')[0],
                        style: TextStyle(
                          color: selectedDayIndex == index
                              ? Colors.white
                              : Colors.black,
                          fontWeight: selectedDayIndex == index
                              ? FontWeight.bold
                              : FontWeight.normal,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: 16),
          Text("Choose time"),
          SizedBox(height: 8),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: List.generate(
                availability.length,
                (index) => GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedTime = availability[index];
                      selectedTimeIndex = index;
                    });
                  },
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    child: Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: selectedTimeIndex == index
                            ? Colors.blue
                            : Colors.grey[200],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        availability[index],
                        style: TextStyle(
                          color: selectedTimeIndex == index
                              ? Colors.white
                              : Colors.black,
                          fontWeight: selectedTimeIndex == index
                              ? FontWeight.bold
                              : FontWeight.normal,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: 16),
          TextFormField(
            onChanged: (value) {
              setState(() {
                reason = value;
              });
            },
            validator: validateEmptyField,
            decoration: InputDecoration(
              labelText: 'Reason',
              border: OutlineInputBorder(),
            ),
          ),
          SizedBox(height: 16),
          ElevatedButton(
            onPressed: bookAppointment,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              padding: EdgeInsets.symmetric(vertical: 16, horizontal: 32),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: isLoading
                ? CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  )
                : Text(
                    'Book Appointment',
                    style: TextStyle(fontSize: 16),
                  ),
          ),
        ],
      ),
    );
  }
}
