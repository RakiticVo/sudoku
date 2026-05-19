// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'sudoku_board.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SudokuBoard {

 List<List<SudokuCell>> get cells;
/// Create a copy of SudokuBoard
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SudokuBoardCopyWith<SudokuBoard> get copyWith => _$SudokuBoardCopyWithImpl<SudokuBoard>(this as SudokuBoard, _$identity);

  /// Serializes this SudokuBoard to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SudokuBoard&&const DeepCollectionEquality().equals(other.cells, cells));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(cells));

@override
String toString() {
  return 'SudokuBoard(cells: $cells)';
}


}

/// @nodoc
abstract mixin class $SudokuBoardCopyWith<$Res>  {
  factory $SudokuBoardCopyWith(SudokuBoard value, $Res Function(SudokuBoard) _then) = _$SudokuBoardCopyWithImpl;
@useResult
$Res call({
 List<List<SudokuCell>> cells
});




}
/// @nodoc
class _$SudokuBoardCopyWithImpl<$Res>
    implements $SudokuBoardCopyWith<$Res> {
  _$SudokuBoardCopyWithImpl(this._self, this._then);

  final SudokuBoard _self;
  final $Res Function(SudokuBoard) _then;

/// Create a copy of SudokuBoard
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? cells = null,}) {
  return _then(_self.copyWith(
cells: null == cells ? _self.cells : cells // ignore: cast_nullable_to_non_nullable
as List<List<SudokuCell>>,
  ));
}

}


/// Adds pattern-matching-related methods to [SudokuBoard].
extension SudokuBoardPatterns on SudokuBoard {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SudokuBoard value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SudokuBoard() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SudokuBoard value)  $default,){
final _that = this;
switch (_that) {
case _SudokuBoard():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SudokuBoard value)?  $default,){
final _that = this;
switch (_that) {
case _SudokuBoard() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<List<SudokuCell>> cells)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SudokuBoard() when $default != null:
return $default(_that.cells);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<List<SudokuCell>> cells)  $default,) {final _that = this;
switch (_that) {
case _SudokuBoard():
return $default(_that.cells);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<List<SudokuCell>> cells)?  $default,) {final _that = this;
switch (_that) {
case _SudokuBoard() when $default != null:
return $default(_that.cells);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SudokuBoard implements SudokuBoard {
  const _SudokuBoard({required final  List<List<SudokuCell>> cells}): _cells = cells;
  factory _SudokuBoard.fromJson(Map<String, dynamic> json) => _$SudokuBoardFromJson(json);

 final  List<List<SudokuCell>> _cells;
@override List<List<SudokuCell>> get cells {
  if (_cells is EqualUnmodifiableListView) return _cells;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_cells);
}


/// Create a copy of SudokuBoard
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SudokuBoardCopyWith<_SudokuBoard> get copyWith => __$SudokuBoardCopyWithImpl<_SudokuBoard>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SudokuBoardToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SudokuBoard&&const DeepCollectionEquality().equals(other._cells, _cells));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_cells));

@override
String toString() {
  return 'SudokuBoard(cells: $cells)';
}


}

/// @nodoc
abstract mixin class _$SudokuBoardCopyWith<$Res> implements $SudokuBoardCopyWith<$Res> {
  factory _$SudokuBoardCopyWith(_SudokuBoard value, $Res Function(_SudokuBoard) _then) = __$SudokuBoardCopyWithImpl;
@override @useResult
$Res call({
 List<List<SudokuCell>> cells
});




}
/// @nodoc
class __$SudokuBoardCopyWithImpl<$Res>
    implements _$SudokuBoardCopyWith<$Res> {
  __$SudokuBoardCopyWithImpl(this._self, this._then);

  final _SudokuBoard _self;
  final $Res Function(_SudokuBoard) _then;

/// Create a copy of SudokuBoard
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? cells = null,}) {
  return _then(_SudokuBoard(
cells: null == cells ? _self._cells : cells // ignore: cast_nullable_to_non_nullable
as List<List<SudokuCell>>,
  ));
}


}

// dart format on
