import 'package:scada_config_editor/core/entries/scada_config_entry.dart';

final class ScadaConfig {
  final String? name;
  final String? description;
  final List<ScadaConfigEntry> entries;

  const ScadaConfig({
    this.name,
    this.description,
    this.entries = const [],
  });

  Map<String, dynamic> asMap() => {
        if (name != null) 'name': name,
        if (description != null) 'description': description,
        ...Map.fromEntries(entries.map((e) => e.asMapEntry()))
      };
}
