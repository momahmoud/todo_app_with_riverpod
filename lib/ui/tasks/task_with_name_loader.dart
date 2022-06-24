import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:todo/models/task_state.dart';
import 'package:todo/ui/tasks/task_with_name.dart';

import '../../models/task.dart';
import '../../persistence/hive_data_store.dart';

class TaskWithNameLoader extends ConsumerWidget {
  final Task task;
  final bool isEditing;
  final WidgetBuilder? editTaskButtonBuilder;
  const TaskWithNameLoader({
    Key? key,
    required this.task,
    this.isEditing = false,
    this.editTaskButtonBuilder,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dataStore = ref.watch(dataStoreProvider);
    return ValueListenableBuilder(
      valueListenable: dataStore.taskStateListenable(task: task),
      builder: (context, Box<TaskState> box, __) {
        final taskState = dataStore.taskState(box, task: task);
        return TaskWithName(
          task: task,
          completed: taskState.completed,
          isEditing: isEditing,
          onCompleted: (completed) {
            ref
                .read(dataStoreProvider)
                .setTaskState(task: task, completed: completed);
          },
          editTaskButtonBuilder: editTaskButtonBuilder,
        );
      },
    );
  }
}
