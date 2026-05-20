import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/database/sudoku_database.dart';
import '../../../../core/di/service_locator.dart';
import '../../../../core/style/design_system.dart';
import '../cubit/settings_cubit.dart';
import '../cubit/economy_cubit.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  int _archivedSolvesCount = 0;
  bool _isLoadingStorage = true;
  late TextEditingController _nameController;

  @override
  void initState() {
    super.initState();
    _loadStorageInfo();
    final initialName = context.read<SettingsCubit>().state.username;
    _nameController = TextEditingController(text: initialName);
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _loadStorageInfo() async {
    setState(() => _isLoadingStorage = true);
    try {
      final db = sl<SudokuDatabase>();
      final replays = await db.getAllReplays();
      if (mounted) {
        setState(() {
          _archivedSolvesCount = replays.length;
          _isLoadingStorage = false;
        });
      }
    } catch (_) {
      if (mounted) {
        setState(() => _isLoadingStorage = false);
      }
    }
  }

  Future<void> _purgeStorage() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        final state = context.read<SettingsCubit>().state;
        final isDark = state.isDarkNewsprint;
        final font = state.activeFontFamily;
        final ink = state.activeInkColorName;
        final textClue = AppColors.getInk(isDark, ink).textClue;

        return AlertDialog(
          backgroundColor: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4.0),
            side: BorderSide(color: textClue, width: 2.0),
          ),
          title: Text(
            'PURGE ARCHIVES?',
            style: TextStyle(
              fontFamily: font,
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: textClue,
            ),
          ),
          content: Text(
            'This will permanently delete all your selective replay solves. This cannot be undone.',
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
                'PURGE',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: isDark ? const Color(0xFFFC8181) : const Color(0xFFC53030),
                ),
              ),
            ),
          ],
        );
      },
    );

    if (confirmed == true) {
      await sl<SudokuDatabase>().purgeAllReplays();
      await _loadStorageInfo();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Archives cleared successfully.'),
            duration: Duration(seconds: 2),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsCubit, SettingsState>(
      builder: (context, state) {
        return BlocBuilder<EconomyCubit, EconomyState>(
          builder: (context, economyState) {
            final isDark = state.isDarkNewsprint;
            final font = state.activeFontFamily;
            final ink = state.activeInkColorName;
            final palette = AppColors.getInk(isDark, ink);

            final scaffoldBg = isDark ? AppColors.backgroundDark : AppColors.backgroundLight;
            final surfaceBg = isDark ? AppColors.surfaceDark : AppColors.surfaceLight;
            final borderThemeColor = isDark ? AppColors.cellBorderDark : AppColors.cellBorderLight;
            final textClueColor = palette.textClue;
            final textUserColor = palette.textUser;

            // Sync controller text if modified outside (like in a test)
            if (_nameController.text != state.username && !FocusScope.of(context).hasFocus) {
              _nameController.text = state.username;
            }

            return Scaffold(
              backgroundColor: scaffoldBg,
              appBar: AppBar(
                backgroundColor: scaffoldBg,
                elevation: 0,
                iconTheme: IconThemeData(color: textClueColor),
                centerTitle: true,
                title: Text(
                  'THE PRESS ROOM',
                  style: TextStyle(
                    fontFamily: font,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2.0,
                    color: textClueColor,
                  ),
                ),
                bottom: PreferredSize(
                  preferredSize: const Size.fromHeight(2.0),
                  child: Container(
                    color: textClueColor,
                    height: 2.0,
                  ),
                ),
              ),
              body: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildSectionHeader('USER PROFILE', font, textClueColor),
                      _buildCard(
                        surfaceBg,
                        textClueColor,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                          child: TextFormField(
                            key: const Key('username_field'),
                            controller: _nameController,
                            style: TextStyle(
                              fontFamily: font,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: textClueColor,
                            ),
                            decoration: InputDecoration(
                              labelText: 'PUBLISHER NAME',
                              labelStyle: TextStyle(
                                fontFamily: font,
                                fontSize: 12,
                                color: textClueColor.withValues(alpha: 0.6),
                              ),
                              border: InputBorder.none,
                              hintText: 'Enter your name...',
                              hintStyle: TextStyle(
                                fontFamily: font,
                                fontSize: 16,
                                color: textClueColor.withValues(alpha: 0.4),
                              ),
                            ),
                            onChanged: (val) {
                              context.read<SettingsCubit>().setUsername(val.trim().isEmpty ? 'User' : val);
                            },
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      _buildSectionHeader('DISPLAY MODES', font, textClueColor),
                      _buildCard(
                        surfaceBg,
                        textClueColor,
                        child: SwitchListTile(
                          activeThumbColor: textUserColor,
                          activeTrackColor: textUserColor.withValues(alpha: 0.2),
                          inactiveThumbColor: isDark ? Colors.white54 : Colors.grey,
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                          title: Text(
                            'Dark Newsprint',
                            style: TextStyle(
                              fontFamily: font,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: textClueColor,
                            ),
                          ),
                          subtitle: Text(
                            'Soft dark palette mimicking deep ink on slate paper for late night solving.',
                            style: TextStyle(
                              fontSize: 12,
                              color: textClueColor.withValues(alpha: 0.7),
                            ),
                          ),
                          value: isDark,
                          onChanged: (val) {
                            context.read<SettingsCubit>().toggleDarkNewsprint(val);
                          },
                        ),
                      ),
                      const SizedBox(height: 24),
                      _buildSectionHeader('HISTORICAL INKS', font, textClueColor),
                      _buildCard(
                        surfaceBg,
                        textClueColor,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Column(
                            children: [
                              _buildInkOption(context, 'Charcoal', 'Bold Dark Charcoal (Standard)', font, state.activeInkColorName, textClueColor, textUserColor, economyState.unlockedInks.contains('Charcoal')),
                              _buildDivider(borderThemeColor),
                              _buildInkOption(context, 'Vintage Sepia', 'Warm sepia photo dye', font, state.activeInkColorName, textClueColor, textUserColor, economyState.unlockedInks.contains('Vintage Sepia')),
                              _buildDivider(borderThemeColor),
                              _buildInkOption(context, 'Prussian Blue', 'Deep Indigo Prussian ink', font, state.activeInkColorName, textClueColor, textUserColor, economyState.unlockedInks.contains('Prussian Blue')),
                              _buildDivider(borderThemeColor),
                              _buildInkOption(context, 'Teal Cyan', 'Sleek premium cyan ink', font, state.activeInkColorName, textClueColor, textUserColor, economyState.unlockedInks.contains('Teal Cyan')),
                              _buildDivider(borderThemeColor),
                              _buildInkOption(context, 'Vintage Orange', 'Classic vibrant orange print', font, state.activeInkColorName, textClueColor, textUserColor, economyState.unlockedInks.contains('Vintage Orange')),
                              _buildDivider(borderThemeColor),
                              _buildInkOption(context, 'Blush Pink', 'Harmonious vibrant pink dye', font, state.activeInkColorName, textClueColor, textUserColor, economyState.unlockedInks.contains('Blush Pink')),
                              _buildDivider(borderThemeColor),
                              _buildInkOption(context, 'Forest Pine', 'Deep foliage green ink', font, state.activeInkColorName, textClueColor, textUserColor, economyState.unlockedInks.contains('Forest Pine')),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      _buildSectionHeader('STORAGE MANAGEMENT', font, textClueColor),
                      _buildCard(
                        surfaceBg,
                        textClueColor,
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(16.0),
                          title: Text(
                            'Replay Solves Archive',
                            style: TextStyle(
                              fontFamily: font,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: textClueColor,
                            ),
                          ),
                          subtitle: _isLoadingStorage
                              ? const Text('Calculating size...')
                              : Text(
                                  'Currently storing $_archivedSolvesCount custom solve log(s) (~${_archivedSolvesCount * 5} KB database space).',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: textClueColor.withValues(alpha: 0.7),
                                  ),
                                ),
                          trailing: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: isDark ? const Color(0xFF3D2020) : const Color(0xFFFFF5F5),
                              side: BorderSide(
                                color: isDark ? const Color(0xFFFC8181) : const Color(0xFFC53030),
                                width: 1.2,
                              ),
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4.0),
                              ),
                            ),
                            onPressed: _archivedSolvesCount > 0 ? _purgeStorage : null,
                            child: Text(
                              'PURGE',
                              style: TextStyle(
                                fontFamily: font,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                                color: isDark ? const Color(0xFFFC8181) : const Color(0xFFC53030),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 48),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildSectionHeader(String title, String font, Color color) {
    return Padding(
      padding: const EdgeInsets.only(left: 4.0, bottom: 8.0),
      child: Text(
        title,
        style: TextStyle(
          fontFamily: font,
          fontSize: 12,
          fontWeight: FontWeight.bold,
          letterSpacing: 2.0,
          color: color.withValues(alpha: 0.8),
        ),
      ),
    );
  }

  Widget _buildCard(Color bg, Color borderColor, {required Widget child}) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(4.0),
        border: Border.all(color: borderColor, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: child,
    );
  }

  Widget _buildInkOption(
    BuildContext context,
    String value,
    String displayName,
    String headerFont,
    String selectedValue,
    Color textClueColor,
    Color textUserColor,
    bool isUnlocked,
  ) {
    final isSelected = selectedValue == value;
    final titleText = isUnlocked ? displayName : '$displayName 🔒';
    return RadioListTile<String>(
      activeColor: textUserColor,
      title: Row(
        children: [
          Container(
            width: 14,
            height: 14,
            decoration: BoxDecoration(
              color: _getPreviewColor(value),
              shape: BoxShape.circle,
              border: Border.all(color: textClueColor, width: 1.0),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              titleText,
              style: TextStyle(
                fontFamily: headerFont,
                fontSize: 15,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isUnlocked ? textClueColor : textClueColor.withValues(alpha: 0.5),
              ),
            ),
          ),
        ],
      ),
      value: value,
      groupValue: selectedValue,
      onChanged: isUnlocked
          ? (val) {
              if (val != null) {
                context.read<SettingsCubit>().setInkColor(val);
              }
            }
          : null,
    );
  }

  Color _getPreviewColor(String inkName) {
    switch (inkName) {
      case 'Vintage Sepia':
        return const Color(0xFF704214);
      case 'Prussian Blue':
        return const Color(0xFF003153);
      case 'Teal Cyan':
        return const Color(0xFF0D7A80);
      case 'Vintage Orange':
        return const Color(0xFFC85A17);
      case 'Blush Pink':
        return const Color(0xFFD53F8C);
      case 'Forest Pine':
        return const Color(0xFF224D17);
      case 'Charcoal':
      default:
        return const Color(0xFF1E2022);
    }
  }

  Widget _buildDivider(Color color) {
    return Divider(
      height: 1,
      thickness: 0.75,
      color: color,
    );
  }
}
