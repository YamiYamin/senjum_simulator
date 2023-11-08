import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:senjum_simulator/domain/entities/soldier.dart';

part 'soldiers_provider.g.dart';

@riverpod
class SoldiersNotifier extends _$SoldiersNotifier {
  @override
  List<Soldier> build() {
    return [];
  }

  void updateState(List<Soldier> newState) {
    state = newState;
  }
  
}
