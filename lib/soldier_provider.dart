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
        strategies: {},
        abilities: {});
  }

  void generateRandom() {
    int a = random.nextInt(1);
    final character = switch (a) {
      0 => '足軽',
      _ => '',
    };

    final action = switch (character) {
      '足軽' => random.nextDouble() * 100 > 99.5 ? '槍術' : '槍撃',
      '騎馬' => '騎突',
      _ => ''
    };

    final strategies = <String, bool>{
      '突撃': false,
      '守備': false,
      '迎撃': false,
      '乱戦': false,
      '待機': false,
    };

    final abilities = <String, bool>{
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
      '火遁': false,
      '忍狩': false,
      '猛退': false,
      '陣頭': false,
    };

    abilities.forEach((key, _) {
      if (key == '膂力' ||
          key == '連発' ||
          key == '討取' ||
          key == '鼓舞' ||
          key == '奮起') {
        abilities[key] = random.nextDouble() * 100 > 95;
        return;
      }
      if (key == '火遁' || key == '忍狩' || key == '猛退' || key == '陣頭') {
        return;
      }
      abilities[key] = random.nextDouble() * 100 > 80;
    });

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
      abilities: abilities,
      strategies: strategies,
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
