// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sudoku_cell.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_SudokuCell _$SudokuCellFromJson(Map<String, dynamic> json) => _SudokuCell(
  row: (json['row'] as num).toInt(),
  col: (json['col'] as num).toInt(),
  value: (json['value'] as num).toInt(),
  correctValue: (json['correctValue'] as num).toInt(),
  isClue: json['isClue'] as bool,
  notes:
      (json['notes'] as List<dynamic>?)
          ?.map((e) => (e as num).toInt())
          .toSet() ??
      const <int>{},
  isInvalid: json['isInvalid'] as bool? ?? false,
);

Map<String, dynamic> _$SudokuCellToJson(_SudokuCell instance) =>
    <String, dynamic>{
      'row': instance.row,
      'col': instance.col,
      'value': instance.value,
      'correctValue': instance.correctValue,
      'isClue': instance.isClue,
      'notes': instance.notes.toList(),
      'isInvalid': instance.isInvalid,
    };
