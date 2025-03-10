import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:tor_player/services/preferences/preferences_service.dart';

class SettingsView extends StatefulWidget {
  const SettingsView({super.key});

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  late String _dataDirPath;
  bool _isDataDirPathChanged = false;
  late bool _deleteAfterClose;

  @override
  void initState() {
    super.initState();
    _dataDirPath = PreferencesService.getInstance().dataDir;
    _deleteAfterClose = PreferencesService.getInstance().deleteAfterClose;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: body(context),
    );
  }

  Widget body(BuildContext context) {
    return Column(
      children: [
        ListTile(
          title: const Text('Data Directory'),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(_dataDirPath),
              if (_isDataDirPathChanged)
                Text(
                  'Data directory path has been changed. Restart the app to apply changes.',
                  style:
                      TextStyle(color: Theme.of(context).colorScheme.onSurface),
                ),
            ],
          ),
          trailing: IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              _updateDataDirPath();
            },
          ),
        ),
        SwitchListTile(
          title: const Text('Delete After Close'),
          value: _deleteAfterClose,
          onChanged: _updateDeleteAfterClose,
        ),
      ],
    );
  }

  void _updateDataDirPath() async {
    String? selectedDirectory = await FilePicker.platform.getDirectoryPath();
    if (selectedDirectory != null) {
      await PreferencesService.getInstance().setDataDir(selectedDirectory);
      setState(() {
        _dataDirPath = selectedDirectory;
        _isDataDirPathChanged = true;
      });
    }
  }

  void _updateDeleteAfterClose(bool value) async {
    await PreferencesService.getInstance().setDeleteAfterClose(value);
    setState(() {
      _deleteAfterClose = value;
    });
  }
}
