import 'dart:math';

import 'package:flutter/material.dart';
import 'package:todo/ui/theme/app_theme.dart';

class TaskCompletionRing extends StatelessWidget {
  final double progress;
  const TaskCompletionRing({
    Key? key,
    required this.progress,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeData = AppTheme.of(context);
    return AspectRatio(
      aspectRatio: 1.0,
      child: CustomPaint(
        painter: RingPainter(
          progress: progress,
          taskDoneColor: themeData.accent,
          taskNotDoneColor: themeData.taskRing,
        ),
      ),
    );
  }
}

class RingPainter extends CustomPainter {
  final double progress;
  final Color taskDoneColor;
  final Color taskNotDoneColor;

  RingPainter({
    required this.progress,
    required this.taskDoneColor,
    required this.taskNotDoneColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final notDone = progress < 1.0;
    final strokeWidth = size.width / 15.0;
    final center = Offset(size.width / 2, size.height / 2);
    final radius = notDone ? (size.width - strokeWidth) / 2 : size.width / 2;

    if (notDone) {
      final backgroundPaint = Paint()
        ..isAntiAlias = true
        ..strokeWidth = strokeWidth
        ..color = taskNotDoneColor
        ..style = PaintingStyle.stroke;

      canvas.drawCircle(center, radius, backgroundPaint);
    }

    final foregroundPaint = Paint()
      ..isAntiAlias = true
      ..strokeWidth = strokeWidth
      ..color = taskDoneColor
      ..style = notDone ? PaintingStyle.stroke : PaintingStyle.fill;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -pi / 2,
      2 * pi * progress,
      false,
      foregroundPaint,
    );
  }

  @override
  bool shouldRepaint(covariant RingPainter oldDelegate) =>
      //improve performance
      //redraw if progress value changes
      oldDelegate.progress != progress;
}
