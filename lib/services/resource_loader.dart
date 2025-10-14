import 'dart:convert';
import 'dart:math';
import 'package:flutter/services.dart' show rootBundle;
import '../models/educational_resource.dart';

// track_that_money
// lib/services/resource_loader.dart

/// Handles loading and filtering of edu resources
class ResourceLoader {
  static const String _resourcePath = 'lib/data/resources_library.json';
  static final Random _random = Random();

  /// Loads all edu resources from JSON
  static Future<List<EducationalResource>> loadAllResources() async {
    try {
      final jsonString = await rootBundle.loadString(_resourcePath);
      final List<dynamic> data = json.decode(jsonString);
      return data.map((item) => EducationalResource.fromJson(item)).toList();
    } catch (e) {
      print('Error loading educational resources: $e');
      return [];
    }
  }

  /// Returns all resources that match a specific category
  static Future<List<EducationalResource>> loadByCategory(String category) async {
    final all = await loadAllResources();
    return all.where((r) => r.category.toLowerCase() == category.toLowerCase()).toList();
  }

  /// Returns all resources that match a specific tag
  static Future<List<EducationalResource>> loadByTag(String tag) async {
    final all = await loadAllResources();
    return all.where((r) => r.tag.toLowerCase() == tag.toLowerCase()).toList();
  }

  /// Returns all resources whose title or description contains a given keyword
  static Future<List<EducationalResource>> search(String keyword) async {
    final all = await loadAllResources();
    final query = keyword.toLowerCase();
    return all.where((r) =>
        r.title.toLowerCase().contains(query) ||
        r.description.toLowerCase().contains(query) ||
        r.category.toLowerCase().contains(query)).toList();
  }

  /// Returns a random "featured" edu resource for the dashboard
  static Future<EducationalResource?> getFeaturedResource() async {
    final all = await loadAllResources();
    if (all.isEmpty) return null;
    return all[_random.nextInt(all.length)];
  }
}
