import 'package:freezed_annotation/freezed_annotation.dart';
import 'sudoku_cell.dart';

part 'sudoku_board.freezed.dart';
part 'sudoku_board.g.dart';

@freezed
abstract class SudokuBoard with _$SudokuBoard {
  const factory SudokuBoard({
    required List<List<SudokuCell>> cells,
  }) = _SudokuBoard;

  factory SudokuBoard.fromJson(Map<String, dynamic> json) =>
      _$SudokuBoardFromJson(json);
}
