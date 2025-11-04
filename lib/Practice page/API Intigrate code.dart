import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';
import 'package:email_validator/email_validator.dart';
import '../Doctor_Page/Doctor_Homescreen.dart';
import 'package:http/http.dart' as http;

class DoctorLogin extends StatefulWidget {
  @override
  _DoctorLoginState createState() => _DoctorLoginState();
}

class _DoctorLoginState extends State<DoctorLogin> {
  bool isEmailVerified = false;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  TextEditingController doctorNameController = TextEditingController();
  TextEditingController mobileNumberController = TextEditingController();

  bool isDoctorNameEntered = false;
  bool isMobileEntered = false;
  bool isPasswordEntered = false;
  bool isConfirmPasswordEntered = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        actions: [
          Flexible(
            child: Image.asset(
              'assets/images/logo4.png',
            ),
          ),
          SizedBox(
            width: 10,
          ),
          Center(
            child: Image.asset(
              'assets/images/newsoft1.png',
              width: 160,
            ),
          ),
          Lottie.network(
            'https://lottie.host/f43ce550-17bc-4c15-b5ab-8dc96f1028d1/89cRpwHCj5.json',
            height: 80,
          ),
          SizedBox(width: 10),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          constraints: BoxConstraints(maxWidth: double.infinity),
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Text(
                  "Sign UP",
                  style: TextStyle(fontSize: 30, color: Colors.blueAccent),
                ),
              ),
              SizedBox(height: 8),
              Center(
                child: Text(
                  "Click the Register button below to complete the sign-up process.",
                  style: TextStyle(fontSize: 16, color: Colors.black54),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(height: 8),
              _buildTextField(
                label: 'Doctor Name',
                hintText: 'Enter your Name',
                showDrText: true,
                controller: doctorNameController,
                onChanged: (value) {
                  setState(() {
                    isDoctorNameEntered = value.isNotEmpty;
                  });
                },
              ),
              _buildCountryCodeAndMobileTextBoxes(),
              _buildTextField(
                label: 'Email',
                hintText: 'Enter your email',
                isEmail: true,
                showDrText: false,
                controller: emailController,
                onChanged: (value) {
                  setState(() {
                    isEmailVerified = EmailValidator.validate(value);
                  });
                },
              ),
              _buildTextField(
                label: 'Password',
                hintText: 'Enter your password',
                isPassword: true,
                controller: passwordController,
                onChanged: (value) {
                  setState(() {
                    isPasswordEntered = value.isNotEmpty;
                  });
                },
              ),
              SizedBox(height: 8),
              _buildTextField(
                label: 'Confirm Password',
                hintText: 'Re-enter your password',
                isConfirmPassword: true,
                controller: confirmPasswordController,
                onChanged: (value) {
                  setState(() {
                    isConfirmPasswordEntered = value.isNotEmpty;
                  });
                },
              ),
              SizedBox(height: 30),
              Center(
                child: SizedBox(
                  width: 200,
                  height: 40,
                  child: ElevatedButton(
                    onPressed: () {
                      if (isDoctorNameEntered &&
                          isMobileEntered &&
                          isEmailVerified &&
                          isPasswordEntered &&
                          isConfirmPasswordEntered) {
                        String password = passwordController.text;
                        String confirmPassword = confirmPasswordController.text;

                        if (password == confirmPassword) {
                          registerDoctor();
                        } else {
                          showPasswordMismatchAlert();
                        }
                      } else if (!isEmailVerified) {
                        showInvalidEmailAlert();
                      } else {
                        showMissingInfoAlert();
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                    ),
                    child: Text(
                      'Register',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void showPasswordMismatchAlert() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Incorrect Values'),
        content: Text('Please enter matching password and confirm password.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  void showInvalidEmailAlert() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Invalid Email'),
        content: Text('Please enter a valid email address.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  void showMissingInfoAlert() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Missing Information'),
        content: Text('Please fill in all the required fields.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  void registerDoctor() async {
    String doctorName = doctorNameController.text;
    String email = emailController.text;
    String password = passwordController.text;
    String mobileNumber = mobileNumberController.text;

    var url = Uri.parse('https://realemr.newcloud.co.in/api/DoctorRegistration.php');
    var requestBody = {
      'DoctorName': doctorName,
      'Email': email,
      'Password': password,
      'MobileNumber': mobileNumber,
    };

    try {
      var response = await http.post(
        url,
        body: requestBody,
      );

      if (response.statusCode == 200) {
        var responseData = json.decode(response.body);
        print('Registration successful: $responseData');
        // Handle successful registration here, e.g., navigate to a new screen
      } else {
        print('Registration failed: ${response.body}');
        // Handle registration failure here
      }
    } catch (error) {
      print('Error during registration: $error');
      // Handle network errors or exceptions here
    }
  }

  Widget _buildTextField({
    required String label,
    required String hintText,
    double height = 70,
    double width = 350,
    bool showDrText = false,
    bool isNumeric = false,
    bool isFixed = false,
    bool readOnly = false,
    bool isPassword = false,
    bool isConfirmPassword = false,
    bool isEmail = false,
    TextEditingController? controller,
    Function(String)? onChanged,
    List<TextInputFormatter>? inputFormatter,
  }) {
    return Container(
      height: height,
      width: width,
      child: Card(
        elevation: 0.0,
        color: Colors.transparent,
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: Row(
            children: [
              if (showDrText && !isPassword && !isConfirmPassword)
                Text(
                  isFixed ? '+91' : 'Dr.',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              SizedBox(width: showDrText && !isPassword && !isConfirmPassword ? 8 : 0),
              Expanded(
                child: isEmail
                    ? TextField(
                  controller: controller,
                  readOnly: readOnly,
                  decoration: InputDecoration(
                    labelText: label,
                    hintText: hintText,
                    border: OutlineInputBorder(),
                    suffixIcon: controller != null
                        ? (isEmailVerified
                        ? Icon(
                      Icons.check,
                      color: Colors.green,
                    )
                        : Icon(
                      Icons.error,
                      color: Colors.red,
                    ))
                        : null,
                  ),
                  onChanged: onChanged,
                )
                    : isPassword
                    ? TextField(
                  controller: controller,
                  readOnly: readOnly,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: label,
                    hintText: hintText,
                    border: OutlineInputBorder(),
                  ),
                  onChanged: onChanged,
                )
                    : TextField(
                  controller: controller,
                  readOnly: readOnly,
                  obscureText: false,
                  inputFormatters: inputFormatter,
                  decoration: InputDecoration(
                    labelText: label,
                    hintText: hintText,
                    border: OutlineInputBorder(),
                  ),
                  onChanged: onChanged,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCountryCodeAndMobileTextBoxes() {
    return Row(
      children: [
        _buildTextField(
          height: 70,
          label: '+91',
          width: 80,
          showDrText: false,
          isFixed: true,
          readOnly: true,
          hintText: '+91',
        ),
        SizedBox(
          width: 2,
        ),
        Expanded(
          child: _buildTextField(
            label: 'Mobile Number',
            hintText: 'Enter your mobile number',
            height: 70,
            showDrText: false,
            isNumeric: true,
            controller: mobileNumberController,
            readOnly: false,
            inputFormatter: [
              LengthLimitingTextInputFormatter(10),
              FilteringTextInputFormatter.digitsOnly,
            ],
            onChanged: (value) {
              setState(() {
                isMobileEntered = value.isNotEmpty && value.length == 10;
              });
            },
          ),
        ),
      ],
    );
  }
}
