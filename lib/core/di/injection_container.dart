import 'package:get_it/get_it.dart';
import '../network/dio_client.dart';
import '../../data/datasources/post_remote_data_source.dart';
import '../../data/repositories/post_repository_impl.dart';
import '../../domain/repositories/post_repository.dart';
import '../../domain/usecases/get_posts_usecase.dart';
import '../../domain/usecases/get_post_by_id_usecase.dart';

final getIt = GetIt.instance;

Future<void> setupDependencies() async {

  getIt.registerLazySingleton<DioClient>(() => DioClient());

  getIt.registerLazySingleton<BookRemoteDataSource>(
    () => BookRemoteDataSourceImpl(getIt<DioClient>()),
  );

  getIt.registerLazySingleton<BookRepository>(
    () => BookRepositoryImpl(getIt<BookRemoteDataSource>()),
  );

  getIt.registerLazySingleton<SearchBooksUseCase>(
    () => SearchBooksUseCase(getIt<BookRepository>()),
  );

  getIt.registerLazySingleton<GetBookByKeyUseCase>(
    () => GetBookByKeyUseCase(getIt<BookRepository>()),
  );
}

