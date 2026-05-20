import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/style/design_system.dart';
import '../cubit/settings_cubit.dart';
import '../cubit/economy_cubit.dart';
import '../widgets/control_pad.dart';

class ShopPage extends StatelessWidget {
  const ShopPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsCubit, SettingsState>(
      builder: (context, settingsState) {
        final isDark = settingsState.isDarkNewsprint;
        final font = settingsState.activeFontFamily;
        final ink = settingsState.activeInkColorName;
        final palette = AppColors.getInk(isDark, ink);

        final scaffoldBg = isDark ? AppColors.backgroundDark : AppColors.backgroundLight;
        final surfaceBg = isDark ? AppColors.surfaceDark : AppColors.surfaceLight;
        final borderThemeColor = isDark ? AppColors.cellBorderDark : AppColors.cellBorderLight;
        final textClueColor = palette.textClue;
        final textUserColor = palette.textUser;

        return Scaffold(
          backgroundColor: scaffoldBg,
          appBar: AppBar(
            backgroundColor: scaffoldBg,
            elevation: 0,
            iconTheme: IconThemeData(color: textClueColor),
            centerTitle: true,
            title: Text(
              'THE NEWSSTAND',
              style: TextStyle(
                fontFamily: font,
                fontSize: 20,
                fontWeight: FontWeight.bold,
                letterSpacing: 2.0,
                color: textClueColor,
              ),
            ),
            actions: [
              BlocBuilder<EconomyCubit, EconomyState>(
                builder: (context, economyState) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 16.0),
                    child: Center(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          border: Border.all(color: textClueColor, width: 1.5),
                          borderRadius: BorderRadius.circular(4),
                          color: surfaceBg,
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              '💧',
                              style: TextStyle(fontSize: 14, color: textUserColor),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '${economyState.balance}',
                              style: TextStyle(
                                fontFamily: font,
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                                color: textClueColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(2.0),
              child: Container(
                color: textClueColor,
                height: 2.0,
              ),
            ),
          ),
          body: BlocBuilder<EconomyCubit, EconomyState>(
            builder: (context, economyState) {
              return SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Editorial Description
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          border: Border.all(color: borderThemeColor, width: 1),
                          color: surfaceBg,
                        ),
                        child: Text(
                          'Exchange your earned Ink Droplets (💧) gathered from completing puzzle editions to custom-tailor your manual typesetting press experience.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontStyle: FontStyle.italic,
                            fontSize: 12,
                            color: textClueColor.withValues(alpha: 0.8),
                            height: 1.4,
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),

                      _buildSectionHeader('GAMEPLAY UTILITIES', font, textClueColor),
                      _buildUtilitiesShopSection(context, font, textClueColor, surfaceBg, borderThemeColor, economyState, settingsState),
                      const SizedBox(height: 24),

                      _buildSectionHeader('HISTORICAL INK COLORS', font, textClueColor),
                      _buildInkShopSection(context, font, textClueColor, surfaceBg, borderThemeColor, economyState, settingsState),
                      const SizedBox(height: 24),

                      _buildSectionHeader('EDITORIAL PRESS STAMPS', font, textClueColor),
                      _buildStampShopSection(context, font, textClueColor, surfaceBg, borderThemeColor, economyState, settingsState),
                      const SizedBox(height: 48),
                    ],
                  ),
                ),
              );
            },
          ),
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
      ),
      child: child,
    );
  }

  Widget _buildUtilitiesShopSection(
    BuildContext context,
    String font,
    Color textClueColor,
    Color surfaceBg,
    Color borderThemeColor,
    EconomyState economyState,
    SettingsState settingsState,
  ) {
    final utilities = [
      {
        'name': 'Logical Hint Token',
        'desc': 'Acquire a token for a logical grid reveal. Capped at 50 max.',
        'cost': 50,
        'wallet': '${economyState.hints} / 50',
        'isHint': true,
        'isCapped': economyState.hints >= 50,
      },
      {
        'name': 'Revive Token',
        'desc': 'Roll back 1 mistake on a game over screen. Capped at 1 per session.',
        'cost': 500,
        'wallet': '${economyState.revives}',
        'isHint': false,
        'isCapped': false,
      },
    ];

    return _buildCard(
      surfaceBg,
      textClueColor,
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: utilities.length,
        separatorBuilder: (context, index) => Divider(height: 1, thickness: 0.75, color: borderThemeColor),
        itemBuilder: (context, index) {
          final item = utilities[index];
          final name = item['name'] as String;
          final desc = item['desc'] as String;
          final cost = item['cost'] as int;
          final wallet = item['wallet'] as String;
          final isHint = item['isHint'] as bool;
          final isCapped = item['isCapped'] as bool;

          final unlockedColor = AppColors.getInk(settingsState.isDarkNewsprint, settingsState.activeInkColorName).textUser;

          return ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            title: Text(
              name,
              style: TextStyle(
                fontFamily: font,
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: textClueColor,
              ),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  desc,
                  style: TextStyle(
                    fontSize: 11,
                    color: textClueColor.withValues(alpha: 0.7),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Wallet: $wallet',
                  style: TextStyle(
                    fontFamily: font,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: textClueColor.withValues(alpha: 0.9),
                  ),
                ),
              ],
            ),
            trailing: isCapped
                ? Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      border: Border.all(color: textClueColor.withValues(alpha: 0.5), width: 1.5),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      'MAX 50',
                      style: TextStyle(
                        fontFamily: font,
                        fontWeight: FontWeight.bold,
                        fontSize: 11,
                        color: textClueColor.withValues(alpha: 0.5),
                      ),
                    ),
                  )
                : SizedBox(
                    width: 90,
                    height: 32,
                    child: TactileButton(
                      backgroundColor: unlockedColor.withValues(alpha: 0.1),
                      borderColor: unlockedColor,
                      onTap: () async {
                        final balance = context.read<EconomyCubit>().state.balance;
                        if (balance < cost) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Not enough Ink Droplets 💧 to purchase this utility.'),
                              duration: Duration(seconds: 2),
                            ),
                          );
                          return;
                        }
                        
                        final success = isHint
                            ? await context.read<EconomyCubit>().buyHint(cost)
                            : await context.read<EconomyCubit>().buyRevive(cost);
                            
                        if (success && context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Purchased $name successfully!'),
                              duration: const Duration(seconds: 2),
                            ),
                          );
                        }
                      },
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              '💧',
                              style: const TextStyle(fontSize: 10),
                            ),
                            const SizedBox(width: 2),
                            Text(
                              '$cost',
                              style: TextStyle(
                                fontFamily: font,
                                fontWeight: FontWeight.bold,
                                fontSize: 11,
                                color: unlockedColor,
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
    );
  }

  Widget _buildInkShopSection(
    BuildContext context,
    String font,
    Color textClueColor,
    Color surfaceBg,
    Color borderThemeColor,
    EconomyState economyState,
    SettingsState settingsState,
  ) {
    final inks = [
      {'name': 'Charcoal', 'desc': 'Pure soot newspaper black ink', 'cost': 0},
      {'name': 'Vintage Sepia', 'desc': 'Warm photographic sepia solution', 'cost': 100},
      {'name': 'Prussian Blue', 'desc': 'Deep royal indigo Prussian pigment', 'cost': 100},
      {'name': 'Teal Cyan', 'desc': 'Sleek premium cyan ink', 'cost': 100},
      {'name': 'Vintage Orange', 'desc': 'Classic vibrant orange print', 'cost': 100},
      {'name': 'Blush Pink', 'desc': 'Harmonious vibrant pink dye', 'cost': 100},
      {'name': 'Forest Pine', 'desc': 'Deep foliage green ink', 'cost': 100},
    ];

    return _buildCard(
      surfaceBg,
      textClueColor,
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: inks.length,
        separatorBuilder: (context, index) => Divider(height: 1, thickness: 0.75, color: borderThemeColor),
        itemBuilder: (context, index) {
          final item = inks[index];
          final name = item['name'] as String;
          final desc = item['desc'] as String;
          final cost = item['cost'] as int;

          final isUnlocked = economyState.unlockedInks.contains(name);
          final isActive = settingsState.activeInkColorName == name;

          return ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            title: Row(
              children: [
                Container(
                  width: 14,
                  height: 14,
                  decoration: BoxDecoration(
                    color: _getPreviewColor(name),
                    shape: BoxShape.circle,
                    border: Border.all(color: textClueColor, width: 1.0),
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  name,
                  style: TextStyle(
                    fontFamily: font,
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    color: textClueColor,
                  ),
                ),
              ],
            ),
            subtitle: Text(
              desc,
              style: TextStyle(
                fontSize: 11,
                color: textClueColor.withValues(alpha: 0.7),
              ),
            ),
            trailing: _buildShopActionWidget(
              context: context,
              font: font,
              cost: cost,
              isUnlocked: isUnlocked,
              isActive: isActive,
              onBuy: () => context.read<EconomyCubit>().unlockInk(name, cost),
              onSelect: () => context.read<SettingsCubit>().setInkColor(name),
              textClueColor: textClueColor,
              unlockedColor: AppColors.getInk(settingsState.isDarkNewsprint, settingsState.activeInkColorName).textUser,
              isDark: settingsState.isDarkNewsprint,
            ),
          );
        },
      ),
    );
  }

  Widget _buildStampShopSection(
    BuildContext context,
    String font,
    Color textClueColor,
    Color surfaceBg,
    Color borderThemeColor,
    EconomyState economyState,
    SettingsState settingsState,
  ) {
    final stamps = [
      {'name': 'Approved', 'desc': 'Official verification red seal', 'cost': 0},
      {'name': 'Flawless', 'desc': 'Commending absolute logical perfection', 'cost': 200},
      {'name': 'Masterpiece', 'desc': 'Reserved for the finest sudoku artisans', 'cost': 300},
      {'name': 'Certified', 'desc': 'Formal declaration of solved layout', 'cost': 400},
    ];

    return _buildCard(
      surfaceBg,
      textClueColor,
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: stamps.length,
        separatorBuilder: (context, index) => Divider(height: 1, thickness: 0.75, color: borderThemeColor),
        itemBuilder: (context, index) {
          final item = stamps[index];
          final name = item['name'] as String;
          final desc = item['desc'] as String;
          final cost = item['cost'] as int;

          final isUnlocked = economyState.unlockedStamps.contains(name);
          final isActive = settingsState.activeStampStyle == name;

          return ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            title: Text(
              name.toUpperCase(),
              style: TextStyle(
                fontFamily: font,
                fontWeight: FontWeight.w900,
                letterSpacing: 1.0,
                fontSize: 15,
                color: textClueColor,
              ),
            ),
            subtitle: Text(
              desc,
              style: TextStyle(
                fontSize: 11,
                color: textClueColor.withValues(alpha: 0.7),
              ),
            ),
            trailing: _buildShopActionWidget(
              context: context,
              font: font,
              cost: cost,
              isUnlocked: isUnlocked,
              isActive: isActive,
              onBuy: () => context.read<EconomyCubit>().unlockStamp(name, cost),
              onSelect: () => context.read<SettingsCubit>().setStampStyle(name),
              textClueColor: textClueColor,
              unlockedColor: AppColors.getInk(settingsState.isDarkNewsprint, settingsState.activeInkColorName).textUser,
              isDark: settingsState.isDarkNewsprint,
            ),
          );
        },
      ),
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

  Widget _buildShopActionWidget({
    required BuildContext context,
    required String font,
    required int cost,
    required bool isUnlocked,
    required bool isActive,
    required Future<bool> Function() onBuy,
    required VoidCallback onSelect,
    required Color textClueColor,
    required Color unlockedColor,
    required bool isDark,
  }) {
    if (isActive) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          border: Border.all(color: textClueColor, width: 2.0),
          color: textClueColor,
          borderRadius: BorderRadius.circular(4),
        ),
        child: Text(
          'ACTIVE',
          style: TextStyle(
            fontFamily: font,
            fontWeight: FontWeight.bold,
            fontSize: 11,
            color: isDark ? const Color(0xFF1E2022) : Colors.white,
          ),
        ),
      );
    }

    if (isUnlocked) {
      return SizedBox(
        width: 80,
        height: 32,
        child: TactileButton(
          backgroundColor: Colors.transparent,
          borderColor: textClueColor,
          onTap: onSelect,
          child: Center(
            child: Text(
              'APPLY',
              style: TextStyle(
                fontFamily: font,
                fontWeight: FontWeight.bold,
                fontSize: 11,
                color: textClueColor,
              ),
            ),
          ),
        ),
      );
    }

    return SizedBox(
      width: 90,
      height: 32,
      child: TactileButton(
        backgroundColor: unlockedColor.withValues(alpha: 0.1),
        borderColor: unlockedColor,
        onTap: () async {
          final balance = context.read<EconomyCubit>().state.balance;
          if (balance < cost) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Not enough Ink Droplets 💧 to unlock this item.'),
                duration: Duration(seconds: 2),
              ),
            );
            return;
          }
          final success = await onBuy();
          if (success && context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Unlocked successfully!'),
                duration: Duration(seconds: 2),
              ),
            );
          }
        },
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                '💧',
                style: TextStyle(fontSize: 10),
              ),
              const SizedBox(width: 2),
              Text(
                '$cost',
                style: TextStyle(
                  fontFamily: font,
                  fontWeight: FontWeight.bold,
                  fontSize: 11,
                  color: unlockedColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
