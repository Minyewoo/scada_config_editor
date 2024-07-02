part 'api_client.dart';
part 'cache_service.dart';
part 'multi_queue.dart';
part 'profinet_client.dart';
part 'task.dart';
part 'tcp_server.dart';

sealed class ScadaConfigEntry {
  String? get name;
  String get typeName;
  factory ScadaConfigEntry.fromMapEntry(MapEntry entry) {
    final names = entry.key.toString().split(' ');
    return switch (names) {
      ['service', 'MultiQueue'] => const MultiQueue(),
      ['service', 'ApiClient'] => const ApiClient(),
      ['service', 'TcpServer'] => const TcpServer(),
      ['service', 'Task', final name] => Task(name: name),
      ['service', 'CacheService', final name] => CacheService(name: name),
      ['service', 'ProfinetClient', final name] => ProfinetClient(name: name),
      _ => UnknownEntry(name: names.toString()),
    };
  }
  MapEntry<String, dynamic> asMapEntry();
}

final class UnknownEntry implements ScadaConfigEntry {
  @override
  final String? name;
  @override
  final String typeName = 'Unknown';

  const UnknownEntry({this.name});

  @override
  MapEntry<String, dynamic> asMapEntry() => const MapEntry(
        'service Unknown',
        {},
      );
}
