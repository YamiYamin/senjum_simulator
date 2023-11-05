import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'stage_lv_provider.g.dart';

@riverpod
class StageLvNotifier extends _$StageLvNotifier {
  @override
  int build() {
    return 0;
  }

  void updateState(int newState) {
    state = newState;
  }
}
