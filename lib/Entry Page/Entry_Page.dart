import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:realemrs/Entry%20Page/Daignosis.dart';
import 'package:realemrs/Entry%20Page/Tablet_Select.dart';
import 'dart:async';
import 'Chief_Complaint.dart';
class EntryPage extends StatefulWidget {
  final String userName;
  final String userGender;
  final String genderIconPath;

  const EntryPage({
    Key? key,
    required this.userName,
    required this.userGender,
    required this.genderIconPath,
  }) : super(key: key);

  @override
  State<EntryPage> createState() => _EntryPageState();
}

class _EntryPageState extends State<EntryPage> {
  List<String> selectedComplaints = [];
  List<String> selectedTablets = [];
  List<String> selectedDiagnosis = [];

  void _updateComplaintsValue(List<String> updatedItems) {
    setState(() {
      selectedComplaints = updatedItems;
    });
  }

  void _updateTabletsValue(List<String> updatedItems) {
    setState(() {
      selectedTablets = updatedItems;
    });
  }
  void _openVitalInfoPopup(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Center(
              child: Text('Vital Information',style: TextStyle(
                color: Colors.blueAccent,
              ),
              )
          ),
          content: SingleChildScrollView(
            child: Container(
              // width: 600, // Set your desired width
              // height: 100,
              child: Column(
                // crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Divider(
                    color: Colors.black12,
                    thickness: 1.0,
                    indent: 5,
                    endIndent: 3,
                  ),
                  SizedBox(height: 10), // Adjusted spacing
                  Row(
                    // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                      Text('mmHg',style: TextStyle(
                        color: Colors.blueAccent
                      ),),
                    ],

                  ),
                  SizedBox(height: 10),
                  Divider(
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
                ],
              ),
            ),
          ),

          actions: [

            TextButton(
              onPressed: () {
                _openNewPopup(context); // Call the function to open the new popup
              },
              child: Text('Add New'),
            ),


            TextButton(
              onPressed: () {
                _openNewPopup(context);
              },
              child: Text('Save'),
            ),
            // SizedBox(width: 5,),
            TextButton(
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

  void _openNewPopup(BuildContext context) {
    String newItem = ''; // Variable to store the new item
    String newUnit = ''; // Variable to store the unit

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add New Vital'),
          content: Column(
            children: [
              SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 10),
                child: TextField(
                  onChanged: (value) {
                    newItem = value;
                  },
                  decoration: InputDecoration(labelText: 'Enter New Item'),
                ),
              ),
              SizedBox(height: 10),
              TextField(
                onChanged: (value) {
                  newUnit = value;
                },
                decoration: InputDecoration(labelText: 'Enter Unit'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                // Perform actions with the new item and unit (e.g., add to a list)
                print('New Item: $newItem');
                print('Unit: $newUnit');

                // Close the dialog
                Navigator.of(context).pop();
              },
              child: Text('Add'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog without adding
              },
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }




  void _updateDiagonosisValue(List<String> updatedItems) {
    setState(() {
      selectedDiagnosis = updatedItems;
    });
  }

  Future<void> _openComplaintsWindow() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChiefComplaint(
          updateSelectedValue: _updateComplaintsValue,
          initialSelectedItems: selectedComplaints,
        ),
      ),
    );
    if (result != null && result is List<String>) {
      setState(() {
        selectedComplaints = result.toSet().toList(); // Remove duplicates
      });
    }
  }

  Future<void> _openTabletSelectWindow() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TabletSelect(
          updateSelectedValue: _updateTabletsValue,
          initialSelectedItems: selectedTablets,
        ),
      ),
    );
    if (result != null && result is List<String>) {
      setState(() {
        selectedTablets = result.toSet().toList(); //  Removeduplicates
      });
    }
  }


  Future<void> _openDiagnosisSelectWindow() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DiagnosisSelect(
          updateSelectedValue: _updateDiagonosisValue,
          initialSelectedItems: selectedDiagnosis,
        ),
      ),
    );
    if (result != null && result is List<String>) {
      setState(() {
        selectedDiagnosis = result.toSet().toList(); // Remove duplicates
      });
    }
  }




  String currentDate = DateFormat('dd-MMM-yyyy').format(DateTime.now());
  late String currentTime;
  late Timer timer;

  @override
  void initState() {
    super.initState();
    currentTime = DateFormat('hh:mm:ss a').format(DateTime.now());
    timer = Timer.periodic(Duration(seconds: 1), (Timer t) {
      setState(() {
        currentTime = DateFormat('hh:mm:ss a').format(DateTime.now());
      });
    });
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant EntryPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.userName != oldWidget.userName) {
      setState(() {
        // Update any relevant state based on new widget data
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '${widget.userName} (${widget.userGender.toUpperCase()})',
          style: TextStyle(fontSize: 20),
        ),
        backgroundColor: Colors.blue,
        centerTitle: true,
        automaticallyImplyLeading: false,
        leading: Image.asset(
          widget.genderIconPath,
          width: 24,
          height: 24,
        ),


      ),

      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            // crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: 60,),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Image.asset(
                        'assets/images/schedule.png',
                        width: 24,
                        height: 24,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        currentDate,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Colors.deepPurple,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 23),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/images/clock.png',
                      width: 24,
                      height: 24,
                    ),
                    SizedBox(width: 5),
                    Expanded(
                      child: Text(
                        currentTime,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.deepPurple,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 10),
          Divider(
            thickness: 1,
            color: Colors.blueAccent,
            height: 5,
            indent: 5,
            endIndent: 5,
          ),
          SizedBox(height: 5),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,

            children: [
              Image.asset(
                'assets/images/medicine.png',
                height: 20,
                width: 20,
              ),
              Text(
                'Chief Complaints',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(width: 80),
              ElevatedButton(
                onPressed: _openComplaintsWindow,
                child: Text('View'),
              ),
            ],
          ),
          if (selectedComplaints.isNotEmpty) ...[
            SizedBox(height: 5),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: selectedComplaints
                  .map(
                    (item) => Text(
                  '- $item',
                  style: TextStyle(fontSize: 14),
                ),
              )
                  .toList(),
            ),
          ],
          Divider(
            thickness: 1,
            color: Colors.blueAccent,
            height: 5,
            indent: 5,
            endIndent: 5,
          ),
          SizedBox(height: 5),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Image.asset(
                'assets/images/drugs.png',
                height: 20,
                width: 20,
              ),
              // SizedBox(width: 5,),
              Text(
                'Tablet',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(width: 160),
              ElevatedButton(
                onPressed: _openTabletSelectWindow,
                child: Text('View'),
              ),
            ],
          ),
          if (selectedTablets.isNotEmpty) ...[
            SizedBox(height: 5),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: selectedTablets
                  .map(
                    (item) => Text(
                  '- $item',
                  style: TextStyle(fontSize: 14),
                ),
              )
                  .toList(),
            ),
          ],
          Divider(
            thickness: 1,
            color: Colors.blueAccent,
            height: 5,
            indent: 5,
            endIndent: 5,
          ),
          SizedBox(height: 5),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Image.asset(
                'assets/images/diagnosis.png',
                height: 20,
                width: 20,
              ),
              Text(
                'Diagnosis',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(width: 140),
              ElevatedButton(
                onPressed: _openDiagnosisSelectWindow,
                child: Text('View'),
              ),
            ],
          ),
          if (selectedDiagnosis.isNotEmpty) ...[
            SizedBox(height: 5),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: selectedDiagnosis
                  .map(
                    (item) => Text(
                  '- $item',
                  style: TextStyle(fontSize: 14),
                ),
              )
                  .toList(),
            ),
          ],
          Divider(
            thickness: 1,
            color: Colors.blueAccent,
            height: 5,
            indent: 5,
            endIndent: 5,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Image.asset(
                'assets/images/vital.png',
                height: 20,
                width: 20,
              ),
              Text(
                'Vital Information',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(width: 90),
              ElevatedButton(
                onPressed: () {
                  _openVitalInfoPopup(context);
                  // Call function to open the popup
                },
                child: Text('View'),
              ),
            ],
          ),

          Divider(
            thickness: 1,
            color: Colors.blueAccent,
            height: 5,
            indent: 5,
            endIndent: 5,
          ),
        ],

      ),
    );
  }
}