import 'package:flutter/material.dart';
import 'package:senjum_simulator/stage_name_provider.dart';
import 'package:senjum_simulator/status_page.dart';
import 'package:senjum_simulator/stage_lv_provider.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class StageSelectionPage extends HookConsumerWidget {
  const StageSelectionPage({super.key});

  List<DropdownMenuEntry<int>> getStageLevelMenus(String stageName) {
    if (stageName == '裏戦国') {
      return [const DropdownMenuEntry(value: 10, label: 'Lv.X')];
    }
    var stageLevelMenues = <DropdownMenuEntry<int>>[];
    if (stageName == '平地') {
      stageLevelMenues.add(
        const DropdownMenuEntry(value: 7, label: 'Lv.7'),
      );
    }
    stageLevelMenues.addAll([
      const DropdownMenuEntry(value: 6, label: 'Lv.6'),
      const DropdownMenuEntry(value: 5, label: 'Lv.5'),
      const DropdownMenuEntry(value: 4, label: 'Lv.4'),
      const DropdownMenuEntry(value: 3, label: 'Lv.3'),
      const DropdownMenuEntry(value: 2, label: 'Lv.2'),
    ]);
    if (stageName == '平地' || stageName == '武家屋敷') {
      stageLevelMenues.add(
        const DropdownMenuEntry(value: 1, label: 'Lv.1'),
      );
    }
    return stageLevelMenues;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stageLv = ref.watch(stageLvNotifierProvider);
    final stageName = ref.watch(stageNameNotifierProvider);

    final stageNameController = useTextEditingController();
    final stageLvController = useTextEditingController();

    final stageLevels = useState(getStageLevelMenus(stageName));

    final stageLvDropDown = DropdownMenu<int>(
      initialSelection: stageLv,
      controller: stageLvController,
      width: 150,
      label: const Text('ステージLv'),
      onSelected: (value) {
        if (value != null) {
          ref.read(stageLvNotifierProvider.notifier).updateState(value);
        }
      },
      dropdownMenuEntries: stageLevels.value,
    );

    final stageNameDropDown = DropdownMenu<String>(
      initialSelection: stageName,
      label: const Text('ステージ'),
      controller: stageNameController,
      dropdownMenuEntries: const [
        DropdownMenuEntry(value: '平地', label: '平地'),
        DropdownMenuEntry(value: '鉄砲鍛造所', label: '鉄砲鍛造所'),
        DropdownMenuEntry(value: '武家屋敷', label: '武家屋敷'),
        DropdownMenuEntry(value: '忍の里', label: '忍の里'),
        DropdownMenuEntry(value: '繁華街', label: '繁華街'),
        DropdownMenuEntry(value: '兵学舎', label: '兵学舎'),
        DropdownMenuEntry(value: '裏戦国', label: '裏戦国'),
      ],
      onSelected: (value) {
        ref.read(stageNameNotifierProvider.notifier).updateState(value!);
        stageLevels.value = getStageLevelMenus(value);
        stageLvController.text = stageLevels.value[0].label;
        ref
            .read(stageLvNotifierProvider.notifier)
            .updateState(stageLevels.value[0].value);
      },
    );

    final button = ElevatedButton(
      child: const Text('開始'),
      onPressed: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => const StatusPage(),
          ),
        );
      },
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('ステージ選択'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                stageNameDropDown,
                stageLvDropDown,
              ],
            ),
            button,
          ],
        ),
      ),
    );
  }
}
