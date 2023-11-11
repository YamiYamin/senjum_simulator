import 'dart:math';

import 'package:senjum_simulator/domain/entities/map_data.dart';
import 'package:senjum_simulator/domain/entities/soldier.dart';

class SoldierLogic {
  static final random = Random();

  static String getSoldiersData(String stageName, int stageLv) {
    switch (stageName) {
      case '平地':
        return mapData[random.nextInt(38)];
      case '鉄砲鍛造所':
        return switch (stageLv) {
          6 => '633333646864634343436843436864644364434364636343646464634343',
          4 => '633333646864631340136813406864641364401364636313646464631313',
          3 => '633333646864631340136813406864641364401364636313646464631313',
          _ => '',
        };
      case '忍の里':
        return switch (stageLv) {
          6 => '784040242424244040714040382424117111407111381171716464244071',
          5 => '784111242424241171714040402424117111647111401171716464247171',
          4 => '331111244024407171712323234040387138407140584071714040584071',
          3 => '787111242424241140712323402424117111387111401171712323243871',
          2 => '787171242424241171712323112424117111717111111171712323247171',
          _ => '',
        };
      case '繁華街':
        return switch (stageLv) {
          6 => '404071244024404040402424242424234023404023402340402323404040',
          5 => '404040244024404040402424242424234023404023402340402323404040',
          4 => '534040644064404040406464646464234023404064406440406464404040',
          3 => mapData[random.nextInt(5) + 17],
          2 => '333121244024402323402424242424234023404023402340402323404040',
          _ => '',
        };
      case '兵学舎':
        return switch (stageLv) {
          6 => '533858385313104364386464646413534364535358535843535343646453',
          5 =>
            '101653152038161678151238122123071513071710191940171518171718141624141523141723081413071613101023191340171418121923101223151158102123152158191140121223121023192140081813171818101923',
          // 5 => '131658121638211638221771221871221440221540211411201711211811201511201864201423141523071514081423081623081823121758091523071614121358121958200681091723141623141723121558071714202681',
          4 => '585858112311235858582323232311315831404058582371716464585840',
          3 => '585873135813581818236464641323382338181858585823232323581818',
          2 =>
            '111658181411181711071524122018071724121218191311191811201911141624141523141723081424081824171331201211171931141958191540161458121358161858190971192471171164172264121958141358191640',
          _ => '',
        };
      case '武家屋敷':
        return switch (stageLv) {
          6 => '815871711824181181112323232424318131814038283840402323288140',
          5 => '333858242324382828483348382324382838484838132848486464334848',
          4 => '815858718114333840812333312323234023408123284028232323144081',
          3 => '333858712314232323232323231414332333237133233371712323232371',
          2 => '333833241824184823232423232424313831484858585838332323584848',
          1 => mapData[random.nextInt(5) + 12],
          _ => '',
        };
      case '裏戦国':
        return '333433333433434333717153533363636464646463646411233440536471';
      default:
        return '';
    }
  }

  static List<Soldier> determineCharacter(
      List<Soldier> soldiers, String stageName, int stageLv) {
    String soldiersData = getSoldiersData(stageName, stageLv);
    final newSoldiers = <Soldier>[];

    int i = 0;
    for (final soldier in soldiers) {
      String character = switch (soldiersData[i]) {
        '1' => '足軽',
        '2' => '弓兵',
        '3' => '武将',
        '4' => '猛者',
        '5' => '軍師',
        '6' => '鉄砲',
        '7' => '忍者',
        '8' => '騎馬',
        _ => ''
      };

      String currentStrategy = switch (soldiersData[i + 1]) {
        '1' => '突撃',
        '3' => '守備',
        '8' => '迎撃',
        '0' => '乱戦',
        '4' => '待機',
        _ => ''
      };

      newSoldiers.add(
        soldier.copyWith(
          character: character,
          currentStrategy: currentStrategy,
        ),
      );

      i += 2;
    }

    return newSoldiers;
  }

