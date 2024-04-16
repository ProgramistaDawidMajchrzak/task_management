import 'package:flutter/material.dart';
import 'package:task_management_go_online/route_generator.dart';
import 'package:task_management_go_online/screens/boarding.dart';
import 'package:task_management_go_online/screens/home.dart';
// import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:task_management_go_online/services/notify_service.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await LocalNotifications.init();
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()!
      .requestNotificationsPermission();
  flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()!
      .pendingNotificationRequests();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Widget defaultHome = const HomeWidget();
  int? showBoarding = 0;
  @override
  void initState() {
    LocalNotifications.scheduledNotification(hour: 10, minutes: 30);
    loadPreferences();
    super.initState();
  }

  Future<void> loadPreferences() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    showBoarding = prefs.getInt('show_boarding');
    setState(() {
      defaultHome = (showBoarding != null && showBoarding != 0)
          ? const HomeWidget()
          : const OnboardingScreen();
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Task Management',
      onGenerateRoute: RouteGenerator.generateRoute,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: defaultHome,
    );
  }
}
