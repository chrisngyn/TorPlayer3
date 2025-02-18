//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class File {
  /// Returns a new [File] instance.
  File({
    required this.name,
    required this.size,
  });

  /// File name
  String name;

  /// File size
  int size;

  @override
  bool operator ==(Object other) => identical(this, other) || other is File &&
    other.name == name &&
    other.size == size;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (name.hashCode) +
    (size.hashCode);

  @override
  String toString() => 'File[name=$name, size=$size]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'name'] = this.name;
      json[r'size'] = this.size;
    return json;
  }

  /// Returns a new [File] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static File? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "File[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "File[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return File(
        name: mapValueOfType<String>(json, r'name')!,
        size: mapValueOfType<int>(json, r'size')!,
      );
    }
    return null;
  }

  static List<File> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <File>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = File.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, File> mapFromJson(dynamic json) {
    final map = <String, File>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = File.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of File-objects as value to a dart map
  static Map<String, List<File>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<File>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = File.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'name',
    'size',
  };
}

