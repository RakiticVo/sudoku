import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/models/board_move.dart';
import '../../domain/models/sudoku_board.dart';
import '../../domain/models/sudoku_cell.dart';
import '../../../../core/style/design_system.dart';
import '../cubit/settings_cubit.dart';
import '../widgets/control_pad.dart';
import '../widgets/sudoku_grid_view.dart';

class ReplayerPage extends StatefulWidget {
  final String id;
  final String title;
  final String difficulty;
  final int solveTimeSeconds;
  final String dateFormatted;
  final String rawPayload;

  const ReplayerPage({
    super.key,
    required this.id,
    required this.title,
    required this.difficulty,
    required this.solveTimeSeconds,
    required this.dateFormatted,
    required this.rawPayload,
  });

  @override
  State<ReplayerPage> createState() => _ReplayerPageState();
}

class _ReplayerPageState extends State<ReplayerPage> {
  late final SudokuBoard _initialBoard;
  final List<BoardMove> _moves = [];
  
  int _currentStepIndex = 0;
  bool _isPlaying = false;
  int _speedMultiplier = 1; // 1x, 2x, 5x
  Timer? _playbackTimer;

  @override
  void initState() {
    super.initState();
    _parsePayload();
  }

  @override
  void dispose() {
    _stopPlayback();
    super.dispose();
  }

  void _parsePayload() {
    try {
      final List<dynamic> parsed = jsonDecode(widget.rawPayload) as List<dynamic>;
      
      // The first entry is always the init board
      final initEntry = parsed[0] as Map<String, dynamic>;
      _initialBoard = SudokuBoard.fromJson(initEntry['board'] as Map<String, dynamic>);
      
      // Subsequent entries are moves
      for (int i = 1; i < parsed.length; i++) {
        final moveEntry = parsed[i]['move'] as Map<String, dynamic>;
        _moves.add(BoardMove.fromJson(moveEntry));
      }
    } catch (e) {
      // Fallback empty board if parse fails
      _initialBoard = const SudokuBoard(cells: []);
    }
  }

  SudokuBoard _getCurrentBoardState() {
    if (_initialBoard.cells.isEmpty) return _initialBoard;

    // Start with the deep copy of initial board cells
    final cells = _initialBoard.cells
        .map((row) => List<SudokuCell>.from(row))
        .toList();

    // Replay the moves up to _currentStepIndex
    for (int i = 0; i < _currentStepIndex; i++) {
      final move = _moves[i];
      final currentCell = cells[move.row][move.col];

      if (move.isNote) {
        final newNotes = Set<int>.from(currentCell.notes);
        if (newNotes.contains(move.val)) {
          newNotes.remove(move.val);
        } else {
          newNotes.add(move.val);
        }
        cells[move.row][move.col] = currentCell.copyWith(
          notes: newNotes,
          value: 0,
        );
      } else {
        final isInvalid = move.val != 0 && move.val != currentCell.correctValue;
        cells[move.row][move.col] = currentCell.copyWith(
          value: move.val,
          isInvalid: isInvalid,
        );
      }
    }

    return SudokuBoard(cells: cells);
  }

  void _startPlayback() {
    _stopPlayback();
    setState(() => _isPlaying = true);
    
    final durationMs = (1000 ~/ _speedMultiplier);
    _playbackTimer = Timer.periodic(Duration(milliseconds: durationMs), (timer) {
      if (_currentStepIndex >= _moves.length) {
        _stopPlayback();
      } else {
        setState(() {
          _currentStepIndex++;
        });
      }
    });
  }

  void _stopPlayback() {
    _playbackTimer?.cancel();
    _playbackTimer = null;
    if (mounted) {
      setState(() => _isPlaying = false);
    }
  }

  void _stepForward() {
    _stopPlayback();
    if (_currentStepIndex < _moves.length) {
      setState(() {
        _currentStepIndex++;
      });
    }
  }

  void _stepBackward() {
    _stopPlayback();
    if (_currentStepIndex > 0) {
      setState(() {
        _currentStepIndex--;
      });
    }
  }

  void _cycleSpeed() {
    setState(() {
      if (_speedMultiplier == 1) {
        _speedMultiplier = 2;
      } else if (_speedMultiplier == 2) {
        _speedMultiplier = 5;
      } else {
        _speedMultiplier = 1;
      }
    });

    if (_isPlaying) {
      _startPlayback(); // Restart timer with new speed
    }
  }

