import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:get/get.dart';
import 'package:realemrs/Log_In_Screen/Doctor_SignUp.dart';
import 'package:realemrs/Log_In_Screen/Staff_Screen.dart';

class OptionScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,

        children: [
          SizedBox(height: screenHeight * .12 ,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
             Text('Log In ',style: TextStyle(
               fontSize: 30,
               color: Colors.blue,
               fontWeight: FontWeight.bold
             ),)
              ],
            ),
          ),
          SizedBox(height: screenHeight * 0.020),
          _buildBoxWithLottie(screenWidth,screenHeight,
            'https://lottie.host/268c1788-4bb5-424a-bb0a-901d737a2c48/YyJLShC0tv.json',
            Colors.white,
                () {
              print("Click me as Doctor");
            },
          ),
          _buildButton(screenWidth,screenHeight,"As Doctor", () {
            Get.to(DoctorSignup());
            print("Click me as Doctor");
          }),
          SizedBox(height: screenHeight * 0.040),
          _buildBoxWithLottie(screenWidth,screenHeight,
            'https://lottie.host/e83e018f-6a4f-4e46-b3cb-ad12cf36ea7b/DBoFTR8QwP.json',
            Colors.white,
                () {
              print("Click me as Staff");
            },
          ),
          _buildButton(screenWidth,screenHeight,"As Reception", () {
            Get.to(StaffScreen());
            print("Click me as Staff");
          }),
        ],


      ),
    );
  }

  Widget _buildBoxWithLottie(double screenWidth,double screenHeight, String animationPath, Color color, VoidCallback onTap) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: onTap,
          child: Container(
            // width: screenWidth * 0.300,
            height: screenHeight * 0.270,
            decoration: BoxDecoration(
              color: color,
            ),
            child: Center(
              child: Lottie.network(
                animationPath,
                // width: screenWidth * 0.100,
                // height: screenHeight * 0.200,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        SizedBox(
          height: screenHeight * 0.0500,),
      ],
    );
  }

  Widget _buildButton(double screenWidth,double screenHeight, String buttonText, VoidCallback onPressed) {
    return Container(
      width: screenWidth * 0.600,
      height: screenHeight * 0.0500,
      child: ElevatedButton(
        onPressed: onPressed,
        child: Text(buttonText),
      ),
    );
  }
}
