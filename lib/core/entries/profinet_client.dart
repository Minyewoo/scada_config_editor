part of 'scada_config_entry.dart';

final class ProfinetClient implements ScadaConfigEntry {
  @override
  final String name;
  @override
  final String typeName = 'ProfinetClient';
  const ProfinetClient({required this.name});

  @override
  MapEntry<String, dynamic> asMapEntry() => MapEntry(
        'service ProfinetClient $name',
        {},
      );
}
