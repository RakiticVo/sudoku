import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/style/design_system.dart';
import '../../domain/models/game_state.dart';
import '../cubit/sudoku_cubit.dart';
import '../cubit/economy_cubit.dart';
import '../cubit/campaign_cubit.dart';
import '../cubit/daily_challenge_cubit.dart';
import '../../../../core/database/sudoku_database.dart';
import '../widgets/control_pad.dart';
import '../widgets/sudoku_grid_view.dart';

class GamePage extends StatefulWidget {
  final String difficulty;
  final bool isResume;
  final String? volumeId;
  final int? levelIndex;
  final int? seed;
  final String? dailyDate;

  const GamePage({
    super.key,
    required this.difficulty,
    this.isResume = false,
    this.volumeId,
    this.levelIndex,
    this.seed,
    this.dailyDate,
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
      _cubit.startNewGame(widget.difficulty, seed: widget.seed);
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

  int _calculateReward(String difficulty) {
    switch (difficulty.toLowerCase()) {
      case 'easy':
        return 10;
      case 'medium':
        return 25;
      case 'hard':
        return 50;
      case 'expert':
        return 100;
      default:
        return 25;
    }
  }

  int _calculateDailyReward(String difficulty) {
    switch (difficulty.toLowerCase()) {
      case 'easy':
        return 20;
      case 'medium':
        return 50;
      case 'hard':
        return 100;
      case 'expert':
        return 200;
      default:
        return 50;
    }
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
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        final shouldPop = await _onWillPop();
        if (shouldPop && context.mounted) {
          Navigator.of(context).pop();
        }
      },
      child: BlocProvider<SudokuCubit>.value(
        value: _cubit,
        child: Scaffold(
          backgroundColor: context.scaffoldBg,
          body: SafeArea(
            child: BlocConsumer<SudokuCubit, GameState>(
              listener: (context, state) {
                if (state.isCompleted && !_dialogOpen) {
                  _showGameWinDialog();
                } else if (state.isGameOver && !_dialogOpen) {
                  final ecoState = context.read<EconomyCubit>().state;
                  final cannotRevive = state.reviveUsed || (ecoState.revives == 0 && ecoState.balance < 500);
                  if (cannotRevive) {
                    _showGameOverDialog();
                  } else {
                    _showReviveDialog();
                  }
                }
              },
              builder: (context, state) {
                if (state.board.cells.isEmpty) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                return LayoutBuilder(
                  builder: (context, constraints) {
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
              icon: Icon(
                Icons.arrow_back_ios_new_rounded,
                color: context.keyText,
                size: 20,
              ),
            ),
            Text(
              'THE CLASSIC SOLVER',
              style: TextStyle(
                fontFamily: context.fontFamily,
                fontSize: 16,
                fontWeight: FontWeight.w900,
                letterSpacing: 2.0,
                color: context.textClue,
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
          color: context.textClue,
        ),
        const SizedBox(height: 6),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '${state.difficulty.toUpperCase()} EDITION',
              style: TextStyle(
                fontFamily: context.fontFamily,
                fontSize: 11,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.0,
                color: context.textClue,
              ),
            ),
            Text(
              'VOL. I • NO. ${4694 + state.difficulty.length}',
              style: TextStyle(
                fontFamily: context.fontFamily,
                fontSize: 10,
                fontWeight: FontWeight.w500,
                color: context.textNote,
              ),
            ),
            Text(
              'MISTAKES: ${state.mistakesMade}/${state.maxMistakes}',
              style: TextStyle(
                fontFamily: context.fontFamily,
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: state.mistakesMade > 0 ? context.textInvalid : context.textClue,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Container(
          height: 1.0,
          color: context.cellBorder,
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
            Text(
              'PUZZLE STAMP',
              style: TextStyle(
                fontFamily: context.fontFamily,
                fontSize: 9,
                fontWeight: FontWeight.bold,
                color: context.textNote,
              ),
            ),
            const SizedBox(height: 2),
            Row(
              children: [
                Icon(
                  Icons.timer_outlined,
                  size: 14,
                  color: context.textClue,
                ),
                const SizedBox(width: 4),
                Text(
                  _formatDuration(state.elapsedSeconds),
                  style: TextStyle(
                    fontFamily: context.fontFamily,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: context.textClue,
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
          onHint: () => _handleHintTap(state),
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
          color: context.surfaceBg,
          borderRadius: BorderRadius.circular(8.0),
          border: Border.all(color: context.gridOuter, width: 2.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 16,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'PAUSE GAME',
              style: TextStyle(
                fontFamily: context.fontFamily,
                fontSize: 20,
                fontWeight: FontWeight.w900,
                letterSpacing: 2.0,
                color: context.textClue,
              ),
            ),
            const SizedBox(height: 8),
            Container(width: 80, height: 1.5, color: context.subgridBorder),
            const SizedBox(height: 16),
            Text(
              'Do you want to abandon the current puzzle? Your progress will be lost.',
              style: TextStyle(
                fontSize: 13,
                color: context.keyText.withValues(alpha: 0.8),
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
                      backgroundColor: context.keyBg,
                      onTap: () => Navigator.pop(context, false),
                      child: Center(
                        child: Text(
                          'RESUME',
                          style: TextStyle(
                            fontFamily: context.fontFamily,
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: context.keyText,
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
                      backgroundColor: context.surfaceBg,
                      onTap: () => Navigator.pop(context, true),
                      child: Center(
                        child: Text(
                          'ABANDON',
                          style: TextStyle(
                            fontFamily: context.fontFamily,
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: context.textInvalid,
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

    final isDaily = widget.dailyDate != null;
    final reward = isDaily ? _calculateDailyReward(widget.difficulty) : _calculateReward(widget.difficulty);
    
    if (isDaily) {
      context.read<DailyChallengeCubit>().completeChallenge(
        date: widget.dailyDate!,
        difficulty: widget.difficulty,
        solveTimeSeconds: _cubit.state.elapsedSeconds,
      );
    } else {
      context.read<EconomyCubit>().addDroplets(reward);
    }

    if (widget.volumeId != null && widget.levelIndex != null) {
      context.read<CampaignCubit>().completeLevel(
        widget.volumeId!,
        widget.levelIndex!,
        _cubit.state.elapsedSeconds,
      );
    }

    bool isArchived = false;

    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return Dialog(
              backgroundColor: Colors.transparent,
              elevation: 0,
              child: Container(
                padding: const EdgeInsets.all(28.0),
                decoration: BoxDecoration(
                  color: context.surfaceBg,
                  borderRadius: BorderRadius.circular(8.0),
                  border: Border.all(color: context.gridOuter, width: 3.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.12),
                      blurRadius: 24,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.workspace_premium_outlined,
                      size: 48,
                      color: context.textUser,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'PUZZLE COMPLETED',
                      style: TextStyle(
                        fontFamily: context.fontFamily,
                        fontSize: 20,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1.5,
                        color: context.textClue,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(width: 100, height: 1.5, color: context.subgridBorder),
                    const SizedBox(height: 16),
                    Text(
                      'Your logical scan was absolutely flawless. You have completed this edition and earned droplets!',
                      style: TextStyle(
                        fontFamily: context.fontFamily,
                        fontStyle: FontStyle.italic,
                        fontSize: 13,
                        color: context.textNote,
                        height: 1.4,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 12),
                    // Droplets Earned Badge
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.water_drop_outlined, color: Colors.blue, size: 20),
                        const SizedBox(width: 4),
                        Text(
                          '+$reward💧 Unlocked',
                          style: TextStyle(
                            fontFamily: context.fontFamily,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: context.textUser,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                      decoration: BoxDecoration(
                        color: context.scaffoldBg,
                        borderRadius: BorderRadius.circular(6.0),
                        border: Border.all(color: context.cellBorder, width: 1.0),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Column(
                            children: [
                              Text(
                                'DIFFICULTY',
                                style: TextStyle(
                                  fontFamily: context.fontFamily,
                                  fontSize: 9,
                                  fontWeight: FontWeight.bold,
                                  color: context.textNote,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                widget.difficulty.toUpperCase(),
                                style: TextStyle(
                                  fontFamily: context.fontFamily,
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                  color: context.textClue,
                                ),
                              ),
                            ],
                          ),
                          Container(width: 1, height: 24, color: context.cellBorder),
                          Column(
                            children: [
                              Text(
                                'TIME TAKEN',
                                style: TextStyle(
                                  fontFamily: context.fontFamily,
                                  fontSize: 9,
                                  fontWeight: FontWeight.bold,
                                  color: context.textNote,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                _formatDuration(_cubit.state.elapsedSeconds),
                                style: TextStyle(
                                  fontFamily: context.fontFamily,
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                  color: context.textClue,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    // Action Buttons: Replay Archive & Return
                    Row(
                      children: [
                        Expanded(
                          child: SizedBox(
                            height: 46,
                            child: TactileButton(
                              isActive: isArchived,
                              backgroundColor: isArchived ? context.keyBg : context.surfaceBg,
                              onTap: isArchived
                                  ? () {}
                                  : () async {
                                      final id = DateTime.now().millisecondsSinceEpoch.toString();
                                      final title = 'Classic Solve - ${DateTime.now().hour.toString().padLeft(2, '0')}:${DateTime.now().minute.toString().padLeft(2, '0')}';
                                      await SudokuDatabase.instance.saveReplay(
                                        id: id,
                                        title: title,
                                        difficulty: widget.difficulty,
                                        solveDurationSeconds: _cubit.state.elapsedSeconds,
                                        moves: _cubit.getReplayPayload(),
                                      );
                                      setDialogState(() {
                                        isArchived = true;
                                      });
                                    },
                              child: Center(
                                child: Text(
                                  isArchived ? 'ARCHIVED 🗞️' : 'SAVE REPLAY',
                                  style: TextStyle(
                                    fontFamily: context.fontFamily,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: isArchived ? context.textNote : context.keyText,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: SizedBox(
                            height: 46,
                            child: TactileButton(
                              backgroundColor: context.keyBg,
                              onTap: () {
                                Navigator.pop(context); // Close dialog
                                Navigator.pop(context); // Back to HomePage
                              },
                              child: Center(
                                child: Text(
                                  'RETURN',
                                  style: TextStyle(
                                    fontFamily: context.fontFamily,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: context.keyText,
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
              color: context.surfaceBg,
              borderRadius: BorderRadius.circular(8.0),
              border: Border.all(color: context.textInvalid, width: 2.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.12),
                  blurRadius: 24,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.error_outline_rounded,
                  size: 48,
                  color: context.textInvalid,
                ),
                const SizedBox(height: 12),
                Text(
                  'PUZZLE FAILED',
                  style: TextStyle(
                    fontFamily: context.fontFamily,
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1.5,
                    color: context.textInvalid,
                  ),
                ),
                const SizedBox(height: 8),
                Container(width: 100, height: 1.5, color: context.textInvalid.withValues(alpha: 0.5)),
                const SizedBox(height: 16),
                Text(
                  'Too many mistakes were stamped onto this edition. Don\'t lose heart, practice makes perfect!',
                  style: TextStyle(
                    fontFamily: context.fontFamily,
                    fontStyle: FontStyle.italic,
                    fontSize: 13,
                    color: context.textNote,
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
                          backgroundColor: context.surfaceBg,
                          onTap: () {
                            Navigator.pop(context); // Close dialog
                            Navigator.pop(context); // Back to HomePage
                          },
                          child: Center(
                            child: Text(
                              'HOME',
                              style: TextStyle(
                                fontFamily: context.fontFamily,
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: context.keyText,
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
                          backgroundColor: context.keyBg,
                          onTap: () {
                            Navigator.pop(context); // Close dialog
                            _cubit.startNewGame(widget.difficulty);
                          },
                          child: Center(
                            child: Text(
                              'RESTART',
                              style: TextStyle(
                                fontFamily: context.fontFamily,
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: context.textUser,
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

  void _handleHintTap(GameState state) {
    if (state.selectedRow == null || state.selectedCol == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No Selection: Select a cell to apply a logical hint.'),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    final cell = state.board.cells[state.selectedRow!][state.selectedCol!];
    if (cell.isClue || cell.value == cell.correctValue) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Already Solved: Select an unsolved cell to apply a logical hint.'),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    final diff = widget.difficulty.toLowerCase();
    if (diff == 'expert') {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Expert Edition: Logical hints are not permitted on Expert broadsheets.'),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    int cap = 5;
    if (diff == 'easy') {
      cap = 5;
    } else if (diff == 'medium') {
      cap = 4;
    } else if (diff == 'hard') {
      cap = 3;
    }

    if (state.hintsUsed >= cap) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Logical Limit Reached: You can only use at most $cap hints on $diff difficulty.'),
          duration: const Duration(seconds: 2),
        ),
      );
      return;
    }

    final economyCubit = context.read<EconomyCubit>();
    if (economyCubit.state.hints > 0) {
      economyCubit.useHintToken();
      _cubit.useHint();
    } else {
      _showOutOfHintsDialog();
    }
  }

  void _showOutOfHintsDialog() {
    _cubit.pauseTimer();
    setState(() {
      _dialogOpen = true;
    });

    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return BlocBuilder<EconomyCubit, EconomyState>(
          builder: (context, ecoState) {
            final balance = ecoState.balance;
            final canAfford = balance >= 50;

            return Dialog(
              backgroundColor: Colors.transparent,
              elevation: 0,
              child: Container(
                padding: const EdgeInsets.all(24.0),
                decoration: BoxDecoration(
                  color: context.surfaceBg,
                  borderRadius: BorderRadius.circular(8.0),
                  border: Border.all(color: context.gridOuter, width: 2.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.08),
                      blurRadius: 16,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'OUT OF HINTS',
                      style: TextStyle(
                        fontFamily: context.fontFamily,
                        fontSize: 20,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 2.0,
                        color: context.textClue,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(width: 80, height: 1.5, color: context.subgridBorder),
                    const SizedBox(height: 16),
                    Text(
                      'Your pre-owned hint wallet is empty. Purchase and use an instant hint now?',
                      style: TextStyle(
                        fontSize: 13,
                        color: context.keyText.withValues(alpha: 0.8),
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
                              backgroundColor: context.surfaceBg,
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: Center(
                                child: Text(
                                  'CANCEL',
                                  style: TextStyle(
                                    fontFamily: context.fontFamily,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: context.textNote,
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
                              isActive: canAfford,
                              backgroundColor: canAfford ? context.keyBg : context.surfaceBg,
                              onTap: () async {
                                if (!canAfford) return;
                                final economyCubit = context.read<EconomyCubit>();
                                final success = await economyCubit.buyHint(50);
                                if (success && context.mounted) {
                                  await economyCubit.useHintToken();
                                  _cubit.useHint();
                                  Navigator.pop(context);
                                }
                              },
                              child: Center(
                                child: Text(
                                  'Buy & Use (50 💧)',
                                  style: TextStyle(
                                    fontFamily: context.fontFamily,
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                    color: canAfford ? context.keyText : context.textNote,
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
        );
      },
    ).then((_) {
      setState(() {
        _dialogOpen = false;
      });
      if (!_cubit.state.isCompleted && !_cubit.state.isGameOver) {
        _cubit.resumeTimer();
      }
    });
  }

  void _showReviveDialog() {
    _cubit.pauseTimer();
    setState(() {
      _dialogOpen = true;
    });

    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return BlocBuilder<EconomyCubit, EconomyState>(
          builder: (context, ecoState) {
            final hasToken = ecoState.revives > 0;
            final canAffordBuy = ecoState.balance >= 500;

            return Dialog(
              backgroundColor: Colors.transparent,
              elevation: 0,
              child: Container(
                padding: const EdgeInsets.all(28.0),
                decoration: BoxDecoration(
                  color: context.surfaceBg,
                  borderRadius: BorderRadius.circular(8.0),
                  border: Border.all(color: context.textInvalid, width: 2.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.12),
                      blurRadius: 24,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.newspaper_rounded,
                      size: 48,
                      color: context.textInvalid,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'THE PRESS OVERFLOWED: OUT OF MISTAKES',
                      style: TextStyle(
                        fontFamily: context.fontFamily,
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1.0,
                        color: context.textInvalid,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Container(width: 80, height: 1.5, color: context.textInvalid.withValues(alpha: 0.5)),
                    const SizedBox(height: 16),
                    Text(
                      'Would you like to use a Revive Token to retract one mistake and continue solving? (Limit: Once per game)',
                      style: TextStyle(
                        fontSize: 13,
                        color: context.keyText.withValues(alpha: 0.8),
                        height: 1.4,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    Column(
                      children: [
                        if (hasToken) ...[
                          SizedBox(
                            width: double.infinity,
                            height: 44,
                            child: TactileButton(
                              backgroundColor: context.keyBg,
                              onTap: () async {
                                final economyCubit = context.read<EconomyCubit>();
                                await economyCubit.useReviveToken();
                                _cubit.retractMistake();
                                Navigator.pop(context);
                              },
                              child: Center(
                                child: Text(
                                  'Use 1 Revive Token',
                                  style: TextStyle(
                                    fontFamily: context.fontFamily,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: context.keyText,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                        ] else ...[
                          SizedBox(
                            width: double.infinity,
                            height: 44,
                            child: TactileButton(
                              isActive: canAffordBuy,
                              backgroundColor: canAffordBuy ? context.keyBg : context.surfaceBg,
                              onTap: () async {
                                if (!canAffordBuy) return;
                                final economyCubit = context.read<EconomyCubit>();
                                final success = await economyCubit.buyRevive(500);
                                if (success && context.mounted) {
                                  await economyCubit.useReviveToken();
                                  _cubit.retractMistake();
                                  Navigator.pop(context);
                                }
                              },
                              child: Center(
                                child: Text(
                                  'Buy & Use Revive (500 💧)',
                                  style: TextStyle(
                                    fontFamily: context.fontFamily,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: canAffordBuy ? context.keyText : context.textNote,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                        ],
                        SizedBox(
                          width: double.infinity,
                          height: 44,
                          child: TactileButton(
                            backgroundColor: context.surfaceBg,
                            onTap: () {
                              Navigator.pop(context);
                              _showGameOverDialog();
                            },
                            child: Center(
                              child: Text(
                                'Accept Defeat',
                                style: TextStyle(
                                  fontFamily: context.fontFamily,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: context.textInvalid,
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
        );
      },
    ).then((_) {
      setState(() {
        _dialogOpen = false;
      });
    });
  }
}

