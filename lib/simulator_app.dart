import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:senjum_status/senjum_status_app.dart';
import 'package:senjum_status/stage_selection_page.dart';

class SimulatorApp extends ConsumerWidget {
  const SimulatorApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: StageSelectionPage(),
    );
  }
}
