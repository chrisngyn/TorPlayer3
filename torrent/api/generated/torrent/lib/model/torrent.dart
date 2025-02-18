//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class Torrent {
  /// Returns a new [Torrent] instance.
  Torrent({
    required this.infoHash,
    required this.name,
    required this.size,
    this.files = const [],
  });

  /// Torrent info hash
  String infoHash;

  /// Torrent name
  String name;

  /// Torrent size
  int size;

  List<File> files;

  @override
  bool operator ==(Object other) => identical(this, other) || other is Torrent &&
    other.infoHash == infoHash &&
    other.name == name &&
    other.size == size &&
    _deepEquality.equals(other.files, files);

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (infoHash.hashCode) +
    (name.hashCode) +
    (size.hashCode) +
    (files.hashCode);

  @override
  String toString() => 'Torrent[infoHash=$infoHash, name=$name, size=$size, files=$files]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'infoHash'] = this.infoHash;
      json[r'name'] = this.name;
      json[r'size'] = this.size;
      json[r'files'] = this.files;
    return json;
  }

  /// Returns a new [Torrent] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static Torrent? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "Torrent[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "Torrent[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return Torrent(
        infoHash: mapValueOfType<String>(json, r'infoHash')!,
        name: mapValueOfType<String>(json, r'name')!,
        size: mapValueOfType<int>(json, r'size')!,
        files: File.listFromJson(json[r'files']),
      );
    }
    return null;
  }

  static List<Torrent> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <Torrent>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = Torrent.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, Torrent> mapFromJson(dynamic json) {
    final map = <String, Torrent>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = Torrent.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of Torrent-objects as value to a dart map
  static Map<String, List<Torrent>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<Torrent>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = Torrent.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'infoHash',
    'name',
    'size',
    'files',
  };
}

