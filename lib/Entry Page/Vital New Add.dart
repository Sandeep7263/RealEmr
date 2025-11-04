import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class YourWidget extends StatefulWidget {
  @override
  _YourWidgetState createState() => _YourWidgetState();
}

class _YourWidgetState extends State<YourWidget> {
  String bloodPressureSystolic = '';
  String bloodPressureDiastolic = '';
  String height = '';
  String diagnosis = '';
  String pulse = '';
  String weight = '';
  String temperature = '';

  @override
  void initState() {
    super.initState();
    _loadValues();
  }

  Future<void> _loadValues() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      bloodPressureSystolic = prefs.getString('bloodPressureSystolic') ?? '';
      bloodPressureDiastolic = prefs.getString('bloodPressureDiastolic') ?? '';
      height = prefs.getString('height') ?? '';
      diagnosis = prefs.getString('diagnosis') ?? '';
      pulse = prefs.getString('pulse') ?? '';
      weight = prefs.getString('weight') ?? '';
      temperature = prefs.getString('temperature') ?? '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        _openVitalInfoPopup(context);
      },
      child: Text('Open Dialog'),
    );
  }

  void _openVitalInfoPopup(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Center(
            child: Text(
              'Vital Information',
              style: TextStyle(
                color: Colors.blueAccent,
              ),
            ),
          ),
          content: SingleChildScrollView(
            child: Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // Your dialog content here
                  Text('Blood Pressure Systolic: $bloodPressureSystolic'),
                  Text('Blood Pressure Diastolic: $bloodPressureDiastolic'),
                  Text('Height: $height'),
                  Text('Diagnosis: $diagnosis'),
                  Text('Pulse: $pulse'),
                  Text('Weight: $weight'),
                  Text('Temperature: $temperature'),
                ],
              ),
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }
}
