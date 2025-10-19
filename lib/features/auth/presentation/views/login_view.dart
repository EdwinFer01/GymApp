import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../viewmodels/login_view_model.dart';
import '../widgets/login_button.dart';
import '../widgets/login_form.dart';
import '../widgets/login_header.dart';
import '../widgets/sign_up_link.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isPasswordVisible = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin(LoginViewModel viewModel) async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    final success = await viewModel.login(
      _emailController.text.trim(),
      _passwordController.text.trim(),
    );

    if (!mounted) return;

    final message = success
        ? 'Sesion iniciada correctamente'
        : viewModel.errorMessage ?? 'No se pudo iniciar sesion';

    final color = success ? Colors.green : Colors.red;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message), backgroundColor: color));
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<LoginViewModel>();

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 40),
              const LoginHeader(),
              const SizedBox(height: 40),
              LoginForm(
                formKey: _formKey,
                emailController: _emailController,
                passwordController: _passwordController,
                isPasswordVisible: _isPasswordVisible,
                onTogglePasswordVisibility: () {
                  setState(() => _isPasswordVisible = !_isPasswordVisible);
                },
              ),
              const SizedBox(height: 20),
              LoginButton(
                isLoading: viewModel.isBusy,
                onPressed: viewModel.isBusy
                    ? null
                    : () => _handleLogin(viewModel),
              ),
              const SizedBox(height: 16),
              const SignUpLink(),
            ],
          ),
        ),
      ),
    );
  }
}
