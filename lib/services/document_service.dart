import 'dart:io';

import 'package:dio/dio.dart';

import '../core/api_client.dart';
import '../core/api_exception.dart';
import '../models/document_item.dart';

class DocumentService {
  DocumentService(this._apiClient);

  final ApiClient _apiClient;

  Future<Map<String, dynamic>> getDocuments({
    int? plotId,
    String? plotReference,
    String? documentType,
  }) async {
    final params = <String>[];
    if (plotId != null) params.add('plot_id=$plotId');
    if (plotReference != null && plotReference.isNotEmpty) {
      params.add('plot_reference=${Uri.encodeQueryComponent(plotReference)}');
    }
    if (documentType != null) params.add('document_type=$documentType');
    final query = params.isNotEmpty ? '?${params.join('&')}' : '';

    final json = await _apiClient.get('/documents$query');
    final success = json['success'] as bool? ?? false;
    final data = json['data'] as Map<String, dynamic>?;

    if (!success || data == null) {
      return {'documents': <DocumentItem>[], 'mode': 'seller_manage'};
    }

    final docsRaw = data['documents'] as List? ?? [];
    return {
      'documents': docsRaw
          .map((item) => DocumentItem.fromJson(item as Map<String, dynamic>))
          .toList(),
      'mode': data['mode']?.toString() ?? 'seller_manage',
      'plot': data['plot'],
    };
  }

  Future<DocumentItem> uploadDocument({
    required File file,
    required String documentType,
    required int plotId,
    String? notes,
  }) async {
    final formData = FormData.fromMap({
      'file': await MultipartFile.fromFile(
        file.path,
        filename: file.uri.pathSegments.isNotEmpty
            ? file.uri.pathSegments.last
            : 'document',
      ),
      'document_type': documentType,
      'plot_id': plotId,
      if (notes != null && notes.trim().isNotEmpty) 'notes': notes.trim(),
    });

    final json = await _apiClient.uploadMultipart(
      '/documents/upload',
      formData: formData,
    );

    final success = json['success'] as bool? ?? false;
    final message = json['message'] as String? ?? '';
    final data = json['data'] as Map<String, dynamic>?;

    if (!success || data == null) {
      throw ApiException(message: message);
    }

    final docData = data['document'] as Map<String, dynamic>?;
    if (docData == null) {
      throw ApiException(message: 'Document data not found.');
    }

    return DocumentItem.fromJson(docData);
  }

  Future<List<int>> downloadDocumentBytes(int id) {
    return _apiClient.downloadBytes('/documents/$id/download');
  }

  Future<void> deleteDocument(int id) async {
    final json = await _apiClient.delete('/documents/$id');
    final success = json['success'] as bool? ?? false;
    if (!success) {
      throw ApiException(
        message: json['message'] as String? ?? 'Failed to delete document.',
      );
    }
  }
}
