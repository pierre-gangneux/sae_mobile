import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:go_router/go_router.dart';
import 'package:sqflite/sqflite.dart';
import 'package:shared_preferences/shared_preferences.dart';  // Importer shared_preferences
import '../Model/Connexion/inscrireModel.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  final _formKey = GlobalKey<FormBuilderState>();
  final RegisterModel _registerModel = RegisterModel(username: '', password: '', confirmPassword: '');
  bool _isPasswordHide = true;
  bool _isConfirmHide = true;
  double _passwordStrength = 0;

  Future<String> getDatabasePath() async {
    return "${await getDatabasesPath()}/database.db";
  }

  // Méthode pour enregistrer l'état de la session
  Future<void> _saveUserSession() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', true);  // Marque l'utilisateur comme connecté
  }

  Future<void> _registerAndNavigate() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      _registerModel.username = _formKey.currentState?.fields['username']?.value ?? '';
      _registerModel.password = _formKey.currentState?.fields['password']?.value ?? '';
      _registerModel.confirmPassword = _formKey.currentState?.fields['ConfirmPassword']?.value ?? '';

      final String dbPath = await getDatabasePath();

      bool success = await _registerModel.registerUser(dbPath);
      if (success) {
        if (mounted) {
          // Sauvegarder l'état de la session après l'inscription réussie
          await _saveUserSession();

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Inscription réussie')),
          );
          debugPrint("Inscription réussie, redirection vers /connexion");
          context.go('/connexion');  // Redirection vers la page de connexion
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Erreur lors de l\'inscription')),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("S'enregistrer"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FormBuilder(
                  key: _formKey,
                  child: Column(
                    children: [
                      FormBuilderTextField(
                        name: 'username',
                        decoration: const InputDecoration(labelText: "Nom d'utilisateur"),
                        validator: FormBuilderValidators.required(errorText: "Veuillez renseigner un nom d'utilisateur"),
                      ),
                      const SizedBox(height: 20),
                      FormBuilderTextField(
                        name: 'password',
                        obscureText: _isPasswordHide,
                        decoration: InputDecoration(
                          labelText: 'Mot de passe',
                          suffixIcon: IconButton(
                            icon: Icon(_isPasswordHide ? Icons.visibility_off : Icons.visibility),
                            onPressed: () {
                              setState(() {
                                _isPasswordHide = !_isPasswordHide;
                              });
                            },
                          ),
                        ),
                        onChanged: (value) {
                          setState(() {
                            _passwordStrength = _registerModel.getPasswordStrength(value ?? '');
                          });
                        },
                        validator: (password) {
                          if (password == null || password.isEmpty) {
                            return "Le mot de passe ne doit pas être vide";
                          }
                          if (_registerModel.getPasswordStrength(password) < 0.3) {
                            return "Mot de passe trop faible";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 10),
                      if (_passwordStrength > 0) ...[
                        LinearProgressIndicator(
                          value: _passwordStrength,
                          backgroundColor: Colors.grey[300],
                          color: _passwordStrength < 0.3
                              ? Colors.red
                              : (_passwordStrength < 0.7 ? Colors.orange : Colors.green),
                          minHeight: 8,
                        ),
                        const SizedBox(height: 2),
                        Text(
                          _passwordStrength < 0.3
                              ? "Mot de passe faible"
                              : (_passwordStrength < 0.7 ? "Mot de passe moyen" : "Mot de passe fort"),
                          style: TextStyle(
                            color: _passwordStrength < 0.3
                                ? Colors.red
                                : (_passwordStrength < 0.7 ? Colors.orange : Colors.green),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ] else ...[
                        const SizedBox(height: 30),
                      ],
                      FormBuilderTextField(
                        name: 'ConfirmPassword',
                        obscureText: _isConfirmHide,
                        decoration: InputDecoration(
                          labelText: 'Confirmation du mot de passe',
                          suffixIcon: IconButton(
                            icon: Icon(_isConfirmHide ? Icons.visibility_off : Icons.visibility),
                            onPressed: () {
                              setState(() {
                                _isConfirmHide = !_isConfirmHide;
                              });
                            },
                          ),
                        ),
                        validator: (confirm) {
                          String password = _formKey.currentState?.fields['password']?.value ?? '';
                          if (confirm == null || confirm.isEmpty) {
                            return "Le champ ne doit pas être vide";
                          }
                          if (password != confirm) {
                            return "Le mot de passe n'est pas identique";
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _registerAndNavigate,  // Appel de la méthode ici
                  child: const Text('S\'enregistrer'),
                ),
                const SizedBox(height: 10),
                TextButton(
                  onPressed: () => context.go('/connexion'),
                  child: const Text("Déjà un compte ? Se connecter"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
