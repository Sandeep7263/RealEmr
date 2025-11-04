import 'dart:async';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:carousel_slider/carousel_options.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:intl/intl.dart';
import 'package:realemrs/DB_Hive/Models.dart';
import 'package:realemrs/Doctor_Page/Add_New_Patients.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:realemrs/Doctor_Page/All_Patients_List.dart';
import '../widgets/Theme_Controller.dart';
import '../widgets/drawer.dart';
import '../Entry Page/Entry_Page.dart';

class PatientController extends GetxController {
  final patientsList = <EmrModels>[].obs;
}


class DoctorHomescreen extends StatefulWidget {
  @override
  State<DoctorHomescreen> createState() => _DoctorHomescreenState();
}

class _DoctorHomescreenState extends State<DoctorHomescreen> {
  final Map<String, String> genderImageMap = {
    'male': 'assets/images/male.png',
    'female': 'assets/images/female.png',
    'other' : 'assets/images/transgender1.png',
    // You can add other genders and their respective image paths here
  };

  final Rx<ThemeMode> _themeMode = ThemeService().themeMode;
  bool _isDarkMode = false;
  void _toggleTheme(bool value) {
    setState(() {
      _isDarkMode = value;
      if (_isDarkMode) {
        Get.changeThemeMode(ThemeMode.dark);
      } else {
        Get.changeThemeMode(ThemeMode.light);
      }
    });
  }



  Future<void> _savePatientData(EmrModels patientData) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String currentDate = DateFormat('dd/MM/yy').format(DateTime.now());

    await prefs.setString('Date', currentDate);

