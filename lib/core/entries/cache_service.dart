part of 'scada_config_entry.dart';

final class CacheService implements ScadaConfigEntry {
  @override
  final String? name;
  @override
  final String typeName = 'CacheService';

  const CacheService({required this.name});

  @override
  MapEntry<String, dynamic> asMapEntry() => MapEntry(
        'service CacheService${name != null ? ' $name' : ''}',
        {},
      );
}