  static Soldier determineCapabilities(Soldier soldier, int stageLv) {
    final strategies = <String, bool>{
      '突撃': false,
      '守備': false,
      '迎撃': false,
      '乱戦': false,
      '待機': false,
    };

    String action = '';
    int hp = 0;
    int kp = 0;
    int pw = 0;
    int df = 0;
    int spd = 0;

    switch (soldier.character) {
      case '足軽':
        action = random.nextDouble() * 100 > 99.5 ? '槍術' : '槍撃';
        spd = (random.nextDouble() * 3).floor() + 2;

        hp = 30 + (random.nextDouble() * 20).floor();
        kp = 30 + (random.nextDouble() * 20).floor();
        pw = 40 + (random.nextDouble() * 20).floor();
        df = 30 + (random.nextDouble() * 20).floor();

        if (random.nextDouble() * 100 > 60) {
          hp += (random.nextDouble() * 25).floor();
          kp += (random.nextDouble() * 30).floor();
          pw += (random.nextDouble() * 30).floor();
          df += (random.nextDouble() * 25).floor();

          if (random.nextDouble() * 100 > 70) {
            hp += (random.nextDouble() * 5).floor();
            kp += (random.nextDouble() * 20).floor();
            pw += (random.nextDouble() * 20).floor();
            df += (random.nextDouble() * 10).floor();

            if (random.nextDouble() * 100 > 70) {
              hp += (random.nextDouble() * 15).floor();
              df += (random.nextDouble() * 15).floor();
            }
          }
        }

        if (random.nextDouble() * 100 > 50 || soldier.currentStrategy == '突撃') {
          strategies['突撃'] = true;
        }
        if (random.nextDouble() * 100 > 50 ||
            !strategies['突撃']! ||
            soldier.currentStrategy == '守備') {
          strategies['守備'] = true;
        }
        if (random.nextDouble() * 100 > 65 || soldier.currentStrategy == '迎撃') {
          strategies['迎撃'] = true;
        }
        if (random.nextDouble() * 100 > 95 || soldier.currentStrategy == '乱戦') {
          strategies['乱戦'] = true;
        }
        if (random.nextDouble() * 100 > 80 || soldier.currentStrategy == '待機') {
          strategies['待機'] = true;
        }
        break;
      case '弓兵':
        action = '弓矢';
        if (random.nextDouble() * 300 > 287) {
          // 1.82%
          if (random.nextDouble() * 100 > 30) {
            action = '火矢';
            // 0.78%
          } else {
            action = '焙烙';
          }
        }
        spd = (random.nextDouble() * 3).floor() + 2;

        hp = 30 + (random.nextDouble() * 20).floor();
        kp = 30 + (random.nextDouble() * 20).floor();
        pw = 20 + (random.nextDouble() * 20).floor();
        df = 20 + (random.nextDouble() * 20).floor();

        // 火矢や焙烙だった兵もこのifを抜けると弓矢か遠射になる
        // 77.4%で弓矢、20%で遠射
        if (random.nextDouble() * 100 > 60) {
          action = random.nextBool() ? '弓矢' : '遠射';
          hp += (random.nextDouble() * 30).floor();
          kp += (random.nextDouble() * 30).floor();
          pw += (random.nextDouble() * 20).floor();
          df += (random.nextDouble() * 30).floor();

          if (random.nextDouble() * 100 > 90) {
            pw += (random.nextDouble() * 20).floor();

            if (random.nextDouble() * 100 > 95) {
              pw += (random.nextDouble() * 80).floor();
            }

            hp += (random.nextDouble() * 20).floor();
            kp += (random.nextDouble() * 20).floor();
            df += (random.nextDouble() * 20).floor();
          }
        }

        if (random.nextDouble() * 100 > 50 || soldier.currentStrategy == '突撃') {
          strategies['突撃'] = true;
        }
        if (random.nextDouble() * 100 > 40 ||
            !strategies['突撃']! ||
            soldier.currentStrategy == '守備') {
          strategies['守備'] = true;
        }
        if (random.nextDouble() * 100 > 65 || soldier.currentStrategy == '迎撃') {
          strategies['迎撃'] = true;
        }
        if (random.nextDouble() * 100 > 95 || soldier.currentStrategy == '乱戦') {
          strategies['乱戦'] = true;
        }
        if (random.nextDouble() * 100 > 30 ||
            strategies['守備']! ||
            soldier.currentStrategy == '待機') {
          strategies['待機'] = true;
        }
        break;
      case '武将':
        //
        action = '号令';

        // 0.5%
        if (random.nextDouble() * 400 > 398) {
          action = '豪傑';
        }
        // 0.11...%
        if (random.nextDouble() * 1800 > 1798) {
          action = '治癒';
        }
        spd = (random.nextDouble() * 3).floor() + 2;
        hp = 30 + (random.nextDouble() * 20).floor();
        kp = 30 + (random.nextDouble() * 20).floor();
        pw = 30 + (random.nextDouble() * 20).floor();
        df = 65 + (random.nextDouble() * 15).floor();

        if (random.nextDouble() * 100 > 60) {
          hp += (random.nextDouble() * 30).floor();
          kp += (random.nextDouble() * 30).floor();
          pw += (random.nextDouble() * 30).floor();
          df += (random.nextDouble() * 50).floor();
        }

        if (random.nextDouble() * 100 > 70) {
          hp += (random.nextDouble() * 20).floor();
          kp += (random.nextDouble() * 20).floor();
          pw += (random.nextDouble() * 50).floor();
          df += (random.nextDouble() * 50).floor();
        }

        if (random.nextDouble() * 100 > 50 || soldier.currentStrategy == '突撃') {
          strategies['突撃'] = true;
        }
        if (random.nextDouble() * 100 > 50 || soldier.currentStrategy == '守備') {
          strategies['守備'] = true;
        }
        if (random.nextDouble() * 100 > 25 ||
            !strategies['突撃']! && !strategies['守備']! ||
            soldier.currentStrategy == '迎撃') {
          strategies['迎撃'] = true;
        }
        if (random.nextDouble() * 100 > 97 || soldier.currentStrategy == '乱戦') {
          strategies['乱戦'] = true;
        }
        if (random.nextDouble() * 100 > 97 || soldier.currentStrategy == '待機') {
          strategies['待機'] = true;
        }

        break;
      case '猛者':
        action = '旋風';
        if (random.nextDouble() * 100 > 75) {
          action = '無双';
        }
        if (random.nextDouble() * 500 > 498) {
          action = '鬼神';
        }
        spd = (random.nextDouble() * 3).floor() + 2;
        hp = 45 + (random.nextDouble() * 15).floor();
        kp = 30 + (random.nextDouble() * 20).floor();
        pw = 65 + (random.nextDouble() * 15).floor();
        df = 30 + (random.nextDouble() * 20).floor();
        if (random.nextDouble() * 100 > 60) {
          hp += (random.nextDouble() * 30).floor();
          kp += (random.nextDouble() * 30).floor();
          pw += (random.nextDouble() * 30).floor();
          df += (random.nextDouble() * 30).floor();
          if (random.nextDouble() * 100 > 70) {
            hp += (random.nextDouble() * 20).floor();
            kp += (random.nextDouble() * 20).floor();
            pw += (random.nextDouble() * 20).floor();
            df += (random.nextDouble() * 20).floor();
          }
        }

        if (random.nextDouble() * 400 > 395) {
          strategies['突撃'] = true;
        }
        if (random.nextDouble() * 400 > 396) {
          strategies['守備'] = true;
        }
        if (random.nextDouble() * 400 > 396) {
          strategies['迎撃'] = true;
        }
        strategies['乱戦'] = true;
        break;
      case '軍師':
        action = random.nextBool() ? '火遊' : '火攻';
        // 3%で虚報
        if (random.nextDouble() * 100 > 97) {
          action = '虚報';
        }
        // 1%(300>297)で妖術
        if (random.nextDouble() * 300 > 297) {
          action = '妖術';
        }
        spd = (random.nextDouble() * 2).floor() + 2;
        hp = 20 + (random.nextDouble() * 15).floor();
        kp = 30 + (random.nextDouble() * 20).floor();
        pw = 10 + (random.nextDouble() * 10).floor();
        df = 30 + (random.nextDouble() * 20).floor();
        if (random.nextDouble() * 100 > 60) {
          pw += (random.nextDouble() * 20).floor();
          hp += (random.nextDouble() * 10).floor();
          df += (random.nextDouble() * 30).floor();
          kp += (random.nextDouble() * 30).floor();
          if (random.nextDouble() * 100 > 85) {
            action = switch (random.nextDouble() * 3) {
              >= 2 => '火遊',
              >= 1 => '火攻',
              _ => '火計',
            };
            if (random.nextDouble() * 100 > 85) {
              action = switch (random.nextDouble() * 4) {
                >= 3 => '火遊',
                >= 2 => '火攻',
                >= 1 => '火計',
                _ => '業火',
              };
              hp += (random.nextDouble() * 35).floor();
              // 1798/1800
              if (random.nextDouble() * 1800 > 1798) {
                action = '治癒';
              }
              // 1398/1400
              if (random.nextDouble() * 1400 > 1398) {
                action = '炎術';
              }
            }
            pw += (random.nextDouble() * 40).floor();
            hp += (random.nextDouble() * 20).floor();
            df += (random.nextDouble() * 50).floor();
            kp += (random.nextDouble() * 80).floor();
          }
        }

        if (random.nextDouble() * 100 > 50 || soldier.currentStrategy == '突撃') {
          strategies['突撃'] = true;
        }
        if (random.nextDouble() * 100 > 50 || soldier.currentStrategy == '守備') {
          strategies['守備'] = true;
        }
        if (random.nextDouble() * 100 > 50 || soldier.currentStrategy == '迎撃') {
          strategies['迎撃'] = true;
        }
        if (random.nextDouble() * 100 > 50 || soldier.currentStrategy == '乱戦') {
          strategies['乱戦'] = true;
        }
        if (random.nextDouble() * 100 > 50 || soldier.currentStrategy == '待機') {
          strategies['待機'] = true;
        }
        break;

      case '鉄砲':
        action = random.nextDouble() * 300 > 298 ? '砲撃' : '射撃';
        spd = (random.nextDouble() * 2).floor() + 1;

        hp = 20 + (random.nextDouble() * 20).floor();
        kp = 30 + (random.nextDouble() * 20).floor();
        pw = 10 + (random.nextDouble() * 10).floor();
        df = 20 + (random.nextDouble() * 20).floor();

        if (random.nextDouble() * 100 > 60) {
          action = random.nextBool() ? '射撃' : '狙撃';
          hp += (random.nextDouble() * 10).floor();
          kp += (random.nextDouble() * 30).floor();
          pw += (random.nextDouble() * 20).floor();
          df += (random.nextDouble() * 30).floor();

          if (random.nextDouble() * 100 > 90) {
            hp += (random.nextDouble() * 15).floor();
            kp += (random.nextDouble() * 20).floor();
            pw += (random.nextDouble() * 20).floor();
            df += (random.nextDouble() * 20).floor();

            if (random.nextDouble() * 100 > 95) {
              hp += (random.nextDouble() * 30).floor();
            }
          }
        }

        if (random.nextDouble() * 100 > 90 || soldier.currentStrategy == '突撃') {
          strategies['突撃'] = true;
        }
        if (random.nextDouble() * 100 > 90 || soldier.currentStrategy == '守備') {
          strategies['守備'] = true;
        }
        if (random.nextDouble() * 100 > 80 || soldier.currentStrategy == '迎撃') {
          strategies['迎撃'] = true;
        }
        if (random.nextDouble() * 100 > 97 || soldier.currentStrategy == '乱戦') {
          strategies['乱戦'] = true;
        }
        strategies['待機'] = true;

        break;

      case '忍者':
        action = '忍術';
        if (random.nextDouble() * 100 > 87) {
          action = '影走';
        }
        if (random.nextDouble() * 200 > 198) {
          action = '幻術';
        }
        if (random.nextDouble() * 200 > 198) {
          action = '結界';
        }
        spd = (random.nextDouble() * 2).floor() + 4;
        hp = 15 + (random.nextDouble() * 5).floor();
        kp = 30 + (random.nextDouble() * 20).floor();
        pw = 65 + (random.nextDouble() * 15).floor();
        df = 65 + (random.nextDouble() * 15).floor();
        if (random.nextDouble() * 100 > 60) {
          hp += (random.nextDouble() * 15).floor();
          kp += (random.nextDouble() * 30).floor();
          pw += (random.nextDouble() * 20).floor();
          df += (random.nextDouble() * 30).floor();
          if (random.nextDouble() * 100 > 70) {
            hp += (random.nextDouble() * 15).floor();
            kp += (random.nextDouble() * 20).floor();
            pw += (random.nextDouble() * 20).floor();
            df += (random.nextDouble() * 20).floor();
          }
        }

        strategies['突撃'] = true;
        if (random.nextDouble() * 400 > 398) {
          strategies['守備'] = true;
        }
        if (random.nextDouble() * 400 > 398) {
          strategies['迎撃'] = true;
        }
        if (random.nextDouble() * 400 > 398 ||
            soldier.currentStrategy == '乱戦') {
          strategies['乱戦'] = true;
        }
        break;

      case '騎馬':
        action = '騎突';
        spd = (random.nextDouble() * 2).floor() + 5;

        hp = 50 + (random.nextDouble() * 5).floor();
        kp = 55 + (random.nextDouble() * 10).floor();
        pw = 85 + (random.nextDouble() * 20).floor();
        df = 15 + (random.nextDouble() * 5).floor();

        if (random.nextDouble() * 100 > 60) {
          hp += (random.nextDouble() * 20).floor();
          kp += (random.nextDouble() * 20).floor();
          pw += (random.nextDouble() * 20).floor();
          df += (random.nextDouble() * 10).floor();

          if (random.nextDouble() * 100 > 70) {
            hp += (random.nextDouble() * 5).floor();
            kp += (random.nextDouble() * 10).floor();
            pw += (random.nextDouble() * 40).floor();

            if (random.nextDouble() * 100 > 70) {
              hp += (random.nextDouble() * 10).floor();
              kp += (random.nextDouble() * 20).floor();
              df += (random.nextDouble() * 10).floor();
            }
          }
        }
        strategies['突撃'] = true;
        if (random.nextDouble() * 400 > 398) {
          strategies['迎撃'] = true;
        }
        if (random.nextDouble() * 400 > 348 ||
            soldier.currentStrategy == '乱戦') {
          strategies['乱戦'] = true;
        }
        break;
    }

    final enemyLv = stageLv * 5 - 10;

    kp += enemyLv;
    pw += enemyLv;
    df += enemyLv;

    if (soldier.character != '忍者') {
      hp += enemyLv;
    }

    if (soldier.character != '騎馬') {
      if (pw > 110) {
        pw = 110;
      }
    } else {
      if (pw > 125) {
        pw = 125;
      }
    }

    if (df > 110) {
      df = 110;
    }

    if (kp > 110) {
      kp = 110;
    }

    if (hp > 110) {
      hp = 110;
    }

    if (soldier.character == '騎馬' && hp > 90) {
      hp = 80 + (random.nextDouble() * 15).floor();
    }

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
      '忍狩': false,
      '火遁': false,
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
      if (key == '忍狩' && soldier.character == '猛者') {
        abilities[key] = random.nextDouble() * 100 > 85;
        return;
      }
      if (key == '火遁' && soldier.character == '忍者') {
        abilities[key] = random.nextDouble() * 100 > 80;
        return;
      }
      if (key == '猛退' && soldier.character == '騎馬') {
        abilities[key] = true;
        return;
      }
      if (key == '陣頭' && soldier.character == '騎馬') {
        abilities[key] = random.nextDouble() * 100 > 90;
        return;
      }
      abilities[key] = random.nextDouble() * 100 > 75;
    });

    final newSoldier = Soldier(
      name: '弁慶',
      rokudaka: 0,
      character: soldier.character,
      action: action,
      hp: hp,
      kp: kp,
      pw: pw,
      df: df,
      spd: spd,
      growth: 9,
      abilities: abilities,
      currentStrategy: soldier.currentStrategy,
      strategies: strategies,
    );

    return newSoldier.copyWith(rokudaka: calcRokudaka(newSoldier));
  }

  static Soldier updateRokudaka(Soldier soldier) {
    if (soldier.rokudaka >= 9999) {
      return soldier;
    }
    return soldier.copyWith(
      rokudaka: calcRokudaka(soldier),
    );
  }

  static Soldier grow(Soldier soldier) {
    if (soldier.growth < 1) {
      return soldier;
    }

    int hp = soldier.hp;
    int kp = soldier.kp;
    int pw = soldier.pw;
    int df = soldier.df;
    int spd = soldier.spd;

    Map<String, bool> abilities = Map.from(soldier.abilities);
    Map<String, bool> strategies = Map.from(soldier.strategies);

    if (random.nextDouble() * 100 > 8) {
      int loopCount = 0;
      int increase = 0;
      while (true) {
        // 51周しても成長できない場合防御を1上げる
        if (loopCount > 50) {
          df += 1;
          if (df > 125) {
            df = 125;
          }
          break;
        }
        // ステータス上昇量の決定
        if (random.nextDouble() * 100 > 75) {
          if (random.nextDouble() * 100 > 90) {
            increase = 3;
          } else {
            increase = 2;
          }
        } else {
          increase = 1;
        }
        // ステータスを上昇させる（無理ならcontinue）
        switch (random.nextInt(4)) {
          case 0:
            if (hp + increase > 125) {
              loopCount++;
              continue;
            }
            hp += increase;
            break;
          case 1:
            if (kp + increase > 125) {
              loopCount++;
              continue;
            }
            kp += increase;
            break;
          case 2:
            if (pw + increase > 125) {
              loopCount++;
              continue;
            }
            pw += increase;
            break;
          case 3:
            if (df + increase > 125) {
              loopCount++;
              continue;
            }
            df += increase;
            break;
        }
        break;
      }
    } else {
      // 更に90%で星以外の特殊能力が付く
      if (random.nextDouble() * 100 > 10) {
        int loopCount = 0;
        while (true) {
          if (loopCount > 50) {
            df += 1;
            if (df > 125) {
              df = 125;
            }
            break;
          }
          int ss = (random.nextDouble() * 16).floor();
          String key = abilities.keys.elementAt(ss);
          if (key == '膂力' ||
              key == '連発' ||
              key == '討取' ||
              key == '鼓舞' ||
              key == '奮起') {
            loopCount++;
            continue;
          }
          if (!abilities[key]!) {
            abilities[key] = true;
            break;
          } else {
            loopCount++;
            continue;
          }
        }
        // 更に10%で星か作戦行動が付く
      } else {
        int loopCount = 0;
        while (true) {
          if (loopCount > 50) {
            df += 1;
            if (df > 125) {
              df = 125;
            }
            break;
          }
          int index = (random.nextDouble() * 9).floor();
          switch (index) {
            case 0:
            case 1:
            case 2:
            case 3:
            case 4:
              String key = strategies.keys.elementAt(index);
              if (!strategies[key]!) {
                strategies[key] = true;
              } else {
                loopCount++;
                continue;
              }
            case 5:
              if (!abilities['膂力']!) {
                abilities['膂力'] = true;
              } else {
                loopCount++;
                continue;
              }
            case 6:
              if (!abilities['連発']!) {
                abilities['連発'] = true;
              } else {
                loopCount++;
                continue;
              }
            case 7:
              if (!abilities['鼓舞']!) {
                abilities['鼓舞'] = true;
              } else {
                loopCount++;
                continue;
              }
            case 8:
              if (spd < 6) {
                spd++;
              } else {
                loopCount++;
                continue;
              }
          }
          break;
        }
      }
    }

    Soldier newSoldier = soldier.copyWith(
      hp: hp,
      kp: kp,
      pw: pw,
      df: df,
      spd: spd,
      growth: soldier.growth - 1,
      abilities: abilities,
      strategies: strategies,
    );

    return updateRokudaka(newSoldier);
  }

  static int calcRokudaka(Soldier soldier) {
    int rokudaka = (pow(soldier.hp, 3) / 2500 +
            pow(soldier.kp, 3) / 2200 +
            pow(soldier.pw, 3) / 2000 +
            pow(soldier.df, 3) / 3000 +
            pow(soldier.spd, 3) * 2)
        .floor();

    const rokudakaOfStrategies = <String, int>{
      '突撃': 10,
      '守備': 10,
      '迎撃': 10,
      '乱戦': 5,
      '待機': 5,
    };

    soldier.strategies.forEach((key, value) {
      if (value) {
        rokudaka += rokudakaOfStrategies[key]!;
      }
    });

    const rokudakaOfAbilities = <String, int>{
      '突進': 20,
      '攻略': 20,
      '膂力': 300,
      '連発': 350,
      '鉄壁': 10,
      '見切': 20,
      '討取': 10,
      '奮起': 20,
      '鼓舞': 120,
      '回復': 20,
      '治療': 30,
      '療所': 30,
      '仕掛': 10,
      '堅陣': 30,
      '母衣': 10,
      '逃足': 10,
      '忍狩': 700,
      '火遁': 1200,
      '猛退': 1000,
      '陣頭': 2000,
    };

    soldier.abilities.forEach((key, value) {
      if (value) {
        rokudaka += rokudakaOfAbilities[key]!;
      }
    });

    if (soldier.character == '槍撃' || soldier.character == '弓兵') {
      rokudaka = (rokudaka * 0.7).floor();
    }

    if (rokudaka > 9999) {
      rokudaka = 9999;
    }

    return rokudaka;
  }
}
