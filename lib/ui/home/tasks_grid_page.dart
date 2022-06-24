import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:todo/models/app_theme_settings.dart';
import 'package:todo/ui/home/home_page_bottom_options.dart';

import 'package:todo/ui/home/tasks_grid.dart';
import 'package:todo/ui/sliding_panel/sliding_panel.dart';
import 'package:todo/ui/sliding_panel/sliding_panel_animator.dart';
import 'package:todo/ui/sliding_panel/theme_selection_close.dart';
import 'package:todo/ui/sliding_panel/theme_selection_list.dart';
import 'package:todo/ui/theme/app_theme.dart';

import '../../models/task.dart';
import '../theme/animated_app_theme.dart';

class TasksGridPage extends StatelessWidget {
  const TasksGridPage({
    Key? key,
    required this.tasks,
    this.onFlip,
    required this.leftAnimationKey,
    required this.rightAnimationKey,
    required this.themeSettings,
    this.onColorIndexSelected,
    this.onVariantIndexSelected,
    required this.gridKey,
  }) : super(key: key);
  final GlobalKey<SlidingPanelAnimatorState> leftAnimationKey;
  final GlobalKey<SlidingPanelAnimatorState> rightAnimationKey;
  final GlobalKey<TasksGridState> gridKey;
  final AppThemeSettings themeSettings;

  final List<Task> tasks;
  final VoidCallback? onFlip;
  final ValueChanged<int>? onColorIndexSelected;
  final ValueChanged<int>? onVariantIndexSelected;

  void _onEnterEditMode() {
    leftAnimationKey.currentState?.slideIn();
    rightAnimationKey.currentState?.slideIn();
    gridKey.currentState?.enterEditMode();
  }

  void _exitEditMode() {
    leftAnimationKey.currentState?.slideOut();
    rightAnimationKey.currentState?.slideOut();
    gridKey.currentState?.exitEditMode();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedAppTheme(
      duration: Duration(milliseconds: 170),
      data: themeSettings.themeData,
      child: Builder(builder: (context) {
        return AnnotatedRegion<SystemUiOverlayStyle>(
          value: AppTheme.of(context).overlayStyle,
          child: Scaffold(
            backgroundColor: AppTheme.of(context).primary,
            body: SafeArea(
              child: Stack(
                children: [
                  TasksGridContents(
                    tasks: tasks,
                    onFlip: onFlip,
                    gridKey: gridKey,
                    onEnterEditMode: _onEnterEditMode,
                  ),
                  Positioned(
                    bottom: 6,
                    left: 0,
                    width: SlidingPanel.leftPanelFixedWidth,
                    child: SlidingPanelAnimator(
                      key: leftAnimationKey,
                      direction: SlideDirection.leftToRight,
                      child: ThemeSelectionClose(
                        onClose: _exitEditMode,
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 6,
                    right: 0,
                    width: MediaQuery.of(context).size.width -
                        SlidingPanel.leftPanelFixedWidth,
                    child: SlidingPanelAnimator(
                      key: rightAnimationKey,
                      direction: SlideDirection.rightToLeft,
                      child: ThemeSelectionList(
                        currentThemeSettings: themeSettings,
                        availableWidth: MediaQuery.of(context).size.width -
                            SlidingPanel.leftPanelFixedWidth -
                            SlidingPanel.paddingWidth,
                        onColorIndexSelected: onColorIndexSelected,
                        onVariantIndexSelected: onVariantIndexSelected,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}

class TasksGridContents extends StatelessWidget {
  const TasksGridContents({
    Key? key,
    required this.tasks,
    this.onFlip,
    this.onEnterEditMode,
    this.gridKey,
  }) : super(key: key);

  final Key? gridKey;
  final List<Task> tasks;
  final VoidCallback? onFlip;
  final VoidCallback? onEnterEditMode;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
            child: TasksGrid(
              tasks: tasks,
              key: gridKey,
            ),
          ),
        ),
        HomePageBottomOptions(
          onFlip: onFlip,
          onEnterEditMode: onEnterEditMode,
        ),
      ],
    );
  }
}
