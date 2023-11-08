import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'soldier_index_provider.g.dart';

@riverpod
class SoldierIndexNotifier extends _$SoldierIndexNotifier {
  @override
  int build() {
    return 0;
  }

  void updateState(int newState) {
    state = newState;
  }
}