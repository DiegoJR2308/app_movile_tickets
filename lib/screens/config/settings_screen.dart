import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../config/theme_provider.dart';
import '../users/user_account_screen.dart'; // Asegúrate de importar la pantalla UserAccountScreen

class SettingsScreen extends StatelessWidget {
  final int userId; // Agregamos el userId para pasarlo a UserAccountScreen

  const SettingsScreen({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      backgroundColor: isDarkMode ? Color(0xff282828) : Colors.white,
      appBar: AppBar(
        backgroundColor: isDarkMode ? Color(0xff282828) : Colors.white,
        title: Text('Configuración'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            SwitchListTile(
              title: Text('Modo Oscuro'),
              value: themeProvider.themeMode == ThemeMode.dark,
              secondary: Icon(
                themeProvider.themeMode == ThemeMode.dark
                    ? Icons.nights_stay
                    : Icons.wb_sunny,
              ),
              activeColor: Color(0xffbb86fc),
              onChanged: (bool value) {
                themeProvider.toggleTheme(value);
              },
            ),
            ListTile(
              title: Text('Cuenta'),
              leading: Icon(Icons.manage_accounts),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => UserAccountScreen(userId: userId)),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}