
import 'package:csc_picker/csc_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:lottie/lottie.dart';
import '../DB_Hive/API_State.dart';
import 'package:realemrs/boxes/boxes.dart'; // Adjust the path if necessary
import 'package:realemrs/DB_Hive/Models.dart';
class PatientController extends GetxController {
  final RxList<EmrModels> patientsList = <EmrModels>[].obs;
}
class AddPatientsController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    // Add listener to the Date of Birth controller
    dobController.addListener(calculateAge);
  }

  @override
  void onClose() {
    // Clean up listeners when the controller is closed
    dobController.removeListener(calculateAge);
    super.onClose();
  }

  void calculateAge() {
    final dobText = dobController.text;
    if (dobText.isNotEmpty) {
      final dateParts = dobText.split('/');
      if (dateParts.length == 3) {
        try {
          final dob = DateTime(
            int.parse(dateParts[2]),
            int.parse(dateParts[1]),
            int.parse(dateParts[0]),
          );

          final today = DateTime.now();
          final age = today.year -
              dob.year -
              ((today.month > dob.month ||
                  (today.month == dob.month && today.day >= dob.day))
                  ? 0
                  : 1);
          ageController.text = '$age years';
        } catch (e) {
          print('Error calculating age: $e');
        }
      }
    }
  }
  bool areAllFieldsFilled() {
    final controller = Get.find<AddPatientsController>();
    return controller.nameController.text.isNotEmpty &&
        controller.dobController.text.isNotEmpty &&
        controller.ageController.text.isNotEmpty &&
        controller.selectedGenderValue.isNotEmpty &&
        controller.emailController.text.isNotEmpty &&
        controller.mobileNoController.text.isNotEmpty &&
        controller.addressController.text.isNotEmpty;
  }
  final TextEditingController nameController = TextEditingController();
  final TextEditingController mobileNoController = TextEditingController();
  final RxString selectedCity = RxString('');
  String get selectedCityValue => selectedCity.value!;
  set selectedCityValue(String value) => selectedCity.value = value;
  final RxList<String> states = <String>[].obs;
  final RxList<String> cities = <String>[].obs;
  final RxList<String> countries = <String>[].obs;
  final RxString selectedCountry = RxString('');
  String get selectedCountryValue => selectedCountry.value;
  set selectedCountryValue(String value) => selectedCountry.value = value;
  RxString selectedMotherTongueValue = RxString('');
  String? get selectedMotherTongueValueValue => selectedMotherTongueValue.value;
  set selectedMotherTongueValueValue(String? value) =>
      selectedMotherTongueValue.value = value ?? '';
  final RxString selectedGender = RxString('');
  String get selectedGenderValue => selectedGender.value;
  set selectedGenderValue(String value) => selectedGender.value = value; // Use '=' to assign the value




  void fetchStatesFromApi() async {
    try {
      final response = await YourApiService.fetchStates();
      if (response != null) {
        states.assignAll(response);
      }
    } catch (e) {
      print('Failed to fetch states: $e');
    }
  }

  void fetchCitiesFromApi(String selectedState) async {
    try {
      final response = await YourApiService.fetchCities(selectedState);
      if (response != null) {
        cities.assignAll(response);
      }
    } catch (e) {
      print('Failed to fetch cities: $e');
    }
  }
  final TextEditingController dobController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final RxString selectedOccupation = RxString('');
  final RxString selectedReligion = RxString('');
  final RxBool showAdditionalFields = RxBool(false);
  final RxString selectedState = RxString('');

  String get selectedStateValue => selectedState.value!;
  set selectedStateValue(String value) => selectedState.value = value;

  String get selectedReligionValue => selectedReligion.value!;
  set selectedReligionValue(String value) => selectedReligion.value = value;

  String get selectedOccupationValue => selectedOccupation.value!;
  set selectedOccupationValue(String value) => selectedOccupation.value = value;



  Future<void> selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != DateTime.now()) {
      final formattedDate =
          "${picked.day.toString().padLeft(2, '0')}/${picked.month.toString().padLeft(2, '0')}/${picked.year.toString()}";
      dobController.text = formattedDate;

      final today = DateTime.now();
      final age = today.year -
          picked.year -
          ((today.month > picked.month ||
              (today.month == picked.month && today.day >= picked.day))
              ? 0
              : 1);ageController.text = '0 years';
    }
  }


  void toggleAdditionalFields() {
    showAdditionalFields.toggle();
  }
}

