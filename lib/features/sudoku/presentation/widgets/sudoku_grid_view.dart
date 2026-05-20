import 'package:flutter/material.dart';
import '../../domain/models/sudoku_board.dart';
import 'cell_widget.dart';
import '../../../../core/style/design_system.dart';

class SudokuGridView extends StatelessWidget {
  final SudokuBoard board;
  final int? selectedRow;
  final int? selectedCol;
  final void Function(int row, int col) onCellTap;

  const SudokuGridView({
    super.key,
    required this.board,
    required this.selectedRow,
    required this.selectedCol,
    required this.onCellTap,
  });

  @override
  Widget build(BuildContext context) {
    // Determine if there's an active same-value selection to highlight
    int? activeValue;
    if (selectedRow != null && selectedCol != null) {
      final cell = board.cells[selectedRow!][selectedCol!];
      if (cell.value != 0) {
        activeValue = cell.value;
      }
    }

    return AspectRatio(
      aspectRatio: 1.0,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(width: 3.5, color: context.gridOuter),
          color: context.surfaceBg,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: List.generate(9, (rowIndex) {
            return Expanded(
              child: Row(
                children: List.generate(9, (colIndex) {
                  final cell = board.cells[rowIndex][colIndex];
                  final isSelected = selectedRow == rowIndex && selectedCol == colIndex;

                  // Determine crosshair highlight (row, column, or 3x3 box)
                  final inSameRow = selectedRow == rowIndex;
                  final inSameCol = selectedCol == colIndex;
                  final inSameBox = selectedRow != null &&
                      selectedCol != null &&
                      (rowIndex ~/ 3 == selectedRow! ~/ 3) &&
                      (colIndex ~/ 3 == selectedCol! ~/ 3);
                  final isInCrosshair = (inSameRow || inSameCol || inSameBox) && !isSelected;

                  // Determine same-value highlight
                  final isSameValue = activeValue != null && cell.value == activeValue && !isSelected;

                  return Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border(
                          left: colIndex > 0 && colIndex % 3 == 0
                              ? BorderSide(width: 2.0, color: context.subgridBorder)
                              : colIndex > 0
                                  ? BorderSide(width: 0.75, color: context.cellBorder)
                                  : BorderSide.none,
                          top: rowIndex > 0 && rowIndex % 3 == 0
                              ? BorderSide(width: 2.0, color: context.subgridBorder)
                              : rowIndex > 0
                                  ? BorderSide(width: 0.75, color: context.cellBorder)
                                  : BorderSide.none,
                        ),
                      ),
                      child: CellWidget(
                        cell: cell,
                        isSelected: isSelected,
                        isInCrosshair: isInCrosshair,
                        isSameValue: isSameValue,
                        onTap: () => onCellTap(rowIndex, colIndex),
                      ),
                    ),
                  );
                }),
              ),
            );
          }),
        ),
      ),
    );
  }
}
