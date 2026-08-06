// ignore: dangling_library_doc_comments
/// Track That Money
/// lib/ui/theme/spacing.dart
/// Spacing scale — keeps padding/margin consistent across screens

class AppSpacing {
  AppSpacing._(); // non-instantiable

  static const xs = 4.0; // tight gaps — icon-to-label, chip internals
  static const sm = 8.0; // related elements within a component
  static const md = 16.0; // standard padding, screen edges
  static const lg = 24.0; // between distinct sections
  static const xl = 32.0; // major section breaks, screen top/bottom

  // ----- Radius (currently scattered as raw values: 4, 10, 11, 14, 16, 20, 99) -----
  static const radiusSm = 10.0; // small chips, icon containers
  static const radiusMd = 16.0; // tiles, standard cards
  static const radiusLg = 20.0; // hero/summary cards
  static const radiusPill = 99.0; // fully rounded — chips, progress bars
}
