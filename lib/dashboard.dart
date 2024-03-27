import 'package:flutter/material.dart';
import 'package:mainportal/notif_list.dart';
import 'package:mainportal/workorder.dart';
import 'package:mainportal/main.dart';

void main() {
  runApp(MaterialApp(
    home: Dashboard(),
  ));
}

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  void logout() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => MyApp(),
      ),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        title: Text(
          'DASHBOARD',
          style: TextStyle(
            letterSpacing: 2.0,
          ),
        ),
        automaticallyImplyLeading: false,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blue, Colors.blueAccent],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        actions: [
          Tooltip(
            message: "Logout",
            child: IconButton(
              icon: Icon(Icons.logout),
              onPressed: logout,
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(18.0),
              child: Center(
                child: Wrap(
                  spacing: 20.0,
                  runSpacing: 20.0,
                  children: [
                    _buildCard('NOTIFICATION DETAILS', 'View', () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => notification(),
                        ),
                      );
                    }),
                    _buildCard('WORK ORDER DETAILS', 'View', () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => workorder(),
                        ),
                      );
                    }),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
          bottom: 0,
          child: Container(
            width: MediaQuery.of(context).size.width,
            color: Colors.blue,
            padding: const EdgeInsets.all(10),
            child: const Text(
              'SAP ERP Portal Development - MAINTENANCE PORTAL',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ),
        ],
      ),
    );
  }

  Widget _buildCard(String title, String buttonText, VoidCallback onPressed) {
    return SizedBox(
      width: 150.0,
      height: 220.0,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: 4.0),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  onPressed: onPressed,
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 8.0),
                  ),
                  child: Text(
                    buttonText,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
