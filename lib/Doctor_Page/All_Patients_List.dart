import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:intl/intl.dart';
import 'package:realemrs/DB_Hive/Models.dart';
import 'package:realemrs/Entry%20Page/Entry_Page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class AllPatientsScreen extends StatelessWidget {
  void addNewPatient(EmrModels newPatient) {

    patients.add(newPatient);


    _savePatientData(newPatient);
  }
  Future<void> _savePatientData(EmrModels patientData) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String currentDate = DateFormat('dd/MM/yy').format(DateTime.now());
    String formattedCreationDate = DateFormat('dd/MM/yy').format(patientData.creationDateTime.toLocal());

    await prefs.setString('Date', currentDate);

    final box = Hive.box<EmrModels>('EmrModels');
    box.add(patientData);
  }
  final Map<String, String> genderImageMap = {
    'male': 'assets/images/male.png',
    'female': 'assets/images/female.png',
    'other' : 'assets/images/transgender1.png',
    // You can add other genders and their respective image paths here
  };
  late final List<EmrModels> patients;

  AllPatientsScreen({required this.patients});
  Widget _buildGenderIcon(String gender) {
    String imagePath;
    switch (gender) {
      case 'Male':
        imagePath =  'assets/images/male.png'; // Replace with your male image asset path
        break;
      case 'Female':
        imagePath = 'assets/images/female.png'; // Replace with your female image asset path
        break;
      case 'Other':
        imagePath = 'assets/images/transgender1.png'; // Replace with your other gender image asset path
        break;
      default:
        imagePath = 'assets/default_image.png'; // Replace with a default image asset path
    }

    return Image.asset(
      imagePath,
      width: 30,
      height: 30,
      fit: BoxFit.cover,
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('All Patients')),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              showSearch(
                context: context,
                delegate: PatientSearchDelegate(context, patients),
              );
            },
          ),
        ],
      ),
      body: _buildPatientList(),
    );
  }

  Widget _buildPatientList() {
    return ValueListenableBuilder<Box<EmrModels>>(
      valueListenable: Hive.box<EmrModels>("EmrModels").listenable(),
      builder: (context, box, _) {
        var data = box.values.toList().cast<EmrModels>();

        if (data.isEmpty) {
          return Center(
            child: Text('No Record Found'),
          );
        }

        return ListView.builder(
          itemCount: data.length,
          itemBuilder: (context, index) {
            EmrModels patient = data[index];

            return Container(
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: Card(
                  elevation: 4,
                  shadowColor: Colors.pinkAccent,
                  color: Colors.blue,
                  child: ListTile(
                    title: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [

                        Text(
                          'Date: ${DateFormat('dd/MM/yyyy').format(patient.creationDateTime.toLocal())}',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 10), // Adjust the spacing between details
                        Row(
                          children: [
                            _buildGenderIcon(patient.gender),
                            SizedBox(width: 4),
                            _buildDetail(": ${patient.name}", "(${patient.age})", textColor: Colors.white),
                          ],
                        ),
                        SizedBox(height: 10), // Adjust the spacing between details
                        _buildDetail('', patient.mobileno, textColor: Colors.white, icon: Icons.phone), // Additional detail
                        SizedBox(height: 5), // Adjust the spacing between details
                        _buildDetail('', patient.email, textColor: Colors.white, icon: Icons.email), // Additional detail
                        SizedBox(height: 5), // Adjust the spacing between details
                        _buildDetail('', patient.address, textColor: Colors.white, icon: Icons.add_location), // Additional detail
                        SizedBox(height: 10), // Adjust the spacing between details
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            ElevatedButton(
                              onPressed: () {

                              },
                              child: Text(
                                'History',
                                style: TextStyle(
                                  color: Colors.red,
                                ),
                              ),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                String imagePath;
                                String gender = patient.gender.toLowerCase();

                                switch (gender) {
                                  case 'male':
                                    imagePath = 'assets/images/male.png';
                                    break;
                                  case 'female':
                                    imagePath = 'assets/images/female.png';
                                    break;
                                  default:
                                    imagePath = 'assets/images/transgender1.png';
                                    break;
                                }

                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => EntryPage(
                                      userName: patient.name,
                                      userGender: patient.gender,
                                      genderIconPath: imagePath, // Pass the selected image path to the EntryPage
                                    ),
                                  ),
                                );
                              },
                              child: Text('Entry'),
                            ),





                            ElevatedButton(
                              onPressed: () {
                                _showPatientDetails(context, patient, box);
                              },
                              child: Text(
                                'View',
                                style: TextStyle(color: Colors.green),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );




          },
        );
      },
    );
  }

  Widget _buildDetail(String label, String? value, {Color? textColor, IconData? icon}) {
    return Row(
      children: [
        if (icon != null) // Display icon if provided
          Icon(icon, color: textColor),
        SizedBox(width: 4),
        GestureDetector(
          onTap: () {
            if (value != null) {
              launch('tel:$value'); // Opens the phone dialer with the provided number
            }
          },
          child: Container(
            constraints: BoxConstraints(maxWidth: 250), // Adjust the width as needed
            child: Text(
              '$label: ${value ?? ''}',
              style: TextStyle(color: textColor),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
      ],
    );
  }


  void _showDeleteConfirmationDialog(BuildContext context, EmrModels patient, Box<EmrModels> box) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Delete Patient',
            style: TextStyle(
              color: Colors.red,
            ),
          ),
          content: Text('Are you sure you want to delete this patient?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('No'),
            ),
            TextButton(
              onPressed: () {
                box.delete(patient.key);
                Navigator.pop(context); // Close the dialog
                Navigator.pop(context); // Close the view pop-up window
              },
              child: Text('Yes'),
            ),
          ],
        );
      },
    );
  }

  void _showUpdateDialog(BuildContext context, EmrModels patientData, Box<EmrModels> box) {
    TextEditingController nameController = TextEditingController(text: patientData.name);
    TextEditingController dobController = TextEditingController(text: patientData.dob);
    TextEditingController ageController = TextEditingController(text: patientData.age);
    TextEditingController genderController = TextEditingController(text: patientData.gender);
    TextEditingController emailController = TextEditingController(text: patientData.email);
    TextEditingController mobilenoController = TextEditingController(text: patientData.mobileno);
    TextEditingController addressController = TextEditingController(text: patientData.address);
    TextEditingController countryController = TextEditingController(text: patientData.country);
    TextEditingController stateController = TextEditingController(text: patientData.state);
    TextEditingController cityController = TextEditingController(text: patientData.city);
    TextEditingController religionController = TextEditingController(text: patientData.religion);
    TextEditingController occupationController = TextEditingController(text: patientData.occupation);
    TextEditingController mothertongueController = TextEditingController(text: patientData.mothertongue);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Update Patient Details'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(labelText: 'Name'),
                ),
                TextField(
                  controller: dobController,
                  decoration: InputDecoration(labelText: 'Date of Birth'),
                ),
                TextField(
                  controller: ageController,
                  decoration: InputDecoration(labelText: 'Age'),
                ),
                TextField(
                  controller: genderController,
                  decoration: InputDecoration(labelText: 'Gender'),
                ),
                TextField(
                  controller: emailController,
                  decoration: InputDecoration(labelText: 'Email'),
                ),
                TextField(
                  controller: mobilenoController,
                  decoration: InputDecoration(labelText: 'Mobile No'),
                ),
                TextField(
                  controller: addressController,
                  decoration: InputDecoration(labelText: 'Address'),
                ),
                TextField(
                  controller: countryController,
                  decoration: InputDecoration(labelText: 'Country'),
                ),
                TextField(
                  controller: stateController,
                  decoration: InputDecoration(labelText: 'State'),
                ),
                TextField(
                  controller: cityController,
                  decoration: InputDecoration(labelText: 'City'),
                ),
                TextField(
                  controller: religionController,
                  decoration: InputDecoration(labelText: 'Religion'),
                ),
                TextField(
                  controller: occupationController,
                  decoration: InputDecoration(labelText: 'Occupation'),
                ),
                TextField(
                  controller: mothertongueController,
                  decoration: InputDecoration(labelText: 'Mother Tongue'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                EmrModels updatedPatient = EmrModels(
                  name: nameController.text,
                  dob: dobController.text,
                  age: ageController.text,
                  gender: genderController.text,
                  email: emailController.text,
                  mobileno: mobilenoController.text,
                  address: addressController.text,
                  country: countryController.text,
                  state: stateController.text,
                  city: cityController.text,
                  religion: religionController.text,
                  occupation: occupationController.text,
                  mothertongue: mothertongueController.text,
                  // Add other fields accordingly
                );

                box.put(patientData.key, updatedPatient);
                Navigator.pop(context);
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void _showPatientDetails(BuildContext context, EmrModels patient, Box<EmrModels> box) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Patient Details'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildDetail('Name', patient.name),
                _buildDetail('Date of Birth', patient.dob),
                _buildDetail('Age', patient.age),
                _buildDetail('Gender', patient.gender),
                _buildDetail('Email', patient.email),
                _buildDetail('Mobile No', patient.mobileno),
                _buildDetail('Address', patient.address),
                _buildDetail('Country', patient.country),
                _buildDetail('State', patient.state),
                _buildDetail('City', patient.city),
                _buildDetail('Religion', patient.religion),
                _buildDetail('Occupation', patient.occupation),
                _buildDetail('Mother Tongue', patient.mothertongue),
                // Add other patient details here
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                _showUpdateDialog(context, patient, box);
              },
              child: Text('Update'),
            ),

            TextButton(
              onPressed: () {
                _showDeleteConfirmationDialog(context, patient, box); // Pass patient and box here
              },
              child: Text(
                'Delete',
                style: TextStyle(
                  color: Colors.red,
                ),
              ),
            ),
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

}

