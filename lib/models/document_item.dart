class DocumentItem {
  DocumentItem({
    required this.id,
    required this.documentType,
    required this.originalName,
    required this.mimeType,
    required this.size,
    required this.sizeFormatted,
    this.notes,
    this.plotId,
    this.plotReference,
    this.reviewStatus,
    required this.createdAt,
  });

  final int id;
  final String documentType;
  final String originalName;
  final String mimeType;
  final int size;
  final String sizeFormatted;
  final String? notes;
  final int? plotId;
  final String? plotReference;
  final String? reviewStatus;
  final String createdAt;

  factory DocumentItem.fromJson(Map<String, dynamic> json) {
    return DocumentItem(
      id: json['id'] as int? ?? 0,
      documentType: json['document_type'] as String? ?? '',
      originalName: json['original_name'] as String? ?? '',
      mimeType: json['mime_type'] as String? ?? '',
      size: json['size'] as int? ?? 0,
      sizeFormatted: json['size_formatted'] as String? ?? '',
      notes: json['notes'] as String?,
      plotId: json['plot_id'] as int?,
      plotReference: json['plot_reference'] as String?,
      reviewStatus: json['review_status'] as String?,
      createdAt: json['created_at'] as String? ?? '',
    );
  }
}
