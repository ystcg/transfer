import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../services/database_service.dart';
import '../services/tips_service.dart';

class AdminAnalyticsScreen extends StatefulWidget {
  const AdminAnalyticsScreen({super.key});

  @override
  State<AdminAnalyticsScreen> createState() => _AdminAnalyticsScreenState();
}

class _AdminAnalyticsScreenState extends State<AdminAnalyticsScreen> {
  bool _isLoading = true;
  int _totalUsers = 0;
  int _totalBookmarks = 0;
  List<Map<String, dynamic>> _categoryStats = [];

  @override
  void initState() {
    super.initState();
    _loadStats();
  }

  Future<void> _loadStats() async {
    final db = DatabaseService();
    final tipsService = TipsService();
    
    final users = await db.getAllUsers();
    final bookmarks = await db.getTotalBookmarkCount();

    final categories = tipsService.categories;
    final tips = tipsService.tips;

    final List<Map<String, dynamic>> catStats = [];
    for (var cat in categories) {
      final tipsInCat = tips.where((t) => t.categoryId == cat.id).length;
      catStats.add({
        'name': cat.name,
        'count': tipsInCat,
        'color': AppColors.categoryColors[categories.indexOf(cat) % AppColors.categoryColors.length],
        'accent': AppColors.categoryAccents[categories.indexOf(cat) % AppColors.categoryAccents.length],
      });
    }

    // Sort by count descending
    catStats.sort((a, b) => (b['count'] as int).compareTo(a['count'] as int));

    if (!mounted) return;
    setState(() {
      _totalUsers = users.length;
      _totalBookmarks = bookmarks;
      _categoryStats = catStats;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cream,
      appBar: AppBar(
        title: const Text('Analytics'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: AppColors.rose))
          : SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: _StatBox(
                          title: 'Total Users',
                          value: '$_totalUsers',
                          icon: Icons.people_alt_rounded,
                          color: AppColors.rose,
                          bgColor: AppColors.pinkLight,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _StatBox(
                          title: 'Total Bookmarks',
                          value: '$_totalBookmarks',
                          icon: Icons.bookmark_rounded,
                          color: const Color(0xFF5FC8A8),
                          bgColor: AppColors.mintSoft,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                  Text(
                    'Tips by Category',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.shadow.withValues(alpha: 0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      children: _categoryStats.map((stat) {
                        final maxCount = _categoryStats.isNotEmpty
                            ? _categoryStats.first['count'] as int
                            : 1;
                        final double fraction = (stat['count'] as int) / (maxCount > 0 ? maxCount : 1);
                        
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    stat['name'] as String,
                                    style: Theme.of(context).textTheme.titleMedium,
                                  ),
                                  Text(
                                    '${stat['count']}',
                                    style: const TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 6),
                              Stack(
                                children: [
                                  Container(
                                    height: 8,
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      color: (stat['bgColor'] as Color?) ?? AppColors.divider,
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                  ),
                                  FractionallySizedBox(
                                    widthFactor: fraction,
                                    child: Container(
                                      height: 8,
                                      decoration: BoxDecoration(
                                        color: stat['accent'] as Color,
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}

class _StatBox extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;
  final Color bgColor;

  const _StatBox({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
    required this.bgColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(height: 16),
          Text(
            value,
            style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}
