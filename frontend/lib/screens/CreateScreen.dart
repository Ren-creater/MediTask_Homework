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

  void _submitForm() {
    // Check if the form is valid
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save(); // Save the form data
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
      );}}

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
                    onSaved: (value) {
                      setState(() {
                        patient = value!;
                      });
                    },
                      validator: (value) {
                        // Validation function for the name field
                        if (value!.isEmpty) {
                          return "Please enter patient's name.";
                          // Return an error message if the name is empty
                        }
                        return null; // Return null if the name is valid
                      },
                  ),
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Doctor Name'),
                    keyboardType: TextInputType.name,
                    onSaved: (value) {
                      setState(() {
                        doctor = value!;
                      });
                    },
                    validator: (value) {
                      // Validation function for the name field
                      if (value!.isEmpty) {
                        return "Please enter doctor's name.";
                        // Return an error message if the name is empty
                      }
                      return null; // Return null if the name is valid
                    },
                  ),
                  InputDatePickerFormField(
                    acceptEmptyDate: false,
                    errorInvalidText: "invalid date",
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
                    onPressed: _submitForm,
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
