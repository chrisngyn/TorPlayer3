import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path/path.dart' as p;

class PreferencesService {
  static late PreferencesService _instance;
  late final SharedPreferences _preferences;

  PreferencesService._(this._preferences);

  static PreferencesService getInstance() {
    return _instance;
  }

  static Future<void> ensureInitialized() async {
    final preferences = await SharedPreferences.getInstance();
    _instance = PreferencesService._(preferences);
    await _instance._ensureDataDirIsExists();
  }

  static const _keyDataDir = 'data_dir';
  static const _keyDeleteAfterClose = 'delete_after_close';

  Future<void> _ensureDataDirIsExists() async {
    var dataDirPath = _preferences.getString(_keyDataDir);
    if (dataDirPath == null) {
      String path;
      final isDesktop =
          Platform.isWindows || Platform.isLinux || Platform.isMacOS;
      if (isDesktop) {
        final dir = await getDownloadsDirectory();
        if (dir == null) {
          throw Exception('Failed to get downloads directory');
        }

        path = dir.path;
      } else if (Platform.isAndroid) {
        final dir = await getTemporaryDirectory();
        path = dir.path;
      } else {
        throw UnsupportedError('Not support dataDir on this platform');
      }

      dataDirPath = p.join(path, 'TorPlayer');
    }

    final dataDir = Directory(dataDirPath);
    final isExists = await dataDir.exists();
    if (!isExists) {
      await dataDir.create(recursive: true);
    }

    await _preferences.setString(_keyDataDir, dataDir.path);
  }

  Future<void> setDataDir(String path) async {
    final dataDir = Directory(path);
    final isExists = await dataDir.exists();
    if (!isExists) {
      await dataDir.create(recursive: true);
    }

    await _preferences.setString(_keyDataDir, dataDir.path);
  }

  String get dataDir => _preferences.getString(_keyDataDir)!;

  Future<void> setDeleteAfterClose(bool value) async {
    await _preferences.setBool(_keyDeleteAfterClose, value);
  }

  bool get deleteAfterClose =>
      _preferences.getBool(_keyDeleteAfterClose) ?? false;
}
