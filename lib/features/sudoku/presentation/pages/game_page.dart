import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/style/design_system.dart';
import '../../domain/models/game_state.dart';
import '../cubit/sudoku_cubit.dart';
import '../widgets/control_pad.dart';
import '../widgets/sudoku_grid_view.dart';

class GamePage extends StatefulWidget {
  final String difficulty;
  final bool isResume;

  const GamePage({
    super.key,
    required this.difficulty,
    this.isResume = false,
  });

  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> with WidgetsBindingObserver {
  late final SudokuCubit _cubit;
  bool _dialogOpen = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _cubit = SudokuCubit();
    if (widget.isResume) {
      _cubit.loadSavedGame();
    } else {
      _cubit.startNewGame(widget.difficulty);
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _cubit.close();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      _cubit.pauseTimer();
    } else if (state == AppLifecycleState.resumed) {
      // Only resume if we are not showing a dialog or if the game is not finished
      if (!_dialogOpen && !_cubit.state.isCompleted && !_cubit.state.isGameOver) {
        _cubit.resumeTimer();
      }
    }
  }

  String _formatDuration(int seconds) {
    final minutes = (seconds ~/ 60).toString().padLeft(2, '0');
    final secs = (seconds % 60).toString().padLeft(2, '0');
    return '$minutes:$secs';
  }

