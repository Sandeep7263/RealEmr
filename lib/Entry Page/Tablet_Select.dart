import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TabletSelect extends StatefulWidget {
  final Function(List<String>) updateSelectedValue;
  final List<String> initialSelectedItems;

  const TabletSelect({
    Key? key,
    required this.updateSelectedValue,
    required this.initialSelectedItems,
  }) : super(key: key);

  @override
  _TabletSelectState createState() => _TabletSelectState();
}

class _TabletSelectState extends State<TabletSelect> {
  late SharedPreferences _prefs;
  late Box<Entry> _entryBox;
  final List<String> medicalTablets = [
    'Aspirin',
    'Ibuprofen',
    'Acetaminophen',
    'Amoxicillin',
    'Ciprofloxacin',
    'Doxycycline',
    'Prednisone',
    'Warfarin',
    'Metformin',
    'Lisinopril',
    'Atorvastatin',
    'Levothyroxine',
    'Simvastatin',
    'Omeprazole',
    'Azithromycin',
    'Losartan',
    'Metoprolol',
    'Albuterol',
    'Hydrochlorothiazide',
    'Gabapentin',
  ];

  List<String> filteredList = [];
  List<String> selectedItems = [];

  @override
  void initState() {
    super.initState();
    _initBoxes();
    _loadSharedPreferences();
  }

  Future<void> _initBoxes() async {
    await Hive.openBox<Entry>('entryBox');
    _entryBox = Hive.box<Entry>('entryBox');
  }

  Future<void> _loadSharedPreferences() async {
    _prefs = await SharedPreferences.getInstance();
    final List<String>? savedItems = _prefs.getStringList('savedItems');
    if (savedItems != null) {
      setState(() {
        medicalTablets.addAll(savedItems);
        filteredList = medicalTablets;
        selectedItems.addAll(widget.initialSelectedItems);
      });
    }
  }

  void _searchItem(String query) {
    query = query.toLowerCase();
    setState(() {
      filteredList = medicalTablets
          .where((item) => item.toLowerCase().contains(query))
          .toList();
      filteredList.sort(); // Sort the filtered list alphabetically
    });
  }

  void _toggleItemSelection(String item) {
    setState(() {
      if (selectedItems.contains(item)) {
        selectedItems.remove(item);
      } else {
        selectedItems.add(item);
      }
    });
  }

  Future<void> _deleteSelectedItems() async {
    if (selectedItems.isNotEmpty) {
      bool? confirmDelete = await showDialog<bool>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Delete Selected Items?'),
            content: Text('Are you sure you want to delete selected items?'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
                child: Text('No'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
                child: Text(
                  'Yes',
                  style: TextStyle(
                    color: Colors.red,
                  ),
                ),
              ),
            ],
          );
        },
      );

      if (confirmDelete != null && confirmDelete) {
        setState(() {
          medicalTablets.removeWhere((item) => selectedItems.contains(item));
          filteredList.removeWhere((item) => selectedItems.contains(item));
          selectedItems.clear();
        });
        await _prefs.setStringList('savedItems', medicalTablets);
      }
    }
  }

  void _saveSelectedItems() {
    _prefs.setStringList('savedItems', selectedItems);
    widget.updateSelectedValue(selectedItems);

    final entry = Entry(
      tablets: selectedItems,
      // Set other parameters as needed...
    );

    _entryBox.add(entry);
    entry.save();
    print(_entryBox.values); // For testing purposes
    Navigator.of(context).pop();
  }

  void _addItemToList(String newItem) async {
    setState(() {
      medicalTablets.add(newItem);
      filteredList.add(newItem);
      filteredList.sort(); // Sort the filtered list alphabetically
    });
    await _prefs.setStringList('savedItems', medicalTablets);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Selected Tablets'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      labelText: 'Search',
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(),
                    ),
                    onChanged: _searchItem,
                  ),
                ),
                IconButton(
                  onPressed: _deleteSelectedItems,
                  icon: Icon(Icons.delete, color: Colors.red),
                ),
              ],
            ),
          ),
          Expanded(
            child: filteredList.isEmpty
                ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('No records found'),
                  ElevatedButton(
                    onPressed: () async {
                      final newItem = await showDialog<String>(
                        context: context,
                        builder: (BuildContext context) {
                          String newCondition = '';
                          return AlertDialog(
                            title: Text('Add New Medical Condition'),
                            content: TextField(
                              onChanged: (value) {
                                newCondition = value;
                              },
                              decoration: InputDecoration(
                                hintText: 'Enter new condition',
                              ),
                            ),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () {
                                  if (newCondition.isNotEmpty) {
                                    _addItemToList(newCondition);
                                    Navigator.of(context).pop();
                                  }
                                },
                                child: Text('Add'),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: Text('Cancel'),
                              ),
                            ],
                          );
                        },
                      );
                    },
                    child: Text('Add New Item'),
                  ),
                ],
              ),
            )
                : ListView.builder(
              itemCount: filteredList.length,
              itemBuilder: (context, index) {
                final item = filteredList[index];
                final isSelected = selectedItems.contains(item);

                return ListTile(
                  title: Text(item),
                  onTap: () {
                    _toggleItemSelection(item);
                  },
                  trailing: isSelected
                      ? Icon(Icons.check_box)
                      : Icon(Icons.check_box_outline_blank),
                );
              },
            ),
          ),
          SizedBox(
            width: 300,
            height: 60,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: _saveSelectedItems,
                style: ElevatedButton.styleFrom(
                  primary: Colors.lightBlue,
                  onPrimary: Colors.white,
                ),
                child: Text(
                  'Save',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class Entry extends HiveObject {
  late List<String> tablets;

  Entry({
    required this.tablets,
  });

  Future<void> save() async {
    final box = Hive.box<Entry>('entryBox');
    await box.add(this);
  }
}
