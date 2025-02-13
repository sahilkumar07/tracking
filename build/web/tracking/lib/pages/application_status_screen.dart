import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ApplicationStatusScreen extends StatefulWidget {
  @override
  _ApplicationStatusScreenState createState() =>
      _ApplicationStatusScreenState();
}

class _ApplicationStatusScreenState extends State<ApplicationStatusScreen> {
  List<Map<String, dynamic>> stages = [
    {'title': 'Document Submission', 'completed': false},
    {'title': 'Interview Scheduling', 'completed': false},
    {'title': 'Final Decision', 'completed': false},
  ];

  double progress = 0.0;

  @override
  void initState() {
    super.initState();
    _fetchApplicationProgress();
  }

  void _fetchApplicationProgress() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      if (userDoc.exists && userDoc.data() != null) {
        Map<String, dynamic>? data = userDoc.data() as Map<String, dynamic>?;

        if (data != null && data.containsKey('application_stages')) {
          List<dynamic> storedStages = data['application_stages'];

          setState(() {
            for (int i = 0; i < stages.length; i++) {
              if (i < storedStages.length) {
                stages[i]['completed'] = storedStages[i];
              }
            }
            _updateProgress();
          });
        }
      }
    }
  }

  void _toggleStageCompletion(int index) async {
    setState(() {
      stages[index]['completed'] = !stages[index]['completed'];
      _updateProgress();
    });

    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      bool isCompleted = stages.every((stage) => stage['completed']);

      await FirebaseFirestore.instance.collection('users').doc(user.uid).update({
        'application_stages': stages.map((stage) => stage['completed']).toList(),
        'application_status': isCompleted ? 'Completed' : 'Pending',
      });

      if (isCompleted) {
        _showCompletionDialog();
      }
    }
  }

  void _updateProgress() {
    int completedStages =
        stages.where((stage) => stage['completed'] == true).length;
    setState(() {
      progress = completedStages / stages.length;
    });
  }

  void _showCompletionDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Congratulations!'),
          content: Text('You have successfully completed your application.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Application"),backgroundColor: const Color.fromARGB(255, 236, 191, 10), 
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Your Application is in progress...",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            SizedBox(height: 20),
            LinearProgressIndicator(
              value: progress,
              minHeight: 10,
              color: progress == 1.0 ? Colors.green : Colors.red, 
              backgroundColor: Colors.grey[300],
            ),
            SizedBox(height: 40),
            Expanded(
              child: ListView.builder(
                itemCount: stages.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(stages[index]['title'],
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: stages[index]['completed'] ? Colors.green : Colors.red,
                        )),
                    trailing: Icon(
                        stages[index]['completed']
                            ? Icons.check_circle
                            : Icons.circle,
                        color: stages[index]['completed'] ? Colors.green : Colors.red),
                    onTap: () => _toggleStageCompletion(index),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
