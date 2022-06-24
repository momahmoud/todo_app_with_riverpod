import 'package:flutter/material.dart';

import '../../constants/text_styles.dart';
import '../theme/app_theme.dart';

class TextFieldHeader extends StatelessWidget {
  const TextFieldHeader(this.text, {Key? key}) : super(key: key);
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Text(
        text,
        style: TextStyles.caption.copyWith(
          color: AppTheme.of(context).settingsLabel,
        ),
      ),
    );
  }
}
