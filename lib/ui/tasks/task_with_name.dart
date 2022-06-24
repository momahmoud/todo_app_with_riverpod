import 'package:flutter/material.dart';
import 'package:todo/constants/text_styles.dart';

import 'package:todo/ui/tasks/animated_task.dart';
import 'package:todo/ui/theme/app_theme.dart';

import '../../models/task.dart';
import '../common/edit_task_button.dart';

class TaskWithName extends StatelessWidget {
  final Task task;
  final bool completed;
  final bool isEditing;
  final bool hasCompletedState;
  final ValueChanged<bool>? onCompleted;
  final WidgetBuilder? editTaskButtonBuilder;
  const TaskWithName({
    Key? key,
    required this.task,
    this.completed = false,
    this.isEditing = false,
    this.hasCompletedState = true,
    this.onCompleted,
    this.editTaskButtonBuilder,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Stack(
            children: [
              AnimatedTask(
                iconName: task.iconName,
                completed: completed,
                onCompleted: onCompleted,
                hasCompletedState: hasCompletedState,
                isEditing: isEditing,
              ),
              if (editTaskButtonBuilder != null)
                Positioned.fill(
                  child: FractionallySizedBox(
                    widthFactor: EditTaskButton.scaleFactor,
                    heightFactor: EditTaskButton.scaleFactor,
                    alignment: Alignment.bottomRight,
                    child: editTaskButtonBuilder!(context),
                  ),
                ),
            ],
          ),
        ),
        SizedBox(height: 8.0),
        SizedBox(
          height: 39,
          child: Text(
            task.name.toUpperCase(),
            maxLines: 2,
            textAlign: TextAlign.center,
            style: TextStyles.taskName.copyWith(
              color: AppTheme.of(context).accent,
            ),
          ),
        ),
      ],
    );
  }
}
