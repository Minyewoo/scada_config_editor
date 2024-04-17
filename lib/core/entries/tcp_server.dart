part of 'scada_config_entry.dart';

final class TcpServer implements ScadaConfigEntry {
  @override
  final String? name = null;
  @override
  final String typeName = 'TcpServer';
  const TcpServer();
  @override
  MapEntry<String, dynamic> asMapEntry() => const MapEntry(
        'service TcpServer',
        {},
      );
}
