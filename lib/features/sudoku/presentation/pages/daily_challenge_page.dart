import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/algorithms/daily_challenge_generator.dart';
import '../../../../core/style/design_system.dart';
import '../cubit/daily_challenge_cubit.dart';
import '../cubit/settings_cubit.dart';
import 'game_page.dart';

class DailyChallengePage extends StatefulWidget {
  const DailyChallengePage({super.key});

  @override
  State<DailyChallengePage> createState() => _DailyChallengePageState();
}

class _DailyChallengePageState extends State<DailyChallengePage> {
  late final DateTime _currentMonthDate;
  
  @override
  void initState() {
    super.initState();
    _currentMonthDate = DateTime.now();
  }

  String _getMonthName(int month) {
    const months = [
      'JANUARY', 'FEBRUARY', 'MARCH', 'APRIL', 'MAY', 'JUNE',
      'JULY', 'AUGUST', 'SEPTEMBER', 'OCTOBER', 'NOVEMBER', 'DECEMBER'
    ];
    return months[month - 1];
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsCubit, SettingsState>(
      builder: (context, settingsState) {
        final font = settingsState.activeFontFamily;
        final activeStamp = settingsState.activeStampStyle;

        return Scaffold(
          backgroundColor: context.scaffoldBg,
          body: SafeArea(
            child: Column(
              children: [
                _buildHeader(context, font),
                Expanded(
                  child: BlocBuilder<DailyChallengeCubit, DailyChallengeState>(
                    builder: (context, state) {
                      if (state.isLoading) {
                        return const Center(
                          child: CircularProgressIndicator(strokeWidth: 2.0, color: Colors.grey),
                        );
                      }

                      return SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            // Blurb
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: context.surfaceBg,
                                border: Border.all(color: context.cellBorder, width: 1),
                              ),
                              child: Column(
                                children: [
                                  Text(
                                    'THE DAILY GAZETTE REPORT',
                                    style: TextStyle(
                                      fontFamily: font,
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 1.0,
                                      color: context.textUser,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Each morning brings a new deterministic layout crafted by the Editor. Complete the edition to receive double the typical ink rewards (+20💧 up to +200💧).',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontFamily: font,
                                      fontSize: 11,
                                      fontStyle: FontStyle.italic,
                                      color: context.textNote,
                                      height: 1.4,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 24),

                            // Calendar Month Header
                            Center(
                              child: Text(
                                '${_getMonthName(_currentMonthDate.month)} ${_currentMonthDate.year}',
                                style: TextStyle(
                                  fontFamily: font,
                                  fontSize: 22,
                                  fontWeight: FontWeight.w900,
                                  letterSpacing: 1.5,
                                  color: context.textClue,
                                ),
                              ),
                            ),
                            const SizedBox(height: 12),
                            Container(height: 1.5, color: context.textClue),
                            const SizedBox(height: 8),

                            // Calendar grid
                            _buildCalendarGrid(context, state, activeStamp, font),

                            const SizedBox(height: 24),
                            _buildLegend(context, font),
                          ],
                        ),
                      );
                    },
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
                    'THE DAILY EDITION',
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
          'A FRESH LOGICAL CHALLENGE PRINTED EVERY MORNING',
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

  Widget _buildCalendarGrid(
    BuildContext context,
    DailyChallengeState state,
    String activeStamp,
    String font,
  ) {
    final year = _currentMonthDate.year;
    final month = _currentMonthDate.month;
    
    final firstDayOfMonth = DateTime(year, month, 1);
    final lastDayOfMonth = DateTime(year, month + 1, 0);
    
    final totalDays = lastDayOfMonth.day;
    final leadingEmptyDays = firstDayOfMonth.weekday - 1; // Assuming Monday as start of week
    
    const weekDays = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];

    return Table(
      border: TableBorder(
        horizontalInside: BorderSide(color: context.cellBorder, width: 0.5),
        verticalInside: BorderSide(color: context.cellBorder, width: 0.5),
        bottom: BorderSide(color: context.textClue, width: 1.5),
        top: BorderSide(color: context.textClue, width: 1.5),
      ),
      children: [
        // Days of week header
        TableRow(
          decoration: BoxDecoration(
            color: context.isDark ? const Color(0x3D000000) : Colors.grey[200],
          ),
          children: weekDays.map((d) {
            return Container(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              alignment: Alignment.center,
              child: Text(
                d,
                style: TextStyle(
                  fontFamily: font,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: context.textClue,
                ),
              ),
            );
          }).toList(),
        ),
        
        // Days row generator
        ...List.generate(((totalDays + leadingEmptyDays) / 7).ceil(), (rowIndex) {
          return TableRow(
            children: List.generate(7, (colIndex) {
              final dayIndex = rowIndex * 7 + colIndex - leadingEmptyDays;
              if (dayIndex < 0 || dayIndex >= totalDays) {
                return const SizedBox(height: 70); // Empty leading/trailing cell
              }

              final currentDayNumber = dayIndex + 1;
              final cellDate = DateTime(year, month, currentDayNumber);
              final dateKey = "${cellDate.year}-${cellDate.month.toString().padLeft(2, '0')}-${cellDate.day.toString().padLeft(2, '0')}";
              
              final isCompleted = state.completedChallenges.containsKey(dateKey);
              final completedInfo = state.completedChallenges[dateKey];
              
              final today = DateTime.now();
              final isFuture = DateTime(cellDate.year, cellDate.month, cellDate.day)
                  .isAfter(DateTime(today.year, today.month, today.day));
                  
              final difficulty = DailyChallengeGenerator.getDifficultyForDate(cellDate);
              final seed = DailyChallengeGenerator.getSeedForDate(cellDate);

              return _buildCalendarCell(
                context: context,
                dayNum: currentDayNumber,
                difficulty: difficulty,
                seed: seed,
                dateKey: dateKey,
                isCompleted: isCompleted,
                completedInfo: completedInfo,
                isFuture: isFuture,
                activeStamp: activeStamp,
                font: font,
              );
            }),
          );
        }),
      ],
    );
  }

  Widget _buildCalendarCell({
    required BuildContext context,
    required int dayNum,
    required String difficulty,
    required int seed,
    required String dateKey,
    required bool isCompleted,
    required Map<String, dynamic>? completedInfo,
    required bool isFuture,
    required String activeStamp,
    required String font,
  }) {
    Color cellBg = context.surfaceBg;
    if (isFuture) {
      cellBg = context.isDark ? Colors.grey[900]! : Colors.grey[100]!;
    }

    final diffAbbrev = difficulty.substring(0, 3).toUpperCase();
    final diffColor = _getDifficultyColor(context, difficulty);

    return InkWell(
      onTap: isFuture
          ? () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Future editions are locked. Play them on their printing day!'),
                  duration: Duration(seconds: 1),
                ),
              );
            }
          : () async {
              if (isCompleted) {
                final duration = completedInfo?['solve_time'] as int? ?? 0;
                final reward = completedInfo?['reward'] as int? ?? 0;
                final min = duration ~/ 60;
                final sec = duration % 60;
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Completed on $dateKey in ${min}m ${sec}s! Earned +$reward💧 droplets.',
                    ),
                    duration: const Duration(seconds: 2),
                  ),
                );
                return;
              }

              final challengeCubit = context.read<DailyChallengeCubit>();
              // Play challenge!
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => GamePage(
                    difficulty: difficulty,
                    seed: seed,
                    dailyDate: dateKey,
                  ),
                ),
              );
              // Reload challenges info
              if (mounted) {
                challengeCubit.loadChallenges();
              }
            },
      child: Container(
        color: cellBg,
        height: 70,
        padding: const EdgeInsets.all(4.0),
        child: Stack(
          children: [
            // Date number
            Positioned(
              top: 2,
              left: 2,
              child: Text(
                '$dayNum',
                style: TextStyle(
                  fontFamily: font,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: isFuture
                      ? context.textNote.withValues(alpha: 0.4)
                      : context.textClue,
                ),
              ),
            ),

            // Difficulty tag
            if (!isFuture && !isCompleted)
              Positioned(
                bottom: 2,
                left: 2,
                child: Text(
                  diffAbbrev,
                  style: TextStyle(
                    fontFamily: font,
                    fontSize: 7,
                    fontWeight: FontWeight.bold,
                    color: diffColor,
                  ),
                ),
              ),

            // Locked indicator
            if (isFuture)
              const Positioned(
                bottom: 2,
                right: 2,
                child: Icon(Icons.lock_outline, size: 10, color: Colors.grey),
              ),

            // Solve Stamp Overlay
            if (isCompleted)
              Center(
                child: Transform.rotate(
                  angle: -0.15,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1.5),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: context.textUser.withValues(alpha: 0.75),
                        width: 1.2,
                      ),
                      borderRadius: BorderRadius.circular(2),
                    ),
                    child: Text(
                      activeStamp.toUpperCase(),
                      maxLines: 1,
                      style: TextStyle(
                        fontFamily: font,
                        color: context.textUser.withValues(alpha: 0.75),
                        fontSize: 6.5,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Color _getDifficultyColor(BuildContext context, String difficulty) {
    switch (difficulty.toLowerCase()) {
      case 'easy':
        return Colors.green;
      case 'medium':
        return context.isDark ? Colors.orange[300]! : Colors.orange[800]!;
      case 'hard':
        return context.textInvalid;
      case 'expert':
      default:
        return Colors.purple;
    }
  }

  Widget _buildLegend(BuildContext context, String font) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: context.surfaceBg,
        border: Border.all(color: context.cellBorder, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'DAILY EDITION LEGEND',
            style: TextStyle(
              fontFamily: font,
              fontSize: 10,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.0,
              color: context.textClue,
            ),
          ),
          const SizedBox(height: 8),
          _buildLegendRow('EAS', 'Monday Easy Edition (Reward: 20💧)', Colors.green, font, context),
          const SizedBox(height: 4),
          _buildLegendRow('MED', 'Tuesday/Wednesday Medium Edition (Reward: 50💧)', context.isDark ? Colors.orange[300]! : Colors.orange[800]!, font, context),
          const SizedBox(height: 4),
          _buildLegendRow('HAR', 'Thursday/Friday Hard Edition (Reward: 100💧)', context.textInvalid, font, context),
          const SizedBox(height: 4),
          _buildLegendRow('EXP', 'Saturday/Sunday Expert Edition (Reward: 200💧)', Colors.purple, font, context),
        ],
      ),
    );
  }

  Widget _buildLegendRow(String abbrev, String description, Color color, String font, BuildContext context) {
    return Row(
      children: [
        Container(
          width: 28,
          alignment: Alignment.center,
          padding: const EdgeInsets.all(2),
          decoration: BoxDecoration(
            border: Border.all(color: color, width: 0.5),
            borderRadius: BorderRadius.circular(2),
          ),
          child: Text(
            abbrev,
            style: TextStyle(
              fontFamily: font,
              fontSize: 7,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            description,
            style: TextStyle(
              fontSize: 11,
              color: context.textNote,
            ),
          ),
        ),
      ],
    );
  }
}
