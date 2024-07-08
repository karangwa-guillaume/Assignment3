import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'home_page.dart';
import 'theme_provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        final isDarkMode = themeProvider.isDarkMode;
        return MaterialApp(
          title: 'Flutter Demo',
          theme: ThemeData(
            brightness: isDarkMode ? Brightness.dark : Brightness.light,
            colorScheme: isDarkMode
                ? const ColorScheme.dark(
                    primary: Colors.deepPurple,
                  )
                : const ColorScheme.light(
                    primary: Colors.deepPurple,
                  ),
            useMaterial3: true,
          ),
          home: const HomePage(),
        );
      },
    );
  }
}