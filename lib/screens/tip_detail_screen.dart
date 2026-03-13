import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../theme/app_icons.dart';
import '../models/tip.dart';
import '../services/tips_service.dart';
import '../widgets/step_card.dart';
import 'package:flutter/services.dart';

class TipDetailScreen extends StatefulWidget {
  final Tip tip;
  const TipDetailScreen({super.key, required this.tip});

  @override
  State<TipDetailScreen> createState() => _TipDetailScreenState();
}

class _TipDetailScreenState extends State<TipDetailScreen> {
  late bool _isBookmarked;

  @override
  void initState() {
    super.initState();
    _isBookmarked = TipsService().isBookmarked(widget.tip.id);
  }

  void _toggleBookmark() async {
    await TipsService().toggleBookmark(widget.tip.id);
    setState(() {
      _isBookmarked = !_isBookmarked;
    });
  }

  @override
  Widget build(BuildContext context) {
    final tip = widget.tip;

    return Scaffold(
      backgroundColor: AppColors.cream,
      body: CustomScrollView(
        slivers: [
          // Hero header
          SliverAppBar(
            expandedHeight: 200,
            pinned: true,
            backgroundColor: AppColors.pinkLight,
            leading: IconButton(
              icon: Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.8),
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
            actions: [
              IconButton(
                icon: Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.8),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    _isBookmarked
                        ? Icons.bookmark_rounded
                        : Icons.bookmark_outline_rounded,
                    size: 20,
                    color: _isBookmarked
                        ? AppColors.rose
                        : AppColors.textPrimary,
                  ),
                ),
                onPressed: () {
                  HapticFeedback.lightImpact();
                  _toggleBookmark();
                },
              ),
              const SizedBox(width: 8),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: tip.image != null
                  ? ShaderMask(
                      shaderCallback: (rect) {
                        return const LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [Colors.black, Colors.transparent],
                          stops: [0.6, 1.0], // Fades out the bottom 40%
                        ).createShader(rect);
                      },
                      blendMode: BlendMode.dstIn,
                      child: Image.asset(
                        tip.image!,
                        fit: BoxFit.cover,
                        color: AppColors.pinkLight.withValues(alpha: 0.15),
                        colorBlendMode: BlendMode.srcOver,
                      ),
                    )
                  : Container(
                      decoration: const BoxDecoration(
                        color: AppColors.pinkLight,
                      ),
                      child: Center(
                        child: Icon(
                          AppIcons.tipIcon(tip.categoryId),
                          size: 48,
                          color: AppColors.rose.withValues(alpha: 0.6),
                        ),
                      ),
                    ),
            ),
          ),

          // Content
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Text(
                    tip.title,
                    style: Theme.of(context).textTheme.displayMedium,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    tip.subtitle,
                    style: Theme.of(
                      context,
                    ).textTheme.bodyMedium?.copyWith(fontSize: 16),
                  ),
                  const SizedBox(height: 16),

                  // Badges
                  Row(
                    children: [
                      _Badge(
                        icon: Icons.speed_rounded,
                        label: tip.difficulty,
                        color: _diffColor(tip.difficulty),
                      ),
                      const SizedBox(width: 10),
                      _Badge(
                        icon: Icons.timer_outlined,
                        label: tip.estimatedTime,
                        color: AppColors.textSecondary,
                      ),
                      const SizedBox(width: 10),
                      _Badge(
                        icon: Icons.format_list_numbered_rounded,
                        label: '${tip.steps.length} steps',
                        color: AppColors.rose,
                      ),
                    ],
                  ),
                  const SizedBox(height: 28),

                  // What You Need
                  if (tip.whatYouNeed.isNotEmpty) ...[
                    Text(
                      'What You Need',
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.shadow,
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        children: tip.whatYouNeed
                            .map(
                              (item) => Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 5,
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.check_circle_outline_rounded,
                                      size: 18,
                                      color: AppColors.rose,
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: Text(
                                        item,
                                        style: Theme.of(
                                          context,
                                        ).textTheme.bodyLarge,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                            .toList(),
                      ),
                    ),
                    const SizedBox(height: 28),
                  ],

                  // Steps
                  Text(
                    'Steps',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 16),
                  ...tip.steps.asMap().entries.map(
                    (entry) => StepCard(
                      number: entry.value.number,
                      title: entry.value.title,
                      description: entry.value.description,
                      isLast: entry.key == tip.steps.length - 1,
                    ),
                  ),

                  // Pro Tip
                  if (tip.proTip != null) ...[
                    const SizedBox(height: 24),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.pinkLight.withValues(alpha: 0.3),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: AppColors.pinkLight),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(
                            Icons.tips_and_updates_rounded,
                            size: 20,
                            color: AppColors.rose,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Pro Tip',
                                  style: Theme.of(context).textTheme.titleMedium
                                      ?.copyWith(color: AppColors.rose),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  tip.proTip!,
                                  style: Theme.of(
                                    context,
                                  ).textTheme.bodyMedium?.copyWith(height: 1.5),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _diffColor(String d) {
    switch (d) {
      case 'Easy':
        return const Color(0xFF66BB6A); // Softer green
      case 'Medium':
        return const Color(0xFFFFA726); // Softer orange
      case 'Hard':
        return AppColors.rose; // Keep theme rose
      default:
        return AppColors.textTertiary;
    }
  }
}

class _Badge extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  const _Badge({required this.icon, required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 5),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
