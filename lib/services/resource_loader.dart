// track_that_money
// lib/services/resource_loader.dart

import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import '../models/educational_resource.dart';

Future<List<EducationalResource>> loadEducationalResources() async {
    final data = await rootBundle.loadString('lib/data/resources_library.json');
    final List<dynamic> jsonResult = json.decode(data);
    return jsonResult.map((e) => EducationalResource.fromJson(e)).toList();
}
