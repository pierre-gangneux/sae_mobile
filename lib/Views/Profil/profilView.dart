import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:settings_ui/settings_ui.dart';
import '../../ViewModels/themeViewModel.dart';
import '../../Model/Connexion/authentification.dart';

class ProfilView extends StatefulWidget {
  const ProfilView({super.key});

  @override
  State<ProfilView> createState() => _ProfilViewState();
}

class _ProfilViewState extends State<ProfilView> {
  @override
  Widget build(BuildContext context) {
    final themeViewModel = Provider.of<ThemeViewModel>(context, listen: true); 

    return Scaffold(
      appBar: AppBar(
        title: const Padding(
          padding: EdgeInsets.all(8.0),
          child: Text("Votre Profil"),
        ),
      ),
      body: SettingsList(
        sections: [
          SettingsSection(
            margin: const EdgeInsetsDirectional.all(16),
            tiles: [
              SettingsTile.navigation(
                title: const Text('Mes favoris'),
                description: const Text('Permet de consulter ces favoris'),
                leading: const Icon(Icons.favorite),
                onPressed: (_) {
                  context.go('/profile/favoris');
                },
              ),
            ],
          ),
          SettingsSection(
            margin: const EdgeInsetsDirectional.all(16),
            tiles: [
              SettingsTile.navigation(
                title: const Text('Mes avis'),
                description: const Text('Permet de consulter ces avis'),
                leading: const Icon(Icons.comment),
                onPressed: (_) {
                  context.go('/profile/avis');
                },
              ),
            ],
          ),
          SettingsSection(
            margin: const EdgeInsetsDirectional.all(16),
            title: const Text("Paramètres"),
            tiles: [
              SettingsTile.switchTile(
                initialValue: themeViewModel.isDarkMode, // Use the current theme state
                title: const Text('Changer de thème'),
                description: const Text("Basculer entre le mode clair et sombre"),
                leading: const Icon(Icons.contrast),
                onToggle: (_) {
                  themeViewModel.toggleTheme(); // Toggle the theme
                },
              ),
              SettingsTile(
                title: const Text('Me déconnecter'),
                description: const Text("logout"),
                leading: const Icon(Icons.logout),
                onPressed: (_) {
                  debugPrint("logout");
                  AuthState().signOut().then((_) {
                    context.go('/register');
                  });
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
