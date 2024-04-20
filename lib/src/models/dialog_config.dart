import '../utils/_export_.dart';

class DialogConfig {
  final bool onlyDismissProgrammatically;
  final DialogType dialogType;

  DialogConfig({
    required this.onlyDismissProgrammatically,
    required this.dialogType,
  });
}
