import 'package:flutter/material.dart';

import '../../../auth/domain/entities/auth_user.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key, required this.initialUser});

  final AuthUser initialUser;

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _emailController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(
      text: widget.initialUser.displayName,
    );
    _emailController = TextEditingController(text: widget.initialUser.email);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  void _handleSave() {
    final formState = _formKey.currentState;
    if (formState == null) return;
    if (!formState.validate()) return;

    final updatedUser = widget.initialUser.copyWith(
      displayName: _nameController.text.trim(),
      email: _emailController.text.trim(),
    );

    Navigator.of(context).pop(updatedUser);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Editar perfil')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Informacion personal',
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 24),
                TextFormField(
                  controller: _nameController,
                  textCapitalization: TextCapitalization.words,
                  decoration: const InputDecoration(
                    labelText: 'Nombre completo',
                    hintText: 'Escribe tu nombre',
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'El nombre es obligatorio';
                    }
                    if (value.trim().length < 3) {
                      return 'El nombre debe tener al menos 3 caracteres';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  autofillHints: const [AutofillHints.email],
                  decoration: const InputDecoration(
                    labelText: 'Correo electronico',
                    hintText: 'nombre@correo.com',
                  ),
                  validator: (value) {
                    final email = value?.trim() ?? '';
                    if (email.isEmpty) {
                      return 'El correo es obligatorio';
                    }
                    final emailRegex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
                    if (!emailRegex.hasMatch(email)) {
                      return 'Ingresa un correo valido';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: _handleSave,
                    icon: const Icon(Icons.save_outlined),
                    label: const Text('Guardar cambios'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
