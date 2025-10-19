import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../features/auth/data/repositories/auth_repository_impl.dart';
import '../features/auth/presentation/viewmodels/login_view_model.dart';
import '../features/auth/presentation/views/login_view.dart';

class MyGymApp extends StatelessWidget {
  const MyGymApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<LoginViewModel>(
          create: (_) => LoginViewModel(authRepository: AuthRepositoryImpl()),
        ),
      ],
      child: MaterialApp(
        title: 'My Gym App',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueGrey),
          useMaterial3: true,
          inputDecorationTheme: InputDecorationTheme(
            filled: true,
            fillColor: Colors.grey.shade100,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
        home: const LoginView(),
      ),
    );
  }
}
