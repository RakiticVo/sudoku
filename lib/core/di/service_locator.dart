import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../database/sudoku_database.dart';
import '../../features/sudoku/data/repositories/sudoku_repository_impl.dart';
import '../../features/sudoku/domain/repositories/sudoku_repository.dart';
import '../../features/sudoku/presentation/cubit/settings_cubit.dart';

import '../../features/sudoku/presentation/cubit/economy_cubit.dart';
import '../../features/sudoku/presentation/cubit/campaign_cubit.dart';
import '../../features/sudoku/presentation/cubit/daily_challenge_cubit.dart';

final sl = GetIt.instance;

Future<void> initServiceLocator() async {
  // External
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerSingleton<SharedPreferences>(sharedPreferences);

  // Database
  sl.registerSingleton<SudokuDatabase>(SudokuDatabase.instance);

  // Cubits
  sl.registerSingleton<SettingsCubit>(SettingsCubit(sl<SharedPreferences>()));
  sl.registerSingleton<EconomyCubit>(EconomyCubit(sl<SharedPreferences>()));
  sl.registerSingleton<CampaignCubit>(CampaignCubit(sl<SudokuDatabase>(), sl<EconomyCubit>()));
  sl.registerSingleton<DailyChallengeCubit>(DailyChallengeCubit(sl<SudokuDatabase>(), sl<EconomyCubit>()));

  // Repositories
  sl.registerLazySingleton<SudokuRepository>(
    () => SudokuRepositoryImpl(sl<SharedPreferences>()),
  );
}
