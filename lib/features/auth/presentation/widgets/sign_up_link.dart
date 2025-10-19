import 'package:flutter/material.dart';

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
            // TODO(edwin): Navegar a la pantalla de registro cuando este lista.
          },
          child: const Text('Registrate'),
        ),
      ],
    );
  }
}
