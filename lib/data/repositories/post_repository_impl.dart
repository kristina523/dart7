import '../../domain/entities/post_entity.dart';
import '../../domain/repositories/post_repository.dart';
import '../datasources/post_remote_data_source.dart';

class BookRepositoryImpl implements BookRepository {
  final BookRemoteDataSource remoteDataSource;

  BookRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<BookEntity>> searchBooks({String query = 'russian', int limit = 20}) async {
    return await remoteDataSource.searchBooks(query: query, limit: limit);
  }

  @override
  Future<BookEntity> getBookByKey(String key) async {
    return await remoteDataSource.getBookByKey(key);
  }
}

