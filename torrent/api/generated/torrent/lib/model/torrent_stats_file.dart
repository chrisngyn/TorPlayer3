//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class TorrentStatsFile {
  /// Returns a new [TorrentStatsFile] instance.
  TorrentStatsFile({
    required this.length,
    required this.bytesCompleted,
  });

  /// File length
  int length;

  /// Bytes completed
  int bytesCompleted;

  @override
  bool operator ==(Object other) => identical(this, other) || other is TorrentStatsFile &&
    other.length == length &&
    other.bytesCompleted == bytesCompleted;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (length.hashCode) +
    (bytesCompleted.hashCode);

  @override
  String toString() => 'TorrentStatsFile[length=$length, bytesCompleted=$bytesCompleted]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'length'] = this.length;
      json[r'bytesCompleted'] = this.bytesCompleted;
    return json;
  }

  /// Returns a new [TorrentStatsFile] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static TorrentStatsFile? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "TorrentStatsFile[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "TorrentStatsFile[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return TorrentStatsFile(
        length: mapValueOfType<int>(json, r'length')!,
        bytesCompleted: mapValueOfType<int>(json, r'bytesCompleted')!,
      );
    }
    return null;
  }

  static List<TorrentStatsFile> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <TorrentStatsFile>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = TorrentStatsFile.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, TorrentStatsFile> mapFromJson(dynamic json) {
    final map = <String, TorrentStatsFile>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = TorrentStatsFile.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of TorrentStatsFile-objects as value to a dart map
  static Map<String, List<TorrentStatsFile>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<TorrentStatsFile>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = TorrentStatsFile.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'length',
    'bytesCompleted',
  };
}

