// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'game_state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_GameState _$GameStateFromJson(Map<String, dynamic> json) => _GameState(
  board: SudokuBoard.fromJson(json['board'] as Map<String, dynamic>),
  difficulty: json['difficulty'] as String,
  mistakesMade: (json['mistakesMade'] as num?)?.toInt() ?? 0,
  maxMistakes: (json['maxMistakes'] as num).toInt(),
  hintsUsed: (json['hintsUsed'] as num?)?.toInt() ?? 0,
  maxHints: (json['maxHints'] as num).toInt(),
  elapsedSeconds: (json['elapsedSeconds'] as num?)?.toInt() ?? 0,
  isCompleted: json['isCompleted'] as bool? ?? false,
  isGameOver: json['isGameOver'] as bool? ?? false,
  selectedRow: (json['selectedRow'] as num?)?.toInt(),
  selectedCol: (json['selectedCol'] as num?)?.toInt(),
  isNotesMode: json['isNotesMode'] as bool? ?? false,
  reviveUsed: json['reviveUsed'] as bool? ?? false,
);

Map<String, dynamic> _$GameStateToJson(_GameState instance) =>
    <String, dynamic>{
      'board': instance.board.toJson(),
      'difficulty': instance.difficulty,
      'mistakesMade': instance.mistakesMade,
      'maxMistakes': instance.maxMistakes,
      'hintsUsed': instance.hintsUsed,
      'maxHints': instance.maxHints,
      'elapsedSeconds': instance.elapsedSeconds,
      'isCompleted': instance.isCompleted,
      'isGameOver': instance.isGameOver,
      'selectedRow': instance.selectedRow,
      'selectedCol': instance.selectedCol,
      'isNotesMode': instance.isNotesMode,
      'reviveUsed': instance.reviveUsed,
    };
