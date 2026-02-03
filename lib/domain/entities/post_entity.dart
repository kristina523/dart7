import 'package:equatable/equatable.dart';

class BookEntity extends Equatable {
  final String key;
  final String title;
  final List<String> authors;
  final int? firstPublishYear;
  final String? description;
  final String? coverUrl;
  final List<String>? subjects;

  const BookEntity({
    required this.key,
    required this.title,
    required this.authors,
    this.firstPublishYear,
    this.description,
    this.coverUrl,
    this.subjects,
  });

  @override
  List<Object?> get props => [key, title, authors, firstPublishYear, description, coverUrl, subjects];
}

