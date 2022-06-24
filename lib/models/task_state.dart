import 'package:hive/hive.dart';
part 'task_state.g.dart';

@HiveType(typeId: 1)
class TaskState {
  @HiveField(0)
  final String taskID;
  @HiveField(1)
  final bool completed;

  TaskState({required this.taskID, required this.completed});
}