  Future<bool> _onWillPop() async {
    if (_cubit.state.isCompleted || _cubit.state.isGameOver) {
      return true;
    }
    
    _cubit.pauseTimer();
    setState(() {
      _dialogOpen = true;
    });

    final exitConfirm = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) => _buildTactileExitDialog(context),
    );

    setState(() {
      _dialogOpen = false;
    });

    if (exitConfirm == true) {
      await _cubit.abandonGame();
      return true;
    } else {
      _cubit.resumeTimer();
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: BlocProvider<SudokuCubit>.value(
        value: _cubit,
        child: Scaffold(
          backgroundColor: AppColors.background,
          body: SafeArea(
            child: BlocConsumer<SudokuCubit, GameState>(
              listener: (context, state) {
                if (state.isCompleted) {
                  _showGameWinDialog();
                } else if (state.isGameOver) {
                  _showGameOverDialog();
                }
              },
              builder: (context, state) {
                return LayoutBuilder(
                  builder: (context, constraints) {
                    final isLandscape = constraints.maxWidth > constraints.maxHeight;
                    
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          _buildMastheadHeader(context, state),
                          const SizedBox(height: 12),
                          Expanded(
                            child: Center(
                              child: ConstrainedBox(
                                constraints: const BoxConstraints(maxWidth: 500),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.stretch,
                                  children: [
                                    _buildActionBarRow(context, state),
                                    const SizedBox(height: 8),
                                    SudokuGridView(
                                      board: state.board,
                                      selectedRow: state.selectedRow,
                                      selectedCol: state.selectedCol,
                                      onCellTap: (r, c) => _cubit.selectCell(r, c),
                                    ),
                                    const SizedBox(height: 16),
                                    NumberKeypadWidget(
                                      board: state.board,
                                      onNumberTap: (digit) => _cubit.enterDigit(digit),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  // Newspaper Masthead Style Header
  Widget _buildMastheadHeader(BuildContext context, GameState state) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              onPressed: () async {
                final navigateBack = await _onWillPop();
                if (navigateBack && context.mounted) {
                  Navigator.pop(context);
                }
              },
              icon: const Icon(
                Icons.arrow_back_ios_new_rounded,
                color: AppColors.keyText,
                size: 20,
              ),
            ),
            const Text(
              'THE CLASSIC SOLVER',
              style: TextStyle(
                fontFamily: 'Georgia',
                fontSize: 16,
                fontWeight: FontWeight.w900,
                letterSpacing: 2.0,
                color: AppColors.textClue,
              ),
            ),
            // Balance placeholder to center the title
            const Opacity(
              opacity: 0,
              child: IconButton(
                onPressed: null,
                icon: Icon(Icons.arrow_back_ios_new_rounded, size: 20),
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Container(
          height: 1.5,
          color: AppColors.textClue,
        ),
        const SizedBox(height: 6),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '${state.difficulty.toUpperCase()} EDITION',
              style: const TextStyle(
                fontFamily: 'Georgia',
                fontSize: 11,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.0,
                color: AppColors.textClue,
              ),
            ),
            Text(
              'VOL. I • NO. ${4694 + state.difficulty.length}',
              style: const TextStyle(
                fontFamily: 'Georgia',
                fontSize: 10,
                fontWeight: FontWeight.w500,
                color: AppColors.textNote,
              ),
            ),
            Text(
              'MISTAKES: ${state.mistakesMade}/${state.maxMistakes}',
              style: TextStyle(
                fontFamily: 'Georgia',
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: state.mistakesMade > 0 ? AppColors.textInvalid : AppColors.textClue,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Container(
          height: 1.0,
          color: AppColors.cellBorder,
        ),
      ],
    );
  }

  // Row right above the Sudoku grid (Title / Timer on the Left, Undo/Erase/Notes/Hint on the Right)
  Widget _buildActionBarRow(BuildContext context, GameState state) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        // Title & Time Box
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'PUZZLE STAMP',
              style: TextStyle(
                fontFamily: 'Georgia',
                fontSize: 9,
                fontWeight: FontWeight.bold,
                color: AppColors.textNote,
              ),
            ),
            const SizedBox(height: 2),
            Row(
              children: [
                const Icon(
                  Icons.timer_outlined,
                  size: 14,
                  color: AppColors.textClue,
                ),
                const SizedBox(width: 4),
                Text(
                  _formatDuration(state.elapsedSeconds),
                  style: const TextStyle(
                    fontFamily: 'Georgia',
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textClue,
                  ),
                ),
              ],
            ),
          ],
        ),
        // Stamped Action Buttons (Undo, Erase, Notes, Hint)
        ActionBarWidget(
          isNotesMode: state.isNotesMode,
          hintsUsed: state.hintsUsed,
          maxHints: state.maxHints,
          onUndo: () => _cubit.undo(),
          onErase: () => _cubit.erase(),
          onToggleNotes: () => _cubit.toggleNotesMode(),
          onHint: () => _cubit.useHint(),
        ),
      ],
    );
  }

  Widget _buildTactileExitDialog(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      child: Container(
        padding: const EdgeInsets.all(24.0),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(8.0),
          border: Border.all(color: AppColors.gridOuter, width: 2.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 16,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'PAUSE GAME',
              style: TextStyle(
                fontFamily: 'Georgia',
                fontSize: 20,
                fontWeight: FontWeight.w900,
                letterSpacing: 2.0,
                color: AppColors.textClue,
              ),
            ),
            const SizedBox(height: 8),
            Container(width: 80, height: 1.5, color: AppColors.subgridBorder),
            const SizedBox(height: 16),
            Text(
              'Do you want to abandon the current puzzle? Your progress will be lost.',
              style: TextStyle(
                fontSize: 13,
                color: AppColors.keyText.withOpacity(0.8),
                height: 1.4,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 44,
                    child: TactileButton(
                      backgroundColor: AppColors.keyBackground,
                      onTap: () => Navigator.pop(context, false),
                      child: const Center(
                        child: Text(
                          'RESUME',
                          style: TextStyle(
                            fontFamily: 'Georgia',
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: AppColors.keyText,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: SizedBox(
                    height: 44,
                    child: TactileButton(
                      backgroundColor: AppColors.surface,
                      onTap: () => Navigator.pop(context, true),
                      child: const Center(
                        child: Text(
                          'ABANDON',
                          style: TextStyle(
                            fontFamily: 'Georgia',
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textInvalid,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showGameWinDialog() {
    _cubit.pauseTimer();
    setState(() {
      _dialogOpen = true;
    });

    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          elevation: 0,
          child: Container(
            padding: const EdgeInsets.all(28.0),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(8.0),
              border: Border.all(color: AppColors.gridOuter, width: 3.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.12),
                  blurRadius: 24,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.workspace_premium_outlined,
                  size: 48,
                  color: AppColors.textUser,
                ),
                const SizedBox(height: 12),
                const Text(
                  'PUZZLE COMPLETED',
                  style: TextStyle(
                    fontFamily: 'Georgia',
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1.5,
                    color: AppColors.textClue,
                  ),
                ),
                const SizedBox(height: 8),
                Container(width: 100, height: 1.5, color: AppColors.subgridBorder),
                const SizedBox(height: 16),
                const Text(
                  'Your logical scan was absolutely flawless. You have mastered this edition!',
                  style: TextStyle(
                    fontStyle: FontStyle.italic,
                    fontSize: 13,
                    color: AppColors.textNote,
                    height: 1.4,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                  decoration: BoxDecoration(
                    color: AppColors.background,
                    borderRadius: BorderRadius.circular(6.0),
                    border: Border.all(color: AppColors.cellBorder, width: 1.0),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(
                        children: [
                          const Text(
                            'DIFFICULTY',
                            style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: AppColors.textNote),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            widget.difficulty.toUpperCase(),
                            style: const TextStyle(fontFamily: 'Georgia', fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.textClue),
                          ),
                        ],
                      ),
                      Container(width: 1, height: 24, color: AppColors.cellBorder),
                      Column(
                        children: [
                          const Text(
                            'TIME TAKEN',
                            style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: AppColors.textNote),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            _formatDuration(_cubit.state.elapsedSeconds),
                            style: const TextStyle(fontFamily: 'Georgia', fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.textClue),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  height: 46,
                  child: TactileButton(
                    backgroundColor: AppColors.keyBackground,
                    onTap: () {
                      Navigator.pop(context); // Close dialog
                      Navigator.pop(context); // Back to HomePage
                    },
                    child: const Center(
                      child: Text(
                        'RETURN TO ARCHIVE',
                        style: TextStyle(
                          fontFamily: 'Georgia',
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: AppColors.keyText,
                          letterSpacing: 1.0,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    ).then((_) {
      setState(() {
        _dialogOpen = false;
      });
    });
  }

  void _showGameOverDialog() {
    _cubit.pauseTimer();
    setState(() {
      _dialogOpen = true;
    });

    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          elevation: 0,
          child: Container(
            padding: const EdgeInsets.all(28.0),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(8.0),
              border: Border.all(color: AppColors.textInvalid, width: 2.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.12),
                  blurRadius: 24,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.error_outline_rounded,
                  size: 48,
                  color: AppColors.textInvalid,
                ),
                const SizedBox(height: 12),
                const Text(
                  'PUZZLE FAILED',
                  style: TextStyle(
                    fontFamily: 'Georgia',
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1.5,
                    color: AppColors.textInvalid,
                  ),
                ),
                const SizedBox(height: 8),
                Container(width: 100, height: 1.5, color: AppColors.textInvalid.withOpacity(0.5)),
                const SizedBox(height: 16),
                const Text(
                  'Too many mistakes were stamped onto this edition. Don\'t lose heart, practice makes perfect!',
                  style: TextStyle(
                    fontStyle: FontStyle.italic,
                    fontSize: 13,
                    color: AppColors.textNote,
                    height: 1.4,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 44,
                        child: TactileButton(
                          backgroundColor: AppColors.surface,
                          onTap: () {
                            Navigator.pop(context); // Close dialog
                            Navigator.pop(context); // Back to HomePage
                          },
                          child: const Center(
                            child: Text(
                              'HOME',
                              style: TextStyle(
                                fontFamily: 'Georgia',
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: AppColors.keyText,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: SizedBox(
                        height: 44,
                        child: TactileButton(
                          backgroundColor: AppColors.keyBackground,
                          onTap: () {
                            Navigator.pop(context); // Close dialog
                            _cubit.startNewGame(widget.difficulty);
                          },
                          child: const Center(
                            child: Text(
                              'RESTART',
                              style: TextStyle(
                                fontFamily: 'Georgia',
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textUser,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    ).then((_) {
      setState(() {
        _dialogOpen = false;
      });
    });
  }
}
