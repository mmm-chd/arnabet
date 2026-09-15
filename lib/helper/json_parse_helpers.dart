bool? jsonBool(Map<String, dynamic> json, String key) {
  final value = json[key];
  return value is bool ? value : null;
}

String? jsonString(Map<String, dynamic> json, String key) {
  final value = json[key];
  return value is String ? value : null;
}

num? jsonNum(Map<String, dynamic> json, String key) {
  final value = json[key];
  return value is num ? value : null;
}

int? jsonInt(Map<String, dynamic> json, String key) {
  final value = json[key];
  if (value is int) return value;
  if (value is num) return value.toInt();
  return null;
}

Map<String, dynamic>? jsonMap(Map<String, dynamic> json, String key) {
  final value = json[key];
  return value is Map<String, dynamic> ? value : null;
}

List<String> jsonStringList(Map<String, dynamic> json, String key) {
  final value = json[key];
  if (value is! List) return const [];
  return value.whereType<String>().toList();
}

List<num> jsonNumList(Map<String, dynamic> json, String key) {
  final value = json[key];
  if (value is! List) return const [];
  return value.whereType<num>().toList();
}

List<int> jsonIntList(Map<String, dynamic> json, String key) {
  final value = json[key];
  if (value is! List) return const [];
  return value.whereType<int>().toList();
}

List<Map<String, dynamic>> jsonMapList(Map<String, dynamic> json, String key) {
  final value = json[key];
  if (value is! List) return const [];
  return value.whereType<Map<String, dynamic>>().toList();
}
