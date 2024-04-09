import 'package:flutter/material.dart';
import 'package:task_management_go_online/widgets/style.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool backOption;

  const CustomAppBar({
    Key? key,
    required this.title,
    required this.backOption,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    Widget? leadingWidget = backOption
        ? Container(
            width: 30,
            height: 30,
            margin: const EdgeInsets.only(left: 10.0, top: 5.0, bottom: 5.0),
            decoration: BoxDecoration(
              color: const Color(0xFFE9E9F0),
              borderRadius: BorderRadius.circular(10),
            ),
            child: IconButton(
              icon: const Icon(
                Icons.arrow_back_ios_new,
                color: Colors.grey,
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          )
        : null;

    return AppBar(
      backgroundColor: Colors.white,
      title: Text(
        title,
        style: poppinsBlack.copyWith(
          color: Colors.black,
          fontSize: screenWidth > 360 ? 19 : 13,
        ),
      ),
      centerTitle: true,
      automaticallyImplyLeading: false,
      leading: leadingWidget,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
