part of 'scada_config_entry.dart';

final class MultiQueue implements ScadaConfigEntry {
  @override
  final String? name = null;
  @override
  final String typeName = 'MultiQueue';
  const MultiQueue();

  @override
  MapEntry<String, dynamic> asMapEntry() => const MapEntry(
        'service MultiQueue',
        {},
      );
}
