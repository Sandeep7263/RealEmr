import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/bindings_interface.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:realemrs/DB_Hive/Models.dart';
import 'package:realemrs/Doctor_Page/Add_New_Patients.dart';
import 'package:realemrs/Log_In_Screen/Home_Screeen.dart';
import 'package:realemrs/Log_In_Screen/Slash_screen.dart';
import 'DB_Hive/Entry_DB.dart';
import 'Doctor_Page/Doctor_Homescreen.dart';
import 'Log_In_Screen/Doctor_SignUp.dart';
import 'Log_In_Screen/Option_Screen.dart';
import 'Log_In_Screen/Staff_Screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final appDocumentDir = await getApplicationDocumentsDirectory();
  Hive.init(appDocumentDir.path);

  Hive.registerAdapter(EmrModelsAdapter());
  Hive.registerAdapter(EntryAdapter());
  await Hive.openBox<EmrModels>('EmrModels');
  await Hive.openBox<Entry>('Entry');
if(kIsWeb){
  await Firebase.initializeApp(options: FirebaseOptions(
      apiKey: "AIzaSyANXMEllsA5HyYc1bW3WP-BUBEXRCF_-VA",
      appId: "1:819795713192:web:5a337a66791654cb87369d",
      messagingSenderId: "819795713192",
      projectId: "myopd-acd08"));
}else{
  await Firebase.initializeApp(options: const FirebaseOptions(
      apiKey: "AIzaSyANXMEllsA5HyYc1bW3WP-BUBEXRCF_-VA",
      appId: "1:819795713192:web:5a337a66791654cb87369d",
      messagingSenderId: "819795713192",
      projectId: "myopd-acd08"));
}
  runApp(const MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return  GetMaterialApp(
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: ThemeMode.light,
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      initialBinding: AppBindings(),

      home:   DoctorHomescreen(),

    );
  }
}

class AppBindings extends Bindings {
  @override
  void dependencies() {
    Get.put( HomeScreen ());
    Get.put( HomeController ());
    Get.put( OptionScreen ());
    Get.put(StaffScreen());
    Get.put(DoctorSignup());
    Get.put(DoctorHomescreen());
    Get.put( AddPatientsController());
    Get.put(AddNewPatients());
    Get.put(SplashScreen());


  }
}


