import 'package:flutter/material.dart';
import 'summary_enrollment_page.dart';
import 'database_helper.dart';

class SelectSubjectPage extends StatefulWidget {
  final int userId;

  SelectSubjectPage({required this.userId});

  @override
  _SelectSubjectPageState createState() => _SelectSubjectPageState();
}

class _SelectSubjectPageState extends State<SelectSubjectPage> {
  final DatabaseHelper dbHelper = DatabaseHelper();
  List<Map<String, dynamic>> subjects = [
    {'name': 'Mathematics', 'credits': 4},
    {'name': 'Physics', 'credits': 3},
    {'name': 'Chemistry', 'credits': 3},
    {'name': 'Biology', 'credits': 2},
    {'name': 'History', 'credits': 2},
    {'name': 'Computer Science', 'credits': 5},
    {'name': 'English', 'credits': 2},
  ];
  List<Map<String, dynamic>> selectedSubjects = [];
  int totalCredits = 0;

  @override
  void initState() {
    super.initState();
    _loadSubjects();
  }

  // Load the subjects already selected based on userId
  void _loadSubjects() async {
    final subjectsFromDb = await dbHelper.getSubjectsByUserId(widget.userId);
    setState(() {
      selectedSubjects = List.from(subjectsFromDb);  // Copy data to modify it
      totalCredits = selectedSubjects.fold(0, (sum, subject) => sum + subject['credits'] as int);
    });
  }

  // Toggle the selection or removal of a subject
  void _toggleSubject(Map<String, dynamic> subject) {
    setState(() {
      // Check if the subject is already in the selected list
      if (selectedSubjects.contains(subject)) {
        selectedSubjects.remove(subject);
        totalCredits -= subject['credits'] as int;
      } else if (totalCredits + subject['credits'] <= 24) {
        selectedSubjects.add(subject);
        totalCredits += subject['credits'] as int;
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Total credits cannot exceed 24!')),
        );
      }
    });
  }

  // Save the selected subjects and navigate to the summary page
  void _saveSubjects() async {
    await dbHelper.saveSubjects(widget.userId, selectedSubjects);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SummaryEnrollmentPage(userId: widget.userId),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Background with gold-black gradient
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.black, Colors.yellow.shade700], // Gold and Black gradient
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0), // Padding around the content
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Text
              Text(
                'Select Subjects',
                style: TextStyle(
                  fontSize: 28, // Larger font size for the title
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 2, // Add some letter spacing for elegance
                ),
              ),
              SizedBox(height: 20),

              // List of subjects with checkboxes
              Expanded(
                child: ListView.builder(
                  itemCount: subjects.length,
                  itemBuilder: (context, index) {
                    final subject = subjects[index];
                    final isSelected = selectedSubjects.contains(subject);

                    return Container(
                      margin: EdgeInsets.symmetric(vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.7),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ListTile(
                        contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                        title: Text(
                          subject['name'],
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20, // Larger text for subject name
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        subtitle: Text(
                          '${subject['credits']} credits',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 16, // Slightly smaller subtitle text
                          ),
                        ),
                        trailing: Checkbox(
                          value: isSelected,
                          onChanged: (value) => _toggleSubject(subject),
                          activeColor: Colors.yellow.shade700,
                        ),
                      ),
                    );
                  },
                ),
              ),

              // Total credits display
              Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Total Credits:',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                      ),
                    ),
                    Text(
                      '$totalCredits',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),

              // Save and View Summary Button
              ElevatedButton(
                onPressed: _saveSubjects,
                child: Text('Save and View Summary'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.yellow.shade700, // Gold button color
                  padding: EdgeInsets.symmetric(horizontal: 60, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  textStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
