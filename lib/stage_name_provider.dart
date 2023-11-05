import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'stage_name_provider.g.dart';

@riverpod
class StageNameNotifier extends _$StageNameNotifier {
  @override
  String build() {
    return '平地';
  }

  void updateState(String newState) {
    state = newState;
  }
}
