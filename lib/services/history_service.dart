import '../core/storage_service.dart';

class HistoryService {
  HistoryService(this._storage);

  final StorageService _storage;

  List<Map<String, dynamic>> getHistory() => _storage.verificationHistory;

  Future<void> addHistory(Map<String, dynamic> entry) =>
      _storage.addHistory(entry);
}
