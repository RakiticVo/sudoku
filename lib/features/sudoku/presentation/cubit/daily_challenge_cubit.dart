import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/database/sudoku_database.dart';
import 'economy_cubit.dart';

class DailyChallengeState {
  final Map<String, Map<String, dynamic>> completedChallenges; // "YYYY-MM-DD" -> challenge metrics
  final bool isLoading;

  const DailyChallengeState({
    required this.completedChallenges,
    this.isLoading = false,
  });

  DailyChallengeState copyWith({
    Map<String, Map<String, dynamic>>? completedChallenges,
    bool? isLoading,
  }) {
    return DailyChallengeState(
      completedChallenges: completedChallenges ?? this.completedChallenges,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

class DailyChallengeCubit extends Cubit<DailyChallengeState> {
  final SudokuDatabase _database;
  final EconomyCubit _economyCubit;

  DailyChallengeCubit(this._database, this._economyCubit)
      : super(const DailyChallengeState(completedChallenges: {})) {
    loadChallenges();
  }

  Future<void> loadChallenges() async {
    emit(state.copyWith(isLoading: true));
    final list = await _database.getDailyChallenges();
    
    final Map<String, Map<String, dynamic>> mapped = {};
    for (final row in list) {
      final date = row['challenge_date'] as String;
      mapped[date] = {
        'difficulty': row['difficulty'] as String,
        'solve_time': row['solve_time_seconds'] as int,
        'reward': row['reward_earned'] as int,
      };
    }

    emit(state.copyWith(
      completedChallenges: mapped,
      isLoading: false,
    ));
  }

  Future<void> completeChallenge({
    required String date,
    required String difficulty,
    required int solveTimeSeconds,
  }) async {
    // Check if already completed to prevent double droplets
    if (state.completedChallenges.containsKey(date)) return;

    // Double rewards for Daily Challenges compared to classic solves!
    int reward = 25;
    switch (difficulty.toLowerCase()) {
      case 'easy':
        reward = 20;
        break;
      case 'medium':
        reward = 50;
        break;
      case 'hard':
        reward = 100;
        break;
      case 'expert':
        reward = 200;
        break;
    }

    await _database.saveDailyChallenge(
      date: date,
      difficulty: difficulty,
      solveTimeSeconds: solveTimeSeconds,
      rewardEarned: reward,
    );

    await _economyCubit.addDroplets(reward);
    await loadChallenges();
  }

  bool isDateCompleted(String date) {
    return state.completedChallenges.containsKey(date);
  }
}
