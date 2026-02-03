import '../entities/post_entity.dart';
import '../repositories/post_repository.dart';

class GetBookByKeyUseCase {
  final BookRepository repository;

  GetBookByKeyUseCase(this.repository);

  Future<BookEntity> call(String key) async {
    return await repository.getBookByKey(key);
  }
}

