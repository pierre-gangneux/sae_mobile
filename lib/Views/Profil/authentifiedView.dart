import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:settings_ui/settings_ui.dart';

class AuthentifiedView extends StatefulWidget {
  const AuthentifiedView({super.key});

  @override
  State<AuthentifiedView> createState() => _AuthentifiedViewState();
}

class _AuthentifiedViewState extends State<AuthentifiedView> {
  @override
  Widget build(BuildContext context) {
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
              tiles: [
                SettingsTile(
                  title: Text('Mes favoris'),
                  trailing: Icon(Icons.favorite),
                  onPressed: (_) {
                    context.go('/profile/favoris');
                  },
                ),
                SettingsTile(
                  title: Text('Mes commentaires'),
                  trailing: Icon(Icons.comment),
                  onPressed: (_) {
                    context.go('/profile/comments');
                  },
                ),
              ],
            )
          ],
        )
    );
  }
}
