import 'package:flutter/material.dart';
import 'package:todo/ui/add_task/task_preset_list_tile.dart';
import 'package:todo/ui/add_task/text_field_header.dart';

import '../../constants/app_assets.dart';
import '../../constants/text_styles.dart';
import '../../models/task_preset.dart';
import '../common/app_bar_icon_button.dart';
import '../theme/app_theme.dart';
import 'add_task_navigator.dart';
import 'custom_text_field.dart';

class AddTaskPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppTheme.of(context).secondary,
        leading: AppBarIconButton(
          iconName: AppAssets.navigationClose,
          // * Using `rootNavigator: true` to ensure we dismiss the entire navigation stack.
          // * Remember that we show this page inside [AddTaskNavigator],
          // * which already contains a [Navigator])
          onPressed: () => Navigator.of(context, rootNavigator: true).pop(),
        ),
        title: Text(
          'Add Task',
          style: TextStyles.heading.copyWith(
            color: AppTheme.of(context).settingsText,
          ),
        ),
        elevation: 0,
      ),
      backgroundColor: AppTheme.of(context).primary,
      body: AddTaskContents(),
    );
  }
}

class AddTaskContents extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 32),
              TextFieldHeader('CREATE YOUR OWN:'),
              CustomTextField(
                hintText: 'Enter task title...',
                showChevron: true,
                onSubmit: (value) => Navigator.of(context).pushNamed(
                  AddTaskRoutes.confirmTask,
                  arguments: TaskPreset(
                      iconName: value.substring(0, 1).toUpperCase(),
                      name: value),
                ),
              ),
              SizedBox(height: 32),
              TextFieldHeader('OR CHOOSE A PRESET:'),
            ],
          ),
        ),
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) => TaskPresetListTile(
              taskPreset: TaskPreset.allPresets[index],
              onPressed: (taskPreset) => Navigator.of(context).pushNamed(
                AddTaskRoutes.confirmTask,
                arguments: taskPreset,
              ),
            ),
            childCount: TaskPreset.allPresets.length,
          ),
        ),
        // Account for safe area
        SliverToBoxAdapter(
          child: SizedBox(
            height: MediaQuery.of(context).padding.bottom,
          ),
        )
      ],
    );
  }
}
