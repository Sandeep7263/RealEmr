import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:async';

// Replace these with your actual imports
import 'package:realemrs/Entry%20Page/Entry_Page%20select%20window.dart';
import 'package:realemrs/Entry%20Page/Tablet_Select.dart';

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
  List<String> selectedComplaints = [];
  List<String> selectedTablets = [];

  void _updateComplaintsValue(List<String> updatedItems) {
    setState(() {
      selectedComplaints = updatedItems;
    });
  }

  void _updateTabletsValue(List<String> updatedItems) {
    setState(() {
      selectedTablets = updatedItems;
    });
  }

  Future<void> _openComplaintsWindow() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChiefComplaint(
          updateSelectedValue: _updateComplaintsValue,
          initialSelectedItems: selectedComplaints,
        ),
      ),
    );
    if (result != null && result is List<String>) {
      setState(() {
        selectedComplaints = result.toSet().toList(); // Remove duplicates
      });
    }
  }

  Future<void> _openTabletSelectWindow() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TabletSelect(
          updateSelectedValue: _updateTabletsValue,
          initialSelectedItems: selectedTablets,
        ),
      ),
    );
    if (result != null && result is List<String>) {
      setState(() {
        selectedTablets = result.toSet().toList(); // Remove duplicates
      });
    }
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
          SizedBox(height: 10),
          Divider(
            thickness: 1,
            color: Colors.blueAccent,
            height: 5,
            indent: 5,
            endIndent: 5,
          ),
          SizedBox(height: 5),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Icon(
                Icons.error_outline,
                size: 24,
                color: Colors.blue,
              ),
              Text(
                'Chief Complaints',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(width: 80),
              ElevatedButton(
                onPressed: _openComplaintsWindow,
                child: Text('View'),
              ),
            ],
          ),
          if (selectedComplaints.isNotEmpty) ...[
            SizedBox(height: 5),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: selectedComplaints
                  .map(
                    (item) => Text(
                  '- $item',
                  style: TextStyle(fontSize: 14),
                ),
              )
                  .toList(),
            ),
          ],
          Divider(
            thickness: 1,
            color: Colors.blueAccent,
            height: 5,
            indent: 5,
            endIndent: 5,
          ),
          SizedBox(height: 5),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Icon(
                Icons.add_alarm_sharp,
                size: 24,
                color: Colors.blue,
              ),
              Text(
                'Tablet',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(width: 80),
              ElevatedButton(
                onPressed: _openTabletSelectWindow,
                child: Text('View'),
              ),
            ],
          ),
          if (selectedTablets.isNotEmpty) ...[
            SizedBox(height: 5),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: selectedTablets
                  .map(
                    (item) => Text(
                  '- $item',
                  style: TextStyle(fontSize: 14),
                ),
              )
                  .toList(),
            ),
          ],
          Divider(
            thickness: 1,
            color: Colors.blueAccent,
            height: 5,
            indent: 5,
            endIndent: 5,
          ),
          SizedBox(height: 10),
        ],
      ),
    );
  }
}
