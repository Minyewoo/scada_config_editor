part of 'scada_config_entry.dart';

final class ApiClient implements ScadaConfigEntry {
  @override
  final String? name = null;
  @override
  final String typeName = 'ApiClient';

  const ApiClient();

  @override
  MapEntry<String, dynamic> asMapEntry() => const MapEntry(
        'service ApiClient',
        {},
      );
}
