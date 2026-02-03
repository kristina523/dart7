import '../entities/post_entity.dart';
import '../repositories/post_repository.dart';

class SearchBooksUseCase {
  final BookRepository repository;

  SearchBooksUseCase(this.repository);

  Future<List<BookEntity>> call({String query = 'russian', int limit = 20}) async {
    return await repository.searchBooks(query: query, limit: limit);
  }
}

