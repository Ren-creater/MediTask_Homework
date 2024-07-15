import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import '../api.dart';

class Appointment {
  late String id;
  late String doctor;
  late String patient;
  late String date;
  late String time;

  Appointment(this.id, this.doctor, this.patient, this.date, this.time);

  Appointment.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    doctor = json['doctor'];
    patient = json['patient'];
    date = json['date'];
    time = json['time'];
  }
}

// GET /appointments/
Future<List<Appointment>> listAppointments(http.Client client) async {
  var url = Uri.parse(serverURL);
  final response = await client.get(url);
  final List body = json.decode(response.body);
  return body.map((e) => Appointment.fromJson(e)).toList();
}

// GET /appointments/<id>/
Future<Appointment> fetchAppointment(http.Client client, String id) async {
  var url = Uri.parse("$serverURL$id/");
  final response = await client.get(url);

  // Appropriate action depending upon the
  // server response
  if (response.statusCode == 200) {
    return Appointment.fromJson(json.decode(response.body));
  } else {
    throw Exception('Failed to load appointment');
  }
}

// POST /appointments/
Future<Response> createAppointment(http.Client client,
    Appointment appointment) async {
  var url = Uri.parse(serverURL);
  final http.Response response = await client.post(
    url,
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, dynamic>{
      'patient': appointment.patient,
      'doctor': appointment.doctor,
      'date': appointment.date,
      'time': appointment.time
    }),
  );
  return response;
}

//DELETE /appointments/<id>/
Future<Response> deleteAppointment(http.Client client, String id) async {
  var url = Uri.parse("$serverURL$id/");
  final http.Response response = await client.delete(url);
  return response;
}

