import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../services/tips_service.dart';
import 'tip_detail_screen.dart';

class AdminManageTipsScreen extends StatelessWidget {
  const AdminManageTipsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final tipsService = TipsService();
    final categories = tipsService.categories;

    return Scaffold(
      backgroundColor: AppColors.cream,
      appBar: AppBar(
        title: const Text('Manage Tips'),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          final categoryTips = tipsService.getTipsByCategory(category.id);
          
          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Container(
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
              child: ExpansionTile(
                iconColor: AppColors.rose,
                collapsedIconColor: AppColors.textTertiary,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                collapsedShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.categoryColors[index % AppColors.categoryColors.length],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    Icons.category_rounded, // Assuming icon mapping isn't available here easily
                    color: AppColors.categoryAccents[index % AppColors.categoryAccents.length],
                  ),
                ),
                title: Text(
                  category.name,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                subtitle: Text(
                  '\${categoryTips.length} tips',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                children: categoryTips.map((tip) {
                  return ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                    title: Text(tip.title, style: const TextStyle(fontWeight: FontWeight.w500)),
                    subtitle: Text(tip.subtitle, maxLines: 1, overflow: TextOverflow.ellipsis),
                    trailing: const Icon(Icons.chevron_right_rounded, color: AppColors.textTertiary),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => TipDetailScreen(tip: tip),
                        ),
                      );
                    },
                  );
                }).toList(),
              ),
            ),
          );
        },
      ),
    );
  }
}
