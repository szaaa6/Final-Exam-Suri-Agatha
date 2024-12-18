import 'package:flutter/material.dart';
import 'database_helper.dart';

class SummaryEnrollmentPage extends StatelessWidget {
  final int userId;
  final DatabaseHelper dbHelper = DatabaseHelper();

  SummaryEnrollmentPage({required this.userId});

  // Mengambil daftar subjek yang dipilih oleh pengguna berdasarkan userId
  Future<List<Map<String, dynamic>>> _getEnrolledSubjects() async {
    return await dbHelper.getSubjectsByUserId(userId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Menggunakan background gold to black gradient
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.black, Colors.yellow.shade700], // Gold and Black Gradient
          ),
        ),
        child: FutureBuilder(
          future: _getEnrolledSubjects(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasData) {
              final subjects = snapshot.data as List<Map<String, dynamic>>;
              final totalCredits = subjects.fold(
                0,
                    (sum, subject) => sum + subject['credits'] as int,
              );

              // Menampilkan daftar subjek dan total kredit
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Header Text
                    Text(
                      "Your Enrolled Subjects",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 20),

                    // Daftar subjek yang diambil
                    Expanded(
                      child: ListView.builder(
                        itemCount: subjects.length,
                        itemBuilder: (context, index) {
                          final subject = subjects[index];
                          return Container(
                            margin: EdgeInsets.symmetric(vertical: 5),
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.7),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: ListTile(
                              title: Text(
                                subject['name'],
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              subtitle: Text(
                                '${subject['credits']} credits',
                                style: TextStyle(
                                  color: Colors.white70,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),

                    // Total Credits Section
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      child: Text(
                        'Total Credits: $totalCredits',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.yellow.shade700,
                        ),
                      ),
                    ),

                    // Back Button
                    ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text('Back to Subjects'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.yellow.shade700,  // Gold button
                        padding: EdgeInsets.symmetric(horizontal: 60, vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        textStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],
                ),
              );
            } else {
              return Center(child: Text('No subjects enrolled yet.'));
            }
          },
        ),
      ),
    );
  }
}
