import 'package:freezed_annotation/freezed_annotation.dart';

part 'soldier.freezed.dart';

@freezed
class Soldier with _$Soldier {
  const factory Soldier({
    required String name,
    required int rokudaka,
    required String character,
    required String action,
    required int hp,
    required int kp,
    required int pw,
    required int df,
    required int spd,
    required int growth,
  }) = _Soldier;
}
