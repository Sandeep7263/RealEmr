import 'package:hive/hive.dart';
import 'package:realemrs/DB_Hive/Models.dart';

import '../boxes/boxes.dart';

part 'Entry_DB.g.dart';

@HiveType(typeId: 14)
class Entry extends HiveObject {
  @HiveField(0)
  late List<String> complaints;

  @HiveField(1)
  late List<String> tablets;

  @HiveField(2)
  late List<String> diagnosis;

  Entry({
    required this.complaints,
    required this.tablets,
    required this.diagnosis,
  });

  Future<void> save() async {
    final box = Boxes.getData(); // Get the Hive box
    await box.add(this as EmrModels); // Add the data to the box without casting to EmrModels
  }
}
