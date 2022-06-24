import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:hive/hive.dart';

import '../../persistence/hive_data_store.dart';
import '../home/home_page.dart';
import 'onboarding_page.dart';

class HomeOrOnboarding extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dataStore = ref.watch(dataStoreProvider);
    return ValueListenableBuilder(
      valueListenable: dataStore.didAddFirstTaskListenable(),
      builder: (_, Box<bool> box, __) {
        return dataStore.didAddFirstTask(box) ? HomePage() : OnboardingPage();
      },
    );
  }
}
