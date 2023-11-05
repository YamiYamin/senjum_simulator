import 'package:flutter/material.dart';
import 'package:senjum_status/senjum_status_app.dart';
import 'package:senjum_status/stage_lv_provider.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class StageSelectionPage extends HookConsumerWidget {
  const StageSelectionPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(stageLvNotifierProvider);
    final stageLvController = useTextEditingController();
    final dropDown = DropdownMenu(
      controller: stageLvController,
      width: 150,
      label: const Text('ステージLv'),
      onSelected: (value) {
        if (value != null) {
          ref.read(stageLvNotifierProvider.notifier).updateState(value);
        }
      },
      dropdownMenuEntries: const [
        DropdownMenuEntry(label: '1', value: 1),
        DropdownMenuEntry(label: '2', value: 2),
        DropdownMenuEntry(label: '3', value: 3),
        DropdownMenuEntry(label: '4', value: 4),
        DropdownMenuEntry(label: '5', value: 5),
        DropdownMenuEntry(label: '6', value: 6),
        DropdownMenuEntry(label: '7', value: 7),
        DropdownMenuEntry(label: '10', value: 10),
      ],
    );

    final button = ElevatedButton(
      child: const Text('開始'),
      onPressed: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => const SenjumStatusApp(),
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
          children: [
            dropDown,
            button,
          ],
        ),
      ),
    );
  }
}
