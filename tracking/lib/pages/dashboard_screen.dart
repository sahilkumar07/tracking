import 'package:flutter/material.dart';
import 'application_status_screen.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print("Background Message: ${message.notification?.title} - ${message.notification?.body}");
}

class DashboardScreen extends StatefulWidget {
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  late FirebaseMessaging _firebaseMessaging;
  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String studentName = "";
  String studentEmail = "";
  String studentPhone = "";
  String applicationStatus = "Loading...";

  @override
  void initState() {
    super.initState();
    _firebaseMessaging = FirebaseMessaging.instance;
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    _initializePushNotifications();
    _fetchUserData(); 
  }

  void _initializePushNotifications() async {
    
    NotificationSettings settings = await _firebaseMessaging.requestPermission();
    
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    final InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);
    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onSelectNotification: _onSelectNotification, 
    );

    _firebaseMessaging.getToken().then((token) async {
      if (token != null) {
        _updateUserFCMToken(token);
      }
    });

    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      showNotification(message.notification?.title, message.notification?.body);
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
      print("Notification Clicked (Background): ${message.notification?.title}");
      _navigateToApplicationStatusScreen();
    });

    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  }

  Future<void> showNotification(String? title, String? body) async {
    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'channel_id',
      'Important Updates',
      importance: Importance.max,
      priority: Priority.high,
    );
    const NotificationDetails notificationDetails = NotificationDetails(android: androidDetails);
    await flutterLocalNotificationsPlugin.show(
      0,
      title ?? "New Notification",
      body ?? "You have an update",
      notificationDetails,
      payload: 'Custom Data', 
    );
  }

  Future<void> _onSelectNotification(String? payload) async {
    print("Notification Clicked: $payload");
    _navigateToApplicationStatusScreen();
  }

  void _navigateToApplicationStatusScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ApplicationStatusScreen()),
    );
  }

  Future<void> _updateUserFCMToken(String token) async {
    User? user = _auth.currentUser;
    if (user != null) {
      await _firestore.collection('users').doc(user.uid).update({
        'fcm_token': token,
      });
    }
  }

  void _fetchUserData() async {
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        DocumentSnapshot userDoc = await _firestore.collection('users').doc(user.uid).get();

        if (userDoc.exists) {
          setState(() {
            studentName = userDoc['name'] ?? 'Unknown';
            studentEmail = userDoc['email'] ?? 'Unknown';
            studentPhone = userDoc['phone'] ?? 'Unknown';
            applicationStatus = userDoc['application_status'] ?? 'Pending';
          });
        } else {
          setState(() {
            applicationStatus = 'No application found';
          });
        }
      } else {
        setState(() {
          applicationStatus = 'No user authenticated';
        });
      }
    } catch (e) {
      setState(() {
        applicationStatus = 'Error fetching data';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Dashboard"),backgroundColor:const Color.fromARGB(255, 236, 191, 10),),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.all(20),
                width: double.infinity, 
                decoration: BoxDecoration(
                  color: Colors.blueAccent.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                 
                ),
                margin: EdgeInsets.only(bottom: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Student Details", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.blue)),
                    SizedBox(height: 10),
                    Text("Name: $studentName", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black)), 
                    Text("Email: $studentEmail", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black)), 
                    Text("Phone: $studentPhone", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black)), 
                    SizedBox(height: 10),
                    Text("Application Status: $applicationStatus", 
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, 
                        color: applicationStatus == 'Completed' ? Colors.green : Colors.blueAccent)),
                  ],
                ),
              ),

              Card(
                elevation: 5,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: ListTile(
                  title: Text('View Application Status', style: TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text('Current Status: $applicationStatus'),
                  onTap: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ApplicationStatusScreen()),
                    );
                    _fetchUserData(); 
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

