import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../services/tips_service.dart';
import '../widgets/tip_card.dart';
import 'tip_detail_screen.dart';

class BookmarksScreen extends StatefulWidget {
  const BookmarksScreen({super.key});

  @override
  State<BookmarksScreen> createState() => _BookmarksScreenState();
}

class _BookmarksScreenState extends State<BookmarksScreen> {
  @override
  Widget build(BuildContext context) {
    final bookmarks = TipsService().getBookmarkedTips();

    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
            child: Text(
              'Saved Tips',
              style: Theme.of(context).textTheme.displayMedium,
            ),
          ),
          Expanded(
            child: bookmarks.isEmpty
                ? Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.shadow.withValues(alpha: 0.1),
                                blurRadius: 20,
                                offset: const Offset(0, 10),
                              ),
                            ],
                          ),
                          child: Icon(
                            Icons.bookmark_outline_rounded,
                            size: 64,
                            color: AppColors.rose.withValues(alpha: 0.5),
                          ),
                        ),
                        const SizedBox(height: 32),
                        Text(
                          'No saved tips yet',
                          style: Theme.of(context).textTheme.headlineMedium,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Tap the bookmark icon on any tip to save it here',
                          style: Theme.of(context).textTheme.bodyMedium,
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    itemCount: bookmarks.length,
                    itemBuilder: (context, i) => TipCard(
                      tip: bookmarks[i],
                      onTap: () async {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => TipDetailScreen(tip: bookmarks[i]),
                          ),
                        );
                        // Refresh when returning in case bookmark was toggled
                        setState(() {});
                      },
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
