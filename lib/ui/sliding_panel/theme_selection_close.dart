import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

class ThemeSelectionClose extends StatelessWidget {
  const ThemeSelectionClose({Key? key, this.onClose}) : super(key: key);
  final VoidCallback? onClose;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onClose,
      icon: Icon(
        Icons.close,
        color: AppTheme.of(context).accentNegative,
      ),
    );
  }
}
