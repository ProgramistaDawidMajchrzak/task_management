import 'package:flutter/material.dart';
import 'package:task_management_go_online/widgets/custom_app_bar.dart';
import 'package:task_management_go_online/widgets/custom_nav_bar.dart';

class HomeWidget extends StatelessWidget {
  const HomeWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: CustomAppBar(
        title: 'Home',
        backOption: false,
      ),
      bottomNavigationBar: CustomNavBar(),
    );
  }
}
