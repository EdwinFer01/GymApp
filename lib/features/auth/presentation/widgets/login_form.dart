import 'package:flutter/material.dart';

class LoginForm extends StatelessWidget {
  const LoginForm({
    super.key,
    required this.formKey,
    required this.emailController,
    required this.passwordController,
    required this.isPasswordVisible,
    required this.onTogglePasswordVisibility,
  });

  final GlobalKey<FormState> formKey;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final bool isPasswordVisible;
  final VoidCallback onTogglePasswordVisibility;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        children: [
          TextFormField(
            controller: emailController,
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(
              labelText: 'Correo electronico',
              hintText: 'tu-email@dominio.com',
              prefixIcon: Icon(Icons.email_outlined),
            ),
            validator: (value) {
              final email = value?.trim() ?? '';
              if (email.isEmpty) {
                return 'Ingresa tu correo electronico';
              }
              final emailRegExp = RegExp(r'^[^@]+@[^@]+\.[^@]+');
              if (!emailRegExp.hasMatch(email)) {
                return 'El correo no es valido';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: passwordController,
            obscureText: !isPasswordVisible,
            decoration: InputDecoration(
              labelText: 'Contrasena',
              prefixIcon: const Icon(Icons.lock_outline),
              suffixIcon: IconButton(
                icon: Icon(
                  isPasswordVisible ? Icons.visibility_off : Icons.visibility,
                ),
                onPressed: onTogglePasswordVisibility,
              ),
            ),
            validator: (value) {
              final password = value ?? '';
              if (password.isEmpty) {
                return 'Ingresa tu contrasena';
              }
              if (password.length < 6) {
                return 'Debe tener al menos 6 caracteres';
              }
              return null;
            },
          ),
        ],
      ),
    );
  }
}
