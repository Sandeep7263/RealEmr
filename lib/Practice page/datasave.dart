import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:realemrs/DB_Hive/Models.dart';
import 'package:realemrs/Doctor_Page/Add_New_Patients.dart';
import 'package:realemrs/widgets/drawer.dart';
import 'package:hive_flutter/hive_flutter.dart';

class DoctorHomescreen extends StatefulWidget {
  @override
  State<DoctorHomescreen> createState() => _DoctorHomescreenState();
}

class _DoctorHomescreenState extends State<DoctorHomescreen> {
  final patientController = Get.put(PatientController());
  final RxBool exitConfirmed = false.obs;

  Future<bool> _onWillPop() async {
    bool? confirm = await _showExitConfirmationDialog();
    return confirm ?? false;
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
              exitConfirmed.value = true;
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
                _buildDetail('Age', patientData.age),
                _buildDetail('Gender', patientData.gender),
                _buildDetail('Email', patientData.email),
                _buildDetail('Mobile No', patientData.mobileno),
                _buildDetail('Address', patientData.address),
                _buildDetail('Country', patientData.country),
                _buildDetail('State', patientData.state),
                _buildDetail('City', patientData.city),
                _buildDetail('Religion', patientData.religion),
                _buildDetail('Occupation', patientData.occupation),
                _buildDetail('Mother Tongue', patientData.mothertongue),

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

  Widget _buildPatientList() {
    return ValueListenableBuilder<Box<EmrModels>>(
      valueListenable: Hive.box<EmrModels>("EmrModels").listenable(),
      builder: (context, box, _) {
        var data = box.values.toList().cast<EmrModels>();

        return ListView.builder(
          itemCount: data.length,
          itemBuilder: (context, index) {
            return Card(
              child: ListTile(
                title: Text('Patient Details'),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildDetail('Name', data[index].name),
                    // _buildDetail('DOB', data[index].dob),
                    // _buildDetail('Age', data[index].age),
                    // _buildDetail('Gender', data[index].gender),
                    // _buildDetail('Email', data[index].email),
                    // _buildDetail('Mobile No', data[index].mobileno),
                    // _buildDetail('Address', data[index].address),
                    // _buildDetail('Country', data[index].country),
                    // _buildDetail('State', data[index].state),
                    // _buildDetail('City', data[index].city),
                    // _buildDetail('Religion', data[index].religion),
                    // _buildDetail('Occupation', data[index].occupation),
                    // _buildDetail('Mother Tongue', data[index].mothertongue),
                    // Include other patient details similarly...
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            box.delete(data[index].key);
                          },
                          child: Text('Delete'),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            patientController.patientsList.add(data[index]);
                            Get.to(AddNewPatients());
                          },
                          child: Text('Update'),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            _showPatientDetails(data[index]);
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
              icon: Icon(Icons.search),
              onPressed: () {
              },
            ),
            IconButton(
              icon: Icon(Icons.notifications),
              onPressed: () {

              },
            ),
          ],
        ),
        drawer: MenuDrawer(),
        body: _buildPatientList(),
        bottomNavigationBar: BottomAppBar(
          child: Container(
            height: 60.0,
            child: ElevatedButton(
              onPressed: () {
                Get.to(AddNewPatients())?.then((value) {
                  if (value != null && value) {
                    Get.snackbar('Success', 'Patient data saved!');
                  }
                });
              },
              child: Text(
                'Add New Patients',
                style: TextStyle(fontSize: 20),
              ),
            ),
          ),
        ),
      ),
    );
  }

}
