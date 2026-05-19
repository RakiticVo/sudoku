import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import '../../../../core/style/design_system.dart';
import '../../domain/repositories/sudoku_repository.dart';
import '../widgets/control_pad.dart';
import 'game_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _hasSavedGame = false;
  String _savedDifficulty = 'medium';
  final SudokuRepository _repository = GetIt.I<SudokuRepository>();

  @override
  void initState() {
    super.initState();
    _checkSavedGame();
  }

  Future<void> _checkSavedGame() async {
    final hasSaved = await _repository.hasSavedGame();
    if (hasSaved) {
      final savedState = await _repository.loadGameState();
      if (savedState != null) {
        if (mounted) {
          setState(() {
            _hasSavedGame = true;
            _savedDifficulty = savedState.difficulty;
          });
        }
        return;
      }
    }
    if (mounted) {
      setState(() {
        _hasSavedGame = false;
      });
    }
  }

  Future<void> _navigateToGame({required String difficulty, bool isResume = false}) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => GamePage(
          difficulty: difficulty,
          isResume: isResume,
        ),
      ),
    );
    // Refresh the saved game state when returning
    _checkSavedGame();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight,
                ),
                child: IntrinsicHeight(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 24.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const Spacer(flex: 2),
                        
                        // Vintage Printed Header Sheet Brand
                        Center(
                          child: Column(
                            children: [
                              Text(
                                'THE CLASSIC',
                                style: TextStyle(
                                  fontFamily: 'Georgia',
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 4.0,
                                  color: AppColors.keyText.withValues(alpha: 0.8),
                                ),
                              ),
                              const SizedBox(height: 8),
                              const Text(
                                'S U D O K U',
                                style: TextStyle(
                                  fontFamily: 'Georgia',
                                  fontSize: 48,
                                  fontWeight: FontWeight.w900,
                                  letterSpacing: 2.0,
                                  color: AppColors.textClue,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Container(
                                width: 140,
                                height: 1.5,
                                color: AppColors.subgridBorder,
                              ),
                              const SizedBox(height: 8),
                              const Text(
                                'Tactile Newsprint Edition',
                                style: TextStyle(
                                  fontStyle: FontStyle.italic,
                                  fontFamily: 'Georgia',
                                  fontSize: 13,
                                  color: AppColors.textNote,
                                ),
                              ),
                            ],
                          ),
                        ),
                        
                        const Spacer(flex: 2),

                        if (_hasSavedGame) ...[
                          _buildResumeButton(context),
                        ],

                        // Difficulty Selection Header
                        Text(
                          'SELECT DIFFICULTY',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: 'Georgia',
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 2.0,
                            color: AppColors.keyText.withValues(alpha: 0.7),
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Difficulty Cards Grid
                        _buildDifficultyButton(context, 'Beginner', 'easy', 'Perfect for learning the mechanics.'),
                        const SizedBox(height: 12),
                        _buildDifficultyButton(context, 'Medium', 'medium', 'Standard challenge with logical scans.'),
                        const SizedBox(height: 12),
                        _buildDifficultyButton(context, 'Hard', 'hard', 'Advanced strategies required. No hints.'),
                        const SizedBox(height: 12),
                        _buildDifficultyButton(context, 'Expert', 'expert', 'Extremely low clues. Ultimate logic.'),

                        const Spacer(flex: 3),

                        // Footer Stamp
                        Center(
                          child: Text(
                            'No. 4694 • EST. 2026',
                            style: TextStyle(
                              fontFamily: 'Georgia',
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textNote.withValues(alpha: 0.8),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildResumeButton(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 24.0),
      child: TactileButton(
        backgroundColor: AppColors.keyBackground,
        onTap: () => _navigateToGame(difficulty: _savedDifficulty, isResume: true),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 20.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.play_arrow_rounded,
                color: AppColors.textClue,
                size: 24,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'RESUME GAME',
                      style: TextStyle(
                        fontFamily: 'Georgia',
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.0,
                        color: AppColors.textClue,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Continue your ${_savedDifficulty.toUpperCase()} edition puzzle',
                      style: const TextStyle(
                        fontSize: 11,
                        color: AppColors.keyText,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDifficultyButton(
    BuildContext context,
    String label,
    String difficultyKey,
    String subtitle,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(color: AppColors.cellBorder, width: 1.2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(8.0),
          onTap: () {
            _navigateToGame(difficulty: difficultyKey, isResume: false);
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        label,
                        style: const TextStyle(
                          fontFamily: 'Georgia',
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textClue,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: const TextStyle(
                          fontSize: 11,
                          color: AppColors.textNote,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 14,
                  color: AppColors.keyText,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
