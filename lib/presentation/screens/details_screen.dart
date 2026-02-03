import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/di/injection_container.dart';
import '../../domain/entities/post_entity.dart';
import '../../domain/usecases/get_post_by_id_usecase.dart';

class DetailsScreen extends StatefulWidget {
  final String bookKey;

  const DetailsScreen({super.key, required this.bookKey});

  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  final GetBookByKeyUseCase _getBookByKeyUseCase = getIt<GetBookByKeyUseCase>();
  BookEntity? _book;
  bool _isLoading = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadBook();
  }

  Future<void> _loadBook() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final decodedKey = Uri.decodeComponent(widget.bookKey);
      final book = await _getBookByKeyUseCase(decodedKey);
      setState(() {
        _book = book;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Детали книги'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/'),
        ),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            Text(
              'Ошибка: $_error',
              style: const TextStyle(color: Colors.red),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loadBook,
              child: const Text('Повторить'),
            ),
          ],
        ),
      );
    }

    if (_book == null) {
      return const Center(child: Text('Книга не найдена'));
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Обложка книги
          if (_book!.coverUrl != null)
            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  _book!.coverUrl!,
                  height: 300,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      height: 300,
                      width: double.infinity,
                      color: Colors.grey[300],
                      child: const Icon(Icons.book, size: 64, color: Colors.grey),
                    );
                  },
                ),
              ),
            )
          else
            Center(
              child: Container(
                height: 300,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.book, size: 64, color: Colors.grey),
              ),
            ),
          const SizedBox(height: 24),
          // Название
          Text(
            _book!.title,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 16),
          // Авторы
          if (_book!.authors.isNotEmpty) ...[
            Row(
              children: [
                const Icon(Icons.person, size: 20, color: Colors.grey),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Автор: ${_book!.authors.join(', ')}',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
          ],
          // Год издания
          if (_book!.firstPublishYear != null) ...[
            Row(
              children: [
                const Icon(Icons.calendar_today, size: 20, color: Colors.grey),
                const SizedBox(width: 8),
                Text(
                  'Год издания: ${_book!.firstPublishYear}',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ],
            ),
            const SizedBox(height: 12),
          ],
          // Жанры
          if (_book!.subjects != null && _book!.subjects!.isNotEmpty) ...[
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _book!.subjects!.map((subject) {
                return Chip(
                  label: Text(subject),
                  backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                );
              }).toList(),
            ),
            const SizedBox(height: 16),
          ],
          // Описание
          if (_book!.description != null) ...[
            const Divider(),
            const SizedBox(height: 16),
            Text(
              'Описание',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              _book!.description!,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ],
          const SizedBox(height: 24),
          // Кнопка назад
          Center(
            child: ElevatedButton.icon(
              onPressed: () => context.go('/'),
              icon: const Icon(Icons.home),
              label: const Text('Назад к списку'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

