import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';

import 'package:my_gym_app/core/constants/table_names.dart';
import 'package:my_gym_app/core/database/app_database.dart';
import 'package:my_gym_app/features/user_profile/data/repositories/training_goal_repository_impl.dart';
import 'package:my_gym_app/features/user_profile/domain/entities/training_goal.dart';

class _TestPathProvider extends PathProviderPlatform {
  _TestPathProvider(this._baseDir);

  final Directory _baseDir;

  @override
  Future<String?> getApplicationDocumentsPath() async {
    final dir = Directory('${_baseDir.path}/docs');
    if (!dir.existsSync()) {
      dir.createSync(recursive: true);
    }
    return dir.path;
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('TrainingGoalRepositoryImpl', () {
    late PathProviderPlatform originalPlatform;
    late Directory tempDir;
    late AppDatabase database;
    late TrainingGoalRepositoryImpl repository;

    setUpAll(() async {
      tempDir = Directory.systemTemp.createTempSync('training_goal_test_');
      originalPlatform = PathProviderPlatform.instance;
      PathProviderPlatform.instance = _TestPathProvider(tempDir);
      database = AppDatabase.instance;
      repository = TrainingGoalRepositoryImpl();
      final db = await database.database;
      await db.delete(TableNames.trainingGoals);
      await db.delete(TableNames.users);
      await db.insert(TableNames.users, <String, Object?>{
        'id': 1,
        'email': 'test@example.com',
        'password_hash': 'hash',
        'display_name': 'Test User',
        'role': 'client',
        'created_at': DateTime.now().toIso8601String(),
        'updated_at': DateTime.now().toIso8601String(),
      });
    });

    tearDownAll(() async {
      try {
        await database.close();
      } catch (_) {}
      await tempDir.delete(recursive: true);
      PathProviderPlatform.instance = originalPlatform;
    });

    test('save and fetch goal', () async {
      final goal = TrainingGoal(
        userId: 1,
        exercise: 'Prensa de piernas',
        targetWeight: 120,
      );

      await repository.saveGoal(goal);

      final goals = await repository.getGoalsByUser(1);

      expect(goals, isNotEmpty);
      expect(goals.first.exercise, 'Prensa de piernas');
      expect(goals.first.targetWeight, 120);
    });
  });
}
