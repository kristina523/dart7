import '../../domain/entities/post_entity.dart';

class BookModel extends BookEntity {
  const BookModel({
    required super.key,
    required super.title,
    required super.authors,
    super.firstPublishYear,
    super.description,
    super.coverUrl,
    super.subjects,
  });

  factory BookModel.fromSearchJson(Map<String, dynamic> json) {
    final key = json['key'] as String? ?? '';
    final title = json['title'] as String? ?? 'Без названия';
    
    final List<String> authors = [];
    if (json['author_name'] != null) {
      final authorNames = json['author_name'] as List<dynamic>;
      authors.addAll(authorNames.map((a) => a.toString()));
    }
    
    final publishYear = json['first_publish_year'] as int?;
    
    String? description;
    if (json['first_sentence'] != null) {
      final sentences = json['first_sentence'] as List<dynamic>;
      description = sentences.isNotEmpty ? sentences.first.toString() : null;
    }
    
    String? coverUrl;
    if (json['cover_i'] != null) {
      final coverId = json['cover_i'] as int;
      coverUrl = 'https://covers.openlibrary.org/b/id/$coverId-L.jpg';
    }
    
    final List<String> subjects = [];
    if (json['subject'] != null) {
      final subjectList = json['subject'] as List<dynamic>;
      subjects.addAll(subjectList.take(5).map((s) => s.toString()));
    }
    
    return BookModel(
      key: key,
      title: title,
      authors: authors,
      firstPublishYear: publishYear,
      description: description,
      coverUrl: coverUrl,
      subjects: subjects.isNotEmpty ? subjects : null,
    );
  }

  // Парсинг из детальной информации о книге
  factory BookModel.fromWorkJson(String key, Map<String, dynamic> json) {
    final title = json['title'] as String? ?? 'Без названия';
    
    // Извлекаем авторов
    final List<String> authors = [];
    if (json['authors'] != null) {
      final authorsList = json['authors'] as List<dynamic>;
      for (var author in authorsList) {
        if (author is Map && author['author'] != null) {
          final authorData = author['author'] as Map<String, dynamic>;
          if (authorData['key'] != null) {
            authors.add(authorData['key'] as String);
          }
        }
      }
    }
    
    final publishYear = json['first_publish_date'] != null 
        ? int.tryParse((json['first_publish_date'] as String).split('-').first)
        : null;
    
    String? description;
    if (json['description'] != null) {
      if (json['description'] is String) {
        description = json['description'] as String;
      } else if (json['description'] is Map) {
        final descMap = json['description'] as Map<String, dynamic>;
        description = descMap['value'] as String?;
      }
    }
    
    String? coverUrl;
    if (json['covers'] != null && (json['covers'] as List).isNotEmpty) {
      final coverId = (json['covers'] as List).first;
      coverUrl = 'https://covers.openlibrary.org/b/id/$coverId-L.jpg';
    }
    
    final List<String> subjects = [];
    if (json['subjects'] != null) {
      final subjectsList = json['subjects'] as List<dynamic>;
      subjects.addAll(subjectsList.take(5).map((s) => s.toString()));
    }
    
    return BookModel(
      key: key,
      title: title,
      authors: authors,
      firstPublishYear: publishYear,
      description: description,
      coverUrl: coverUrl,
      subjects: subjects.isNotEmpty ? subjects : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'key': key,
      'title': title,
      'authors': authors,
      'first_publish_year': firstPublishYear,
      'description': description,
      'cover_url': coverUrl,
      'subjects': subjects,
    };
  }
}

