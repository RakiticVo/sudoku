import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../../../core/database/sudoku_database.dart';
import '../../../../core/style/design_system.dart';
import '../cubit/settings_cubit.dart';
import 'replayer_page.dart';

class PressArchivesPage extends StatefulWidget {
  const PressArchivesPage({super.key});

  @override
  State<PressArchivesPage> createState() => _PressArchivesPageState();
}

class _PressArchivesPageState extends State<PressArchivesPage> {
  List<Map<String, dynamic>> _replays = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadReplays();
  }

  Future<void> _loadReplays() async {
    setState(() => _isLoading = true);
    final replays = await SudokuDatabase.instance.getAllReplays();
    setState(() {
      _replays = replays;
      _isLoading = false;
    });
  }

  Future<void> _deleteReplay(String id) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        final state = context.read<SettingsCubit>().state;
        final font = state.activeFontFamily;
        final textClue = context.textClue;

        return AlertDialog(
          backgroundColor: context.surfaceBg,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4.0),
            side: BorderSide(color: textClue, width: 2.0),
          ),
          title: Text(
            'DELETE RECORD?',
            style: TextStyle(
              fontFamily: font,
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: textClue,
            ),
          ),
          content: Text(
            'Are you sure you want to delete this solve record from the printing archives?',
            style: TextStyle(
              fontSize: 14,
              color: textClue,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(
                'CANCEL',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: textClue,
                ),
              ),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: Text(
                'DELETE',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: context.textInvalid,
                ),
              ),
            ),
          ],
        );
      },
    );

    if (confirmed == true) {
      await SudokuDatabase.instance.deleteReplay(id);
      _loadReplays();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Solve record deleted from archives.'),
            duration: Duration(seconds: 1),
          ),
        );
      }
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

        return Scaffold(
          backgroundColor: context.scaffoldBg,
          body: SafeArea(
            child: Column(
              children: [
                _buildHeader(context, font),
                Expanded(
                  child: _isLoading
                      ? const Center(
                          child: CircularProgressIndicator(strokeWidth: 2.0, color: Colors.grey),
                        )
                      : _replays.isEmpty
                          ? _buildEmptyState(context, font)
                          : ListView.builder(
                              physics: const BouncingScrollPhysics(),
                              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                              itemCount: _replays.length,
                              itemBuilder: (context, index) {
                                return Builder(
                                  builder: (context) {
                                    final replay = _replays[index];
                                    final id = replay['id'] as String;
                                    final title = replay['title'] as String;
                                    final difficulty = replay['difficulty'] as String;
                                    final timeTaken = replay['solve_duration_seconds'] as int;
                                    final timestamp = replay['date_timestamp'] as int;
                                    final date = DateTime.fromMillisecondsSinceEpoch(timestamp);
                                    final formattedDate = DateFormat('MMMM dd, yyyy • HH:mm').format(date);

                                    return _buildArchiveItem(
                                      context: context,
                                      id: id,
                                      title: title,
                                      difficulty: difficulty,
                                      timeTaken: timeTaken,
                                      formattedDate: formattedDate,
                                      font: font,
                                      payload: replay['log_payload'] as String,
                                    );
                                  },
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
                    'THE PRESS ARCHIVES',
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
          'HISTORICAL LOGS OF INK-SOLVED PUZZLE REPLAYS',
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

  Widget _buildArchiveItem({
    required BuildContext context,
    required String id,
    required String title,
    required String difficulty,
    required int timeTaken,
    required String formattedDate,
    required String font,
    required String payload,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12.0),
      decoration: BoxDecoration(
        color: context.surfaceBg,
        borderRadius: BorderRadius.circular(4.0),
        border: Border.all(color: context.cellBorder, width: 1.0),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(4.0),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ReplayerPage(
                  id: id,
                  title: title,
                  difficulty: difficulty,
                  solveTimeSeconds: timeTaken,
                  dateFormatted: formattedDate,
                  rawPayload: payload,
                ),
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              border: Border.all(color: context.textClue, width: 0.5),
                              borderRadius: BorderRadius.circular(2),
                            ),
                            child: Text(
                              difficulty.toUpperCase(),
                              style: TextStyle(
                                fontFamily: font,
                                fontSize: 8,
                                fontWeight: FontWeight.bold,
                                color: context.textClue,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            _formatDuration(timeTaken),
                            style: TextStyle(
                              fontFamily: font,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: context.textUser,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        title.toUpperCase(),
                        style: TextStyle(
                          fontFamily: font,
                          fontSize: 14,
                          fontWeight: FontWeight.w900,
                          color: context.textClue,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        formattedDate,
                        style: TextStyle(
                          fontSize: 11,
                          color: context.textNote,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: Icon(
                    Icons.delete_outline_rounded,
                    color: context.textInvalid.withValues(alpha: 0.8),
                    size: 22,
                  ),
                  onPressed: () => _deleteReplay(id),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context, String font) {
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.archive_outlined,
              size: 48,
              color: context.textNote.withValues(alpha: 0.4),
            ),
            const SizedBox(height: 16),
            Text(
              'ARCHIVES ARE EMPTY',
              style: TextStyle(
                fontFamily: font,
                fontSize: 14,
                fontWeight: FontWeight.bold,
                letterSpacing: 2.0,
                color: context.textClue,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'No puzzle solves have been archived yet. When completing any edition in classic, campaign, or daily challenges, tap the "SAVE REPLAY" option to catalog your solving steps in this ledger.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                color: context.textNote,
                height: 1.4,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
