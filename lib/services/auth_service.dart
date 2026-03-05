import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';
import 'database_service.dart';

class AuthService {
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  final DatabaseService _db = DatabaseService();
  AppUser? _currentUser;

  AppUser? get currentUser => _currentUser;
  bool get isLoggedIn => _currentUser != null;

  Future<void> initialize() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt('currentUserId');
    if (userId != null) {
      _currentUser = await _db.getUserById(userId);
      if (_currentUser == null) {
        await prefs.remove('currentUserId');
      }
    }
  }

  Future<({bool success, String message})> signup(
      String name, String email, String password) async {
    if (name.trim().isEmpty) {
      return (success: false, message: 'Please enter your name');
    }
    if (email.trim().isEmpty || !email.contains('@')) {
      return (success: false, message: 'Please enter a valid email');
    }
    if (password.length < 6) {
      return (success: false, message: 'Password must be at least 6 characters');
    }

    final existing = await _db.getUserByEmail(email);
    if (existing != null) {
      return (success: false, message: 'An account with this email already exists');
    }

    final user = await _db.createUser(name.trim(), email, password);
    if (user == null) {
      return (success: false, message: 'Could not create account. Please try again.');
    }

    _currentUser = user;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('currentUserId', user.id);
    return (success: true, message: 'Account created successfully!');
  }

  Future<({bool success, String message})> login(
      String email, String password) async {
    if (email.trim().isEmpty || !email.contains('@')) {
      return (success: false, message: 'Please enter a valid email');
    }
    if (password.isEmpty) {
      return (success: false, message: 'Please enter your password');
    }

    final valid = await _db.validatePassword(email, password);
    if (!valid) {
      return (success: false, message: 'Invalid email or password');
    }

    _currentUser = await _db.getUserByEmail(email);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('currentUserId', _currentUser!.id);
    return (success: true, message: 'Welcome back!');
  }

  Future<void> logout() async {
    _currentUser = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('currentUserId');
  }
}
