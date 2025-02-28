import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/home/main_screen.dart';
import 'config/theme_provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return MaterialApp(
      title: 'Flutter Login',
      themeMode: themeProvider.themeMode,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      darkTheme: ThemeData.dark(),
      home: MainScreen(
        id: '',
        rol: 'Invitado',
        nombre: 'Invitado',
        correo: '',
      ),
    );
  }
}
