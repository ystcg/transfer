import 'package:flutter/material.dart';

class AppIcons {
  /// Maps category IDs to Material icons
  static IconData categoryIcon(String categoryId) {
    switch (categoryId) {
      case 'lighting':
        return Icons.lightbulb_outline_rounded;
      case 'plumbing':
        return Icons.plumbing_rounded;
      case 'cleaning':
        return Icons.cleaning_services_rounded;
      case 'kitchen':
        return Icons.kitchen_rounded;
      case 'repairs':
        return Icons.build_rounded;
      case 'garden':
        return Icons.yard_rounded;
      case 'laundry':
        return Icons.local_laundry_service_rounded;
      case 'safety':
        return Icons.shield_rounded;
      default:
        return Icons.tips_and_updates_rounded;
    }
  }

  /// Maps tip categoryId to an icon for tip cards
  static IconData tipIcon(String categoryId) {
    return categoryIcon(categoryId);
  }
}
