// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'game_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$GameState {

 SudokuBoard get board; String get difficulty; int get mistakesMade; int get maxMistakes; int get hintsUsed; int get maxHints; int get elapsedSeconds; bool get isCompleted; bool get isGameOver; int? get selectedRow; int? get selectedCol; bool get isNotesMode;
/// Create a copy of GameState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GameStateCopyWith<GameState> get copyWith => _$GameStateCopyWithImpl<GameState>(this as GameState, _$identity);

  /// Serializes this GameState to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GameState&&(identical(other.board, board) || other.board == board)&&(identical(other.difficulty, difficulty) || other.difficulty == difficulty)&&(identical(other.mistakesMade, mistakesMade) || other.mistakesMade == mistakesMade)&&(identical(other.maxMistakes, maxMistakes) || other.maxMistakes == maxMistakes)&&(identical(other.hintsUsed, hintsUsed) || other.hintsUsed == hintsUsed)&&(identical(other.maxHints, maxHints) || other.maxHints == maxHints)&&(identical(other.elapsedSeconds, elapsedSeconds) || other.elapsedSeconds == elapsedSeconds)&&(identical(other.isCompleted, isCompleted) || other.isCompleted == isCompleted)&&(identical(other.isGameOver, isGameOver) || other.isGameOver == isGameOver)&&(identical(other.selectedRow, selectedRow) || other.selectedRow == selectedRow)&&(identical(other.selectedCol, selectedCol) || other.selectedCol == selectedCol)&&(identical(other.isNotesMode, isNotesMode) || other.isNotesMode == isNotesMode));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,board,difficulty,mistakesMade,maxMistakes,hintsUsed,maxHints,elapsedSeconds,isCompleted,isGameOver,selectedRow,selectedCol,isNotesMode);

@override
String toString() {
  return 'GameState(board: $board, difficulty: $difficulty, mistakesMade: $mistakesMade, maxMistakes: $maxMistakes, hintsUsed: $hintsUsed, maxHints: $maxHints, elapsedSeconds: $elapsedSeconds, isCompleted: $isCompleted, isGameOver: $isGameOver, selectedRow: $selectedRow, selectedCol: $selectedCol, isNotesMode: $isNotesMode)';
}


}

