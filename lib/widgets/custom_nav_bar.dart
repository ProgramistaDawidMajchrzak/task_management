import 'package:flutter/material.dart';

class CustomNavBar extends StatefulWidget {
  // ignore: prefer_typing_uninitialized_variables
  const CustomNavBar({super.key});

  @override
  State<CustomNavBar> createState() => CustomNavBarWidgetState();
}

class CustomNavBarWidgetState extends State<CustomNavBar> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final route = ModalRoute.of(context);
    final currentPath = route?.settings.name ?? 'No path';
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Container(
        // /width: MediaQuery.of(context).size.width - 200,
        decoration: const BoxDecoration(
          color: Color(0xFFE9E9F0),
          borderRadius: BorderRadius.all(Radius.circular(40.0)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(
                icon: Icon(
                  Icons.home_outlined,
                  color: currentPath == '/home'
                      ? const Color(0xFF3787EB)
                      : Colors.grey,
                ),
                onPressed: () {
                  Navigator.pushNamed(context, '/home');
                },
              ),
              _buildCenterButton(),
              IconButton(
                icon: Icon(
                  Icons.list_alt,
                  color: currentPath == '/tasks-list'
                      ? const Color(0xFF3787EB)
                      : Colors.grey,
                ),
                onPressed: () {
                  Navigator.pushNamed(context, '/tasks-list');
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCenterButton() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF3787EB),
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: IconButton(
        icon: const Icon(
          Icons.add,
          color: Colors.white,
        ),
        onPressed: () {
          Navigator.pushNamed(context, '/add-task');
        },
      ),
    );
  }
}
