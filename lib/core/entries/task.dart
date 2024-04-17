part of 'scada_config_entry.dart';

final class Task implements ScadaConfigEntry {
  @override
  final String name;
  @override
  final String typeName = 'Task';
  const Task({required this.name});
  @override
  MapEntry<String, dynamic> asMapEntry() => MapEntry(
        'service Task $name',
        {},
      );
}
