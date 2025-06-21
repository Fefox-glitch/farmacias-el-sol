import 'dart:convert';
import 'package:shared_preferences.dart';
import '../config/constants.dart';
import '../models/user.dart';
import '../models/reminder.dart';
import '../models/pharmacy.dart';

class StorageService {
  static final StorageService _instance = StorageService._internal();
  static SharedPreferences? _prefs;

  factory StorageService() {
    return _instance;
  }

  StorageService._internal();

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // User Data
  Future<void> saveUser(User user) async {
    await _prefs?.setString(AppConstants.userCacheKey, jsonEncode(user.toJson()));
  }

  Future<User?> getUser() async {
    final userStr = _prefs?.getString(AppConstants.userCacheKey);
    if (userStr == null) return null;
    try {
      return User.fromJson(jsonDecode(userStr));
    } catch (e) {
      print('Error deserializando usuario: $e');
      return null;
    }
  }

  Future<void> removeUser() async {
    await _prefs?.remove(AppConstants.userCacheKey);
  }

  // Auth Token
  Future<void> saveToken(String token) async {
    await _prefs?.setString(AppConstants.tokenCacheKey, token);
  }

  String? getToken() {
    return _prefs?.getString(AppConstants.tokenCacheKey);
  }

  Future<void> removeToken() async {
    await _prefs?.remove(AppConstants.tokenCacheKey);
  }

  // Reminders
  Future<void> saveReminders(List<Reminder> reminders) async {
    final remindersJson = reminders.map((r) => r.toJson()).toList();
    await _prefs?.setString(AppConstants.remindersKey, jsonEncode(remindersJson));
  }

  Future<List<Reminder>> getReminders() async {
    final remindersStr = _prefs?.getString(AppConstants.remindersKey);
    if (remindersStr == null) return [];
    try {
      final List<dynamic> remindersJson = jsonDecode(remindersStr);
      return remindersJson
          .map((json) => Reminder.fromJson(json))
          .toList();
    } catch (e) {
      print('Error deserializando recordatorios: $e');
      return [];
    }
  }

  // Recent Searches
  Future<void> addRecentSearch(String search) async {
    final searches = getRecentSearches();
    if (!searches.contains(search)) {
      searches.insert(0, search);
      if (searches.length > AppConstants.maxRecentSearches) {
        searches.removeLast();
      }
      await _prefs?.setStringList(AppConstants.recentSearchesKey, searches);
    }
  }

  List<String> getRecentSearches() {
    return _prefs?.getStringList(AppConstants.recentSearchesKey) ?? [];
  }

  Future<void> clearRecentSearches() async {
    await _prefs?.remove(AppConstants.recentSearchesKey);
  }

  // Favorite Pharmacies
  Future<void> saveFavoritePharmacies(List<Pharmacy> pharmacies) async {
    final pharmaciesJson = pharmacies.map((p) => p.toJson()).toList();
    await _prefs?.setString(
      AppConstants.favoritePharmaciesKey,
      jsonEncode(pharmaciesJson),
    );
  }

  Future<List<Pharmacy>> getFavoritePharmacies() async {
    final pharmaciesStr = _prefs?.getString(AppConstants.favoritePharmaciesKey);
    if (pharmaciesStr == null) return [];
    try {
      final List<dynamic> pharmaciesJson = jsonDecode(pharmaciesStr);
      return pharmaciesJson
          .map((json) => Pharmacy.fromJson(json))
          .toList();
    } catch (e) {
      print('Error deserializando farmacias favoritas: $e');
      return [];
    }
  }

  Future<void> addFavoritePharmacy(Pharmacy pharmacy) async {
    final pharmacies = await getFavoritePharmacies();
    if (!pharmacies.any((p) => p.id == pharmacy.id)) {
      pharmacies.add(pharmacy);
      if (pharmacies.length > AppConstants.maxFavoritePharmacies) {
        pharmacies.removeAt(0);
      }
      await saveFavoritePharmacies(pharmacies);
    }
  }

  Future<void> removeFavoritePharmacy(String pharmacyId) async {
    final pharmacies = await getFavoritePharmacies();
    pharmacies.removeWhere((p) => p.id == pharmacyId);
    await saveFavoritePharmacies(pharmacies);
  }

  // Theme Mode
  Future<void> saveThemeMode(ThemeMode mode) async {
    await _prefs?.setInt(AppConstants.themeModeKey, mode.index);
  }

  ThemeMode getThemeMode() {
    final index = _prefs?.getInt(AppConstants.themeModeKey);
    return index != null ? ThemeMode.values[index] : ThemeMode.system;
  }

  // Clear All Data
  Future<void> clearAll() async {
    await _prefs?.clear();
  }

  // Check if First Launch
  bool isFirstLaunch() {
    const key = 'is_first_launch';
    final isFirst = _prefs?.getBool(key) ?? true;
    if (isFirst) {
      _prefs?.setBool(key, false);
    }
    return isFirst;
  }

  // App Settings
  Future<void> saveSetting(String key, dynamic value) async {
    if (value is String) {
      await _prefs?.setString(key, value);
    } else if (value is int) {
      await _prefs?.setInt(key, value);
    } else if (value is bool) {
      await _prefs?.setBool(key, value);
    } else if (value is double) {
      await _prefs?.setDouble(key, value);
    } else {
      throw Exception('Tipo de dato no soportado para configuración');
    }
  }

  T? getSetting<T>(String key) {
    return _prefs?.get(key) as T?;
  }

  Future<void> removeSetting(String key) async {
    await _prefs?.remove(key);
  }
}
