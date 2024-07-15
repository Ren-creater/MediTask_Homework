import 'package:flutter/material.dart';
import './DetailScreen.dart';
import './CreateScreen.dart';
import '../Appointment.dart';
import 'package:http/http.dart' as http;

// list all appointments
// home screen class
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

// home screen state
class _HomeScreenState extends State<HomeScreen> {

  // variable to call and store future list of appointments
  Future<List<Appointment>> appointmentsFuture = listAppointments(http.Client());

  // build function
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 8,
        title: const Text("MediTask", style: TextStyle(color: Colors.purple)),
      ),
      body: Center(
        // FutureBuilder
        child: FutureBuilder<List<Appointment>>(
          future: appointmentsFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              // until data is fetched, show loader
              return const CircularProgressIndicator();
            } else if (snapshot.hasData) {
              // once data is fetched, display it on screen (call buildAppointments())
              final appointments = snapshot.data!;
              return buildAppointments(appointments);
            } else {
              // if no data, show simple Text
              return const Text("No Data");
            }
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const CreateScreen(),
            ),
          );
        },
        tooltip: 'create appointment',
        child: const Icon(Icons.add),
      ),
    );
  }

  // function to display fetched data on screen
  Widget buildAppointments(List<Appointment> appointments) {
    if (appointments.isEmpty) {
      return const Text("No Appointments Yet.");
    }
    // ListView Builder to show data in a list
    return ListView.builder(
      itemCount: appointments.length,
      itemBuilder: (context, index) {
        final appointment = appointments[index];
        return Container(
          color: Colors.grey.shade300,
          margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
          padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
          height: 100,
          width: double.maxFinite,
          child: Column(children:[
            Text("Appointment ${index + 1}",
                style: const TextStyle(fontSize: 15, color: Colors.purple)),
            Text("Doctor: ${appointment.doctor}"),
              ElevatedButton(
                child: const Text('Detail'),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DetailScreen(id: appointment.id),
                    ),
                  );
                },
              )])
        );
      },
    );
  }
}