/// @nodoc
abstract mixin class $GameStateCopyWith<$Res>  {
  factory $GameStateCopyWith(GameState value, $Res Function(GameState) _then) = _$GameStateCopyWithImpl;
@useResult
$Res call({
 SudokuBoard board, String difficulty, int mistakesMade, int maxMistakes, int hintsUsed, int maxHints, int elapsedSeconds, bool isCompleted, bool isGameOver, int? selectedRow, int? selectedCol, bool isNotesMode
});


$SudokuBoardCopyWith<$Res> get board;

}
/// @nodoc
class _$GameStateCopyWithImpl<$Res>
    implements $GameStateCopyWith<$Res> {
  _$GameStateCopyWithImpl(this._self, this._then);

  final GameState _self;
  final $Res Function(GameState) _then;

/// Create a copy of GameState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? board = null,Object? difficulty = null,Object? mistakesMade = null,Object? maxMistakes = null,Object? hintsUsed = null,Object? maxHints = null,Object? elapsedSeconds = null,Object? isCompleted = null,Object? isGameOver = null,Object? selectedRow = freezed,Object? selectedCol = freezed,Object? isNotesMode = null,}) {
  return _then(_self.copyWith(
board: null == board ? _self.board : board // ignore: cast_nullable_to_non_nullable
as SudokuBoard,difficulty: null == difficulty ? _self.difficulty : difficulty // ignore: cast_nullable_to_non_nullable
as String,mistakesMade: null == mistakesMade ? _self.mistakesMade : mistakesMade // ignore: cast_nullable_to_non_nullable
as int,maxMistakes: null == maxMistakes ? _self.maxMistakes : maxMistakes // ignore: cast_nullable_to_non_nullable
as int,hintsUsed: null == hintsUsed ? _self.hintsUsed : hintsUsed // ignore: cast_nullable_to_non_nullable
as int,maxHints: null == maxHints ? _self.maxHints : maxHints // ignore: cast_nullable_to_non_nullable
as int,elapsedSeconds: null == elapsedSeconds ? _self.elapsedSeconds : elapsedSeconds // ignore: cast_nullable_to_non_nullable
as int,isCompleted: null == isCompleted ? _self.isCompleted : isCompleted // ignore: cast_nullable_to_non_nullable
as bool,isGameOver: null == isGameOver ? _self.isGameOver : isGameOver // ignore: cast_nullable_to_non_nullable
as bool,selectedRow: freezed == selectedRow ? _self.selectedRow : selectedRow // ignore: cast_nullable_to_non_nullable
as int?,selectedCol: freezed == selectedCol ? _self.selectedCol : selectedCol // ignore: cast_nullable_to_non_nullable
as int?,isNotesMode: null == isNotesMode ? _self.isNotesMode : isNotesMode // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}
/// Create a copy of GameState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SudokuBoardCopyWith<$Res> get board {
  
  return $SudokuBoardCopyWith<$Res>(_self.board, (value) {
    return _then(_self.copyWith(board: value));
  });
}
}


/// Adds pattern-matching-related methods to [GameState].
extension GameStatePatterns on GameState {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _GameState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _GameState() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _GameState value)  $default,){
final _that = this;
switch (_that) {
case _GameState():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _GameState value)?  $default,){
final _that = this;
switch (_that) {
case _GameState() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( SudokuBoard board,  String difficulty,  int mistakesMade,  int maxMistakes,  int hintsUsed,  int maxHints,  int elapsedSeconds,  bool isCompleted,  bool isGameOver,  int? selectedRow,  int? selectedCol,  bool isNotesMode)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _GameState() when $default != null:
return $default(_that.board,_that.difficulty,_that.mistakesMade,_that.maxMistakes,_that.hintsUsed,_that.maxHints,_that.elapsedSeconds,_that.isCompleted,_that.isGameOver,_that.selectedRow,_that.selectedCol,_that.isNotesMode);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( SudokuBoard board,  String difficulty,  int mistakesMade,  int maxMistakes,  int hintsUsed,  int maxHints,  int elapsedSeconds,  bool isCompleted,  bool isGameOver,  int? selectedRow,  int? selectedCol,  bool isNotesMode)  $default,) {final _that = this;
switch (_that) {
case _GameState():
return $default(_that.board,_that.difficulty,_that.mistakesMade,_that.maxMistakes,_that.hintsUsed,_that.maxHints,_that.elapsedSeconds,_that.isCompleted,_that.isGameOver,_that.selectedRow,_that.selectedCol,_that.isNotesMode);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( SudokuBoard board,  String difficulty,  int mistakesMade,  int maxMistakes,  int hintsUsed,  int maxHints,  int elapsedSeconds,  bool isCompleted,  bool isGameOver,  int? selectedRow,  int? selectedCol,  bool isNotesMode)?  $default,) {final _that = this;
switch (_that) {
case _GameState() when $default != null:
return $default(_that.board,_that.difficulty,_that.mistakesMade,_that.maxMistakes,_that.hintsUsed,_that.maxHints,_that.elapsedSeconds,_that.isCompleted,_that.isGameOver,_that.selectedRow,_that.selectedCol,_that.isNotesMode);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _GameState implements GameState {
  const _GameState({required this.board, required this.difficulty, this.mistakesMade = 0, required this.maxMistakes, this.hintsUsed = 0, required this.maxHints, this.elapsedSeconds = 0, this.isCompleted = false, this.isGameOver = false, this.selectedRow, this.selectedCol, this.isNotesMode = false});
  factory _GameState.fromJson(Map<String, dynamic> json) => _$GameStateFromJson(json);

@override final  SudokuBoard board;
@override final  String difficulty;
@override@JsonKey() final  int mistakesMade;
@override final  int maxMistakes;
@override@JsonKey() final  int hintsUsed;
@override final  int maxHints;
@override@JsonKey() final  int elapsedSeconds;
@override@JsonKey() final  bool isCompleted;
@override@JsonKey() final  bool isGameOver;
@override final  int? selectedRow;
@override final  int? selectedCol;
@override@JsonKey() final  bool isNotesMode;

/// Create a copy of GameState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$GameStateCopyWith<_GameState> get copyWith => __$GameStateCopyWithImpl<_GameState>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$GameStateToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _GameState&&(identical(other.board, board) || other.board == board)&&(identical(other.difficulty, difficulty) || other.difficulty == difficulty)&&(identical(other.mistakesMade, mistakesMade) || other.mistakesMade == mistakesMade)&&(identical(other.maxMistakes, maxMistakes) || other.maxMistakes == maxMistakes)&&(identical(other.hintsUsed, hintsUsed) || other.hintsUsed == hintsUsed)&&(identical(other.maxHints, maxHints) || other.maxHints == maxHints)&&(identical(other.elapsedSeconds, elapsedSeconds) || other.elapsedSeconds == elapsedSeconds)&&(identical(other.isCompleted, isCompleted) || other.isCompleted == isCompleted)&&(identical(other.isGameOver, isGameOver) || other.isGameOver == isGameOver)&&(identical(other.selectedRow, selectedRow) || other.selectedRow == selectedRow)&&(identical(other.selectedCol, selectedCol) || other.selectedCol == selectedCol)&&(identical(other.isNotesMode, isNotesMode) || other.isNotesMode == isNotesMode));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,board,difficulty,mistakesMade,maxMistakes,hintsUsed,maxHints,elapsedSeconds,isCompleted,isGameOver,selectedRow,selectedCol,isNotesMode);

@override
String toString() {
  return 'GameState(board: $board, difficulty: $difficulty, mistakesMade: $mistakesMade, maxMistakes: $maxMistakes, hintsUsed: $hintsUsed, maxHints: $maxHints, elapsedSeconds: $elapsedSeconds, isCompleted: $isCompleted, isGameOver: $isGameOver, selectedRow: $selectedRow, selectedCol: $selectedCol, isNotesMode: $isNotesMode)';
}


}

/// @nodoc
abstract mixin class _$GameStateCopyWith<$Res> implements $GameStateCopyWith<$Res> {
  factory _$GameStateCopyWith(_GameState value, $Res Function(_GameState) _then) = __$GameStateCopyWithImpl;
@override @useResult
$Res call({
 SudokuBoard board, String difficulty, int mistakesMade, int maxMistakes, int hintsUsed, int maxHints, int elapsedSeconds, bool isCompleted, bool isGameOver, int? selectedRow, int? selectedCol, bool isNotesMode
});


@override $SudokuBoardCopyWith<$Res> get board;

}
/// @nodoc
class __$GameStateCopyWithImpl<$Res>
    implements _$GameStateCopyWith<$Res> {
  __$GameStateCopyWithImpl(this._self, this._then);

  final _GameState _self;
  final $Res Function(_GameState) _then;

/// Create a copy of GameState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? board = null,Object? difficulty = null,Object? mistakesMade = null,Object? maxMistakes = null,Object? hintsUsed = null,Object? maxHints = null,Object? elapsedSeconds = null,Object? isCompleted = null,Object? isGameOver = null,Object? selectedRow = freezed,Object? selectedCol = freezed,Object? isNotesMode = null,}) {
  return _then(_GameState(
board: null == board ? _self.board : board // ignore: cast_nullable_to_non_nullable
as SudokuBoard,difficulty: null == difficulty ? _self.difficulty : difficulty // ignore: cast_nullable_to_non_nullable
as String,mistakesMade: null == mistakesMade ? _self.mistakesMade : mistakesMade // ignore: cast_nullable_to_non_nullable
as int,maxMistakes: null == maxMistakes ? _self.maxMistakes : maxMistakes // ignore: cast_nullable_to_non_nullable
as int,hintsUsed: null == hintsUsed ? _self.hintsUsed : hintsUsed // ignore: cast_nullable_to_non_nullable
as int,maxHints: null == maxHints ? _self.maxHints : maxHints // ignore: cast_nullable_to_non_nullable
as int,elapsedSeconds: null == elapsedSeconds ? _self.elapsedSeconds : elapsedSeconds // ignore: cast_nullable_to_non_nullable
as int,isCompleted: null == isCompleted ? _self.isCompleted : isCompleted // ignore: cast_nullable_to_non_nullable
as bool,isGameOver: null == isGameOver ? _self.isGameOver : isGameOver // ignore: cast_nullable_to_non_nullable
as bool,selectedRow: freezed == selectedRow ? _self.selectedRow : selectedRow // ignore: cast_nullable_to_non_nullable
as int?,selectedCol: freezed == selectedCol ? _self.selectedCol : selectedCol // ignore: cast_nullable_to_non_nullable
as int?,isNotesMode: null == isNotesMode ? _self.isNotesMode : isNotesMode // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

/// Create a copy of GameState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SudokuBoardCopyWith<$Res> get board {
  
  return $SudokuBoardCopyWith<$Res>(_self.board, (value) {
    return _then(_self.copyWith(board: value));
  });
}
}

// dart format on
