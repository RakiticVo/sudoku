import 'package:flutter/material.dart';
import '../../domain/models/sudoku_board.dart';
import '../../../../core/style/design_system.dart';

class TactileButton extends StatefulWidget {
  final Widget child;
  final VoidCallback onTap;
  final Color? backgroundColor;
  final Color? borderColor;
  final bool isActive;

  const TactileButton({
    super.key,
    required this.child,
    required this.onTap,
    this.backgroundColor,
    this.borderColor,
    this.isActive = false,
  });

  @override
  State<TactileButton> createState() => _TactileButtonState();
}

class _TactileButtonState extends State<TactileButton> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 80),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.94).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final defaultBg = context.keyBg;
    final activeBg = context.isDark ? context.subgridBorder : context.keyBg.withValues(alpha: 0.5);
    final finalBg = widget.isActive ? activeBg : (widget.backgroundColor ?? defaultBg);

    return GestureDetector(
      onTapDown: (_) => _controller.forward(),
      onTapUp: (_) {
        _controller.reverse();
        widget.onTap();
      },
      onTapCancel: () => _controller.reverse(),
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Container(
          decoration: BoxDecoration(
            color: finalBg,
            borderRadius: BorderRadius.circular(6.0),
            border: Border.all(
              color: widget.borderColor ?? (widget.isActive ? context.subgridBorder : context.cellBorder),
              width: 1.2,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 2,
                offset: const Offset(0, 1.5),
              ),
            ],
          ),
          child: widget.child,
        ),
      ),
    );
  }
}

class ActionBarWidget extends StatelessWidget {
  final bool isNotesMode;
  final int hintsUsed;
  final int maxHints;
  final VoidCallback onUndo;
  final VoidCallback onErase;
  final VoidCallback onToggleNotes;
  final VoidCallback onHint;

  const ActionBarWidget({
    super.key,
    required this.isNotesMode,
    required this.hintsUsed,
    required this.maxHints,
    required this.onUndo,
    required this.onErase,
    required this.onToggleNotes,
    required this.onHint,
  });

  @override
  Widget build(BuildContext context) {
    final hintsRemaining = maxHints > 0 ? (maxHints - hintsUsed).clamp(0, maxHints) : 0;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildActionButton(
          context,
          icon: Icons.undo_outlined,
          label: 'Undo',
          onTap: onUndo,
        ),
        const SizedBox(width: 8),
        _buildActionButton(
          context,
          icon: Icons.delete_outline,
          label: 'Erase',
          onTap: onErase,
        ),
        const SizedBox(width: 8),
        _buildActionButton(
          context,
          icon: Icons.edit_outlined,
          label: 'Notes',
          isActive: isNotesMode,
          onTap: onToggleNotes,
        ),
        const SizedBox(width: 8),
        _buildActionButton(
          context,
          icon: Icons.lightbulb_outline,
          label: 'Hint ($hintsRemaining)',
          onTap: onHint,
          isDisabled: false,
        ),
      ],
    );
  }

  Widget _buildActionButton(
    BuildContext context, {
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    bool isActive = false,
    bool isDisabled = false,
  }) {
    return Opacity(
      opacity: isDisabled ? 0.4 : 1.0,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 48,
            height: 40,
            child: TactileButton(
              isActive: isActive,
              backgroundColor: context.surfaceBg,
              onTap: isDisabled ? () {} : onTap,
              child: Icon(
                icon,
                color: isActive ? context.textUser : context.keyText,
                size: 20,
              ),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: context.keyText,
            ),
          ),
        ],
      ),
    );
  }
}

class NumberKeypadWidget extends StatelessWidget {
  final SudokuBoard board;
  final void Function(int digit) onNumberTap;

  const NumberKeypadWidget({
    super.key,
    required this.board,
    required this.onNumberTap,
  });

  int _countDigit(int digit) {
    int count = 0;
    for (final row in board.cells) {
      for (final cell in row) {
        if (cell.value == digit) {
          count++;
        }
      }
    }
    return count;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final keyWidth = (constraints.maxWidth - (8 * 8)) / 9;
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(9, (index) {
            final digit = index + 1;
            final count = _countDigit(digit);
            final isComplete = count >= 9;

            return SizedBox(
              width: keyWidth,
              height: keyWidth * 1.25, // Tactile standard key aspect ratio
              child: Opacity(
                opacity: isComplete ? 0.35 : 1.0,
                child: TactileButton(
                  onTap: () => onNumberTap(digit),
                  backgroundColor: context.keyBg,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Text(
                        '$digit',
                        style: TextStyle(
                          fontFamily: context.fontFamily,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: context.keyText,
                        ),
                      ),
                      if (isComplete)
                        Positioned(
                          top: 4,
                          right: 4,
                          child: Icon(
                            Icons.check_circle,
                            size: 10,
                            color: context.textNote,
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            );
          }),
        );
      },
    );
  }
}
