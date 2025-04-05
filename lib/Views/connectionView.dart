import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:sqflite/sqflite.dart';
import '../Model/Connexion/connexionModel.dart';
import '../ViewModels/connexionViewModel.dart';

class ConnectionView extends StatefulWidget {
  const ConnectionView({super.key});

  @override
  State<ConnectionView> createState() => _ConnectionViewState();
}

class _ConnectionViewState extends State<ConnectionView> {
  final _formKey = GlobalKey<FormBuilderState>();
  bool _isPasswordHide = true;
  bool _isLoading = false; // Pour indiquer si la requête est en cours

  Future<String> getDatabasePath() async {
    return "${await getDatabasesPath()}/database.db";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Padding(
          padding: EdgeInsets.all(8.0),
          child: Text("Se connecter"),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FormBuilder(
                key: _formKey,
                child: Column(
                  children: [
                    // Champ pour le nom d'utilisateur
                    FormBuilderTextField(
                      name: 'username',
                      decoration: const InputDecoration(
                        labelText: "Nom d'utilisateur",
                        border: OutlineInputBorder(),
                      ),
                      validator: FormBuilderValidators.required(errorText: "Veuillez renseigner votre nom d'utilisateur"),
                    ),
                    const SizedBox(height: 20),

                    // Champ pour le mot de passe
                    FormBuilderTextField(
                      name: 'password',
                      obscureText: _isPasswordHide,
                      decoration: InputDecoration(
                        labelText: 'Mot de passe',
                        border: const OutlineInputBorder(),
                        suffixIcon: IconButton(
                          icon: Icon(_isPasswordHide ? Icons.visibility : Icons.visibility_off),
                          onPressed: () {
                            setState(() {
                              _isPasswordHide = !_isPasswordHide;
                            });
                          },
                        ),
                      ),
                      validator: FormBuilderValidators.required(errorText: "Le champ est obligatoire"),
                    ),
                    const SizedBox(height: 20),

                    // Bouton de connexion
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: () async {
                            final String dbPath = await getDatabasePath(); // Obtenir le chemin de la base de données
                            if (_formKey.currentState!.validate()) {
                              setState(() {
                                _isLoading = true;
                              });
                              String username = _formKey.currentState?.fields['username']?.value;
                              String password = _formKey.currentState?.fields['password']?.value;

                              // Mise à jour des valeurs dans le ViewModel
                              context.read<ConnexionViewModel>().setUsername(username);
                              context.read<ConnexionViewModel>().setPassword(password);

                              // Modèle de connexion
                              LoginModel loginModel = LoginModel(username: username, password: password);

                              // Appeler la méthode loginUser pour vérifier l'utilisateur
                              bool isConnected = await context.read<ConnexionViewModel>().loginUser(context, dbPath);

                              setState(() {
                                _isLoading = false;
                              });

                              if (isConnected) {
                                // L'utilisateur est connecté avec succès
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Connexion réussie pour $username')),
                                );
                                // Rediriger vers la page principale ou autre page après connexion
                                context.go('/home');
                              } else {
                                // Erreur de connexion
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Nom d\'utilisateur ou mot de passe incorrect')),
                                );
                              }
                            }
                          },
                          child: _isLoading
                              ? const CircularProgressIndicator(color: Colors.white)
                              : const Text('Se connecter'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // Lien vers la page d'inscription
                    TextButton(
                      onPressed: () {
                        // Redirection vers la page d'inscription
                        context.go('/register');
                      },
                      child: const Text('Pas de compte ? Inscrivez-vous'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