class AddNewPatients extends GetView<AddPatientsController> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false, // This line will remove the back button
        backgroundColor: Colors.blue,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Center(
                child: SizedBox(
                  height: 60,
                  child: Image.asset(
                    'assets/images/newsoft1.png',
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
            SizedBox(width: 10), // Add spacing between the two images
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                  child: Lottie.network(
                    'https://lottie.host/f43ce550-17bc-4c15-b5ab-8dc96f1028d1/89cRpwHCj5.json',
                    height: 80,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: 8),
              Center(
                child: Text(
                  'Add New Patients',
                  style: TextStyle(
                    fontSize: 30,
                  ),
                ),
              ),
              SizedBox(height: 20),
              SizedBox(
                height: 57,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: TextField(
                    controller: controller.nameController,
                    decoration: InputDecoration(
                      labelText: 'Name',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.text,
                  ),
                ),
              ),
              SizedBox(height: 8),
              Stack(
                children: [
                  SizedBox(
                    height: 57,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: TextField(
                        controller: controller.dobController,
                        decoration: InputDecoration(
                          labelText: 'Date of Birth',
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.datetime,
                      ),
                    ),
                  ),
                  Positioned(
                    right: 0.0,
                    bottom: 8.0,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: IconButton(
                        icon: Icon(Icons.calendar_today,
                            color: Colors.deepOrange),
                        onPressed: () =>
                            controller.selectDate(context),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8),
              SizedBox(
                height: 57,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: TextField(
                    controller: controller.ageController, // Age text field
                    decoration: InputDecoration(
                      labelText: 'Age',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                    enabled: false, // Disable user input for age
                  ),
                ),
              ),
              SizedBox(height: 8),
              SizedBox(height: 57,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      labelText: 'Gender',
                      border: OutlineInputBorder(),
                    ),
                    value: controller.selectedGenderValue.isNotEmpty
                        ? controller.selectedGenderValue
                        : null,
                    onChanged: (String? newValue) {
                      if (newValue != null) {
                        controller.selectedGenderValue = newValue;
                      }
                    },
                    items: <String>['Male', 'Female','Other']
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                ),
              ),

              SizedBox(height: 8),
              SizedBox(
                height: 57,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: TextField(
                    controller: controller.emailController,
                    decoration: InputDecoration(
                      labelText: 'Email Address',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.emailAddress,
                  ),
                ),
              ),
              SizedBox(height: 8,),
              SizedBox(
                height: 57,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: TextField(
                    controller: controller.mobileNoController,
                    decoration: InputDecoration(
                      labelText: 'Mobile No',
                      border: OutlineInputBorder(),
                      counterText: '', // Hides the counter text
                    ),
                    keyboardType: TextInputType.phone,
                    maxLength: 10,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                  ),
                ),
              ),
              SizedBox(height: 8),
              _buildAddressTextField(),
              SizedBox(height: 8),
              GestureDetector(
                onTap: () {
                  final controller = Get.find<AddPatientsController>();
                  controller.toggleAdditionalFields();
                },
                child: Center(
                  child: Obx(
                        () => Text(
                      Get.find<AddPatientsController>().showAdditionalFields.value
                          ? 'Less'
                          : 'More',
                      style: TextStyle(
                        color: Colors.blue,
                        decoration: TextDecoration.underline,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),

              SizedBox(height: 8),
              _buildAdditionalFields(),
              SizedBox(height: 8),
              _buildSaveButton(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAdditionalFields() {
    return Obx(() {
      final controller = Get.find<AddPatientsController>();

      return Visibility(
        visible: controller.showAdditionalFields.value,
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: CSCPicker(
                  onCountryChanged: (value) {
                    if (value != null) {
                      controller.selectedCountryValue = value;
                      controller.fetchStatesFromApi();
                    }
                  },
                  onStateChanged: (value) {
                    if (value != null) {
                      controller.selectedStateValue = value;
                      controller.fetchCitiesFromApi(value);
                    }
                  },
                  onCityChanged: (value) {
                    if (value != null) {
                      controller.selectedCityValue = value;
                    }
                  },
                  flagState: CountryFlag.DISABLE,
                  dropdownDecoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  selectedItemStyle: TextStyle(fontSize: 14),
                ),
              ),
              SizedBox(height: 8),
              SizedBox(
                height: 57,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      labelText: 'Religion',
                      border: OutlineInputBorder(),
                     ),
                    value: controller.selectedReligionValue.isNotEmpty
                        ? controller.selectedReligionValue
                        : null,
                    onChanged: (String? newValue) {
                      if (newValue != null) {
                        controller.selectedReligionValue = newValue;
                      }
                    },
                    items: <String>['Hindu', 'Muslim','Christen','Sikh','Buddha','Jain',] // Update with your religion options
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                ),
              ),
              SizedBox(height: 8),
              SizedBox(height: 57,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      labelText: 'Occupation',
                      border: OutlineInputBorder(),
                    ),
                    value: controller.selectedOccupationValue.isNotEmpty
                        ? controller.selectedOccupationValue
                        : null,
                    onChanged: (String? newValue) {
                      if (newValue != null) {
                        controller.selectedOccupationValue = newValue;
                      }
                    },
                    items: <String>['Job', 'Worker']
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                ),
              ),
              SizedBox(height: 8,),
              SizedBox(
                height: 57,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      labelText: 'Mother Tongue',
                      border: OutlineInputBorder(),
                    ),
                    value: controller.selectedMotherTongueValue.isNotEmpty
                        ? controller.selectedMotherTongueValue.value
                        : null,
                    onChanged: (String? newValue) {
                      if (newValue != null) {
                        controller.selectedMotherTongueValue.value = newValue;
                      }
                    },
                    items: <String>['Hindi','Marathi','Kannada', 'Telugu',
                      'Urdu','Bengali','Tamil','Gujarati',
                      'Odia',
                      'Malayalam','Panjabi','Assamese', 'English']
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                ),
              ),


              SizedBox(height: 8),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildAddressTextField() {
    return SizedBox(
      height: 57,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: TextField(
          controller: controller.addressController, // Add the controller
          decoration: InputDecoration(
            labelText: 'Address',
            border: OutlineInputBorder(),
          ),
          keyboardType: TextInputType.text,
        ),
      ),
    );
  }


  Widget _buildSaveButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        height: 50,
        width: 20,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: ElevatedButton(
            onPressed: () async {
              // Check if the compulsory fields are filled
              if (controller.nameController.text.isEmpty ||
                  controller.selectedGenderValue.isEmpty ||
                  controller.ageController.text.isEmpty ||
                  controller.dobController.text.isEmpty ||
                  controller.emailController.text.isEmpty ||
                  controller.mobileNoController.text.isEmpty ||
                  controller.addressController.text.isEmpty) {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('Error'),
                      content: Text('Please fill all the compulsory fields.'),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text('OK'),
                        ),
                      ],
                    );
                  },
                );
                return;
              }

              final data = EmrModels(
                name: controller.nameController.text,
                gender: controller.selectedGenderValue,
                dob: controller.dobController.text,
                email: controller.emailController.text,
                mobileno: controller.mobileNoController.text,
                age: controller.ageController.text,
                country: controller.selectedCountryValue,
                state: controller.selectedStateValue,
                city: controller.selectedCityValue,
                religion: controller.selectedReligionValue,
                occupation: controller.selectedOccupationValue,
                address: controller.addressController.text,
                mothertongue: controller.selectedMotherTongueValueValue ?? '',
              );

              final box = Boxes.getData(); // Get the Hive box
              box.add(data); // Add the data to the box
              data.save();
              print(box);
              controller.nameController.clear();
              controller.dobController.clear();
              controller.ageController.clear();
              controller.selectedGenderValue = '';
              controller.emailController.clear();
              controller.mobileNoController.clear();
              controller.addressController.clear();
              controller.selectedCountryValue = '';
              controller.selectedStateValue = '';
              controller.selectedCityValue = '';
              controller.selectedReligionValue = '';
              controller.selectedOccupationValue = '';
              controller.selectedMotherTongueValue.value = '';

              Fluttertoast.showToast(
                msg: 'Data Saved Successfully',
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.green,
                textColor: Colors.white,
              );

              // Optional: Close the keyboard
              // FocusScope.of(context as BuildContext).unfocus();
            },
            child: Text('Save'),
          ),
        ),
      ),
    );
  }



}
