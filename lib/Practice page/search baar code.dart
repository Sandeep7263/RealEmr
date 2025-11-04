import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:realemrs/DB_Hive/Models.dart';
import 'package:realemrs/Doctor_Page/Add_New_Patients.dart';
import 'package:realemrs/widgets/drawer.dart';
import 'package:hive_flutter/hive_flutter.dart';

class PatientController extends GetxController {
  final patientsList = <EmrModels>[].obs;
}

class DoctorHomescreen extends StatefulWidget {
  @override
  State<DoctorHomescreen> createState() => _DoctorHomescreenState();
}

class _DoctorHomescreenState extends State<DoctorHomescreen> {
  final patientController = Get.put(PatientController());
  TextEditingController _searchController = TextEditingController();
  List<EmrModels> _searchResults = [];
  bool _isSearchBarOpened = false;

  void _performSearch(String query) {
    var data = Hive.box<EmrModels>("EmrModels").values.toList().cast<EmrModels>();

    setState(() {
      _searchResults = data.where((patient) =>
      patient.name.toLowerCase().contains(query.toLowerCase()) ||
          patient.dob.toLowerCase().contains(query.toLowerCase())).toList();
    });
  }

  Future<bool> _onWillPop() async {
    if (_isSearchBarOpened) {
      setState(() {
        _isSearchBarOpened = false;
        _searchResults.clear();
        _searchController.clear();
      });
      return false; // Prevents closing the app when back button is pressed
    } else {
      bool? confirm = await _showExitConfirmationDialog();
      return confirm ?? false;
    }
  }

  Future<bool?> _showExitConfirmationDialog() async {
    return Get.dialog<bool>(
      AlertDialog(
        title: Text('Exit App?'),
        content: Text('Are you sure you want to exit the app?'),
        actions: [
          TextButton(
            onPressed: () {
              Get.back(result: false);
            },
            child: Text('No'),
          ),
          TextButton(
            onPressed: () {
              Get.back(result: true);
              SystemNavigator.pop();
            },
            child: Text('Yes'),
          ),
        ],
      ),
    );
  }

  void _showPatientDetails(EmrModels patientData) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Patient Details'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildDetail('Name', patientData.name),
                _buildDetail('Date of Birth', patientData.dob),
                // Add other patient details here
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildSearchBar() {
    return Container(
      padding: EdgeInsets.all(16.0),
      child: TextField(
        controller: _searchController,
        onChanged: _performSearch,
        decoration: InputDecoration(
          hintText: 'Search...',
          prefixIcon: Icon(Icons.search),
          border: OutlineInputBorder(),
        ),
      ),
    );
  }

  Widget _buildPatientList() {
    return ValueListenableBuilder<Box<EmrModels>>(
      valueListenable: Hive.box<EmrModels>("EmrModels").listenable(),
      builder: (context, box, _) {
        var data = box.values.toList().cast<EmrModels>();

        return ListView.builder(
          itemCount: _searchResults.isNotEmpty ? _searchResults.length : data.length,
          itemBuilder: (context, index) {
            EmrModels patient = _searchResults.isNotEmpty ? _searchResults[index] : data[index];
            return Card(
              child: ListTile(
                title: Text('Patient Details'),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildDetail('Name', patient.name),
                    // _buildDetail('Date of Birth', patient.dob),
                    // _buildDetail('Age', patient.age),
                    // _buildDetail('Gender', patient.gender),
                    // _buildDetail('Email', patient.email),
                    // _buildDetail('Mobile No', patient.mobileno),
                    // _buildDetail('Address', patient.address),
                    // _buildDetail('Country', patient.country),
                    // _buildDetail('State', patient.state),
                    // _buildDetail('City', patient.city),
                    // _buildDetail('Religion', patient.religion),
                    // _buildDetail('Occupation', patient.occupation),
                    // _buildDetail('Mother Tongue', patient.mothertongue),





                    // Add other relevant details to display in the list
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            // Handle delete functionality
                            box.delete(patient.key);
                          },
                          child: Text('Delete'),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            // Handle update functionality
                            patientController.patientsList.add(patient);
                            Get.to(AddNewPatients());
                          },
                          child: Text('Update'),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            // Show patient details
                            _showPatientDetails(patient);
                          },
                          child: Text('View'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildDetail(String label, String? value) {
    return Text('$label: ${value ?? ''}');
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Real EMR'),
          actions: [
            IconButton(
              icon: Icon(Icons.notifications),
              onPressed: () {},
            ),
            IconButton(
              icon: Icon(Icons.search),
              onPressed: () {
                setState(() {
                  _isSearchBarOpened = !_isSearchBarOpened;
                  if (!_isSearchBarOpened) {
                    _searchResults.clear();
                    _searchController.clear();
                  }
                });
              },
            ),
          ],
        ),
        drawer: MenuDrawer(),
        body: Column(
          children: [
            if (_isSearchBarOpened) _buildSearchBar(), // Show search bar conditionally
            Expanded(
              child: _buildPatientList(),
            ),
          ],
        ),
        bottomNavigationBar: BottomAppBar(
          // Your bottom navigation bar content here
        ),
      ),
    );
  }
}