class PatientSearchDelegate extends SearchDelegate<String> {
  final BuildContext context;
  final List<EmrModels> patients;

  PatientSearchDelegate(this.context, this.patients);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, '');
      },
    );
  }
  @override
  Widget buildResults(BuildContext context) {
    var filteredPatients = patients.where((patient) =>
    patient.name.toLowerCase().contains(query.toLowerCase()) ||
        patient.mobileno.toLowerCase().contains(query.toLowerCase())
    );

    var box = Hive.box<EmrModels>("EmrModels");
    var filteredInBox = box.values.where((patient) =>
    patient.name.toLowerCase().contains(query.toLowerCase()) ||
        patient.mobileno.toLowerCase().contains(query.toLowerCase())
    ).toList().cast<EmrModels>();

    // Combine results from both list and box
    var combinedResults = Set<EmrModels>.from([...filteredPatients, ...filteredInBox]);

    return _buildSearchResults(context, combinedResults.toList());
  }


  @override
  Widget buildSuggestions(BuildContext context) {
    return Center(
      child: Text('Search Suggestions for: $query'),
    );
  }

  Widget _buildSearchResults(BuildContext context, List<EmrModels> searchResults) {
    if (searchResults.isEmpty) {
      return Center(
        child: Text('No Results Found for: $query'),
      );
    }

    return ListView.builder(
      itemCount: searchResults.length,
      itemBuilder: (context, index) {
        EmrModels patient = searchResults[index];
        String formattedCreationDate = DateFormat('dd/MM/yy').format(patient.creationDateTime.toLocal());


        return InkWell(
          onTap: () {
            _showPatientDetails(context, patient, Hive.box<EmrModels>("EmrModels"));
          },
          child: Card(
            elevation: 4,
            shadowColor: Colors.pinkAccent,
            color: Colors.blue,
            child: ListTile(
              title: Text(patient.name),
              subtitle: Text(
                'Date: ${DateFormat('dd/MM/yyyy').format(patient.creationDateTime.toLocal())}',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        );
      },
    );
  }



  void _showPatientDetails(BuildContext context, EmrModels patientData, Box<EmrModels> box) {
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

  Widget _buildDetail(String label, String? value, {Color? textColor}) {
    return Text(
      '$label: ${value ?? ''}',
      style: TextStyle(color: textColor),
    );
  }
}