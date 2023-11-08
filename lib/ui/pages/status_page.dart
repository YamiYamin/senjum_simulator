import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:senjum_simulator/domain/features/soldier_logic.dart';
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

    final buttons = Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        randomGenerateButton,
        growButton,
        initializeButton,
      ],
    );

    return Scaffold(
      appBar: AppBar(),
      body: Container(
        color: const Color.fromARGB(255, 40, 40, 40),
        child: Column(
          children: [
            SoldierWidget(soldier: soldier),
            const SizedBox(height: 10),
            buttons,
          ],
        ),
      ),
    );
  }
}
