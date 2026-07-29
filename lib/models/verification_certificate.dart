class VerificationCertificate {
  VerificationCertificate({
    required this.id,
    required this.certificateNumber,
    required this.verificationLogId,
    required this.plotReference,
    required this.verdict,
    this.riskScore,
    this.issuedAt,
    this.expiresAt,
    this.pdfPath,
    this.fingerprint,
    this.certificateType,
    this.certificateTitle,
  });

  final int id;
  final String certificateNumber;
  final int verificationLogId;
  final String plotReference;
  final String verdict;
  final int? riskScore;
  final String? issuedAt;
  final String? expiresAt;
  final String? pdfPath;
  final String? fingerprint;
  final String? certificateType;
  final String? certificateTitle;

  bool get isSellerOwnership => certificateType == 'seller_ownership';

  bool get isExpired {
    if (expiresAt == null) return false;
    final expiry = DateTime.tryParse(expiresAt!);
    if (expiry == null) return false;
    return expiry.isBefore(DateTime.now());
  }

  factory VerificationCertificate.fromJson(Map<String, dynamic> json) {
    return VerificationCertificate(
      id: json['id'] as int? ?? 0,
      certificateNumber: json['certificate_number'] as String? ?? '',
      verificationLogId: json['verification_log_id'] as int? ?? 0,
      plotReference: json['plot_reference'] as String? ?? '',
      verdict: json['verdict'] as String? ?? '',
      riskScore: json['risk_score'] as int?,
      issuedAt: json['issued_at'] as String?,
      expiresAt: json['expires_at'] as String?,
      pdfPath: json['pdf_path'] as String?,
      fingerprint: json['fingerprint'] as String?,
      certificateType: json['certificate_type'] as String?,
      certificateTitle: json['certificate_title'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'certificate_number': certificateNumber,
      'verification_log_id': verificationLogId,
      'plot_reference': plotReference,
      'verdict': verdict,
      'risk_score': riskScore,
      'issued_at': issuedAt,
      'expires_at': expiresAt,
      'pdf_path': pdfPath,
      'fingerprint': fingerprint,
      'certificate_type': certificateType,
      'certificate_title': certificateTitle,
    };
  }
}
