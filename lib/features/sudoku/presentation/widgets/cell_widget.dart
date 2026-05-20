import 'package:flutter/material.dart';
import '../../domain/models/sudoku_cell.dart';
import '../../../../core/style/design_system.dart';

class CellWidget extends StatelessWidget {
  final SudokuCell cell;
  final bool isSelected;
  final bool isInCrosshair;
  final bool isSameValue;
  final VoidCallback onTap;

  const CellWidget({
    super.key,
    required this.cell,
    required this.isSelected,
    required this.isInCrosshair,
    required this.isSameValue,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // Determine background color based on status
    Color backgroundColor = context.surfaceBg;

    if (cell.isInvalid) {
      backgroundColor = context.bgInvalid;
    } else if (isSelected) {
      backgroundColor = context.inkPalette.highlightActive;
    } else if (isSameValue) {
      backgroundColor = context.inkPalette.highlightSameValue;
    } else if (isInCrosshair) {
      backgroundColor = context.isDark ? const Color(0x14FAF7F2) : const Color(0x0C1E2022);
    }

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        decoration: BoxDecoration(
          color: backgroundColor,
        ),
        alignment: Alignment.center,
        child: cell.value != 0
            ? Text(
                '${cell.value}',
                style: _getTextStyle(context),
              )
            : _buildNotesGrid(context),
      ),
    );
  }

  TextStyle _getTextStyle(BuildContext context) {
    if (cell.isClue) {
      return context.cellClueStyle;
    } else if (cell.isInvalid) {
      return context.cellInvalidStyle;
    } else {
      return context.cellUserStyle;
    }
  }

  Widget _buildNotesGrid(BuildContext context) {
    if (cell.notes.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: List.generate(3, (rowIndex) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(3, (colIndex) {
              final digit = rowIndex * 3 + colIndex + 1;
              final hasNote = cell.notes.contains(digit);
              return Expanded(
                child: Center(
                  child: Text(
                    hasNote ? '$digit' : '',
                    style: context.noteStyle,
                    textAlign: TextAlign.center,
                  ),
                ),
              );
            }),
          );
        }),
      ),
    );
  }
}
