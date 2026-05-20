import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import '../../../../core/style/design_system.dart';
import '../../domain/repositories/sudoku_repository.dart';
import '../widgets/control_pad.dart';
import '../cubit/economy_cubit.dart';
import '../cubit/settings_cubit.dart';
import 'game_page.dart';
import 'settings_page.dart';
import 'campaign_page.dart';
import 'daily_challenge_page.dart';
import 'press_archives_page.dart';
import 'shop_page.dart';

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

  void _showQuickPlayDialog(BuildContext context) {
    final settingsState = context.read<SettingsCubit>().state;
    final isDark = settingsState.isDarkNewsprint;
    final font = settingsState.activeFontFamily;
    final ink = settingsState.activeInkColorName;
    final palette = AppColors.getInk(isDark, ink);
    final textClue = palette.textClue;
    final surfaceBg = isDark ? AppColors.surfaceDark : AppColors.surfaceLight;

    showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: surfaceBg,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4.0),
            side: BorderSide(color: textClue, width: 2.0),
          ),
          title: Center(
            child: Text(
              'SELECT DIFFICULTY',
              style: TextStyle(
                fontFamily: font,
                fontWeight: FontWeight.bold,
                fontSize: 18,
                letterSpacing: 2.0,
                color: textClue,
              ),
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildDialogDifficultyOption(context, 'Beginner', 'easy', font, textClue),
              const SizedBox(height: 10),
              _buildDialogDifficultyOption(context, 'Medium', 'medium', font, textClue),
              const SizedBox(height: 10),
              _buildDialogDifficultyOption(context, 'Hard', 'hard', font, textClue),
              const SizedBox(height: 10),
              _buildDialogDifficultyOption(context, 'Expert', 'expert', font, textClue),
            ],
          ),
          actions: [
            Center(
              child: TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text(
                  'CLOSE',
                  style: TextStyle(
                    fontFamily: font,
                    fontWeight: FontWeight.bold,
                    color: textClue,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildDialogDifficultyOption(
    BuildContext context,
    String label,
    String difficultyKey,
    String font,
    Color color,
  ) {
    return SizedBox(
      width: double.infinity,
      height: 44,
      child: TactileButton(
        key: Key('diff_opt_$difficultyKey'),
        backgroundColor: context.keyBg,
        onTap: () {
          Navigator.of(context).pop();
          _navigateToGame(difficulty: difficultyKey, isResume: false);
        },
        child: Center(
          child: Text(
            label.toUpperCase(),
            style: TextStyle(
              fontFamily: font,
              fontWeight: FontWeight.bold,
              fontSize: 14,
              letterSpacing: 1.0,
              color: color,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.scaffoldBg,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Top Action Row
              _buildTopRow(context),
              const SizedBox(height: 24),
              
              // Vintage Printed Header Brand
              _buildBrandHeader(context),
              const SizedBox(height: 28),

              // Resume Game if exists
              if (_hasSavedGame) ...[
                _buildResumeButton(context),
              ],

              // Quick Play Section
              _buildSpecialEditionCard(
                key: const Key('quick_play_card'),
                context: context,
                title: 'PLAY QUICK EDITION',
                subtitle: 'Select from Beginner, Medium, Hard, or Expert logical editions to solve instantly.',
                icon: Icons.bolt_outlined,
                onTap: () => _showQuickPlayDialog(context),
              ),
              const SizedBox(height: 28),

              // Special Editions list
              _buildSpecialEditionCard(
                context: context,
                title: 'THE EDITORIAL JOURNEY',
                subtitle: 'Theme-based puzzle volumes. Complete challenges to publish articles and earn grand droplets rewards.',
                icon: Icons.menu_book_rounded,
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const CampaignPage()),
                ),
              ),
              _buildSpecialEditionCard(
                context: context,
                title: 'THE DAILY EDITION',
                subtitle: 'A fresh challenge printed every morning. Play today\'s puzzle for double droplets!',
                icon: Icons.calendar_today_rounded,
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const DailyChallengePage()),
                ),
              ),
              _buildSpecialEditionCard(
                context: context,
                title: 'THE PRESS ARCHIVES',
                subtitle: 'Action-logs timeline replayer of your historical publications with scrubbers and speeds.',
                icon: Icons.history_edu_rounded,
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const PressArchivesPage()),
                ),
              ),
              const SizedBox(height: 24),

              // Footer Stamp
              Center(
                child: Text(
                  'No. 4694 • EST. 2026',
                  style: TextStyle(
                    fontFamily: context.fontFamily,
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: context.textNote.withValues(alpha: 0.8),
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTopRow(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Left: Personalized greeting label
        BlocBuilder<SettingsCubit, SettingsState>(
          builder: (context, settingsState) {
            final username = settingsState.username;
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                border: Border.all(color: context.cellBorder, width: 0.8),
                borderRadius: BorderRadius.circular(2),
              ),
              child: Text(
                'Hello $username',
                style: TextStyle(
                  fontFamily: context.fontFamily,
                  fontSize: 8,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                  color: context.textNote,
                ),
              ),
            );
          },
        ),
        
        // Right: Droplets & Settings
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Droplets badge
            BlocBuilder<EconomyCubit, EconomyState>(
              builder: (context, economyState) {
                return GestureDetector(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const ShopPage()),
                  ),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: context.surfaceBg,
                      border: Border.all(color: context.cellBorder, width: 1.2),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '💧',
                          style: TextStyle(
                            fontSize: 12,
                            color: context.textUser,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${economyState.balance}',
                          style: TextStyle(
                            fontFamily: context.fontFamily,
                            fontSize: 12,
                            fontWeight: FontWeight.w900,
                            color: context.textUser,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
            const SizedBox(width: 4),
            // Settings button
            IconButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SettingsPage()),
              ),
              icon: Icon(
                Icons.settings_outlined,
                color: context.keyText,
                size: 20,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildBrandHeader(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Text(
            'THE CLASSIC',
            style: TextStyle(
              fontFamily: context.fontFamily,
              fontSize: 13,
              fontWeight: FontWeight.bold,
              letterSpacing: 5.0,
              color: context.keyText.withValues(alpha: 0.8),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'S U D O K U',
            style: TextStyle(
              fontFamily: context.fontFamily,
              fontSize: 42,
              fontWeight: FontWeight.w900,
              letterSpacing: 3.5,
              color: context.textClue,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            width: 140,
            height: 1.5,
            color: context.subgridBorder,
          ),
          const SizedBox(height: 8),
          Text(
            'Tactile Newsprint Edition',
            style: TextStyle(
              fontFamily: context.fontFamily,
              fontSize: 12,
              fontStyle: FontStyle.italic,
              color: context.textNote,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionDivider(BuildContext context, String text) {
    return Row(
      children: [
        Expanded(child: Divider(color: context.cellBorder, thickness: 1)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: Text(
            text,
            style: TextStyle(
              fontFamily: context.fontFamily,
              fontSize: 11,
              fontWeight: FontWeight.bold,
              letterSpacing: 2.0,
              color: context.textClue,
            ),
          ),
        ),
        Expanded(child: Divider(color: context.cellBorder, thickness: 1)),
      ],
    );
  }

  Widget _buildResumeButton(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 24.0),
      child: TactileButton(
        backgroundColor: context.keyBg,
        onTap: () => _navigateToGame(difficulty: _savedDifficulty, isResume: true),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 20.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.play_arrow_rounded,
                color: context.textClue,
                size: 24,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'RESUME GAME',
                      style: TextStyle(
                        fontFamily: context.fontFamily,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.0,
                        color: context.textClue,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Continue your ${_savedDifficulty.toUpperCase()} edition puzzle',
                      style: TextStyle(
                        fontFamily: context.fontFamily,
                        fontSize: 11,
                        color: context.keyText,
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

  Widget _buildSpecialEditionCard({
    required BuildContext context,
    required String title,
    required String subtitle,
    required IconData icon,
    required VoidCallback onTap,
    Key? key,
  }) {
    return Container(
      key: key,
      margin: const EdgeInsets.only(bottom: 12.0),
      decoration: BoxDecoration(
        color: context.surfaceBg,
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(color: context.cellBorder, width: 1.2),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(8.0),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10.0),
                  decoration: BoxDecoration(
                    color: context.keyBg,
                    borderRadius: BorderRadius.circular(6.0),
                    border: Border.all(color: context.cellBorder, width: 0.8),
                  ),
                  child: Icon(
                    icon,
                    color: context.textUser,
                    size: 22,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontFamily: context.fontFamily,
                          fontSize: 14,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 0.5,
                          color: context.textClue,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        subtitle,
                        style: TextStyle(
                          fontFamily: context.fontFamily,
                          fontSize: 11,
                          color: context.textNote,
                          height: 1.3,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Icon(
                  Icons.chevron_right_rounded,
                  size: 18,
                  color: context.keyText,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
