import 'dart:async';
import 'package:flutter/material.dart';
import '../Appointment.dart';
import 'package:http/http.dart' as http;

// create a new appointment
class CreateScreen extends StatefulWidget {
  const CreateScreen({super.key});

  @override
  State<CreateScreen> createState() => _CreateScreenState();
}

class _CreateScreenState extends State<CreateScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey();

  String patient = "";
  String doctor = "";

  DateTime? selectedDate;
  TimeOfDay selectedTime = TimeOfDay.now();

  final firstDate = DateTime.now();
  final lastDate = DateTime(DateTime.now().year + 1);

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked_s = await showTimePicker(
        context: context,
        initialTime: selectedTime, builder: (BuildContext context, Widget? child) {
      return MediaQuery(
        data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: false),
        child: child!,
      );});
    if (picked_s != null && picked_s != selectedTime ) {
      setState(() {
        selectedTime = picked_s;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Appointment appointment =
    Appointment("", patient, doctor, selectedDate.toString(), selectedTime.toString());

    return Scaffold(
      appBar: AppBar(
        elevation: 8,
        title: const Text("Create An Appointment"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            Expanded(child:Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Patient Name'),
                    keyboardType: TextInputType.name,
                    onFieldSubmitted: (value) {
                      setState(() {
                        patient = value;
                      });
                    },

                  ),
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Doctor Name'),
                    keyboardType: TextInputType.name,
                    onFieldSubmitted: (value) {
                      setState(() {
                        doctor = value;
                      });
                    },
                  ),
                  InputDatePickerFormField(
                    acceptEmptyDate: false,
                    errorInvalidText: "invalid text",
                    firstDate: firstDate,
                    lastDate: lastDate,
                    onDateSubmitted: (date) {
                      setState(() {
                        selectedDate = date;
                      });
                    },
                    onDateSaved: (date) {
                      setState(() {
                        selectedDate = date;
                      });
                    },
                  ),
                  ElevatedButton(
                    onPressed: () {_selectTime(context);},
                    child: Text("pick a time: ${selectedTime.format(context)}")
                  ),
                  ElevatedButton(
                    onPressed: () {
                      if(selectedDate == null || patient == "" || doctor == "") {
                        showDialog<String>(
                          context: context,
                          builder: (BuildContext context) => AlertDialog(
                            title: const Text('Invalid Form'),
                            content: const Text('Names cannot be empty, and date must be reasonable'),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () => Navigator.pop(context, 'OK'),
                                child: const Text('OK'),
                              ),
                            ],
                          ),
                        );
                      }
                      else {
                        createAppointment(
                          http.Client(),
                            Appointment(
                              "no id",
                            patient,
                            doctor,
                            "${selectedDate!.toLocal()}".split(' ')[0],
                            selectedTime.format(context))
                        );
                      Navigator.pop(context);

                        showDialog<String>(
                          context: context,
                          builder: (BuildContext context) => AlertDialog(
                            title: const Text('Created'),
                            content: const Text('Appointment created'),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () {Navigator.pop(context, 'OK');},
                                child: const Text('OK'),
                              ),
                            ],
                          ),
                        );}},
                    child: const Text("Submit"),
                  ),
                ],
              ),
            )),
          ],
        ),
      ),
    );
  }
}
