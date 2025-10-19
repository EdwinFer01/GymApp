import '../../core/database/app_database.dart';

Future<void> configureDependencies() async {
  // Ensures that the SQLite database is created and ready before the app runs.
  await AppDatabase.instance.database;
}
