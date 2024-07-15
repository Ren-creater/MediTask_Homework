import 'package:flutter/material.dart';
import '../Appointment.dart';
import 'package:http/http.dart' as http;

// view details of a specific appointment
class DetailScreen extends StatefulWidget {
  final String id;
  const DetailScreen({super.key, required this.id});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  late Future<Appointment> appointment;

  @override
  void initState() {
    super.initState();
    appointment = fetchAppointment(http.Client(), widget.id);
  }

  @override
  Widget build(BuildContext context) {
    const box = SizedBox(height: 20);
    return Scaffold(
        appBar: AppBar(
          elevation: 8,
          title: const Text('Appointment Detail'),
        ),
        body: Center(
          child: FutureBuilder<Appointment>(
            future: appointment,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Column(
                  children: [
                    box,
                    Text('Patient: ${snapshot.data!.patient}'),
                    box,
                    Text('Doctor: ${snapshot.data!.doctor}'),
                    box,
                    Text('Date: ${snapshot.data!.date}'),
                    box,
                    Text('Time: ${snapshot.data!.time}'),
                    box,
                    ElevatedButton(
                      //ask for confirmation
                        onPressed: ()=> showDialog<String>(
                        context: context,
                        builder: (BuildContext context) => AlertDialog(
                        title: const Text('Are you Sure?'),
                        content: const Text('The action cannot be undone'),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () => Navigator.pop(context, 'Cancel'),
                            child: const Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () {
                              //confirmed
                              deleteAppointment(http.Client(), snapshot.data!.id.toString());
                              Navigator.pop(context);
                              showDialog<String>(
                                context: context,
                                builder: (BuildContext context) => AlertDialog(
                                  title: const Text('Canceled'),
                                  content: const Text('Appointment canceled'),
                                  actions: <Widget>[
                                TextButton(
                                  onPressed: () {Navigator.pop(context, 'OK');
                                    Navigator.pop(context);},
                                  child: const Text('OK'),
                                ),
                              ],
                            ),
                          );},
                        child: const Text('Yes', style: TextStyle(color: Colors.red)),
                        ),
                        ],
                        ),
                        ),
                        child: const Text("Delete",
                            style: TextStyle(color: Colors.red))
                    ) // cancel an appointment
                  ]
                );
              } else if (snapshot.hasError) {
                return Text("${snapshot.error}");
              }
              return const CircularProgressIndicator();
            },
          ),
        ),
      );
  }
}