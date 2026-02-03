import '../entities/post_entity.dart';

abstract class BookRepository {
  Future<List<BookEntity>> searchBooks({String query = 'russian', int limit = 20});
  Future<BookEntity> getBookByKey(String key);
}

