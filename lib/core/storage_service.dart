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

  Future<void> clearAuthToken() => _box.delete(_authTokenKey);

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
    final raw = _box.get(_historyKey);
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

    await _box.put(_historyKey, list);
  }
}
