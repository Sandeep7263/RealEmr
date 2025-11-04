import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:lottie/lottie.dart';
import 'package:realemrs/Log_In_Screen/Home_Screeen.dart';


class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  bool _isLoading = true;
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    );
    _animation = Tween<double>(begin: 0, end: 1).animate(_animationController);
    _animationController.forward();

    Future.delayed(const Duration(seconds: 5), () {
      setState(() {
        // _isLoading = false;
        Get.off(() => HomeScreen()); // Use GetX navigation
      });
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomRight,
            colors: [Colors.black, Colors.purple],
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 100),
                AnimatedBuilder(
                  animation: _animation,
                  builder: (context, child) {
                    return Transform.scale(
                      scale: _animation.value,
                      child: child,
                    );
                  },
                  child: Image.asset(
                    'assets/images/newsoft1.png',
                    height: 70,
                  ),
                ),
                const SizedBox(height: 50),
                Lottie.network(
                  'https://lottie.host/242652e9-8865-4371-91a6-4f6374a37c60/VIDnEs1K73.json',
                  height: 300,
                ),
                const SizedBox(height: 30,),
                const Column(
                  children: [
                    Text(
                      'Real EMR',
                      style: TextStyle(
                        fontFamily: 'Kanit',
                        fontSize: 30,
                        fontWeight: FontWeight.normal,
                      ),
                    )
                  ],
                ),
                Container(),
                const SizedBox(height: 35,),
                const SizedBox(height: 30),
                if (_isLoading)
                  const SpinKitRipple(
                    color: Colors.white,
                    size: 60.0,
                  ),
                const SizedBox(height: 100),
              ],
            ),
          ),
        ),
      ),
    );
  }
}