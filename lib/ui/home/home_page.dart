import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:page_flip_builder/page_flip_builder.dart';
import 'package:todo/ui/home/tasks_grid.dart';

import 'package:todo/ui/home/tasks_grid_page.dart';
import 'package:todo/ui/sliding_panel/sliding_panel_animator.dart';
import 'package:todo/ui/theme/app_theme_manager.dart';

import '../../models/front_or_back_side.dart';
import '../../models/task.dart';
import '../../persistence/hive_data_store.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _pageFlipKey = GlobalKey<PageFlipBuilderState>();
  final _frontSlidingLeftAnimatedKey = GlobalKey<SlidingPanelAnimatorState>();
  final _frontSlidingRightAnimatedKey = GlobalKey<SlidingPanelAnimatorState>();
  final _backSlidingLeftAnimatedKey = GlobalKey<SlidingPanelAnimatorState>();
  final _backSlidingRightAnimatedKey = GlobalKey<SlidingPanelAnimatorState>();
  final _backGridKey = GlobalKey<TasksGridState>();
  final _frontGridKey = GlobalKey<TasksGridState>();

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (_, ref, __) {
      final dataStore = ref.watch(dataStoreProvider);
      return Container(
        color: Colors.black,
        child: PageFlipBuilder(
            key: _pageFlipKey,
            frontBuilder: (_) {
              return ProviderScope(
                overrides: [
                  frontOrBackSideProvider
                      .overrideWithValue(FrontOrBackSide.front)
                ],
                child: ValueListenableBuilder(
                  valueListenable: dataStore.frontTasksListenable(),
                  builder: (_, Box<Task> box, __) {
                    return TasksGridPage(
                      gridKey: _frontGridKey,
                      key: ValueKey(1),
                      tasks: box.values.toList(),
                      onFlip: () => _pageFlipKey.currentState?.flip(),
                      leftAnimationKey: _frontSlidingLeftAnimatedKey,
                      rightAnimationKey: _frontSlidingRightAnimatedKey,
                      themeSettings: ref.watch(frontThemeManagerProvider),
                      onColorIndexSelected: (colorIndex) => ref
                          .read(frontThemeManagerProvider.notifier)
                          .updateColorIndex(colorIndex),
                      onVariantIndexSelected: (variantIndex) => ref
                          .read(frontThemeManagerProvider.notifier)
                          .updateVariantIndex(variantIndex),
                    );
                  },
                ),
              );
            },
            backBuilder: (_) {
              return ProviderScope(
                overrides: [
                  frontOrBackSideProvider
                      .overrideWithValue(FrontOrBackSide.back)
                ],
                child: ValueListenableBuilder(
                  valueListenable: dataStore.backTasksListenable(),
                  builder: (_, Box<Task> box, __) {
                    return TasksGridPage(
                      gridKey: _backGridKey,
                      key: ValueKey(2),
                      tasks: box.values.toList(),
                      onFlip: () => _pageFlipKey.currentState?.flip(),
                      leftAnimationKey: _backSlidingLeftAnimatedKey,
                      rightAnimationKey: _backSlidingRightAnimatedKey,
                      themeSettings: ref.watch(backThemeManagerProvider),
                      onColorIndexSelected: (colorIndex) => ref
                          .read(backThemeManagerProvider.notifier)
                          .updateColorIndex(colorIndex),
                      onVariantIndexSelected: (variantIndex) => ref
                          .read(backThemeManagerProvider.notifier)
                          .updateVariantIndex(variantIndex),
                    );
                  },
                ),
              );
            }),
      );
    });
  }
}
