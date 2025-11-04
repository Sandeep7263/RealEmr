import 'package:hive/hive.dart';

import '../DB_Hive/Models.dart';

class Boxes{

  static Box<EmrModels> getData() => Hive.box<EmrModels>('EmrModels');
}