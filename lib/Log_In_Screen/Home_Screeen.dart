import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:realemrs/Log_In_Screen/Option_Screen.dart';

class HomeController extends GetxController {
  RxBool acceptedTerms = false.obs;
  RxBool isGoogleButtonEnabled = false.obs;

  Future<void> handleGoogleSignIn() async {
    if (acceptedTerms.value) {
      try {
        Get.dialog(
          AlertDialog(
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 16),
                Text("Please wait..."),
              ],
            ),
          ),
          barrierDismissible: false,
        );

        final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

        if (googleUser == null) {
          Get.back();
          return;
        }

        final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

        final UserCredential authResult = await FirebaseAuth.instance.signInWithCredential(credential);

        // Do something with the authenticated user if needed
        print("User signed in: ${authResult.user?.displayName}");

        Get.to(() => OptionScreen()); // Navigate to OptionScreen
         // Get.back(); // Close the loading dialog
      } catch (error) {
        // Handle sign-in error
        Get.back(); // Close the loading dialog
        print(error.toString());
      }
    } else {
      Get.dialog(
        AlertDialog(
          title: Text("Oops!"),
          content: Text("Please accept the terms and conditions before proceeding."),
          actions: [
            TextButton(
              onPressed: () {
                Get.back();
              },
              child: Text("Close"),
            ),
          ],
        ),
      );
    }
  }
}

class HomeScreen extends GetView<HomeController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 20),
            Center(
              child: Image.asset(
                'assets/images/NewSoftTMlogo2.png',
                height: 60,
                width: 130,
                fit: BoxFit.contain,
              ),
            ),
            SizedBox(height: 10),
            Center(
              child: Image.asset(
                'assets/images/google.png',
                height: 70,
                width: 70,
              ),
            ),
            SizedBox(height: 20),
            Container(
              child: Center(
                child: Column(
                  children: [
                      Text(
                        'Choose Your Google Account To  Proceed.',
                        style: TextStyle(
                          fontSize: 17,
                        ),
                      ),
                    SizedBox(height: 15),
                    Divider(
                      thickness: 2,
                      color: Colors.blue,
                      height: 20,
                    ),
                  ],
                ),
              ),
            ),
            Column(
              children: [
                Center(
                  child: Text(
                    "By using Real EMR, you agree to comply with and be bound by the following terms and conditions of use."
                        "\nIf you do not agree with these terms,please do not use the application.",
                    style: TextStyle(
                      fontSize: 15,
                    ),
                  ),
                ),

                Center(
                  child: Obx(
                        () => CheckboxListTile(
                      title: Text('I accept the terms and, conditions',),
                      value: controller.acceptedTerms.value,
                      onChanged: (bool? value) {
                        controller.acceptedTerms.value = value ?? false;
                        controller.isGoogleButtonEnabled.value = controller.acceptedTerms.value;
                      },
                      controlAffinity: ListTileControlAffinity.leading,
                    ),
                  ),
                ),
                Divider(
                  thickness: 2,
                  color: Colors.blue,
                  height: 20,
                ),
              ],
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () async {
                    if (controller.isGoogleButtonEnabled.value) {
                      await controller.handleGoogleSignIn();
                    } else {
                      Get.dialog(
                        AlertDialog(
                          title: Text("Oops!"),
                          content: Text("Please accept the terms and conditions before proceeding."),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Get.back();
                              },
                              child: Text("Close"),
                            ),
                          ],
                        ),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Colors.white,
                    minimumSize: Size(200, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(0),
                      side: BorderSide(color: Colors.transparent),
                    ),
                  ),
                  child: Row(

                    children: [
                      Image.asset(
                        'assets/images/google.png',
                        height: 30,
                        width: 30,
                      ),
                      SizedBox(width: 10),
                      Text(
                        'Continue With Google',
                        style: TextStyle(
                          color: Colors.black,
                        ),
                      ),

                    ],

                  ),
                ),

              ],
            ),
            SizedBox(height: 50,),
            Column(

        children: [
          SizedBox(height: 120,),
          Center(
            child:  Image.asset(
              'assets/images/emrlogo2.png',
              height: 80,
              width: 80,
            ),
          ),
        ],
            ),
          ],

        ),

      ),
    );
  }
}