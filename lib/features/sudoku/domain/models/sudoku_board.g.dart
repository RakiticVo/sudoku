// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sudoku_board.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_SudokuBoard _$SudokuBoardFromJson(Map<String, dynamic> json) => _SudokuBoard(
  cells: (json['cells'] as List<dynamic>)
      .map(
        (e) => (e as List<dynamic>)
            .map((e) => SudokuCell.fromJson(e as Map<String, dynamic>))
            .toList(),
      )
      .toList(),
);

Map<String, dynamic> _$SudokuBoardToJson(_SudokuBoard instance) =>
    <String, dynamic>{
      'cells': instance.cells
          .map((e) => e.map((e) => e.toJson()).toList())
          .toList(),
    };
