import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../theme/app_icons.dart';
import '../models/tip_category.dart';
import '../services/tips_service.dart';
import '../widgets/tip_card.dart';
import 'tip_detail_screen.dart';

class CategoryScreen extends StatelessWidget {
  final TipCategory category;
  final int index;

  const CategoryScreen({
    super.key,
    required this.category,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    final tips = TipsService().getTipsByCategory(category.id);
    final bgColor =
        AppColors.categoryColors[index % AppColors.categoryColors.length];
    final accentColor =
        AppColors.categoryAccents[index % AppColors.categoryAccents.length];

    return Scaffold(
      backgroundColor: AppColors.cream,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            backgroundColor: AppColors.cream,
            surfaceTintColor: Colors.transparent, // Prevents scroll overlap discoloration
            leading: IconButton(
              icon: Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: bgColor,
                  shape: BoxShape.circle,
                ),
                child: const Padding(
                  padding: EdgeInsets.only(left: 6),
                  child: Icon(
                    Icons.arrow_back_ios_new_rounded,
                    size: 18,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Centered Category Icon
                  Container(
                    padding: const EdgeInsets.all(28),
                    decoration: BoxDecoration(
                      color: bgColor,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: accentColor.withValues(alpha: 0.15),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Icon(
                      AppIcons.categoryIcon(category.id),
                      size: 56,
                      color: accentColor,
                    ),
                  ),
                  const SizedBox(height: 24),
                  
                  // Title
                  Text(
                    category.name,
                    style: Theme.of(context).textTheme.displayMedium?.copyWith(
                      fontSize: 26,
                      height: 1.2,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),
                  
                  // Badge (${tips.length} tips)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: accentColor.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      '${tips.length} tips',
                      style: TextStyle(
                        color: accentColor,
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  
                  // Description
                  Text(
                    category.description,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontSize: 16,
                      height: 1.4,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 36),
                ],
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, i) => TipCard(
                  tip: tips[i],
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => TipDetailScreen(tip: tips[i]),
                    ),
                  ),
                ),
                childCount: tips.length,
              ),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 24)),
        ],
      ),
    );
  }
}
