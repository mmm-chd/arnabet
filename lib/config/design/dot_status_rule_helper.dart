import 'package:arena/config/design/status_color_config.dart';
import 'package:arena/models/metadata/status_style.dart';
import 'package:arena/models/stock/dot_status_rule_model.dart';

class DotStatusRuleHelper {
  static Map<String, StatusStyle> buildStyleMap(List<Datum>? rules) {
    final map = <String, StatusStyle>{};
    if (rules != null) {
      for (final rule in rules) {
        final key = rule.name?.trim().toLowerCase() ?? '';
        if (key.isNotEmpty) {
          map[key] = StockConfig.getStyleByName(rule.name);
        }
      }
    }
    return map;
  }

  static StatusStyle getStyleByName(
    String? name, {
    List<Datum>? rules,
  }) {
    if (name == null || name.trim().isEmpty) {
      return StockConfig.getStyleByName(null);
    }
    final map = buildStyleMap(rules);
    return map[name.trim().toLowerCase()] ??
        StockConfig.getStyleByName(name);
  }
}
