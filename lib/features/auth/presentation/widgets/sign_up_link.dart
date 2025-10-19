import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../data/repositories/auth_repository_impl.dart';
import '../viewmodels/registration_view_model.dart';
import '../views/registration_view.dart';

class SignUpLink extends StatelessWidget {
  const SignUpLink({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Aun no tienes cuenta?',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => ChangeNotifierProvider(
                  create: (_) => RegistrationViewModel(
                    authRepository: AuthRepositoryImpl(),
                  ),
                  child: const RegistrationView(),
                ),
              ),
            );
          },
          child: const Text('Registrate'),
        ),
      ],
    );
  }
}
