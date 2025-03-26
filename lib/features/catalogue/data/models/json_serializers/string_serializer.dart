import 'package:json_annotation/json_annotation.dart';

/// A custom JSON converter to handle potentially null string values
class SafeStringConverter implements JsonConverter<String?, dynamic> {
  const SafeStringConverter();

  @override
  String? fromJson(dynamic json) {
    if (json == null) return null;

    // Handle various possible types
    if (json is String) return json;
    if (json is num) return json.toString();
    if (json is bool) return json.toString();

    // For any other type, try toString() but return null if it fails
    try {
      return json.toString();
    } catch (_) {
      return null;
    }
  }

  @override
  dynamic toJson(String? object) => object;
}
