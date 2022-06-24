import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo/constants/app_assets.dart';
import 'package:todo/models/front_or_back_side.dart';
import 'package:todo/persistence/hive_data_store.dart';
import 'package:todo/ui/home/home_page.dart';
import 'package:todo/ui/onboarding/home_or_onboarding.dart';
import 'package:todo/ui/onboarding/onboarding_page.dart';

import 'package:todo/ui/theme/app_theme_manager.dart';

import 'models/task.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppAssets.preloadSVGs();
  final dataStore = HiveDataStore();
  await dataStore.init();
  // await dataStore.createDemoTasks(
  //   frontTasks: [
  //     Task.create(name: 'Eat a Healthy Meal', iconName: AppAssets.carrot),
  //     Task.create(name: 'Walk the Dog', iconName: AppAssets.dog),
  //     Task.create(name: 'Do Some Coding', iconName: AppAssets.html),
  //     Task.create(name: 'Meditate', iconName: AppAssets.meditation),
  //     Task.create(name: 'Do 10 Pushups', iconName: AppAssets.pushups),
  //     // Task.create(name: 'Sleep 8 Hours', iconName: AppAssets.rest),
  //   ],
  //   backTasks: [
  //     Task.create(name: 'Wash Your Hands', iconName: AppAssets.washHands),
  //     Task.create(name: 'Wear a Mask', iconName: AppAssets.mask),
  //     Task.create(name: 'Brush Your Teeth', iconName: AppAssets.toothbrush),
  //     Task.create(name: 'Floss Your Teeth', iconName: AppAssets.dentalFloss),
  //     Task.create(name: 'Drink Water', iconName: AppAssets.water),
  //     // Task.create(name: 'Practice Instrument', iconName: AppAssets.guitar),
  //   ],
  //   force: true,
  // );

  final frontThemeSettings =
      await dataStore.appThemeSettings(side: FrontOrBackSide.front);
  final backThemeSettings =
      await dataStore.appThemeSettings(side: FrontOrBackSide.back);

  runApp(
    ProviderScope(
      overrides: [
        dataStoreProvider.overrideWithValue(dataStore),
        frontThemeManagerProvider.overrideWithValue(
          AppThemeManager(
            themeSettings: frontThemeSettings,
            dataStore: dataStore,
            side: FrontOrBackSide.front,
          ),
        ),
        backThemeManagerProvider.overrideWithValue(
          AppThemeManager(
            themeSettings: backThemeSettings,
            dataStore: dataStore,
            side: FrontOrBackSide.back,
          ),
        ),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        hoverColor: Colors.transparent,
      ),
      home: HomeOrOnboarding(),
    );
  }
}
