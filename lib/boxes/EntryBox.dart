import 'dart:html';

import 'package:hive/hive.dart';

class EntryBox{

  static Box<Entry> getData() => Hive.box<Entry>('Entry');
}