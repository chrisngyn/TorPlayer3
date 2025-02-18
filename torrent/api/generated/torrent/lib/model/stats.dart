//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class Stats {
  /// Returns a new [Stats] instance.
  Stats({
    required this.totalPeers,
    required this.pendingPeers,
    required this.activePeers,
    required this.connectedPeers,
    required this.halfOpenPeers,
    required this.length,
    required this.bytesCompleted,
  });

  /// Total peers
  int totalPeers;

  /// Pending peers
  int pendingPeers;

  /// Active peers
  int activePeers;

  /// Connected peers
  int connectedPeers;

  /// Half open peers
  int halfOpenPeers;

  /// Length
  int length;

  /// Bytes completed
  int bytesCompleted;

  @override
  bool operator ==(Object other) => identical(this, other) || other is Stats &&
    other.totalPeers == totalPeers &&
    other.pendingPeers == pendingPeers &&
    other.activePeers == activePeers &&
    other.connectedPeers == connectedPeers &&
    other.halfOpenPeers == halfOpenPeers &&
    other.length == length &&
    other.bytesCompleted == bytesCompleted;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (totalPeers.hashCode) +
    (pendingPeers.hashCode) +
    (activePeers.hashCode) +
    (connectedPeers.hashCode) +
    (halfOpenPeers.hashCode) +
    (length.hashCode) +
    (bytesCompleted.hashCode);

  @override
  String toString() => 'Stats[totalPeers=$totalPeers, pendingPeers=$pendingPeers, activePeers=$activePeers, connectedPeers=$connectedPeers, halfOpenPeers=$halfOpenPeers, length=$length, bytesCompleted=$bytesCompleted]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'totalPeers'] = this.totalPeers;
      json[r'pendingPeers'] = this.pendingPeers;
      json[r'activePeers'] = this.activePeers;
      json[r'connectedPeers'] = this.connectedPeers;
      json[r'halfOpenPeers'] = this.halfOpenPeers;
      json[r'length'] = this.length;
      json[r'bytesCompleted'] = this.bytesCompleted;
    return json;
  }

  /// Returns a new [Stats] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static Stats? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "Stats[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "Stats[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return Stats(
        totalPeers: mapValueOfType<int>(json, r'totalPeers')!,
        pendingPeers: mapValueOfType<int>(json, r'pendingPeers')!,
        activePeers: mapValueOfType<int>(json, r'activePeers')!,
        connectedPeers: mapValueOfType<int>(json, r'connectedPeers')!,
        halfOpenPeers: mapValueOfType<int>(json, r'halfOpenPeers')!,
        length: mapValueOfType<int>(json, r'length')!,
        bytesCompleted: mapValueOfType<int>(json, r'bytesCompleted')!,
      );
    }
    return null;
  }

  static List<Stats> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <Stats>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = Stats.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, Stats> mapFromJson(dynamic json) {
    final map = <String, Stats>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = Stats.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of Stats-objects as value to a dart map
  static Map<String, List<Stats>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<Stats>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = Stats.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'totalPeers',
    'pendingPeers',
    'activePeers',
    'connectedPeers',
    'halfOpenPeers',
    'length',
    'bytesCompleted',
  };
}

