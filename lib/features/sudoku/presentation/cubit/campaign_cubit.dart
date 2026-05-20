import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/database/sudoku_database.dart';
import 'economy_cubit.dart';

class CampaignLevel {
  final int index;
  final int seed;
  final String difficulty;

  const CampaignLevel({
    required this.index,
    required this.seed,
    required this.difficulty,
  });
}

class CampaignVolume {
  final String id;
  final String title;
  final String subtitle;
  final String year;
  final int dropletReward;
  final List<CampaignLevel> levels;
  final String editorialTitle;
  final String editorialContent;

  const CampaignVolume({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.year,
    required this.dropletReward,
    required this.levels,
    required this.editorialTitle,
    required this.editorialContent,
  });
}

class CampaignState {
  final List<CampaignVolume> volumes;
  final Map<String, List<bool>> completionStatus; // volumeId -> completion status of each level
  final bool isLoading;

  const CampaignState({
    required this.volumes,
    required this.completionStatus,
    this.isLoading = false,
  });

  CampaignState copyWith({
    List<CampaignVolume>? volumes,
    Map<String, List<bool>>? completionStatus,
    bool? isLoading,
  }) {
    return CampaignState(
      volumes: volumes ?? this.volumes,
      completionStatus: completionStatus ?? this.completionStatus,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

class CampaignCubit extends Cubit<CampaignState> {
  final SudokuDatabase _database;
  final EconomyCubit _economyCubit;

  static List<CampaignLevel> _generate100Levels(int baseSeed) {
    return List.generate(100, (i) {
      final index = i;
      final seed = baseSeed + i;
      String difficulty;
      if (i < 25) {
        difficulty = 'easy';
      } else if (i < 60) {
        difficulty = 'medium';
      } else if (i < 90) {
        difficulty = 'hard';
      } else {
        difficulty = 'expert';
      }
      return CampaignLevel(index: index, seed: seed, difficulty: difficulty);
    });
  }

  static final List<CampaignVolume> _presetVolumes = [
    CampaignVolume(
      id: 'vol_gutenberg',
      title: 'The Gutenberg Press',
      subtitle: 'The dawn of movable print type',
      year: '1456',
      dropletReward: 500,
      levels: _generate100Levels(1000),
      editorialTitle: 'THE GUTENBERG CHRONICLE',
      editorialContent: 'In the year 1456, Johannes Gutenberg perfected the mechanical movable type printing press in Mainz, Germany. This monument of human ingenuity shattered the bottleneck of hand-copied script, ushering in the Age of Enlightenment. Modern democracy, science, and literature owe their birth to this lead block imprint. Your mastery of this volume honors the typographic legacy that freed the written word!',
    ),
    CampaignVolume(
      id: 'vol_pennypress',
      title: 'The Penny Press Era',
      subtitle: 'Newspapers for the common man',
      year: '1833',
      dropletReward: 750,
      levels: _generate100Levels(2000),
      editorialTitle: 'THE PENNY DAILY TRIBUNE',
      editorialContent: 'By the 1830s, industrial steam printing dropped production costs to a single cent per newspaper. The New York Sun and daily sheets democratized news, transforming journalism from political newsletters for elite merchants into sensational, broad-scope public documents for the common laborer. Complete information became a public utility. Your puzzle speed keeps the street press roaring!',
    ),
    CampaignVolume(
      id: 'vol_moderntimes',
      title: 'The Times Dispatch',
      subtitle: 'High-speed rotary grid systems',
      year: '1920',
      dropletReward: 1000,
      levels: _generate100Levels(3000),
      editorialTitle: 'THE METROPOLIS REGISTER',
      editorialContent: 'At the turn of the 20th century, giant cylinder rotary presses sped through millions of pages every hour. Front-page layout reached artistic heights, bringing global events, comic strips, crosswords, and intellectual puzzles directly into busy urban transit cars and breakfast tables. You have conquered the pinnacle of retro print intelligence!',
    ),
  ];

  CampaignCubit(this._database, this._economyCubit)
      : super(CampaignState(
          volumes: _presetVolumes,
          completionStatus: {
            for (var vol in _presetVolumes)
              vol.id: List.filled(vol.levels.length, false),
          },
        )) {
    loadProgress();
  }

  Future<void> loadProgress() async {
    emit(state.copyWith(isLoading: true));
    final updatedCompletion = Map<String, List<bool>>.from(state.completionStatus);

    for (final volume in state.volumes) {
      final dbProgress = await _database.getVolumeProgress(volume.id);
      final levelCompletions = List.filled(volume.levels.length, false);

      for (final row in dbProgress) {
        final idx = row['level_index'] as int;
        final completed = (row['is_completed'] as int) == 1;
        if (idx >= 0 && idx < levelCompletions.length) {
          levelCompletions[idx] = completed;
        }
      }
      updatedCompletion[volume.id] = levelCompletions;
    }

    emit(state.copyWith(
      completionStatus: updatedCompletion,
      isLoading: false,
    ));
  }

  Future<void> completeLevel(String volumeId, int levelIndex, int timeTakenSeconds) async {
    // 1. Save level progress to DB
    await _database.saveCampaignProgress(
      volumeId: volumeId,
      levelIndex: levelIndex,
      isCompleted: true,
      bestTimeSeconds: timeTakenSeconds,
    );

    // 2. Check if this volume was already fully completed before this save
    final currentStatus = state.completionStatus[volumeId] ?? [];
    final wasVolumeComplete = currentStatus.every((completed) => completed);

    // 3. Update completion state
    final updatedList = List<bool>.from(currentStatus);
    if (levelIndex >= 0 && levelIndex < updatedList.length) {
      updatedList[levelIndex] = true;
    }
    
    final updatedCompletionMap = Map<String, List<bool>>.from(state.completionStatus)
      ..[volumeId] = updatedList;

    emit(state.copyWith(completionStatus: updatedCompletionMap));

    // 4. If volume just transitioned from incomplete to complete, reward droplets!
    final isVolumeCompleteNow = updatedList.every((completed) => completed);
    if (!wasVolumeComplete && isVolumeCompleteNow) {
      final volume = state.volumes.firstWhere((v) => v.id == volumeId);
      await _economyCubit.addDroplets(volume.dropletReward);
    }
  }

  bool isVolumeCompleted(String volumeId) {
    final status = state.completionStatus[volumeId] ?? [];
    return status.isNotEmpty && status.every((completed) => completed);
  }
}