  String _formatDuration(int seconds) {
    final minutes = (seconds ~/ 60).toString().padLeft(2, '0');
    final secs = (seconds % 60).toString().padLeft(2, '0');
    return '$minutes:$secs';
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsCubit, SettingsState>(
      builder: (context, settingsState) {
        final font = settingsState.activeFontFamily;
        final board = _getCurrentBoardState();
        
        // Highlight cell of the active/last applied move
        int? selectedRow;
        int? selectedCol;
        if (_currentStepIndex > 0 && _currentStepIndex - 1 < _moves.length) {
          final lastMove = _moves[_currentStepIndex - 1];
          selectedRow = lastMove.row;
          selectedCol = lastMove.col;
        }

        return Scaffold(
          backgroundColor: context.scaffoldBg,
          body: SafeArea(
            child: Column(
              children: [
                _buildHeader(context, font),
                
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 500),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          _buildMetaDataBar(context, font),
                          const SizedBox(height: 16),

                          // Sudoku Grid
                          SudokuGridView(
                            board: board,
                            selectedRow: selectedRow,
                            selectedCol: selectedCol,
                            onCellTap: (row, col) {}, // Read-only replayer grid
                          ),
                          const SizedBox(height: 16),

                          // Replay Timeline Slider
                          _buildTimelineSlider(context, font),
                          const SizedBox(height: 16),

                          // Playback Controls Row
                          _buildPlaybackControls(context, font),
                          const SizedBox(height: 24),

                          // Technical solve facts blurb
                          _buildReplayDetailsBox(context, font),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeader(BuildContext context, String font) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Row(
            children: [
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: Icon(
                  Icons.arrow_back_ios_new_rounded,
                  color: context.keyText,
                  size: 20,
                ),
              ),
              Expanded(
                child: Center(
                  child: Text(
                    'THE SOLVE REPLAYER',
                    style: TextStyle(
                      fontFamily: font,
                      fontSize: 16,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 2.0,
                      color: context.textClue,
                    ),
                  ),
                ),
              ),
              const Opacity(
                opacity: 0,
                child: IconButton(
                  onPressed: null,
                  icon: Icon(Icons.arrow_back, size: 20),
                ),
              ),
            ],
          ),
        ),
        Container(
          height: 1.5,
          color: context.textClue,
          margin: const EdgeInsets.symmetric(horizontal: 16.0),
        ),
        const SizedBox(height: 4),
        Text(
          'STEP-BY-STEP REPLAY ARCHIVE SCRUBBER',
          style: TextStyle(
            fontFamily: font,
            fontSize: 9,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.0,
            color: context.textNote,
          ),
        ),
        const SizedBox(height: 6),
        Container(
          height: 1.0,
          color: context.cellBorder,
          margin: const EdgeInsets.symmetric(horizontal: 16.0),
        ),
      ],
    );
  }

  Widget _buildMetaDataBar(BuildContext context, String font) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: context.surfaceBg,
        border: Border.all(color: context.cellBorder, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.title.toUpperCase(),
                style: TextStyle(
                  fontFamily: font,
                  fontSize: 14,
                  fontWeight: FontWeight.w900,
                  color: context.textClue,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  border: Border.all(color: context.textClue, width: 0.5),
                  borderRadius: BorderRadius.circular(2),
                ),
                child: Text(
                  widget.difficulty.toUpperCase(),
                  style: TextStyle(
                    fontFamily: font,
                    fontSize: 8,
                    fontWeight: FontWeight.bold,
                    color: context.textClue,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.dateFormatted,
                style: TextStyle(
                  fontSize: 11,
                  color: context.textNote,
                ),
              ),
              Text(
                'SOLVE TIME: ${_formatDuration(widget.solveTimeSeconds)}',
                style: TextStyle(
                  fontFamily: font,
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: context.textUser,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTimelineSlider(BuildContext context, String font) {
    final maxSteps = _moves.length;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Row(
        children: [
          Text(
            'START',
            style: TextStyle(
              fontFamily: font,
              fontSize: 9,
              fontWeight: FontWeight.bold,
              color: context.textNote,
            ),
          ),
          Expanded(
            child: SliderTheme(
              data: SliderTheme.of(context).copyWith(
                activeTrackColor: context.textClue,
                inactiveTrackColor: context.cellBorder,
                thumbColor: context.textUser,
                overlayColor: context.textUser.withValues(alpha: 0.12),
                trackHeight: 2.0,
                thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6.0),
              ),
              child: Slider(
                value: _currentStepIndex.toDouble(),
                min: 0,
                max: maxSteps == 0 ? 1.0 : maxSteps.toDouble(),
                divisions: maxSteps == 0 ? 1 : maxSteps,
                onChanged: (val) {
                  _stopPlayback();
                  setState(() {
                    _currentStepIndex = val.toInt();
                  });
                },
              ),
            ),
          ),
          Text(
            'END',
            style: TextStyle(
              fontFamily: font,
              fontSize: 9,
              fontWeight: FontWeight.bold,
              color: context.textNote,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlaybackControls(BuildContext context, String font) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Cycle Speed Button
        SizedBox(
          width: 54,
          height: 40,
          child: TactileButton(
            backgroundColor: context.surfaceBg,
            onTap: _cycleSpeed,
            child: Center(
              child: Text(
                '${_speedMultiplier}X',
                style: TextStyle(
                  fontFamily: font,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: context.textUser,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 16),
        
        // Single Step Backwards
        IconButton(
          onPressed: _currentStepIndex > 0 ? _stepBackward : null,
          icon: Icon(
            Icons.skip_previous_rounded,
            color: _currentStepIndex > 0 ? context.textClue : Colors.grey.withValues(alpha: 0.4),
            size: 28,
          ),
        ),
        const SizedBox(width: 12),
        
        // Play / Pause Circle Tactile button
        GestureDetector(
          onTap: () {
            if (_isPlaying) {
              _stopPlayback();
            } else {
              if (_currentStepIndex >= _moves.length) {
                setState(() => _currentStepIndex = 0); // Restart from beginning
              }
              _startPlayback();
            }
          },
          child: Container(
            width: 58,
            height: 58,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: context.textClue,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Icon(
              _isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
              color: context.scaffoldBg,
              size: 32,
            ),
          ),
        ),
        const SizedBox(width: 12),
        
        // Single Step Forwards
        IconButton(
          onPressed: _currentStepIndex < _moves.length ? _stepForward : null,
          icon: Icon(
            Icons.skip_next_rounded,
            color: _currentStepIndex < _moves.length ? context.textClue : Colors.grey.withValues(alpha: 0.4),
            size: 28,
          ),
        ),
        const SizedBox(width: 16),
        
        // Progress Steps Info Box
        SizedBox(
          width: 54,
          height: 40,
          child: Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: context.surfaceBg,
              border: Border.all(color: context.cellBorder),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              '$_currentStepIndex/${_moves.length}',
              style: TextStyle(
                fontFamily: font,
                fontSize: 9,
                fontWeight: FontWeight.bold,
                color: context.textClue,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildReplayDetailsBox(BuildContext context, String font) {
    String actionDesc = 'INITIAL PRINTING STATE LOADING...';
    if (_currentStepIndex > 0 && _currentStepIndex - 1 < _moves.length) {
      final lastMove = _moves[_currentStepIndex - 1];
      final r = lastMove.row + 1;
      final c = lastMove.col + 1;
      final type = lastMove.isNote ? 'DRAFT NOTE' : 'PERMANENT INK';
      
      if (lastMove.val == 0) {
        actionDesc = 'MOVE $_currentStepIndex: ERASED CELL AT ROW $r, COL $c';
      } else {
        actionDesc = 'MOVE $_currentStepIndex: ENTERED $type ${lastMove.val} AT ROW $r, COL $c';
      }
    } else if (_currentStepIndex == _moves.length && _moves.isNotEmpty) {
      actionDesc = 'EDITION SOLVED! FINAL PRINTING PRESS COMMITTED.';
    }

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: context.surfaceBg,
        border: Border.all(color: context.cellBorder, width: 0.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'PRINT WORKSHOP SCANNER',
            style: TextStyle(
              fontFamily: font,
              fontSize: 9,
              fontWeight: FontWeight.bold,
              color: context.textUser,
              letterSpacing: 1.0,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            actionDesc,
            style: TextStyle(
              fontFamily: font,
              fontSize: 11,
              fontStyle: FontStyle.italic,
              color: context.textClue,
            ),
          ),
        ],
      ),
    );
  }
}
