import 'package:flutter/material.dart';
import 'package:laboratory5/frontend/theme/app_theme.dart';

class TitleAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;

  const TitleAppBar({super.key, required this.title, this.actions});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        title,
        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
      centerTitle: true,
      elevation: 2,
      backgroundColor: AppTheme.accentColor,
      foregroundColor: AppTheme.paperColor,
      actions: actions,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
