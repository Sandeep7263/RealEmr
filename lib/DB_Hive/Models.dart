import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../boxes/boxes.dart';

part 'Models.g.dart';

@HiveType(typeId: 0)
class EmrModels extends HiveObject {
  @HiveField(0)
  final String name;
  @HiveField(1)
  final String dob;
  @HiveField(2)
  final String gender;
  @HiveField(3)
  final String email;
  @HiveField(4)
  final String mobileno;
  @HiveField(5)
  final String age;
  @HiveField(6)
  final String country;
  @HiveField(7)
  final String state;
  @HiveField(8)
  final String city;
  @HiveField(9)
  final String religion;
  @HiveField(10)
  final String occupation;
  @HiveField(11)
  final String address;
  @HiveField(12)
  final String mothertongue;
  @HiveField(13)
  final DateTime creationDateTime;

  @HiveType(typeId: 1)
  EmrModels({
    required this.name,
    required this.dob,
    required this.gender,
    required this.email,
    required this.mobileno,
    required this.age,
    required this.country,
    required this.state,
    required this.city,
    required this.religion,
    required this.occupation,
    required this.address,
    required this.mothertongue,
    DateTime? creationDateTime,
  }) : creationDateTime = creationDateTime ?? DateTime.now();

  Future<void> save() async {
    final box = Boxes.getData(); // Get the Hive box
    box.add(this); // Add the data to the box
  }
}
