import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../providers/movie_provider.dart';
import '../providers/theme_provider.dart';
import '../theme/app_theme.dart';
import 'router.dart';

class MovieExplorerApp extends StatefulWidget {
  const MovieExplorerApp({super.key, this.router});

  final GoRouter? router;

  @override
  State<MovieExplorerApp> createState() => _MovieExplorerAppState();
}

class _MovieExplorerAppState extends State<MovieExplorerApp> {
  late final GoRouter _router = widget.router ?? createAppRouter();

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => MovieProvider()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, _) => MaterialApp.router(
          title: 'Movie Explorer',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: themeProvider.themeMode,
          routerConfig: _router,
        ),
      ),
    );
  }
}
