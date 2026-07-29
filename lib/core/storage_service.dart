import 'package:hive_flutter/hive_flutter.dart';

class StorageService {
  StorageService._(this._box);

  static const String _boxName = 'landlens_box';

  static const String _baseUrlKey = 'base_url';
  static const String _authTokenKey = 'auth_token';
  static const String _verificationTokenKey = 'verification_token';
  static const String _challengeIdKey = 'challenge_id';
  static const String _challengeExpiresKey = 'challenge_expires_at';
  static const String _languageKey = 'language_code';
  static const String _historyKey = 'verification_history';
  static const String _userIdKey = 'current_user_id';
  static const String _deviceTokenKey = 'device_token';
  static const String _lastNotifSeenKey = 'last_notif_seen_id';

  final Box<dynamic> _box;

  static Future<StorageService> init() async {
    await Hive.initFlutter();
    final box = await Hive.openBox<dynamic>(_boxName);
    return StorageService._(box);
  }

  String? get baseUrl => _box.get(_baseUrlKey) as String?;

  Future<void> setBaseUrl(String value) => _box.put(_baseUrlKey, value.trim());

  String? get authToken => _box.get(_authTokenKey) as String?;

  Future<void> setAuthToken(String value) =>
      _box.put(_authTokenKey, value.trim());

  bool get isAuthenticated => (authToken?.isNotEmpty ?? false);

  Future<void> clearAuthToken() async {
    await _box.delete(_authTokenKey);
    await _box.delete(_userRoleKey);
    await _box.delete(_userIdKey);
  }

  int? get currentUserId => _box.get(_userIdKey) as int?;

  Future<void> setCurrentUserId(int id) => _box.put(_userIdKey, id);

  String get _userHistoryKey {
    final uid = currentUserId;
    return uid != null ? '${_historyKey}_$uid' : _historyKey;
  }

  static const String _userRoleKey = 'user_role';

  String? get userRole {
    final raw = (_box.get(_userRoleKey) as String?)?.trim().toLowerCase();
    if (raw == null || raw.isEmpty) return null;
    return raw;
  }

  Future<void> setUserRole(String role) =>
      _box.put(_userRoleKey, role.trim().toLowerCase());

  String homeRouteForRole([String? role]) {
    final resolved = (role ?? userRole ?? 'buyer').toLowerCase();
    return resolved == 'seller' ? '/seller-home' : '/home';
  }

  String? get verificationToken => _box.get(_verificationTokenKey) as String?;

  Future<void> setVerificationToken(String value) =>
      _box.put(_verificationTokenKey, value);

  String? get challengeId => _box.get(_challengeIdKey) as String?;

  Future<void> setChallengeId(String value) => _box.put(_challengeIdKey, value);

  DateTime? get challengeExpiresAt {
    final raw = _box.get(_challengeExpiresKey) as String?;
    if (raw == null) {
      return null;
    }

    return DateTime.tryParse(raw);
  }

  Future<void> setChallengeExpiresAt(DateTime value) =>
      _box.put(_challengeExpiresKey, value.toIso8601String());

  Future<void> clearVerificationSession() async {
    await _box.delete(_verificationTokenKey);
    await _box.delete(_challengeIdKey);
    await _box.delete(_challengeExpiresKey);
  }

  String get languageCode {
    final raw = (_box.get(_languageKey) as String?)?.trim().toLowerCase();
    return raw == 'sw' ? 'sw' : 'en';
  }

  Future<void> setLanguageCode(String value) async {
    final normalized = value.trim().toLowerCase() == 'sw' ? 'sw' : 'en';
    await _box.put(_languageKey, normalized);
  }

  List<Map<String, dynamic>> get verificationHistory {
    final raw = _box.get(_userHistoryKey);
    if (raw is! List) {
      return [];
    }

    return raw
        .whereType<Map>()
        .map((item) => item.cast<String, dynamic>())
        .toList();
  }

  Future<void> addHistory(Map<String, dynamic> entry) async {
    final list = verificationHistory;
    list.insert(0, entry);

    if (list.length > 30) {
      list.removeRange(30, list.length);
    }

    await _box.put(_userHistoryKey, list);
  }

  String? get deviceToken => _box.get(_deviceTokenKey) as String?;

  Future<void> setDeviceToken(String value) =>
      _box.put(_deviceTokenKey, value.trim());

  String get _userNotifSeenKey {
    final uid = currentUserId;
    return uid != null ? '${_lastNotifSeenKey}_$uid' : _lastNotifSeenKey;
  }

  int get lastNotificationSeenId =>
      (_box.get(_userNotifSeenKey) as int?) ?? 0;

  Future<void> setLastNotificationSeenId(int value) =>
      _box.put(_userNotifSeenKey, value);
}
