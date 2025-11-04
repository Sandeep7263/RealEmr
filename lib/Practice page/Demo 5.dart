import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void _openVitalInfoPopup(BuildContext context) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();

  String bloodPressureSystolic = prefs.getString('bloodPressureSystolic') ?? '';
  String bloodPressureDiastolic = prefs.getString('bloodPressureDiastolic') ?? '';
  String height = prefs.getString('height') ?? '';
  String diagnosis = prefs.getString('diagnosis') ?? '';
  String pulse = prefs.getString('pulse') ?? '';
  String weight = prefs.getString('weight') ?? '';
  String temperature = prefs.getString('temperature') ?? '';

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
                SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    _openNewPopup(context, (String item, String unit) {
                      // Handle the values from the new popup
                      prefs.setString('newItem', item);
                      prefs.setString('newUnit', unit);
                    });
                  },
                  child: Text('Add New'),
                ),
                SizedBox(height: 10),

                Text('New Item: ${prefs.getString('newItem') ?? ''}'),
                Text('Unit: ${prefs.getString('newUnit') ?? ''}'),

                Row(
                  children: [
                    Text('Blood Pressure:'),
                    SizedBox(width: 2),
                    Container(
                      height: 20,
                      width: 40,
                      child: TextField(
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: '',
                        ),
                      ),
                    ),
                    SizedBox(width: 2),
                    Container(
                      height: 20,
                      width: 40,
                      child: TextField(
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          hintText: '',
                        ),
                      ),
                    ),
                    SizedBox(width: 2),
                    Text('mmHg', style: TextStyle(color: Colors.blueAccent)),
                  ],
                ),
                SizedBox(height: 10), Divider(
                  color: Colors.black12,
                  thickness: 1.0,
                  indent: 5,
                  endIndent: 3,
                ),
                SizedBox(height: 10), // Adjusted spacing
                Row(
                  // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  // crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Height:'),
                    SizedBox(width: 100),
                    Container(
                      height: 20,
                      width: 45,
                      child: TextField(
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: '',
                        ),
                      ),
                    ),
                    SizedBox(width: 7),
                    Text('cms',style: TextStyle(
                        color: Colors.blueAccent
                    ),),
                  ],
                ),
                SizedBox(height: 10,),
                Divider(
                  color: Colors.black12,
                  thickness: 1.0,
                  indent: 5,
                  endIndent: 5,
                ),
                SizedBox(height: 10,),
                Row(
                  // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text('Dignosis:'),
                    SizedBox(width: 90),
                    Container(
                      height: 20,
                      width: 45,
                      child: TextField(
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: '',
                        ),
                      ),
                    ),
                    SizedBox(width: 7),
                    Text('mm',style: TextStyle(
                        color: Colors.blueAccent
                    ),
                    ),
                  ],
                ),
                SizedBox(height: 10,),

                Divider(
                  color: Colors.black12,
                  thickness: 1.0,
                  indent: 5,
                  endIndent: 5,
                ),
                Row(
                  // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Pulse:'),
                    SizedBox(width: 110),
                    Container(
                      height: 20,
                      width: 45,
                      child: TextField(
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: '',
                        ),
                      ),
                    ),
                    SizedBox(width: 7),
                    Text('/min',style: TextStyle(
                        color: Colors.blueAccent
                    ),),
                  ],
                ),
                SizedBox(height: 10,),
                Divider(
                  color: Colors.black12,
                  thickness: 1.0,
                  indent: 5,
                  endIndent: 5,
                ),
                Row(
                  // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Weight:'),
                    SizedBox(width: 110),
                    Container(
                      height: 20,
                      width: 45,
                      child: TextField(
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: '',
                        ),
                      ),
                    ),
                    SizedBox(width: 7),
                    Text('kg',style: TextStyle(
                        color: Colors.blueAccent
                    ),),
                  ],
                ),
                Divider(
                  color: Colors.black12,
                  thickness: 1.0,
                  indent: 5,
                  endIndent: 5,
                ),
                SizedBox(height: 10,),
                Row(
                  // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text('Temperature:'),
                    SizedBox(width: 70),
                    Container(
                      height: 20,
                      width: 45,
                      child: TextField(
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: '',
                        ),
                      ),
                    ),
                    SizedBox(width: 7),
                    Text('℉',style: TextStyle(
                        color: Colors.blueAccent
                    ),),
                  ],
                ),
                Divider(
                  color: Colors.black12,
                  thickness: 1.0,
                  indent: 5,
                  endIndent: 5,
                ),
                SizedBox(height: 10,),
                // Add more information as needed
              ],// ... (rest of your existing code)

                TextButton(
                  onPressed: () {
                    // Save the entered values to SharedPreferences
                    prefs.setString('bloodPressureSystolic', bloodPressureSystolic);
                    prefs.setString('bloodPressureDiastolic', bloodPressureDiastolic);
                    prefs.setString('height', height);
                    prefs.setString('diagnosis', diagnosis);
                    prefs.setString('pulse', pulse);
                    prefs.setString('weight', weight);
                    prefs.setString('temperature', temperature);

                    // Perform actions with the entered values
                    print('Blood Pressure: $bloodPressureSystolic/$bloodPressureDiastolic mmHg');
                    print('Height: $height cms');
                    print('Diagnosis: $diagnosis mm');
                    print('Pulse: $pulse /min');
                    print('Weight: $weight kg');
                    print('Temperature: $temperature ℉');

                    Navigator.of(context).pop();
                  },
                  child: Text('Save'),
                ),

                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('Close'),
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}
