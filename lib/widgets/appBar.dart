import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool showLeading;
  final List<Widget>? actions;

  CustomAppBar({
    required this.title,
    this.showLeading = false,
    this.actions,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: showLeading
          ? IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.of(context).pop(),
            )
          : Container(),
      title: Text(
        title,
        style: TextStyle(color: Colors.white),
      ),
      backgroundColor: Color(0xFF02243D),
      centerTitle: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(30),
        ),
      ),
      actions: actions,
      bottom: PreferredSize(
        preferredSize: Size.fromHeight(10),
        child: Container(
          margin: EdgeInsets.only(bottom: 10),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight + 10);
}
