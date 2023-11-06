import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:senjum_simulator/soldier_provider.dart';
import 'package:senjum_simulator/soldiers_provider.dart';
import 'package:senjum_simulator/stage_lv_provider.dart';
import 'package:senjum_simulator/stage_name_provider.dart';

class SoldierListPage extends ConsumerWidget {
  const SoldierListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var soldiers = ref.watch(soldiersNotifierProvider);
    ref.watch(soldierNotifierProvider);

    final soldiersListView = ListView.builder(
      itemCount: soldiers.length,
      itemBuilder: (c, i) {
        return ListTile(
          title: Text(soldiers[i].name),
          subtitle:
              Text('兵種：${soldiers[i].character}　技種：${soldiers[i].action}'),
          onTap: () {},
        );
      },
    );

    return Scaffold(
      appBar: AppBar(),
      body: Container(child: soldiersListView),
    );
  }
}
