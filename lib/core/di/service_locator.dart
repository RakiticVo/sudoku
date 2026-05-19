import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../features/sudoku/data/repositories/sudoku_repository_impl.dart';
import '../../features/sudoku/domain/repositories/sudoku_repository.dart';

final sl = GetIt.instance;

Future<void> initServiceLocator() async {
  // External
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerSingleton<SharedPreferences>(sharedPreferences);

  // Repositories
  sl.registerLazySingleton<SudokuRepository>(
    () => SudokuRepositoryImpl(sl<SharedPreferences>()),
  );
}
