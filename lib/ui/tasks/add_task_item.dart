import 'package:flutter/material.dart';

import 'package:todo/ui/tasks/task_with_name.dart';

import '../../constants/app_assets.dart';
import '../../models/task.dart';

class AddTaskItem extends StatelessWidget {
  const AddTaskItem({Key? key, this.onCompleted}) : super(key: key);
  final VoidCallback? onCompleted;

  @override
  Widget build(BuildContext context) {
    return TaskWithName(
      task: Task(
        id: '',
        name: 'Add a task',
        iconName: AppAssets.plus,
      ),
      hasCompletedState: false,
      onCompleted: (completed) => onCompleted?.call(),
    );
  }
}
