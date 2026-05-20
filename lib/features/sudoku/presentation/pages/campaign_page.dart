import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/style/design_system.dart';
import '../cubit/campaign_cubit.dart';
import '../widgets/control_pad.dart';
import 'game_page.dart';

class CampaignPage extends StatelessWidget {
  const CampaignPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: context.scaffoldBg,
        body: SafeArea(
          child: Column(
            children: [
              _buildHeader(context),
              Expanded(
                child: BlocBuilder<CampaignCubit, CampaignState>(
                  builder: (context, state) {
                    if (state.isLoading) {
                      return const Center(
                        child: CircularProgressIndicator(strokeWidth: 2.0, color: Colors.grey),
                      );
                    }

                    if (state.volumes.length < 3) {
                      return const Center(child: Text('Loading volumes...'));
                    }

                    return TabBarView(
                      children: List.generate(3, (index) {
                        final volume = state.volumes[index];
                        final completions = state.completionStatus[volume.id] ?? [];
                        final completedCount = completions.where((c) => c).length;
                        final totalCount = volume.levels.length;
                        final isFullyCompleted = completedCount == totalCount;

                        return SingleChildScrollView(
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: _buildVolumeSection(
                              context,
                              volume: volume,
                              completions: completions,
                              completedCount: completedCount,
                              totalCount: totalCount,
                              isFullyCompleted: isFullyCompleted,
                            ),
                          ),
                        );
                      }),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
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
                    'EDITORIAL JOURNEY',
                    style: TextStyle(
                      fontFamily: context.fontFamily,
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
        TabBar(
          indicatorColor: context.textClue,
          indicatorSize: TabBarIndicatorSize.tab,
          dividerColor: Colors.transparent,
          labelColor: context.textClue,
          labelStyle: TextStyle(
            fontFamily: context.fontFamily,
            fontWeight: FontWeight.w900,
            fontSize: 11,
            letterSpacing: 1.0,
          ),
          unselectedLabelColor: context.textNote.withValues(alpha: 0.7),
          unselectedLabelStyle: TextStyle(
            fontFamily: context.fontFamily,
            fontWeight: FontWeight.bold,
            fontSize: 10,
          ),
          tabs: const [
            Tab(text: '1456 GUTENBERG'),
            Tab(text: '1833 PENNY ERA'),
            Tab(text: '1920 TIMES'),
          ],
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

  Widget _buildVolumeSection(
    BuildContext context, {
    required CampaignVolume volume,
    required List<bool> completions,
    required int completedCount,
    required int totalCount,
    required bool isFullyCompleted,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 24.0),
      decoration: BoxDecoration(
        color: context.surfaceBg,
        border: Border.all(
          color: isFullyCompleted ? context.textUser : context.cellBorder,
          width: isFullyCompleted ? 1.5 : 1.0,
        ),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Volume Header
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'VOLUME • ${volume.year}',
                      style: TextStyle(
                        fontFamily: context.fontFamily,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: isFullyCompleted ? context.textUser : context.textNote,
                        letterSpacing: 1.0,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: isFullyCompleted
                            ? context.textUser.withValues(alpha: 0.1)
                            : context.keyBg,
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(
                          color: isFullyCompleted ? context.textUser : context.cellBorder,
                          width: 0.5,
                        ),
                      ),
                      child: Text(
                        '$completedCount / $totalCount EDITIONS',
                        style: TextStyle(
                          fontFamily: context.fontFamily,
                          fontSize: 9,
                          fontWeight: FontWeight.bold,
                          color: isFullyCompleted ? context.textUser : context.keyText,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  volume.title.toUpperCase(),
                  style: TextStyle(
                    fontFamily: context.fontFamily,
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                    color: context.textClue,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  volume.subtitle,
                  style: TextStyle(
                    fontFamily: context.fontFamily,
                    fontSize: 11,
                    fontStyle: FontStyle.italic,
                    color: context.textNote,
                  ),
                ),
                const SizedBox(height: 8),
                Container(height: 0.8, color: context.cellBorder),
              ],
            ),
          ),

          // Levels Matrix
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Wrap(
              spacing: 8.0,
              runSpacing: 8.0,
              children: List.generate(volume.levels.length, (idx) {
                final level = volume.levels[idx];
                final isCompleted = completions[idx];

                // Locked mechanics: Level is locked if previous is not completed (except first level)
                final isLocked = idx > 0 && !completions[idx - 1];

                return SizedBox(
                  width: 58,
                  height: 52,
                  child: TactileButton(
                    isActive: isCompleted,
                    backgroundColor: isLocked
                        ? (context.isDark ? Colors.grey[900] : Colors.grey[200])
                        : context.keyBg,
                    borderColor: isCompleted ? context.textUser : null,
                    onTap: isLocked
                        ? () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Complete previous editions to unlock this print stage.'),
                                duration: Duration(seconds: 1),
                              ),
                            );
                          }
                          : () {
                              final campaignCubit = context.read<CampaignCubit>();
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => GamePage(
                                    difficulty: level.difficulty,
                                    volumeId: volume.id,
                                    levelIndex: level.index,
                                    seed: level.seed,
                                  ),
                                ),
                              ).then((_) {
                                campaignCubit.loadProgress();
                              });
                            },
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'ED. ${level.index + 1}',
                              style: TextStyle(
                                fontFamily: context.fontFamily,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: isLocked
                                    ? context.textNote.withValues(alpha: 0.5)
                                    : context.keyText,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              level.difficulty.substring(0, 3).toUpperCase(),
                              style: TextStyle(
                                fontFamily: context.fontFamily,
                                fontSize: 7,
                                fontWeight: FontWeight.bold,
                                color: isLocked
                                    ? context.textNote.withValues(alpha: 0.5)
                                    : (level.difficulty == 'hard'
                                        ? context.textInvalid
                                        : context.textNote),
                              ),
                            ),
                          ],
                        ),
                        if (isCompleted)
                          Positioned(
                            top: 2,
                            right: 2,
                            child: Icon(
                              Icons.verified,
                              size: 10,
                              color: context.textUser,
                            ),
                          ),
                        if (isLocked)
                          Positioned(
                            top: 2,
                            right: 2,
                            child: Icon(
                              Icons.lock_outline,
                              size: 10,
                              color: context.textNote.withValues(alpha: 0.5),
                            ),
                          ),
                      ],
                    ),
                  ),
                );
              }),
            ),
          ),

          // Historical Reader Button
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SizedBox(
              height: 44,
              child: TactileButton(
                isActive: !isFullyCompleted,
                backgroundColor: isFullyCompleted ? context.textUser : context.keyBg,
                borderColor: isFullyCompleted ? context.textUser : null,
                onTap: isFullyCompleted
                    ? () => _showBroadsheetArticle(context, volume)
                    : () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'Complete all 100 editions to unlock the Historical Front Page broadsheet reward (+${volume.dropletReward}💧).',
                            ),
                          ),
                        );
                      },
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.newspaper_rounded,
                        color: isFullyCompleted ? Colors.white : context.keyText,
                        size: 18,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        isFullyCompleted ? 'READ ERA FRONT PAGE' : 'VOLUME LOCKED',
                        style: TextStyle(
                          fontFamily: context.fontFamily,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: isFullyCompleted ? Colors.white : context.textNote,
                          letterSpacing: 1.0,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showBroadsheetArticle(BuildContext context, CampaignVolume volume) {
    showDialog<void>(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          elevation: 0,
          child: Container(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.8,
            ),
            padding: const EdgeInsets.all(24.0),
            decoration: BoxDecoration(
              color: context.scaffoldBg, // Yellowish aged print paper
              borderRadius: BorderRadius.circular(4.0),
              border: Border.all(color: context.gridOuter, width: 3.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.16),
                  blurRadius: 32,
                  offset: const Offset(0, 12),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Historical Broadside Masthead Header
                Center(
                  child: Text(
                    volume.editorialTitle,
                    style: TextStyle(
                      fontFamily: context.fontFamily,
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1.5,
                      color: context.textClue,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 2),
                Container(height: 2, color: context.textClue),
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'ESTABLISHED ${volume.year}',
                      style: TextStyle(
                        fontFamily: context.fontFamily,
                        fontSize: 8,
                        fontWeight: FontWeight.bold,
                        color: context.textClue,
                      ),
                    ),
                    Text(
                      'MAINZ & BROADWAY EDITION',
                      style: TextStyle(
                        fontFamily: context.fontFamily,
                        fontSize: 8,
                        fontWeight: FontWeight.bold,
                        color: context.textClue,
                      ),
                    ),
                    Text(
                      'PRICE: ONE CENT',
                      style: TextStyle(
                        fontFamily: context.fontFamily,
                        fontSize: 8,
                        fontWeight: FontWeight.bold,
                        color: context.textClue,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Container(height: 1, color: context.textClue),
                const SizedBox(height: 16),

                // Core Article text laid out in Gutenberg broadsheet style
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'CONGRATULATIONS ON COMPLETING VOLUME ${volume.year}!',
                          style: TextStyle(
                            fontFamily: context.fontFamily,
                            fontSize: 12,
                            fontWeight: FontWeight.w900,
                            color: context.textUser,
                          ),
                        ),
                        const SizedBox(height: 12),
                        // Double column layout emulation
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Big Drop Capital letter emulation!
                            Text(
                              volume.editorialContent.substring(0, 1),
                              style: TextStyle(
                                fontFamily: context.fontFamily,
                                fontSize: 44,
                                fontWeight: FontWeight.bold,
                                height: 0.8,
                                color: context.textClue,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                volume.editorialContent.substring(1),
                                style: TextStyle(
                                  fontFamily: context.fontFamily,
                                  fontSize: 12,
                                  height: 1.5,
                                  color: context.textClue,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Center(
                          child: Icon(
                            Icons.local_printshop_outlined,
                            size: 32,
                            color: context.textNote.withValues(alpha: 0.5),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Container(height: 1, color: context.cellBorder),
                const SizedBox(height: 12),
                SizedBox(
                  height: 44,
                  child: TactileButton(
                    backgroundColor: context.keyBg,
                    onTap: () => Navigator.pop(context),
                    child: Center(
                      child: Text(
                        'DISMISS FRONT PAGE',
                        style: TextStyle(
                          fontFamily: context.fontFamily,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: context.keyText,
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
    );
  }
}
