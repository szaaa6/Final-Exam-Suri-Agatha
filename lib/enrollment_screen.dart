import 'package:flutter/material.dart';
import 'select_subject_page.dart';

class EnrollmentScreen extends StatelessWidget {
  final Map<String, dynamic> user;

  EnrollmentScreen({required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Welcome ${user['name']}'),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,// App bar color set to black
      ),
      body: Container(
        // Background Gradasi Gold dan Hitam
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFFFFD700), // Gold
              Color(0xFF000000), // Black
            ],
          ),
        ),
        child: Center(
          child: ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SelectSubjectPage(userId: user['id'])),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black, // Background color of the button
              foregroundColor: Colors.white, // Text color of the button
              padding: EdgeInsets.symmetric(horizontal: 50, vertical: 20),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30), // Rounded corners
              ),
            ),
            child: Text(
              'Select Subject',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
