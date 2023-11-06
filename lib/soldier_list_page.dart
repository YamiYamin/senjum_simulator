import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:senjum_simulator/soldier.dart';
import 'package:senjum_simulator/soldier_index_provider.dart';
import 'package:senjum_simulator/soldier_provider.dart';
import 'package:senjum_simulator/soldiers_provider.dart';
import 'package:senjum_simulator/stage_lv_provider.dart';
import 'package:senjum_simulator/stage_name_provider.dart';
import 'package:senjum_simulator/status_page.dart';

class SoldierListPage extends ConsumerWidget {
  const SoldierListPage({super.key});

  void soldierListTileOnTap(
      BuildContext context, WidgetRef ref, int i, Soldier soldier) {
    ref.read(soldierIndexNotifierProvider.notifier).updateState(i);
    ref.read(soldierNotifierProvider.notifier).updateState(soldier);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const StatusPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var soldiers = ref.watch(soldiersNotifierProvider);
    ref.watch(soldierIndexNotifierProvider);
    ref.watch(soldierNotifierProvider);

    final soldiersListView = ListView.builder(
      itemCount: soldiers.length,
      itemBuilder: (context, i) {
        return ListTile(
          title: Text(soldiers[i].name),
          subtitle:
              Text('兵種：${soldiers[i].character}　技種：${soldiers[i].action}'),
          onTap: () => soldierListTileOnTap(context, ref, i, soldiers[i]),
        );
      },
    );

    return Scaffold(
      appBar: AppBar(),
      body: Container(child: soldiersListView),
    );
  }
}