    final box = Hive.box<EmrModels>('EmrModels');
    box.add(patientData);
  }

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
        imagePath = 'assets/images/user.png'; // Replace with a default image asset path
    }

    return Image.asset(
      imagePath,
      width: 30,
      height: 30,
      fit: BoxFit.cover,
    );
  }

  final patientController = Get.put(PatientController());
  TextEditingController _searchController = TextEditingController();
  List<EmrModels> _searchResults = [];
  bool _isSearchBarOpened = false;
  final PageController _controller = PageController(viewportFraction: 0.8);
  int _currentPage = 0;
  FocusNode _searchFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    // _startAutoSlide();
  }


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
      return false;
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

  void _showPatientDetails(EmrModels patientData, Box<EmrModels> box) async {
    bool _isDarkMode = false;

    // Function to toggle between light and dark themes
    void _toggleTheme(bool value) {
      setState(() {
        _isDarkMode = value;
        // Logic to switch between light and dark themes based on the '_isDarkMode' value
        if (_isDarkMode) {
          // Implement your code to switch to dark theme
          // Example: Get.changeThemeMode(ThemeMode.dark);
        } else {
          // Implement your code to switch to light theme
          // Example: Get.changeThemeMode(ThemeMode.light);
        }
      });
    }
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? creationDate = prefs.getString('') ?? '';

    showDialog(
      context: context,
      builder: (BuildContext context) {
        String currentDate = DateFormat('dd/MM/yy').format(DateTime.now());

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
                // _buildDetail('Creation Date', creationDate.isNotEmpty ? creationDate : currentDate),
                // Add other patient details here
              ],
            ),
          ),
          actions: [

            TextButton(
              onPressed: () {
                _showUpdateDialog(patientData, box);
              },
              child: Text('Update'),
            ),
            TextButton(
              onPressed: () {
                _showDeleteConfirmationDialog(patientData, box);
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



  void _showDeleteConfirmationDialog(EmrModels patient, Box<EmrModels> box) {
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
                Navigator.pop(context); // Close the delete confirmation dialog
              },
              child: Text('No'),
            ),
            TextButton(
              onPressed: () {
                box.delete(patient.key);
                Navigator.pop(context); // Close the delete confirmation dialog
                Navigator.pop(context); // Close the view pop-up window
              },
              child: Text('Yes'),
            ),
          ],
        );
      },
    );
  }


  void _showUpdateDialog(EmrModels patientData, Box<EmrModels> box) {
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


  Widget _buildPatientList() {
    return ValueListenableBuilder<Box<EmrModels>>(
      valueListenable: Hive.box<EmrModels>("EmrModels").listenable(),
      builder: (context, box, _) {
        var data = box.values.toList().cast<EmrModels>();

        if (_searchResults.isEmpty && data.isEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 180),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Lottie.network(
                    'https://lottie.host/da8c9b66-5d1c-46a3-8ffd-151670ec7b11/2HCi8Z4DrE.json', // Replace with your Lottie animation file
                    width: 200, // Adjust width and height as needed
                    height: 200,
                  ),
                  SizedBox(height: 10),
                  // Text(
                  //   'No Record Found',
                  //   style: TextStyle(fontSize: 18.0),
                  // ),
                ],
              ),
            ),
          );
        }

        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AllPatientsScreen(patients: [])),
                  );
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Patients Details",style: TextStyle(
                      fontSize: 18,
                      color: Colors.black
                    ),
                    ),
                    Text(
                      'See All',
                      style: TextStyle(color: Colors.blue),
                    ),
                  ],
                ),
              ),
            ),
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: (_searchResults.isNotEmpty ? (_searchResults.length > 5 ? 5 : _searchResults.length) : (data.length > 5 ? 5 : data.length)),
              itemBuilder: (context, index) {
                EmrModels patient = _searchResults.isNotEmpty ? _searchResults[index] : data[index];
                String formattedCreationDate = DateFormat('dd/MM/yy').format(patient.creationDateTime.toLocal());

                if (index < 5) {
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
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(
                                'Date: $formattedCreationDate',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  _buildGenderIcon(patient.gender),
                                  SizedBox(width: 4),

                                  _buildDetail(patient.name, "(${patient.age})" ,textColor: Colors.white),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [

                                ],
                              ),
                            ],
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [

                              _buildDetail('', patient.mobileno, textColor: Colors.white, icon: Icons.phone),
                              SizedBox(height: 10,),
                              _buildDetail('', patient.email, textColor: Colors.white,icon: Icons.email),
                              SizedBox(height: 10,),
                              _buildDetail('', patient.address, textColor: Colors.white,icon: Icons.add_location),

                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                                  SizedBox(width: 15),
                                  ElevatedButton(
                                    onPressed: () {
                                      String imagePath;
                                      String gender = patient.gender.toLowerCase();
                                      String name = patient.name.toLowerCase();

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
                                            userName: patient.name, // Fetches the name from the patient object
                                            userGender: patient.gender, // Fetches the gender from the patient object
                                            genderIconPath: imagePath, // Passes the selected image path to the EntryPage
                                          ),
                                        ),
                                      );
                                    },
                                    child: Text('Entry'),
                                  ),




                                  SizedBox(width: 15),
                                  ElevatedButton(
                                    onPressed: () {
                                       _showPatientDetails(patient, box);

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
                } else {
                  return Container();
                }
              },
            )

          ],
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
            constraints: BoxConstraints(maxWidth: 200), // Adjust the width as needed
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



  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: AppBar(
          title: _isSearchBarOpened
              ? _buildSearchBar()
              : Text('Real EMR'),
          actions: [
            if (!_isSearchBarOpened)
              SizedBox(
                height: 80,
                width: 80,
                child: Image.asset(
                  'assets/images/hospital1.png',
                ),
              ),
            IconButton(
              icon: _isSearchBarOpened
                  ? Icon(Icons.close) // Change to close icon when search is opened
                  : Icon(Icons.search),
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
            IconButton(
              icon: Icon(
                _isDarkMode ? Icons.light_mode : Icons.dark_mode,
              ),
              onPressed: () {
                _toggleTheme(!_isDarkMode);

              },
            ),
          ],
        ),

        drawer: MenuDrawer(),
        body: SingleChildScrollView(

          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Categories',style: TextStyle(
                        fontSize: 18,
                        color: Colors.black
                      ),),
                      Text('See All',
                        style: TextStyle(
                        color: Colors.blue
                      ),),
                    ],
                  ),
                ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 0.0),
                child: Container(
                  height: 80,
                  width: double.infinity,
                  child: CarouselSlider.builder(
                    itemCount: 5,
                    itemBuilder: (context, index, realIndex) {
                      return Center(
                        child: Container(
                          width: 200,
                          height: 80,
                          // color: Colors.pinkAccent,
                          child: Card(
                            color: Colors.black,
                            child: Center(
                              child: Image.asset(
                                'assets/images/newsoft1.png',
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                    options: CarouselOptions(
                      viewportFraction: 1 / 2, // Update this line
                      onPageChanged: (int page, CarouselPageChangedReason reason) {
                        setState(() {
                          _currentPage = page;
                        });
                      },
                    ),
                  ),
                ),
              ),
              Flexible(
                child: _buildPatientList(),
              ),
            ],
          ),
        ),

        bottomNavigationBar: Container(
          height: 60.0,
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          child: ElevatedButton(
            onPressed: () {
              Get.to(AddNewPatients())?.then((value) {
                if (value != null && value) {
                  Get.snackbar('Success', 'Patient data saved!');
                }
              }
              );
            },
            child: Text(
              'Add New Patients',
              style: TextStyle(fontSize: 20),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      height: 40, // Adjust the height according to your preference
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: TextField(
        focusNode: _searchFocusNode,
        controller: _searchController,
        onChanged: _performSearch,
        decoration: InputDecoration(
          hintText: 'Search...',
          prefixIcon: Icon(Icons.search),
          border: OutlineInputBorder(),
          contentPadding: EdgeInsets.symmetric(vertical: 10), // Adjust vertical padding
        ),
      ),
    );
  }


  @override
  void dispose() {
    _searchFocusNode.dispose();
    super.dispose();
  }


}