import '../models/post_model.dart';
import '../../core/network/dio_client.dart';
import '../../core/constants/api_constants.dart';

abstract class BookRemoteDataSource {
  Future<List<BookModel>> searchBooks({String query = 'russian', int limit = 20});
  Future<BookModel> getBookByKey(String key);
}

class BookRemoteDataSourceImpl implements BookRemoteDataSource {
  final DioClient dioClient;

  BookRemoteDataSourceImpl(this.dioClient);

  @override
  Future<List<BookModel>> searchBooks({String query = 'russian', int limit = 20}) async {
    try {
      final response = await dioClient.dio.get(
        ApiConstants.searchEndpoint,
        queryParameters: {
          'q': query,
          'limit': limit,
        },
      );
      
      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>;
        final List<dynamic> docs = data['docs'] as List<dynamic>? ?? [];
        return docs.map((json) => BookModel.fromSearchJson(json as Map<String, dynamic>)).toList();
      } else {
        throw Exception('Failed to load books');
      }
    } catch (e) {
      throw Exception('Error getting books: $e');
    }
  }

  @override
  Future<BookModel> getBookByKey(String key) async {
    try {
      String workKey = key;
      if (workKey.startsWith('/works/')) {
        workKey = workKey.replaceFirst('/works/', '');
      }
      if (workKey.startsWith('works/')) {
        workKey = workKey.replaceFirst('works/', '');
      }
      
      final endpoint = ApiConstants.workEndpoint.replaceAll('{key}', workKey);
      final response = await dioClient.dio.get(endpoint);
      
      if (response.statusCode == 200) {
        return BookModel.fromWorkJson(key, response.data as Map<String, dynamic>);
      } else {
        throw Exception('Failed to load book');
      }
    } catch (e) {
      throw Exception('Error getting book: $e');
    }
  }
}

