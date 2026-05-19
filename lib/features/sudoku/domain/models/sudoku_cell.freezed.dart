// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'sudoku_cell.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SudokuCell {

 int get row; int get col; int get value; int get correctValue; bool get isClue; Set<int> get notes; bool get isInvalid;
/// Create a copy of SudokuCell
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SudokuCellCopyWith<SudokuCell> get copyWith => _$SudokuCellCopyWithImpl<SudokuCell>(this as SudokuCell, _$identity);

  /// Serializes this SudokuCell to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SudokuCell&&(identical(other.row, row) || other.row == row)&&(identical(other.col, col) || other.col == col)&&(identical(other.value, value) || other.value == value)&&(identical(other.correctValue, correctValue) || other.correctValue == correctValue)&&(identical(other.isClue, isClue) || other.isClue == isClue)&&const DeepCollectionEquality().equals(other.notes, notes)&&(identical(other.isInvalid, isInvalid) || other.isInvalid == isInvalid));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,row,col,value,correctValue,isClue,const DeepCollectionEquality().hash(notes),isInvalid);

@override
String toString() {
  return 'SudokuCell(row: $row, col: $col, value: $value, correctValue: $correctValue, isClue: $isClue, notes: $notes, isInvalid: $isInvalid)';
}


}

/// @nodoc
abstract mixin class $SudokuCellCopyWith<$Res>  {
  factory $SudokuCellCopyWith(SudokuCell value, $Res Function(SudokuCell) _then) = _$SudokuCellCopyWithImpl;
@useResult
$Res call({
 int row, int col, int value, int correctValue, bool isClue, Set<int> notes, bool isInvalid
});




}
/// @nodoc
class _$SudokuCellCopyWithImpl<$Res>
    implements $SudokuCellCopyWith<$Res> {
  _$SudokuCellCopyWithImpl(this._self, this._then);

  final SudokuCell _self;
  final $Res Function(SudokuCell) _then;

/// Create a copy of SudokuCell
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? row = null,Object? col = null,Object? value = null,Object? correctValue = null,Object? isClue = null,Object? notes = null,Object? isInvalid = null,}) {
  return _then(_self.copyWith(
row: null == row ? _self.row : row // ignore: cast_nullable_to_non_nullable
as int,col: null == col ? _self.col : col // ignore: cast_nullable_to_non_nullable
as int,value: null == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as int,correctValue: null == correctValue ? _self.correctValue : correctValue // ignore: cast_nullable_to_non_nullable
as int,isClue: null == isClue ? _self.isClue : isClue // ignore: cast_nullable_to_non_nullable
as bool,notes: null == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as Set<int>,isInvalid: null == isInvalid ? _self.isInvalid : isInvalid // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [SudokuCell].
extension SudokuCellPatterns on SudokuCell {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SudokuCell value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SudokuCell() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SudokuCell value)  $default,){
final _that = this;
switch (_that) {
case _SudokuCell():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SudokuCell value)?  $default,){
final _that = this;
switch (_that) {
case _SudokuCell() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int row,  int col,  int value,  int correctValue,  bool isClue,  Set<int> notes,  bool isInvalid)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SudokuCell() when $default != null:
return $default(_that.row,_that.col,_that.value,_that.correctValue,_that.isClue,_that.notes,_that.isInvalid);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int row,  int col,  int value,  int correctValue,  bool isClue,  Set<int> notes,  bool isInvalid)  $default,) {final _that = this;
switch (_that) {
case _SudokuCell():
return $default(_that.row,_that.col,_that.value,_that.correctValue,_that.isClue,_that.notes,_that.isInvalid);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int row,  int col,  int value,  int correctValue,  bool isClue,  Set<int> notes,  bool isInvalid)?  $default,) {final _that = this;
switch (_that) {
case _SudokuCell() when $default != null:
return $default(_that.row,_that.col,_that.value,_that.correctValue,_that.isClue,_that.notes,_that.isInvalid);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SudokuCell implements SudokuCell {
  const _SudokuCell({required this.row, required this.col, required this.value, required this.correctValue, required this.isClue, final  Set<int> notes = const <int>{}, this.isInvalid = false}): _notes = notes;
  factory _SudokuCell.fromJson(Map<String, dynamic> json) => _$SudokuCellFromJson(json);

@override final  int row;
@override final  int col;
@override final  int value;
@override final  int correctValue;
@override final  bool isClue;
 final  Set<int> _notes;
@override@JsonKey() Set<int> get notes {
  if (_notes is EqualUnmodifiableSetView) return _notes;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableSetView(_notes);
}

@override@JsonKey() final  bool isInvalid;

/// Create a copy of SudokuCell
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SudokuCellCopyWith<_SudokuCell> get copyWith => __$SudokuCellCopyWithImpl<_SudokuCell>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SudokuCellToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SudokuCell&&(identical(other.row, row) || other.row == row)&&(identical(other.col, col) || other.col == col)&&(identical(other.value, value) || other.value == value)&&(identical(other.correctValue, correctValue) || other.correctValue == correctValue)&&(identical(other.isClue, isClue) || other.isClue == isClue)&&const DeepCollectionEquality().equals(other._notes, _notes)&&(identical(other.isInvalid, isInvalid) || other.isInvalid == isInvalid));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,row,col,value,correctValue,isClue,const DeepCollectionEquality().hash(_notes),isInvalid);

@override
String toString() {
  return 'SudokuCell(row: $row, col: $col, value: $value, correctValue: $correctValue, isClue: $isClue, notes: $notes, isInvalid: $isInvalid)';
}


}

/// @nodoc
abstract mixin class _$SudokuCellCopyWith<$Res> implements $SudokuCellCopyWith<$Res> {
  factory _$SudokuCellCopyWith(_SudokuCell value, $Res Function(_SudokuCell) _then) = __$SudokuCellCopyWithImpl;
@override @useResult
$Res call({
 int row, int col, int value, int correctValue, bool isClue, Set<int> notes, bool isInvalid
});




}
/// @nodoc
class __$SudokuCellCopyWithImpl<$Res>
    implements _$SudokuCellCopyWith<$Res> {
  __$SudokuCellCopyWithImpl(this._self, this._then);

  final _SudokuCell _self;
  final $Res Function(_SudokuCell) _then;

/// Create a copy of SudokuCell
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? row = null,Object? col = null,Object? value = null,Object? correctValue = null,Object? isClue = null,Object? notes = null,Object? isInvalid = null,}) {
  return _then(_SudokuCell(
row: null == row ? _self.row : row // ignore: cast_nullable_to_non_nullable
as int,col: null == col ? _self.col : col // ignore: cast_nullable_to_non_nullable
as int,value: null == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as int,correctValue: null == correctValue ? _self.correctValue : correctValue // ignore: cast_nullable_to_non_nullable
as int,isClue: null == isClue ? _self.isClue : isClue // ignore: cast_nullable_to_non_nullable
as bool,notes: null == notes ? _self._notes : notes // ignore: cast_nullable_to_non_nullable
as Set<int>,isInvalid: null == isInvalid ? _self.isInvalid : isInvalid // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
