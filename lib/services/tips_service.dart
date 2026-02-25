import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/tip.dart';
import '../models/tip_category.dart';

class TipsService {
  static final TipsService _instance = TipsService._internal();
  factory TipsService() => _instance;
  TipsService._internal();

  List<TipCategory> _categories = [];
  List<Tip> _tips = [];
  Set<String> _bookmarkedIds = {};

  List<TipCategory> get categories => _categories;
  List<Tip> get tips => _tips;
  Set<String> get bookmarkedIds => _bookmarkedIds;

  Future<void> initialize() async {
    await _loadTips();
    await _loadBookmarks();
  }

  Future<void> _loadTips() async {
    final String jsonStr =
        await rootBundle.loadString('assets/data/tips.json');
    final Map<String, dynamic> data = json.decode(jsonStr);

    _categories = (data['categories'] as List)
        .map((c) => TipCategory.fromJson(c as Map<String, dynamic>))
        .toList();

    _tips = (data['tips'] as List)
        .map((t) => Tip.fromJson(t as Map<String, dynamic>))
        .toList();
  }

  Future<void> _loadBookmarks() async {
    final prefs = await SharedPreferences.getInstance();
    _bookmarkedIds = (prefs.getStringList('bookmarks') ?? []).toSet();
  }

  Future<void> toggleBookmark(String tipId) async {
    if (_bookmarkedIds.contains(tipId)) {
      _bookmarkedIds.remove(tipId);
    } else {
      _bookmarkedIds.add(tipId);
    }
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('bookmarks', _bookmarkedIds.toList());
  }

  bool isBookmarked(String tipId) => _bookmarkedIds.contains(tipId);

  List<Tip> getTipsByCategory(String categoryId) {
    return _tips.where((t) => t.categoryId == categoryId).toList();
  }

  List<Tip> getBookmarkedTips() {
    return _tips.where((t) => _bookmarkedIds.contains(t.id)).toList();
  }

  List<Tip> searchTips(String query) {
    final q = query.toLowerCase();
    return _tips.where((t) {
      return t.title.toLowerCase().contains(q) ||
          t.subtitle.toLowerCase().contains(q) ||
          t.steps.any((s) =>
              s.title.toLowerCase().contains(q) ||
              s.description.toLowerCase().contains(q));
    }).toList();
  }

  Tip? getTipOfTheDay() {
    if (_tips.isEmpty) return null;
    final dayOfYear = DateTime.now().difference(DateTime(DateTime.now().year)).inDays;
    return _tips[dayOfYear % _tips.length];
  }

  Tip? getFeaturedTip() {
    if (_tips.isEmpty) return null;
    final weekOfYear = DateTime.now().difference(DateTime(DateTime.now().year)).inDays ~/ 7;
    return _tips[weekOfYear % _tips.length];
  }
}
