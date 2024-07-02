import 'dart:convert';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:scada_config_editor/core/scada_config.dart';
import 'package:scada_config_editor/core/entries/scada_config_entry.dart';
import 'package:yaml/yaml.dart';
import 'package:yaml_writer/yaml_writer.dart';

class EditorScreen extends StatefulWidget {
  const EditorScreen({super.key});

  @override
  State<EditorScreen> createState() => _EditorScreenState();
}

class _EditorScreenState extends State<EditorScreen> {
  late ScadaConfig _scadaConfig;
  @override
  void initState() {
    _scadaConfig = const ScadaConfig();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme.titleLarge;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Config editor'),
        actions: [
          ElevatedButton.icon(
            onPressed: () async {
              final result = await FilePicker.platform.pickFiles(
                type: FileType.custom,
                allowedExtensions: ['yaml', 'yml'],
              );
              if (result != null) {
                final config = loadYaml(
                  await File(result.files.single.path!).readAsString(),
                ) as Map;
                setState(() {
                  _scadaConfig = ScadaConfig(
                    name: config['name'],
                    description: config['description'],
                    entries: config.entries
                        .where(
                          (element) =>
                              !['name', 'description'].contains(element.key),
                        )
                        .map((entry) => ScadaConfigEntry.fromMapEntry(entry))
                        .toList(),
                  );
                });
                if (mounted) {
                  // ignore: use_build_context_synchronously
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      backgroundColor: Colors.green.shade300,
                      content: const Text('Config loaded!'),
                    ),
                  );
                }
              } else {
                if (mounted) {
                  // ignore: use_build_context_synchronously
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      backgroundColor: Colors.orange.shade300,
                      content: const Text('Config not loaded!'),
                    ),
                  );
                }
              }
            },
            icon: const Icon(Icons.file_open),
            label: const Text('Open'),
          ),
          const SizedBox(width: 16),
          ElevatedButton.icon(
            onPressed: () async {
              final writer = YamlWriter();
              try {
                final content = utf8.encode(
                  writer.write(_scadaConfig.asMap()),
                );
                final savedPath = await FilePicker.platform.saveFile(
                  type: FileType.custom,
                  allowedExtensions: ['yaml', 'yml'],
                );
                if (savedPath != null) {
                  File(savedPath).writeAsBytes(content);
                  if (mounted) {
                    // ignore: use_build_context_synchronously
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        backgroundColor: Colors.green.shade300,
                        content:
                            Text('Config successfully saved to $savedPath!'),
                      ),
                    );
                  }
                } else {
                  if (mounted) {
                    // ignore: use_build_context_synchronously
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        backgroundColor: Colors.orange.shade300,
                        content: const Text('Config saving aborted!'),
                      ),
                    );
                  }
                }
              } catch (e) {
                if (mounted) {
                  // ignore: use_build_context_synchronously
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      backgroundColor: Colors.red.shade300,
                      content: Text('Unable to save file: $e'),
                    ),
                  );
                }
              }
            },
            icon: const Icon(Icons.save),
            label: const Text('Export'),
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: Column(
        children: [
          if (_scadaConfig.name != null)
            Text(
              'name: ${_scadaConfig.name}',
              style: textStyle,
            ),
          if (_scadaConfig.description != null)
            Text(
              'description: ${_scadaConfig.description}',
              style: textStyle,
            ),
          Expanded(
            child: GridView.count(
              crossAxisCount: 4,
              children: _scadaConfig.entries
                  .map(
                    (entry) => Card(
                      clipBehavior: Clip.antiAlias,
                      child: InkWell(
                        onTap: () {},
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  margin: const EdgeInsets.all(8),
                                  padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                                  decoration: ShapeDecoration(
                                    shape: const StadiumBorder(),
                                    color: switch(entry) {
                                      MultiQueue() => Colors.blue,
                                      ApiClient() => Colors.pinkAccent,
                                      CacheService() => Colors.green,
                                      ProfinetClient() => Colors.deepPurpleAccent,
                                      Task() => Colors.cyan,
                                      TcpServer() => Colors.deepOrangeAccent,
                                      UnknownEntry() => Colors.redAccent,
                                    },
                                  ),
                                  child: Text(
                                    entry.typeName,
                                    style: Theme.of(context).textTheme.titleLarge,
                                    maxLines: 1,
                                    overflow: TextOverflow.fade,
                                    softWrap: false,
                                  ),
                                ),
                                if(entry.name != null)
                                  Text(
                                    entry.name!,
                                    style: Theme.of(context).textTheme.titleLarge,
                                    maxLines: 1,
                                    overflow: TextOverflow.fade,
                                    softWrap: false,
                                  ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }
}
