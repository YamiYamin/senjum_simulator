import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:senjum_simulator/domain/entities/soldier.dart';
import 'package:senjum_simulator/domain/features/soldier_logic.dart';
import 'package:senjum_simulator/state/stage_lv_provider.dart';
import 'package:senjum_simulator/state/soldier_provider.dart';

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

  Widget buildHp(Soldier soldier) {
    return buildStatus('体力', soldier.hp);
  }

  Widget buildKp(Soldier soldier) {
    return buildStatus('技量', soldier.kp);
  }

  Widget buildPw(Soldier soldier) {
    return buildStatus('戦闘', soldier.pw);
  }

  Widget buildDf(Soldier soldier) {
    return buildStatus('防御', soldier.df);
  }

  Widget buildSpd(Soldier soldier) {
    return buildStatus('脚力', soldier.spd);
  }

  Widget buildGrowth(Soldier soldier) {
    if (soldier.growth <= 0) {
      return const SizedBox(width: 90);
    }

    final row = Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        const Text(
          '成長',
          strutStyle: StrutStyle(height: 1.5, fontSize: 14),
          style: TextStyle(
            color: Colors.white70,
          ),
        ),
        const Text(
          'あと',
          style: TextStyle(
            color: Colors.white70,
            fontSize: 9,
          ),
        ),
        Text(
          '${soldier.growth}',
          strutStyle: const StrutStyle(height: 1.5, fontSize: 14),
          style: const TextStyle(
            color: Colors.white70,
          ),
        ),
        const Text(
          '回',
          style: TextStyle(
            color: Colors.white70,
            fontSize: 9,
          ),
        ),
      ],
    );

    return Container(
      width: 80,
      height: 28,
      margin: const EdgeInsets.fromLTRB(5, 2, 5, 2),
      padding: const EdgeInsets.fromLTRB(5, 1, 5, 1),
      decoration: BoxDecoration(
        border: Border.all(
          width: 0.5,
          color: Colors.yellow,
        ),
        color: Colors.brown[800],
      ),
      alignment: Alignment.centerLeft,
      child: row,
    );
  }

  Widget buildStatus(String word, int value) {
    BoxBorder? border;
    const double borderWidth = 1.5;

    if (value >= 111) {
      border = Border.all(
        width: borderWidth,
        color: Colors.red.withOpacity(0.8),
      );
    } else if (value >= 90 || word == '脚力' && value == 6) {
      border = Border.all(
        width: borderWidth,
        color: Colors.red.withOpacity(0.5),
      );
    } else if (value >= 80 || word == '脚力' && value == 5) {
      border = Border.all(
        width: borderWidth,
        color: Colors.orange.withOpacity(0.5),
      );
    } else if (value >= 70 || word == '脚力' && value == 4) {
      border = Border.all(
        width: borderWidth,
        color: Colors.yellow.withOpacity(0.5),
      );
    } else {
      border = Border(
        bottom: BorderSide(
          width: borderWidth,
          color: Colors.yellow.withOpacity(0.5),
        ),
        top: const BorderSide(
          width: borderWidth,
          color: Colors.black,
        ),
        right: const BorderSide(
          width: borderWidth,
          color: Colors.black,
        ),
        left: const BorderSide(
          width: borderWidth,
          color: Colors.black,
        ),
      );
    }
    final row = Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          word,
          strutStyle: const StrutStyle(height: 1.5, fontSize: 14),
          style: const TextStyle(
            color: Colors.white70,
          ),
        ),
        Text(
          '$value',
          strutStyle: const StrutStyle(height: 1.5, fontSize: 14),
          style: const TextStyle(
            color: Colors.white70,
          ),
        ),
      ],
    );

    return Container(
      width: 80,
      height: 28,
      margin: const EdgeInsets.fromLTRB(5, 2, 5, 2),
      padding: const EdgeInsets.fromLTRB(5, 1, 5, 1),
      decoration: BoxDecoration(
        border: border,
        color: Colors.black,
      ),
      alignment: Alignment.centerLeft,
      child: row,
    );
  }

  Widget buildName(soldier) {
    final nameText = Text(
      soldier.name,
      style: const TextStyle(
        color: Colors.white70,
        fontSize: 18,
      ),
    );

    return Container(
      margin: const EdgeInsets.fromLTRB(5, 5, 5, 10),
      child: nameText,
    );
  }

  Widget buildRokudaka(Soldier soldier) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.yellow.withOpacity(0.5),
          width: 1,
        ),
        color: Colors.black,
        borderRadius: BorderRadius.circular(3),
      ),
      width: 100,
      height: 25,
      padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            '禄高',
            style: TextStyle(color: Colors.white70),
          ),
          Text(
            '${soldier.rokudaka}',
            style: const TextStyle(color: Colors.white70),
          ),
        ],
      ),
    );
  }

  Widget buildCharacter(Soldier soldier) {
    // 兵種
    return buildAbilityBack(
      word: '兵種',
      child: buildAbility(
        soldier.character,
        const Color.fromARGB(255, 64, 47, 71),
      ),
    );
  }

  Widget buildAction(Soldier soldier) {
    final color = switch (soldier.action) {
      '槍撃' || '弓矢' || '火遊' => Colors.black,
      '号令' || '火攻' || '旋風' => const Color.fromARGB(255, 98, 77, 24),
      '火矢' ||
      '射撃' ||
      '火計' ||
      '虚報' ||
      '忍術' =>
        const Color.fromARGB(255, 132, 55, 46),
      '槍術' ||
      '遠射' ||
      '焙烙' ||
      '業火' ||
      '狙撃' ||
      '無双' ||
      '影走' =>
        const Color.fromARGB(255, 210, 109, 0),
      '豪傑' ||
      '治癒' ||
      '妖術' ||
      '炎術' ||
      '砲撃' ||
      '鬼神' ||
      '結界' ||
      '幻術' ||
      '騎突' ||
      '奮迅' =>
        const Color.fromARGB(255, 255, 71, 22),
      _ => Colors.black,
    };

    return buildAbilityBack(
      word: '技種',
      child: buildAbility(
        soldier.action,
        color,
      ),
    );
  }

  Widget buildAbility(String word, Color color) {
    final text = Text(
      word,
      style: const TextStyle(
        color: Colors.white70,
        fontSize: 12,
        shadows: [
          Shadow(
            offset: Offset(1, 1),
            blurRadius: 1.0,
            color: Colors.black,
          ),
        ],
      ),
    );

    // 外枠(白)
    return Container(
      width: 40,
      height: 24,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.white.withOpacity(0.3),
        ),
      ),
      // 内枠（黒）
      child: Container(
        width: 38,
        height: 22,
        padding: const EdgeInsets.fromLTRB(5, 1, 5, 1),
        decoration: BoxDecoration(
          border: Border.all(
            width: 1,
            color: Colors.black87,
          ),
          color: color,
        ),
        child: text,
      ),
    );
  }

  // 兵種・技種の背景
  Widget buildAbilityBack({required String word, required Widget child}) {
    return Container(
      padding: const EdgeInsets.fromLTRB(5, 1, 5, 1),
      width: 90,
      height: 30,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.3),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            word,
            style: const TextStyle(
              color: Colors.white70,
            ),
          ),
          child,
        ],
      ),
    );
  }

  Widget buildTopLabel(String data) {
    return Container(
      height: 24,
      margin: const EdgeInsets.only(top: 5),
      padding: const EdgeInsets.fromLTRB(5, 1, 5, 1),
      child: Text(
        data,
        style: const TextStyle(
          color: Colors.white70,
          fontSize: 13,
        ),
      ),
    );
  }

  Widget buildStrategies(Soldier soldier) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildTopLabel('作戦行動'),
        Container(
          margin: const EdgeInsets.only(
            left: 5,
            right: 5,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: 280,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    for (String key in soldier.strategies.keys) ...{
                      soldier.strategies[key]!
                          ? buildAbility(
                              key, const Color.fromARGB(255, 170, 126, 50))
                          : buildAbility(key, Colors.black),
                    },
                    buildAbility('？？', Colors.black),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget buildAbilities(Soldier soldier) {
    final keys = soldier.abilities.keys;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildTopLabel('特殊能力'),
        Container(
          margin: const EdgeInsets.only(
            left: 5,
            right: 5,
          ),
          height: 86,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: 280,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    for (int i = 0; i < 6; i++) ...{
                      soldier.abilities[keys.elementAt(i)]!
                          ? buildAbility(keys.elementAt(i),
                              const Color.fromARGB(255, 170, 126, 50))
                          : buildAbility(keys.elementAt(i), Colors.black),
                    }
                  ],
                ),
              ),
              SizedBox(
                width: 280,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    for (int i = 6; i < 12; i++) ...{
                      soldier.abilities[keys.elementAt(i)]!
                          ? buildAbility(keys.elementAt(i),
                              const Color.fromARGB(255, 170, 126, 50))
                          : buildAbility(keys.elementAt(i), Colors.black),
                    }
                  ],
                ),
              ),
              SizedBox(
                width: 280,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    for (int i = 12; i < 16; i++) ...{
                      soldier.abilities[keys.elementAt(i)]!
                          ? buildAbility(keys.elementAt(i),
                              const Color.fromARGB(255, 170, 126, 50))
                          : buildAbility(keys.elementAt(i), Colors.black),
                    },
                    soldier.character == '猛者' &&
                            soldier.abilities[keys.elementAt(16)]!
                        ? buildAbility(keys.elementAt(16), Colors.red)
                        : soldier.character == '忍者' &&
                                soldier.abilities[keys.elementAt(17)]!
                            ? buildAbility(keys.elementAt(17), Colors.red)
                            : soldier.character == '騎馬' &&
                                    soldier.abilities[keys.elementAt(18)]!
                                ? buildAbility(keys.elementAt(18), Colors.red)
                                : buildAbility('？？', Colors.black),
                    soldier.character == '騎馬' &&
                            soldier.abilities[keys.elementAt(19)]!
                        ? buildAbility(keys.elementAt(19), Colors.red)
                        : buildAbility('？？', Colors.black)
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
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

    // ステータスは4行で構成
    final soldierContainer = Container(
      width: 350,
      padding: const EdgeInsets.all(5),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              buildName(soldier),
              buildRokudaka(soldier),
            ],
          ),
          Container(
            margin: const EdgeInsets.only(bottom: 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                buildCharacter(soldier),
                buildAction(soldier),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              buildHp(soldier),
              buildKp(soldier),
              buildSpd(soldier),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              buildPw(soldier),
              buildDf(soldier),
              buildGrowth(soldier),
            ],
          ),
          buildStrategies(soldier),
          buildAbilities(soldier),
        ],
      ),
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
            soldierContainer,
            const SizedBox(height: 10),
            buttons,
          ],
        ),
      ),
    );
  }
}
