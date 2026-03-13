import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/tip.dart';
import '../models/tip_category.dart';
import 'database_service.dart';
import 'auth_service.dart';

class TipsService {
  static final TipsService _instance = TipsService._internal();
  factory TipsService() => _instance;
  TipsService._internal();

  List<TipCategory> _categories = [];
  List<Tip> _tips = [];
  Set<String> _bookmarkedIds = {};
  String _rawJsonData = '';

  final DatabaseService _db = DatabaseService();

  List<TipCategory> get categories => _categories;
  List<Tip> get tips => _tips;
  Set<String> get bookmarkedIds => _bookmarkedIds;
  String get rawJsonData => _rawJsonData;

  Future<void> initialize() async {
    await _loadTips();
    await loadBookmarks();
  }

  Future<void> _loadTips() async {
    final String jsonStr = await rootBundle.loadString('assets/data/tips.json');
    _rawJsonData = jsonStr;
    final Map<String, dynamic> data = json.decode(jsonStr);

    _categories = (data['categories'] as List)
        .map((c) => TipCategory.fromJson(c as Map<String, dynamic>))
        .toList();

    _tips = (data['tips'] as List)
        .map((t) => Tip.fromJson(t as Map<String, dynamic>))
        .toList();
  }

  Future<void> loadBookmarks() async {
    final user = AuthService().currentUser;
    if (user != null) {
      final bookmarks = await _db.getBookmarks(user.id);
      _bookmarkedIds = bookmarks.toSet();
    } else {
      _bookmarkedIds = {};
    }
  }

  Future<void> toggleBookmark(String tipId) async {
    final user = AuthService().currentUser;
    if (user == null) return;

    if (_bookmarkedIds.contains(tipId)) {
      _bookmarkedIds.remove(tipId);
      await _db.removeBookmark(user.id, tipId);
    } else {
      _bookmarkedIds.add(tipId);
      await _db.addBookmark(user.id, tipId);
    }
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
          t.steps.any(
            (s) =>
                s.title.toLowerCase().contains(q) ||
                s.description.toLowerCase().contains(q),
          );
    }).toList();
  }

  Tip? getTipOfTheDay() {
    if (_tips.isEmpty) return null;
    final dayOfYear = DateTime.now()
        .difference(DateTime(DateTime.now().year))
        .inDays;
    return _tips[dayOfYear % _tips.length];
  }

  Tip? getFeaturedTip() {
    if (_tips.isEmpty) return null;
    final weekOfYear =
        DateTime.now().difference(DateTime(DateTime.now().year)).inDays ~/ 7;
    return _tips[weekOfYear % _tips.length];
  }
}
