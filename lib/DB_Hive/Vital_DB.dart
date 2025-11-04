import 'package:hive/hive.dart';

part 'vital_info.g.dart';

@HiveType(typeId: 0)
class VitalInfo {
  @HiveField(0)
  String bloodPressureSystolic;

  @HiveField(1)
  String bloodPressureDiastolic;

  @HiveField(2)
  String height;

  @HiveField(3)
  String diagnosis;

  @HiveField(4)
  String pulse;

  @HiveField(5)
  String weight;

  @HiveField(6)
  String temperature;

  // Add other fields as needed

  VitalInfo({
    required this.bloodPressureSystolic,
    required this.bloodPressureDiastolic,
    required this.height,
    required this.diagnosis,
    required this.pulse,
    required this.weight,
    required this.temperature,
  });
}
