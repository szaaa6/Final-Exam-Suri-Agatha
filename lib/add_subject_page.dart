import 'package:flutter/material.dart';
import 'database_helper.dart';

class SelectSubjectPage extends StatefulWidget {
  final int userId;

  SelectSubjectPage({required this.userId});

  @override
  _SelectSubjectPageState createState() => _SelectSubjectPageState();
}

class _SelectSubjectPageState extends State<SelectSubjectPage> {
  final DatabaseHelper dbHelper = DatabaseHelper();
  List<Map<String, dynamic>> selectedSubjects = [];

  // Function to load the subjects for the user
  Future<void> _loadSubjects() async {
    final subjects = await dbHelper.getSubjectsByUserId(widget.userId);
    setState(() {
      selectedSubjects = subjects;
    });
  }

  @override
  void initState() {
    super.initState();
    _loadSubjects(); // Load subjects when the page is initialized
  }

  // Navigate to the Add Subject page to add a new subject
  void _navigateToAddSubject() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddSubjectPage(userId: widget.userId),
      ),
    ).then((_) {
      // After returning from AddSubjectPage, reload the subjects list
      _loadSubjects();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Select Subjects')),
      body: Column(
        children: [
          ElevatedButton(
            onPressed: _navigateToAddSubject,
            child: Text('Add Subject'),
          ),
          Expanded(
            child: selectedSubjects.isNotEmpty
                ? ListView.builder(
              itemCount: selectedSubjects.length,
              itemBuilder: (context, index) {
                final subject = selectedSubjects[index];
                return ListTile(
                  title: Text(subject['name']),
                  subtitle: Text('${subject['credits']} credits'),
                );
              },
            )
                : Center(child: Text('No subjects added yet.')),
          ),
        ],
      ),
    );
  }
}

class AddSubjectPage extends StatefulWidget {
  final int userId;

  AddSubjectPage({required this.userId});

  @override
  _AddSubjectPageState createState() => _AddSubjectPageState();
}

class _AddSubjectPageState extends State<AddSubjectPage> {
  final DatabaseHelper dbHelper = DatabaseHelper();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController creditsController = TextEditingController();

  // Function to add subject to the list
  void _addSubject() async {
    final String name = nameController.text;
    final int credits = int.tryParse(creditsController.text) ?? 0;

    if (name.isNotEmpty && credits > 0) {
      await dbHelper.saveSubjects(widget.userId, [
        {'name': name, 'credits': credits}
      ]);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Subject added successfully!'),
      ));

      // Clear input fields after adding
      nameController.clear();
      creditsController.clear();
      Navigator.pop(context); // Go back to the previous page
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Please enter valid subject name and credits.'),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add Subject')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(labelText: 'Subject Name'),
            ),
            TextField(
              controller: creditsController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Credits'),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _addSubject,
              child: Text('Add Subject'),
            ),
          ],
        ),
      ),
    );
  }
}
