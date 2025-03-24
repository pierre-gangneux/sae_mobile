import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:go_router/go_router.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  final _formKey = GlobalKey<FormBuilderState>();
  bool _isPasswordHide = true;
  bool _isConfirmHide = true;
  double _passwordStrength = 0;
  String _password = '';

  double getPasswordStrength(String password) {
    if (password.isEmpty) return 0.0;

    int score = 0;
    if (password.length >= 8) score++;
    if (RegExp(r'[A-Z]').hasMatch(password)) score++;
    if (RegExp(r'[a-z]').hasMatch(password)) score++;
    if (RegExp(r'\d').hasMatch(password)) score++;
    if (RegExp(r'[\W]').hasMatch(password)) score++;

    return score / 5.0;
  }

  Color getStrengthColor(double strength) {
    if (strength < 0.3) return Colors.red;
    if (strength < 0.7) return Colors.orange;
    return Colors.green;
  }

  String getStrengthText(double strength) {
    if (strength < 0.3) return "Mot de passe faible";
    if (strength < 0.7) return "Mot de passe moyen";
    return "Mot de passe fort";
  }

  String? passwordValidator(String? password) {
    if (password == null || password.isEmpty) {
      return "Le mot de passe ne doit pas être vide";
    }
    double strength = getPasswordStrength(password);
    if (strength < 0.3) {
      return "Mot de passe trop faible";
    }
    return null;
  }

  String? confirmValidator(String? confirm) {
    String password = _formKey.currentState?.fields['password']?.value;
    if (confirm == null || confirm.isEmpty){
      return "Le champ ne doit pas être vide";
    }
    if (password != confirm){
      return "Le mot de passe n'est pas identique";
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text("S'enregistrer"),
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
                    // Username
                    FormBuilderTextField(
                      name: 'username',
                      decoration: const InputDecoration(labelText: "Nom d'utilisateur"),
                      validator: FormBuilderValidators.required(errorText: "Veuillez renseigner un nom d'utilisateur"),
                    ),
                    const SizedBox(height: 20),
                    // Password
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
                          _password = value ?? '';
                          _passwordStrength = getPasswordStrength(_password);
                        });
                      },
                      validator: passwordValidator,
                    ),
                    const SizedBox(height: 10),

                    if (_password.isNotEmpty) ...[
                      LinearProgressIndicator(
                        value: _passwordStrength,
                        backgroundColor: Colors.grey[300],
                        color: getStrengthColor(_passwordStrength),
                        minHeight: 8,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        getStrengthText(_passwordStrength),
                        style: TextStyle(
                          color: getStrengthColor(_passwordStrength),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ]
                    else ...[
                      const SizedBox(height: 30),
                    ],

                    const SizedBox(height: 0),
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
                      validator: confirmValidator,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        // Traiter le formulaire ICI
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Nouvel utilisateur : ${_formKey.currentState?.fields['username']?.value}'),
                          ),
                        );
                      }
                    },
                    child: const Text('Envoyer'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      context.go('/profile/connection');
                    },
                    child: const Text('Connection'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
