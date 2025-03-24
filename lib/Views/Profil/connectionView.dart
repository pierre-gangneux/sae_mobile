import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:go_router/go_router.dart';

class ConnectionView extends StatefulWidget {
  const ConnectionView({super.key});

  @override
  State<ConnectionView> createState() => _ConnectionViewState();
}

class _ConnectionViewState extends State<ConnectionView> {
  final _formKey = GlobalKey<FormBuilderState>();
  bool _isPasswordHide = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.all(8.0),
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
                    FormBuilderTextField(
                      name: 'username',
                      decoration: const InputDecoration(labelText: "Nom d'utilisateur"),
                      validator: FormBuilderValidators.required(errorText: "Veuillez renseigner votre nom d'utilisateur"),
                    ),
                    const SizedBox(height: 20),
                    FormBuilderTextField(
                      name: 'password',
                      obscureText: _isPasswordHide,
                      decoration: InputDecoration(
                        labelText: 'Mot de passe',
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
                    const SizedBox(height: 10),
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
                            content: Text('Connection utilisateur : ${_formKey.currentState?.fields['username']?.value}'),
                          ),
                        );
                      }
                    },
                    child: const Text('Envoyer'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      context.go('/profile/register');
                    },
                    child: const Text("S'enregistrer"),
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
