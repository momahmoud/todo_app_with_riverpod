import 'package:adaptive_action_sheet/adaptive_action_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import '../../constants/app_assets.dart';
import '../../constants/text_styles.dart';
import '../../models/front_or_back_side.dart';
import '../../models/task.dart';
import '../../models/task_preset.dart';
import '../../persistence/hive_data_store.dart';
import '../common/app_bar_icon_button.dart';
import '../common/edit_task_button.dart';
import '../common/primary_button.dart';
import '../theme/app_theme.dart';
import 'custom_text_field.dart';
import 'select_icon_page.dart';
import 'task_preset_list_tile.dart';
import 'task_ring_with_image.dart';
import 'text_field_header.dart';

class TaskDetailsPage extends StatelessWidget {
  const TaskDetailsPage({
    Key? key,
    required this.task,
    required this.isNewTask,
    required this.frontOrBackSide,
  }) : super(key: key);
  final Task task;
  final bool isNewTask;
  final FrontOrBackSide frontOrBackSide;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppTheme.of(context).secondary,
        leading: AppBarIconButton(
          iconName:
              isNewTask ? AppAssets.navigationBack : AppAssets.navigationClose,
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          isNewTask ? 'Confirm Task' : 'Edit Task',
          style: TextStyles.heading.copyWith(
            color: AppTheme.of(context).settingsText,
          ),
        ),
        elevation: 0,
      ),
      backgroundColor: AppTheme.of(context).primary,
      body: SafeArea(
        child: ConfirmTaskContents(
          task: task,
          isNewTask: isNewTask,
          frontOrBackSide: frontOrBackSide,
        ),
      ),
    );
  }
}

// * Note: extending ConsumerStatefulWidget so that we can access the WidgetRef directly in the state class
class ConfirmTaskContents extends ConsumerStatefulWidget {
  const ConfirmTaskContents({
    Key? key,
    required this.task,
    required this.isNewTask,
    required this.frontOrBackSide,
  }) : super(key: key);
  final Task task;
  final bool isNewTask;
  final FrontOrBackSide frontOrBackSide;

  @override
  _ConfirmTaskContentsState createState() => _ConfirmTaskContentsState();
}

class _ConfirmTaskContentsState extends ConsumerState<ConfirmTaskContents> {
  final _textFieldKey = GlobalKey<CustomTextFieldState>();

  late String _iconName = widget.task.iconName;

  Future<void> _saveTask() async {
    final _textFieldState = _textFieldKey.currentState;
    if (_textFieldState != null) {
      // Create new task with updated name and asset icon
      final task = Task(
        id: widget.task.id,
        name: _textFieldState.text,
        iconName: _iconName,
      );
      try {
        // * Note: here we can use ref.read because ref is a property of [ConsumerState]
        final dataStore = ref.read<HiveDataStore>(dataStoreProvider);
        // // * Once the first task is added, we no longer need to show the onboarding screen
        await dataStore.setDidAddFirstTask(true);
        await dataStore.saveTask(task, widget.frontOrBackSide);
        // * Pop back to HomePage, using `rootNavigator: true` to ensure we dismiss the entire navigation stack.
        Navigator.of(context, rootNavigator: true).pop();
      } catch (e) {
        // TODO: Proper error handling
        print(e);
        rethrow;
      }
    }
  }

  Future<void> _deleteTask() async {
    final didConfirm = await showAdaptiveActionSheet<bool?>(
      context: context,
      title: const Text('Are you sure?'),
      actions: <BottomSheetAction>[
        BottomSheetAction(
          title: const Text('Delete'),
          onPressed: () => Navigator.of(context).pop(true),
        ),
      ],
      cancelAction: CancelAction(
        title: const Text('Cancel'),
      ),
    );
    if (didConfirm == true) {
      try {
        final dataStore = ref.read<HiveDataStore>(dataStoreProvider);
        // * No longer show [AddTaskItem] widget by default after a task is deleted for the first time
        await dataStore.setAlwaysShowAddTask(false);
        await dataStore.deleteTask(widget.task, widget.frontOrBackSide);
        // * Pop back to HomePage, using `rootNavigator: true` to ensure we dismiss the entire navigation stack.
        Navigator.of(context, rootNavigator: true).pop();
      } catch (e) {
        // TODO: Proper error handling
        print(e);
        rethrow;
      }
    }
  }

  Future<void> _changeIcon() async {
    final appThemeData = AppTheme.of(context);
    final iconName = await showCupertinoModalBottomSheet<String?>(
      context: context,
      builder: (_) => AppTheme(
        data: appThemeData,
        child: SelectIconPage(
          selectedIconName: _iconName,
        ),
      ),
    );
    if (iconName != null) {
      setState(() => _iconName = iconName);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // * Make content scrollable if needed
        SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: 20),
              ConfirmTaskHeader(
                iconName: _iconName,
                onChangeIcon: _changeIcon,
              ),
              SizedBox(height: 20),
              TextFieldHeader('TITLE:'),
              CustomTextField(
                key: _textFieldKey,
                initialValue: widget.task.name,
                hintText: 'Enter task title...',
              ),
              if (!widget.isNewTask) ...[
                Container(height: 20),
                TaskPresetListTile(
                  taskPreset: TaskPreset(
                      name: 'Delete Task', iconName: AppAssets.delete),
                  showChevron: false,
                  onPressed: (_) => _deleteTask(),
                ),
              ],
            ],
          ),
        ),
        // * Pin PrimaryButton to the bottom
        Spacer(),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: PrimaryButton(
            title: widget.isNewTask ? 'SAVE TASK' : 'DONE',
            onPressed: _saveTask,
          ),
        ),
        SizedBox(height: 24.0),
      ],
    );
  }
}

class ConfirmTaskHeader extends StatelessWidget {
  const ConfirmTaskHeader({Key? key, required this.iconName, this.onChangeIcon})
      : super(key: key);
  final String iconName;
  final VoidCallback? onChangeIcon;
  @override
  Widget build(BuildContext context) {
    const size = 150.0;
    final padding = (MediaQuery.of(context).size.width - size) / 2;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: padding),
      child: Stack(
        children: [
          TaskRingWithImage(
            iconName: iconName,
          ),
          Positioned.fill(
            child: FractionallySizedBox(
              widthFactor: EditTaskButton.scaleFactor,
              heightFactor: EditTaskButton.scaleFactor,
              alignment: Alignment.bottomRight,
              child: EditTaskButton(
                onPressed: onChangeIcon,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
