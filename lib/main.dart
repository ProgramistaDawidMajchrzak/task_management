import 'package:flutter/material.dart';
import 'package:task_management_go_online/route_generator.dart';
import 'package:task_management_go_online/screens/home.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
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
      home: HomeWidget(),
    );
  }
}

// class MyHomePage extends StatefulWidget {
//   const MyHomePage({super.key, required this.title});
//   final String title;
//   @override
//   State<MyHomePage> createState() => _MyHomePageState();
// }

// class _MyHomePageState extends State<MyHomePage> {
//   late Widget defaultHome = HomeWidget();
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Task Management',
//       themeMode: ThemeMode.system,
//       home: defaultHome,
//       onGenerateRoute: RouteGenerator.generateRoute,
//     );
//   }
// }
