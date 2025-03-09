//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class TorrentStats {
  /// Returns a new [TorrentStats] instance.
  TorrentStats({
    required this.stats,
    this.files = const [],
  });

  Stats stats;

  List<TorrentStatsFile> files;

  @override
  bool operator ==(Object other) => identical(this, other) || other is TorrentStats &&
    other.stats == stats &&
    _deepEquality.equals(other.files, files);

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (stats.hashCode) +
    (files.hashCode);

  @override
  String toString() => 'TorrentStats[stats=$stats, files=$files]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'stats'] = this.stats;
      json[r'files'] = this.files;
    return json;
  }

  /// Returns a new [TorrentStats] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static TorrentStats? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "TorrentStats[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "TorrentStats[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return TorrentStats(
        stats: Stats.fromJson(json[r'stats'])!,
        files: TorrentStatsFile.listFromJson(json[r'files']),
      );
    }
    return null;
  }

  static List<TorrentStats> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <TorrentStats>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = TorrentStats.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, TorrentStats> mapFromJson(dynamic json) {
    final map = <String, TorrentStats>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = TorrentStats.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of TorrentStats-objects as value to a dart map
  static Map<String, List<TorrentStats>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<TorrentStats>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = TorrentStats.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'stats',
    'files',
  };
}

