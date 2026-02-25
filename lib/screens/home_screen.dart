import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../theme/app_fonts.dart';
import '../theme/bilingui_theme.dart';
import '../providers/app_providers.dart';
import '../widgets/xp_progress_bar.dart';
import '../widgets/skill_activity_rings.dart';
import '../widgets/lesson_module_card.dart';
import '../widgets/glassmorphic_card.dart';
import 'lesson_detail_screen.dart';
import 'chat_screen.dart';
import 'voice_practice_screen.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentPage = ref.watch(currentPageProvider);

    final screens = [
      const _DashboardTab(),
      const VoicePracticeScreen(),
      const ChatScreen(),
      const _ProfileTab(),
    ];

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFF8F0FF), Color(0xFFEDE7F6)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: screens[currentPage],
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: BilinguiColors.deepPurple.withOpacity(0.08),
              blurRadius: 20,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: NavigationBar(
          selectedIndex: currentPage,
          onDestinationSelected: (index) {
            ref.read(currentPageProvider.notifier).state = index;
          },
          backgroundColor: Colors.transparent,
          elevation: 0,
          indicatorColor: BilinguiColors.softLilac.withOpacity(0.3),
          labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.dashboard_outlined),
              selectedIcon: Icon(Icons.dashboard, color: BilinguiColors.deepPurple),
              label: 'Home',
            ),
            NavigationDestination(
              icon: Icon(Icons.mic_none),
              selectedIcon: Icon(Icons.mic, color: BilinguiColors.deepPurple),
              label: 'Voice',
            ),
            NavigationDestination(
              icon: Icon(Icons.chat_bubble_outline),
              selectedIcon: Icon(Icons.chat_bubble, color: BilinguiColors.deepPurple),
              label: 'AI Chat',
            ),
            NavigationDestination(
              icon: Icon(Icons.person_outline),
              selectedIcon: Icon(Icons.person, color: BilinguiColors.deepPurple),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}

class _DashboardTab extends ConsumerWidget {
  const _DashboardTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stats = ref.watch(userStatsProvider);
    final lessons = ref.watch(lessonsProvider);

    return SafeArea(
      child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Hello, Learner!',
                            style: AppFonts.poppins(
                              fontSize: 24,
                              fontWeight: FontWeight.w700,
                              color: BilinguiColors.textPrimary,
                            ),
                          ),
                          Text(
                            'Ready for today\'s lesson?',
                            style: AppFonts.poppins(
                              fontSize: 14,
                              color: BilinguiColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          gradient: BilinguiColors.primaryGradient,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: const Icon(
                          Icons.notifications_outlined,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  XpProgressBar(
                    currentXp: stats.currentXp,
                    maxXp: stats.maxXp,
                    level: stats.level,
                    streak: stats.streak,
                  ),
                  const SizedBox(height: 20),
                  _buildLanguageFlags(),
                  const SizedBox(height: 16),
                  SkillActivityRings(stats: stats),
                  const SizedBox(height: 24),
                  Text(
                    'Lessons',
                    style: AppFonts.poppins(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: BilinguiColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 12),
                ],
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: LessonModuleCard(
                      lesson: lessons[index],
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) =>
                                LessonDetailScreen(lesson: lessons[index]),
                          ),
                        );
                      },
                    ),
                  );
                },
                childCount: lessons.length,
              ),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 20)),
        ],
      ),
    );
  }
}

Widget _buildLanguageFlags() {
  final languages = [
    {'code': 'us', 'name': 'EN', 'active': true},
    {'code': 'de', 'name': 'DE', 'active': false},
    {'code': 'fr', 'name': 'FR', 'active': false},
    {'code': 'es', 'name': 'ES', 'active': false},
    {'code': 'it', 'name': 'IT', 'active': false},
    {'code': 'jp', 'name': 'JP', 'active': false},
    {'code': 'kr', 'name': 'KR', 'active': false},
    {'code': 'cn', 'name': 'CN', 'active': false},
  ];

  return SizedBox(
    height: 44,
    child: Row(
      children: languages.map((lang) {
        final isActive = lang['active'] as bool;
        final code = lang['code'] as String;
        final name = lang['name'] as String;
        final flagUrl = 'https://flagcdn.com/w40/$code.png';

        return Padding(
          padding: const EdgeInsets.only(right: 8),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: isActive
                  ? BilinguiColors.deepPurple.withOpacity(0.1)
                  : Colors.white.withOpacity(0.6),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: isActive
                    ? BilinguiColors.deepPurple.withOpacity(0.4)
                    : BilinguiColors.softLilac.withOpacity(0.3),
                width: isActive ? 1.5 : 1.0,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(3),
                  child: Image.network(
                    flagUrl,
                    width: 22,
                    height: 15,
                    fit: BoxFit.cover,
                    errorBuilder: (ctx, err, stack) => Container(
                      width: 22,
                      height: 15,
                      color: BilinguiColors.softLilac,
                    ),
                  ),
                ),
                const SizedBox(width: 4),
                Text(
                  name,
                  style: AppFonts.poppins(
                    fontSize: 10,
                    fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
                    color: isActive
                        ? BilinguiColors.deepPurple
                        : BilinguiColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    ),
  );
}

class _ProfileTab extends ConsumerWidget {
  const _ProfileTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stats = ref.watch(userStatsProvider);

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 20),
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                gradient: BilinguiColors.primaryGradient,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: BilinguiColors.deepPurple.withOpacity(0.3),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: const Icon(Icons.person, color: Colors.white, size: 48),
            ),
            const SizedBox(height: 16),
            Text(
              'Language Learner',
              style: AppFonts.poppins(
                fontSize: 22,
                fontWeight: FontWeight.w600,
                color: BilinguiColors.textPrimary,
              ),
            ),
            Text(
              'Level ${stats.level} Explorer',
              style: AppFonts.poppins(
                fontSize: 14,
                color: BilinguiColors.textSecondary,
              ),
            ),
            const SizedBox(height: 32),
            _buildStatRow('Total XP', '${stats.currentXp}', Icons.star),
            _buildStatRow('Current Streak', '${stats.streak} days', Icons.local_fire_department),
            _buildStatRow('Lessons Completed', '12', Icons.check_circle),
            _buildStatRow('Words Learned', '156', Icons.book),
            const SizedBox(height: 24),
            SkillActivityRings(stats: stats),
          ],
        ),
      ),
    );
  }

  Widget _buildStatRow(String label, String value, IconData icon) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: BilinguiColors.cardSurface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: BilinguiColors.softLilac.withOpacity(0.3),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              gradient: BilinguiColors.primaryGradient,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: Colors.white, size: 22),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              label,
              style: AppFonts.poppins(
                fontSize: 14,
                color: BilinguiColors.textSecondary,
              ),
            ),
          ),
          Text(
            value,
            style: AppFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: BilinguiColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
