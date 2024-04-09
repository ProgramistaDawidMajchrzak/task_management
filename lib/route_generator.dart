import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:task_management_go_online/screens/add_task.dart';
import 'package:task_management_go_online/screens/home.dart';
import 'package:task_management_go_online/screens/tasks.dart';

class RouteGenerator {
  static Route<dynamic>? generateRoute(RouteSettings settings) {
    final dynamic args = settings.arguments;
    switch (settings.name) {
      //ONBOARDING
      case '/home':
        return PageTransition(
          child: const HomeWidget(),
          type: PageTransitionType.fade,
          settings: settings,
        );
      case '/tasks-list':
        return PageTransition(
          child: const TasksWidget(),
          type: PageTransitionType.fade,
          settings: settings,
        );
      case '/add-task':
        return PageTransition(
          child: const AddTaskWidget(),
          type: PageTransitionType.fade,
          settings: settings,
        );
    }
    return null;
  }
}
