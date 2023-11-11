import 'dart:math';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:senjum_simulator/domain/entities/soldier.dart';

part 'soldier_provider.g.dart';

final random = Random();

@riverpod
class SoldierNotifier extends _$SoldierNotifier {
  @override
  Soldier build() {
    return const Soldier(
      name: '弁慶',
      rokudaka: 0,
      character: '',
      action: '',
      hp: 0,
      kp: 0,
      pw: 0,
      df: 0,
      spd: 0,
      growth: 9,
      strategies: {
        '突撃': false,
        '守備': false,
        '迎撃': false,
        '乱戦': false,
        '待機': false,
      },
      abilities: {
        '突進': false,
        '攻略': false,
        '膂力': false,
        '連発': false,
        '鉄壁': false,
        '見切': false,
        '討取': false,
        '奮起': false,
        '鼓舞': false,
        '回復': false,
        '治療': false,
        '療所': false,
        '仕掛': false,
        '堅陣': false,
        '母衣': false,
        '逃足': false,
        '忍狩': false,
        '火遁': false,
        '猛退': false,
        '陣頭': false,
      },
    );
  }

  void initializeSoldier() {
    state = build();
  }

  void updateState(Soldier soldier) {
    state = soldier.copyWith();
  }
}
