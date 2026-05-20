import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/di/service_locator.dart';
import 'core/style/design_system.dart';
import 'features/sudoku/presentation/cubit/settings_cubit.dart';
import 'features/sudoku/presentation/pages/home_page.dart';

import 'features/sudoku/presentation/cubit/economy_cubit.dart';
import 'features/sudoku/presentation/cubit/campaign_cubit.dart';
import 'features/sudoku/presentation/cubit/daily_challenge_cubit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initServiceLocator();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<SettingsCubit>(
          create: (_) => sl<SettingsCubit>(),
        ),
        BlocProvider<EconomyCubit>(
          create: (_) => sl<EconomyCubit>(),
        ),
        BlocProvider<CampaignCubit>(
          create: (_) => sl<CampaignCubit>(),
        ),
        BlocProvider<DailyChallengeCubit>(
          create: (_) => sl<DailyChallengeCubit>(),
        ),
      ],
      child: BlocBuilder<SettingsCubit, SettingsState>(
        builder: (context, state) {
          return MaterialApp(
            title: 'The Classic Sudoku',
            theme: AppTheme.generate(
              isDark: state.isDarkNewsprint,
              fontFamily: state.activeFontFamily,
              inkColorName: state.activeInkColorName,
            ),
            home: const HomePage(),
            debugShowCheckedModeBanner: false,
          );
        },
      ),
    );
  }
}

