import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../domain/entities/auth_user.dart';
import '../viewmodels/registration_view_model.dart';

class RegistrationView extends StatefulWidget {
  const RegistrationView({super.key});

  @override
  State<RegistrationView> createState() => _RegistrationViewState();
}

class _RegistrationViewState extends State<RegistrationView> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  AuthRole _selectedRole = AuthRole.client;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _handleSubmit(RegistrationViewModel viewModel) async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    final success = await viewModel.register(
      name: _nameController.text.trim(),
      email: _emailController.text.trim(),
      password: _passwordController.text,
      role: _selectedRole,
    );

    if (!mounted) return;

    final message = success
        ? 'Cuenta creada correctamente'
        : viewModel.errorMessage ?? 'No se pudo crear la cuenta';

    final color = success ? Colors.green : Colors.red;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message), backgroundColor: color));

    if (success) {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<RegistrationViewModel>();

    return Scaffold(
      appBar: AppBar(title: const Text('Registro')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Crea una nueva cuenta',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 24),
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'Nombre completo',
                    prefixIcon: Icon(Icons.person_outline),
                  ),
                  validator: (value) {
                    final text = value?.trim() ?? '';
                    if (text.isEmpty) {
                      return 'Ingresa tu nombre';
                    }
                    if (text.length < 3) {
                      return 'Debe tener al menos 3 caracteres';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    labelText: 'Correo electronico',
                    hintText: 'tu-email@dominio.com',
                    prefixIcon: Icon(Icons.email_outlined),
                  ),
                  validator: (value) {
                    final email = value?.trim() ?? '';
                    if (email.isEmpty) {
                      return 'Ingresa tu correo';
                    }
                    final emailRegExp = RegExp(r'^[^@]+@[^@]+\.[^@]+$');
                    if (!emailRegExp.hasMatch(email)) {
                      return 'Correo invalido';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                Text(
                  'Selecciona el tipo de usuario',
                  style: Theme.of(
                    context,
                  ).textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 8),
                SegmentedButton<AuthRole>(
                  segments: const [
                    ButtonSegment<AuthRole>(
                      value: AuthRole.client,
                      icon: Icon(Icons.fitness_center_outlined),
                      label: Text('Cliente'),
                    ),
                    ButtonSegment<AuthRole>(
                      value: AuthRole.coach,
                      icon: Icon(Icons.support_agent_outlined),
                      label: Text('Entrenador'),
                    ),
                    ButtonSegment<AuthRole>(
                      value: AuthRole.admin,
                      icon: Icon(Icons.admin_panel_settings_outlined),
                      label: Text('Admin'),
                    ),
                  ],
                  selected: <AuthRole>{_selectedRole},
                  onSelectionChanged: (selection) {
                    setState(() {
                      _selectedRole = selection.first;
                    });
                  },
                  style: const ButtonStyle(
                    visualDensity: VisualDensity.compact,
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _passwordController,
                  obscureText: !_isPasswordVisible,
                  decoration: InputDecoration(
                    labelText: 'Contrasena',
                    prefixIcon: const Icon(Icons.lock_outline),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isPasswordVisible
                            ? Icons.visibility_off
                            : Icons.visibility,
                      ),
                      onPressed: () => setState(
                        () => _isPasswordVisible = !_isPasswordVisible,
                      ),
                    ),
                  ),
                  validator: (value) {
                    final password = value ?? '';
                    if (password.isEmpty) {
                      return 'Ingresa una contrasena';
                    }
                    if (password.length < 6) {
                      return 'Debe tener al menos 6 caracteres';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _confirmPasswordController,
                  obscureText: !_isConfirmPasswordVisible,
                  decoration: InputDecoration(
                    labelText: 'Confirmar contrasena',
                    prefixIcon: const Icon(Icons.lock_reset_outlined),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isConfirmPasswordVisible
                            ? Icons.visibility_off
                            : Icons.visibility,
                      ),
                      onPressed: () => setState(
                        () => _isConfirmPasswordVisible =
                            !_isConfirmPasswordVisible,
                      ),
                    ),
                  ),
                  validator: (value) {
                    final confirmation = value ?? '';
                    if (confirmation.isEmpty) {
                      return 'Confirma tu contrasena';
                    }
                    if (confirmation != _passwordController.text) {
                      return 'Las contrasenas no coinciden';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),
                FilledButton(
                  onPressed: viewModel.isBusy
                      ? null
                      : () => _handleSubmit(viewModel),
                  child: viewModel.isBusy
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('Registrarme'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
