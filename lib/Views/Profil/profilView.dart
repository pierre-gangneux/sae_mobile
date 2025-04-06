import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:settings_ui/settings_ui.dart';
import '../../Model/Connexion/authentification.dart'; // importe AuthState

class ProfilView extends StatefulWidget {
  const ProfilView({super.key});

  @override
  State<ProfilView> createState() => _ProfilViewState();
}

class _ProfilViewState extends State<ProfilView> {
  @override
  Widget build(BuildContext context) {
    final authState = Provider.of<AuthState>(context, listen: false);

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
                initialValue: true,
                title: Text('Changer de thème'),
                description: Text("WIP"),
                leading: Icon(Icons.contrast),
                onToggle: (_) {
                  // Changer de thème
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
