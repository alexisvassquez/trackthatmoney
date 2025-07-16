// track_that_money
// lib/models/educational_resource.dart

class EducationalResource {
    final String title;
    final String category;
    final String description;
    final String url;
    final String tag;

    EducationalResource({
        required this.title,
        required this.category,
        required this.description,
        required this.url,
        required this.tag,
    });

    factory EducationalResource.fromJson(Map<String, dynamic> json) {
        return EducationalResource(
            title: json['title'],
            category: json['category'],
            description: json['description'],
            url: json['url'],
            tag: json['tag'],
        );
    }
}
