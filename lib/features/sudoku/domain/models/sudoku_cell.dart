import 'package:freezed_annotation/freezed_annotation.dart';

part 'sudoku_cell.freezed.dart';
part 'sudoku_cell.g.dart';

@freezed
abstract class SudokuCell with _$SudokuCell {
  const factory SudokuCell({
    required int row,
    required int col,
    required int value,
    required int correctValue,
    required bool isClue,
    @Default(<int>{}) Set<int> notes,
    @Default(false) bool isInvalid,
  }) = _SudokuCell;

  factory SudokuCell.fromJson(Map<String, dynamic> json) =>
      _$SudokuCellFromJson(json);
}
