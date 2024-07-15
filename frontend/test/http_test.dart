import 'package:flutter_test/flutter_test.dart';
import 'dart:convert';
import 'package:frontend/api.dart';
import 'package:frontend/Appointment.dart';

import 'package:http/http.dart' as http;
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'http_test.mocks.dart';

@GenerateMocks([http.Client])
void main() {
  group('Appointment API Tests', () {

    test('GET /appointments/', () async {
      final client = MockClient();

      final response = jsonEncode([
        {
          "id": "1",
          "patient": "John Doe",
          "doctor": "Dr. Smith",
          "date": "2024-07-15",
          "time": "10:00:00"
        }
      ]);

      when(client.get(Uri.parse(serverURL)))
          .thenAnswer((_) async => http.Response(response, 200));

      // Call function to fetch appointments
      Example: final appointments = await listAppointments(client);

      // Verify the response
      expect(appointments, isNotEmpty);
    });

    test('POST /appointments/', () async {
      final client = MockClient();

      final newAppointment = Appointment(
        "", "Dr. Brown",
        "Jane Doe",
        "2024-07-16",
        "11:00:00"
        );

      final rawAppointment = {
        "patient": "Jane Doe",
        "doctor": "Dr. Brown",
        "date": "2024-07-16",
        "time": "11:00:00"
      };

      when(client.post(
        Uri.parse(serverURL),
        headers: anyNamed('headers'),
        body: jsonEncode(rawAppointment),
      )).thenAnswer((_) async => http.Response(jsonEncode(rawAppointment), 201));

      // Call function to create an appointment
      final response = await createAppointment(client, newAppointment);

      // Verify the response
      expect(response.statusCode, 201);
    });

    test('GET /appointments/id/', () async {
      final client = MockClient();

      final response = jsonEncode({
        "id": "1",
        "patient": "John Doe",
        "doctor": "Dr. Smith",
        "date": "2024-07-15",
        "time": "10:00:00"
      });

      when(client.get(Uri.parse("${serverURL}1/")))
          .thenAnswer((_) async => http.Response(response, 200));

      // Call function to fetch an appointment by id
      final appointment = await fetchAppointment(client, '1');

      // Verify the response
      expect(appointment.patient, 'John Doe');
    });

    test('DELETE /appointments/id/', () async {
      final client = MockClient();
      when(client.delete(Uri.parse("${serverURL}1/")))
          .thenAnswer((_) async => http.Response('', 204));

      // Call function to delete an appointment
      final response = await deleteAppointment(client, '1');

      // Verify the response
      expect(response.statusCode, 204);
    });
  });
}
