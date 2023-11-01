import 'dart:math';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:senjum_status/soldier.dart';

part 'soldier_provider.g.dart';

final random = Random();

@riverpod
class SoldierNotifier extends _$SoldierNotifier {
  @override
  Soldier build() {
    return const Soldier(
      name: '弁慶',
      rokudaka: 0,
      character: '足軽',
      action: '槍術',
      hp: 0,
      kp: 0,
      pw: 0,
      df: 0,
      spd: 0,
      growth: 9,
    );
  }

  void generateRandom() {
    int a = random.nextInt(1);
    final character = switch (a) {
      0 => '足軽',
      _ => '',
    };

    final action = switch (character) {
      '足軽' => random.nextDouble() * 100 > 99.5 ? '槍術' : '槍撃',
      _ => ''
    };

    final newSoldier = Soldier(
      name: '弁慶',
      rokudaka: 0,
      character: '足軽',
      action: action,
      hp: random.nextInt(110) + 1,
      kp: random.nextInt(110) + 1,
      pw: random.nextInt(110) + 1,
      df: random.nextInt(110) + 1,
      spd: random.nextInt(3) + 2,
      growth: 9,
    );

    state = newSoldier.copyWith(
      rokudaka: calcRokudaka(newSoldier),
    );
  }

  void grow() {
    if (state.growth < 1) {
      return;
    }

    int newHp = state.hp;
    int newKp = state.kp;
    int newPw = state.pw;
    int newDf = state.df;
    int newS = state.spd;

    switch (random.nextInt(4)) {
      case 0:
        newHp += random.nextInt(3) + 1;
        break;
      case 1:
        newKp += random.nextInt(3) + 1;
        break;
      case 2:
        newPw += random.nextInt(3) + 1;
        break;
      case 3:
        newDf += random.nextInt(3) + 1;
        break;
      default:
    }

    Soldier newSoldier = state.copyWith(
      hp: newHp,
      kp: newKp,
      pw: newPw,
      df: newDf,
      spd: newS,
      growth: state.growth - 1,
    );
    state = newSoldier;
    updateRokudaka(newSoldier);
  }

  void updateRokudaka(Soldier soldier) {
    if (state.rokudaka >= 9999) {
      return;
    }
    state = soldier.copyWith(
      rokudaka: calcRokudaka(soldier),
    );
  }

  int calcRokudaka(Soldier soldier) {
    int rokudaka = (pow(soldier.hp, 3) / 2500 +
            pow(soldier.kp, 3) / 2200 +
            pow(soldier.pw, 3) / 2000 +
            pow(soldier.df, 3) / 3000 +
            pow(soldier.spd, 3) * 2)
        .floor();

    if (rokudaka > 9999) {
      rokudaka = 9999;
    }

    return rokudaka;
  }

  void initializeSoldier() {
    state = build();
  }
}
