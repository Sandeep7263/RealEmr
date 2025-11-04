import 'package:get/get.dart';

class EntryPageController extends GetxController {
  var dropdownValue = 'Option 1'.obs;

  void changeDropdownValue(String newValue) {
    dropdownValue.value = newValue;
  }
}
