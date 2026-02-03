import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'core/di/injection_container.dart';
import 'presentation/screens/home_screen.dart';
import 'presentation/screens/details_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setupDependencies();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Библиотека книг',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      routerConfig: _router,
    );
  }
}

final GoRouter _router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: '/details/:key',
      builder: (context, state) {
        final key = state.pathParameters['key'] ?? '';
        return DetailsScreen(bookKey: key);
      },
    ),
  ],
);

