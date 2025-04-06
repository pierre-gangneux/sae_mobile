import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:settings_ui/settings_ui.dart';
import '../../Model/Connexion/authentification.dart'; // importe AuthState
import '../../ViewModels/themeViewModel.dart';

class ProfilView extends StatefulWidget {
  const ProfilView({super.key});

  @override
  State<ProfilView> createState() => _ProfilViewState();
}

class _ProfilViewState extends State<ProfilView> {
  @override
  Widget build(BuildContext context) {
    final authState = Provider.of<AuthState>(context, listen: false);
    final themeViewModel = Provider.of<ThemeViewModel>(context, listen: true);

    return Scaffold(
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text("Votre Profil"),
        ),
      ),
      body: SettingsList(
        sections: [
          SettingsSection(
            margin: EdgeInsetsDirectional.all(16),
            tiles: [
              SettingsTile.navigation(
                title: Text('Mes favoris'),
                description: Text('Permet de consulter ces favoris'),
                leading: Icon(Icons.favorite),
                onPressed: (_) {
                  context.go('/profile/favoris');
                },
              ),
            ],
          ),
          SettingsSection(
            margin: EdgeInsetsDirectional.all(16),
            tiles: [
              SettingsTile.navigation(
                title: Text('Mes avis'),
                description: Text('Permet de consulter ces avis'),
                leading: Icon(Icons.comment),
                onPressed: (_) {
                  context.go('/profile/avis');
                },
              ),
            ],
          ),
          SettingsSection(
            margin: EdgeInsetsDirectional.all(16),
            title: Text("Paramètres"),
            tiles: [
              SettingsTile.switchTile(
                key: ValueKey(themeViewModel.isDarkMode), // 👈 force une clé différente selon le mode
                initialValue: themeViewModel.isDarkMode,
                title: const Text('Changer de thème'),
                description: const Text("Basculer entre le mode clair et sombre"),
                leading: const Icon(Icons.contrast),
                onToggle: (_) {
                  themeViewModel.toggleTheme();
                },
              ),
              SettingsTile(
                title: Text('Me déconnecter'),
                description: Text("Déconnexion de votre compte"),
                leading: Icon(Icons.logout),
                onPressed: (_) async {
                  await authState.signOut();
                  if (context.mounted) {
                    context.go('/connexion');
                  }
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
