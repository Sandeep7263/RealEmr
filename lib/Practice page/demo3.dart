import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:async';

class EntryPage extends StatefulWidget {
  final String userName;
  final String userGender;
  final String genderIconPath;

  const EntryPage({
    Key? key,
    required this.userName,
    required this.userGender,
    required this.genderIconPath,
  }) : super(key: key);

  @override
  State<EntryPage> createState() => _EntryPageState();
}

class _EntryPageState extends State<EntryPage> {
  List<String> selectedItems = [];

  void _updateSelectedValue(List<String> selectedItems) {
    setState(() {
      this.selectedItems = selectedItems;
    });
  }

  void _deleteSelectedItem(String item) {
    setState(() {
      selectedItems.remove(item);
    });
  }

  void _openNewItemWindow() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChiefComplaint(
          updateSelectedValue: _updateSelectedValue,
        ),
      ),
    );
    // Handle result if needed
  }

  String currentDate = DateFormat('dd-MMM-yyyy').format(DateTime.now());
  late String currentTime;
  late Timer timer;

  @override
  void initState() {
    super.initState();
    currentTime = DateFormat('hh:mm:ss a').format(DateTime.now());
    timer = Timer.periodic(Duration(seconds: 1), (Timer t) {
      setState(() {
        currentTime = DateFormat('hh:mm:ss a').format(DateTime.now());
      });
    });
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant EntryPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.userName != oldWidget.userName) {
      setState(() {
        // Update any relevant state based on new widget data
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '${widget.userName} (${widget.userGender.toUpperCase()})',
          style: TextStyle(fontSize: 20),
        ),
        backgroundColor: Colors.blue,
        centerTitle: true,
        automaticallyImplyLeading: false,
        leading: Image.asset(
          widget.genderIconPath,
          width: 24,
          height: 24,
        ),
        actions: [
          // Add any other actions here
        ],
      ),
      body: Column(
        children: [
          SizedBox(height: 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Image.asset(
                        'assets/images/schedule.png',
                        width: 24,
                        height: 24,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        currentDate,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Colors.deepPurple,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 23),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/images/clock.png',
                      width: 24,
                      height: 24,
                    ),
                    SizedBox(width: 5),
                    Expanded(
                      child: Text(
                        currentTime,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.deepPurple,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: 200, // Adjust the maximum height as needed
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (selectedItems.isNotEmpty)
                      ...List.generate(selectedItems.length, (index) {
                        final item = selectedItems[index];
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  '${index + 1}. $item',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              IconButton(
                                icon: Icon(
                                  Icons.delete,
                                  color: Colors.black,
                                ),
                                onPressed: () {
                                  _deleteSelectedItem(item);
                                },
                              ),
                            ],
                          ),
                        );
                      }),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                          onPressed: _openNewItemWindow,
                          child: Text(
                            'View',
                            style: TextStyle(
                              color: Colors.blue,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        SizedBox(width: 10),
                        ElevatedButton(
                          onPressed: () {
                            // Handle 'Add' button click
                          },
                          child: Text(
                            'Add',
                            style: TextStyle(
                              color: Colors.green,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(height: 20),
        ],
      ),
    );
  }
}
