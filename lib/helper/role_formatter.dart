extension RoleFormatter on String {
  String toRoleFormatter() {
    return trim()
        .replaceAll(RegExp(r'[_\-\s]+'), ' ')
        .replaceAll(RegExp(r'[^\w\s]'), '')
        .replaceAll('_', ' ')
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim();
  }
}
