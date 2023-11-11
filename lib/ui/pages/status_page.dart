import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:senjum_simulator/domain/features/soldier_logic.dart';
import 'package:senjum_simulator/state/soldier_index_provider.dart';
import 'package:senjum_simulator/state/soldiers_provider.dart';
import 'package:senjum_simulator/state/stage_lv_provider.dart';
import 'package:senjum_simulator/state/soldier_provider.dart';
import 'package:senjum_simulator/ui/widgets/soldier_widget.dart';

class StatusPage extends ConsumerWidget {
  const StatusPage({super.key});

  void growButtonPressed(WidgetRef ref) {
    final soldier = ref.read(soldierNotifierProvider);
    ref
        .read(soldierNotifierProvider.notifier)
        .updateState(SoldierLogic.grow(soldier));
  }

  void initializeButtonPressed(WidgetRef ref) {
    final notifier = ref.read(soldierNotifierProvider.notifier);
    notifier.initializeSoldier();
  }

  void randomButtonPressed(WidgetRef ref) {
    final stageLv = ref.read(stageLvNotifierProvider);
    final soldier = ref.read(soldierNotifierProvider);
    ref
        .read(soldierNotifierProvider.notifier)
        .updateState(SoldierLogic.determineCapabilities(soldier, stageLv));
  }

  void previousButtonPressed(WidgetRef ref) {
    int soldierIndex = ref.read(soldierIndexNotifierProvider);

    if (soldierIndex - 1 >= 0) {
      soldierIndex--;
    } else {
      soldierIndex = 29;
    }

    final soldiers = ref.read(soldiersNotifierProvider);
    final previousSoldier = soldiers[soldierIndex];

    ref.read(soldierNotifierProvider.notifier).updateState(previousSoldier);
    ref.read(soldierIndexNotifierProvider.notifier).updateState(soldierIndex);
  }

  void nextButtonPressed(WidgetRef ref) {
    int soldierIndex = ref.read(soldierIndexNotifierProvider);

    if (soldierIndex + 1 < 30) {
      soldierIndex++;
    } else {
      soldierIndex = 0;
    }

    final soldiers = ref.read(soldiersNotifierProvider);
    final nextSoldier = soldiers[soldierIndex];

    ref.read(soldierNotifierProvider.notifier).updateState(nextSoldier);
    ref.read(soldierIndexNotifierProvider.notifier).updateState(soldierIndex);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final soldier = ref.watch(soldierNotifierProvider);

    final growButton = ElevatedButton(
      onPressed: soldier.growth < 1 ? null : () => growButtonPressed(ref),
      child: const Text('成長'),
    );

    final randomGenerateButton = ElevatedButton(
      onPressed: () => randomButtonPressed(ref),
      child: const Text('生成'),
    );

    final initializeButton = ElevatedButton(
      onPressed: () => initializeButtonPressed(ref),
      child: const Text('初期化'),
    );

    final buttons = SizedBox(
      width: 350,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          randomGenerateButton,
          growButton,
          initializeButton,
        ],
      ),
    );

    final previousButton = ElevatedButton(
      onPressed: () => previousButtonPressed(ref),
      child: const Text('前'),
    );

    final nextButton = ElevatedButton(
      onPressed: () => nextButtonPressed(ref),
      child: const Text('次'),
    );

    final moveButtons = SizedBox(
      width: 350,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          previousButton,
          nextButton,
        ],
      ),
    );

    return Scaffold(
      appBar: AppBar(),
      body: Container(
        width: double.infinity,
        color: const Color.fromARGB(255, 40, 40, 40),
        child: Column(
          children: [
            SoldierWidget(soldier: soldier),
            const SizedBox(height: 10),
            moveButtons,
            const SizedBox(height: 10),
            buttons,
          ],
        ),
      ),
    );
  }
}
