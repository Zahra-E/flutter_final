// lib/screens/settings_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../providers/theme_provider.dart';
import '../providers/favorites_provider.dart';
import '../widgets/primary_button.dart';
import 'login_screen.dart'; // <-- IMPORT for navigation

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();
    final isDark = themeProvider.isDarkMode;

    return Scaffold(
      appBar: AppBar(
        title: Text('settings'.tr()),
        backgroundColor: Colors.red.shade700,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // ---- Dark Mode Toggle ----
            Card(
              child: ListTile(
                leading: Icon(isDark ? Icons.dark_mode : Icons.light_mode),
                title: Text('dark_mode'.tr()),
                trailing: Switch(
                  value: isDark,
                  onChanged: (value) {
                    themeProvider.toggleTheme(value);
                  },
                ),
              ),
            ),
            const SizedBox(height: 16),

            // ---- Language Switch ----
            Card(
              child: ListTile(
                leading: const Icon(Icons.language),
                title: Text('language'.tr()),
                subtitle: Text(
                  context.locale.languageCode == 'en' ? 'English' : 'العربية',
                ),
                trailing: DropdownButton<String>(
                  value: context.locale.languageCode,
                  items: const [
                    DropdownMenuItem(value: 'en', child: Text('English')),
                    DropdownMenuItem(value: 'ar', child: Text('العربية')),
                  ],
                  onChanged: (value) {
                    if (value != null) {
                      context.setLocale(Locale(value));
                    }
                  },
                ),
              ),
            ),
            const SizedBox(height: 16),

            // ---- Favorites count ----
            Card(
              child: ListTile(
                leading: const Icon(Icons.favorite, color: Colors.red),
                title: Text('favorites'.tr()),
                subtitle: Text(
                  '${context.watch<FavoritesProvider>().favorites.length} Pokémon',
                ),
              ),
            ),

            const Spacer(),

            // ⬇️ HERE IS THE LOGOUT BUTTON ⬇️
            PrimaryButton(
              text: 'logout'.tr(),
              onPressed: () async {
                // Sign out from Firebase
                await FirebaseAuth.instance.signOut();

                if (context.mounted) {
                  // Show a snackbar message
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('logged_out'.tr()),
                      backgroundColor: Colors.green,
                      duration: const Duration(seconds: 2),
                    ),
                  );

                  // ⬇️ THIS CLEARS ALL NAVIGATION HISTORY ⬇️
                  // It removes HomeScreen, FavoritesScreen, etc. from the stack
                  // and navigates directly to LoginScreen
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (_) => const LoginScreen()),
                    (route) => false, // Remove all previous routes
                  );
                }
              },
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
