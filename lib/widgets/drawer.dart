import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:realemrs/widgets/Pie_Chart.dart';

class MenuDrawer extends StatefulWidget {
  const MenuDrawer({Key? key}) : super(key: key);

  @override
  _MenuDrawerState createState() => _MenuDrawerState();
}

class _MenuDrawerState extends State<MenuDrawer> {
  late GoogleSignIn _googleSignIn;
  GoogleSignInAccount? _currentUser;

  @override
  void initState() {
    super.initState();
    _googleSignIn = GoogleSignIn(scopes: ['email', 'profile']);
    _googleSignIn.onCurrentUserChanged.listen((GoogleSignInAccount? account) {
      setState(() {
        _currentUser = account;
      });
    });
    _googleSignIn.signInSilently();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
            accountName: Text(
              'Dr. User Name',
              style: TextStyle(
                fontSize: 20,
              ),
            ),
            accountEmail: Text(
              'user@example.com',
            ),
            currentAccountPicture: CircleAvatar(
              backgroundImage: _currentUser?.photoUrl != null
                  ? NetworkImage(_currentUser!.photoUrl!)
                  : AssetImage('assets/images/newsoft.png') as ImageProvider<Object>, // Explicitly cast to ImageProvider<Object>
            ),

            // otherAccountsPictures: [
            //   // ClipOval(
            //   //   child: Image.asset(
            //   //     'assets/images/newsoft1.png',
            //   //     width: 40, // Adjust the width and height as needed
            //   //     height: 40,
            //   //     fit: BoxFit.cover,
            //   //   ),
            //   // ),
            // ],
          ),

          ListTile(
            title: Row(
              children: [
                Icon(Icons.person,),
                SizedBox(width: 16),
                Text('My Profile'),
              ],
            ),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: Row(
              children: [
                Icon(Icons.local_hospital,color: Color(0xFFFF0926),),
                SizedBox(width: 16,),
                Text('View Clinic'),
              ],
            ),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: Row(
              children: [
                Icon(Icons.archive,color: Color(0xFF11CFF1),),
                SizedBox(width: 16,),
                Text('My Services'),
              ],
            ),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: Row(
              children: [
                Icon(Icons.people,color: Color(0xFFE35D2B),),
                SizedBox(width: 16,),
                Text('My clinic Patients'),
              ],
            ),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: Row(
              children: [
                Icon(MdiIcons.pill,color: Color(0xFFFF6791),),
                SizedBox(width: 16,),
                Text('My Medicines'),
              ],
            ),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: Row(
              children: [
                Icon(Icons.redeem,color: Colors.pink,),
                SizedBox(width: 16,),
                Text('My Rewards'),
              ],
            ),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: Row(
              children: [
                Icon(FontAwesomeIcons.bell,color: Colors.amber,),
                SizedBox(width: 16,),
                Text('Subscription Status'),
              ],
            ),
            onTap: () {
              Navigator.pop(context);
            },
          ),

          ListTile(
            title: Row(
              children: [
                Icon(Icons.work,color: Colors.greenAccent,),
                SizedBox(width: 16),
                Text('Manage Reception Staff'),
              ],
            ),
            onTap: () {
              Navigator.pop(context);
              // Add your navigation logic here
            },
          ),
          ListTile(
            title: Row(
              children: [
                Icon(Icons.devices,color: Colors.blue,),
                SizedBox(width: 16),
                Text('Multi-Device Sync'),
              ],
            ),
            onTap: () {
              Navigator.pop(context);
              // Add your navigation logic here
            },
          ),
          ListTile(
            title: Row(
              children: [
                Icon(FontAwesomeIcons.chartPie, color: Colors.red,),
                SizedBox(width: 16),
                Text('Charts'),
              ],
            ),
            onTap: () {
              Navigator.pop(context); // Close the drawer if needed

              // Navigate to the PieChart page
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => PieChartApp()),
              );
            },
          ),

          Divider(
            thickness: 1,
            color: Colors.blueAccent,
            height: 12,
          ),
          ListTile(
            title: Row(
              children: [
                Icon(Icons.share,color: Colors.blue,),
                SizedBox(width: 16),
                Text('Shere With Friends'),
              ],
            ),

            onTap: () {
              Navigator.pop(context);
              // Add your navigation logic here
            },
          ),
          ListTile(
            title: Row(
              children: [
                Icon(Icons.star,color: Colors.yellow,),
                SizedBox(width: 16),
                Text('Rate us on App'),
              ],
            ),

            onTap: () {
              Navigator.pop(context);
              // Add your navigation logic here
            },
          ),
          ListTile(
            title: Row(
              children: [
                Icon(Icons.thumb_down,color: Colors.red,),
                SizedBox(width: 16),
                Text('Feedback/Suggestions'),
              ],
            ),

            onTap: () {
              Navigator.pop(context);
              // Add your navigation logic here
            },
          ),
          ListTile(
            title: Row(
              children: [
                Icon(Icons.call,color: Colors.green,),
                SizedBox(width: 16),
                Text('Contact Support'),
              ],
            ),

            onTap: () {
              Navigator.pop(context);
              // Add your navigation logic here
            },
          ),
          ListTile(
            title: Row(
              children: [
                Icon(Icons.info,color: Colors.grey,),
                SizedBox(width: 16),
                Text('About'),
              ],
            ),

            onTap: () {
              Navigator.pop(context);
              // Add your navigation logic here
            },
          ),
          ListTile(
            title: Row(
              children: [
                Icon(FontAwesomeIcons.signOutAlt,color: Color(0xFF11CFF1),),
                SizedBox(width: 16),
                Text('Log Out'),
              ],
            ),

            onTap: () {
              Navigator.pop(context);
              // Add your navigation logic here
            },
          ),
        ],
      ),
    );
  }
}
