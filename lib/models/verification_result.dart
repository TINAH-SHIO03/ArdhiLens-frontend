import 'identity_summary.dart';
import 'risk_assessment.dart';
import 'verification_steps.dart';
import 'parsing.dart';

class VerificationCertificateSummary {
  VerificationCertificateSummary({
    required this.id,
    required this.certificateNumber,
    this.issuedAt,
    this.fingerprint,
    this.downloadAvailable = true,
    this.certificateType,
    this.certificateTitle,
  });

  final int id;
  final String certificateNumber;
  final String? issuedAt;
  final String? fingerprint;
  final bool downloadAvailable;
  final String? certificateType;
  final String? certificateTitle;

  bool get isSellerOwnership => certificateType == 'seller_ownership';

  factory VerificationCertificateSummary.fromJson(Map<String, dynamic> json) {
    return VerificationCertificateSummary(
      id: asInt(json['id']) ?? 0,
      certificateNumber: json['certificate_number'] as String? ?? '',
      issuedAt: json['issued_at'] as String?,
      fingerprint: json['fingerprint'] as String?,
      downloadAvailable: json['download_available'] as bool? ?? true,
      certificateType: json['certificate_type'] as String?,
      certificateTitle: json['certificate_title'] as String?,
    );
  }
}

class VerificationResult {
  VerificationResult({
    required this.verificationLogId,
    required this.plotReference,
    required this.identity,
    required this.steps,
    required this.assessment,
    this.certificate,
    this.certificateEligible = false,
    this.certificateError,
    this.verificationMode,
    this.remainingAttempts,
  });

  final int verificationLogId;
  final String plotReference;
  final IdentitySummary identity;
  final VerificationSteps steps;
  final RiskAssessment assessment;
  final VerificationCertificateSummary? certificate;
  final bool certificateEligible;
  final String? certificateError;
  final String? verificationMode;
  final int? remainingAttempts;

  factory VerificationResult.fromJson(Map<String, dynamic> json) {
    final identityJson =
        (json['identity'] as Map?)?.cast<String, dynamic>();

    return VerificationResult(
      verificationLogId: asInt(json['verification_log_id']) ?? 0,
      plotReference: json['plot_reference'] as String? ?? '',
      identity: identityJson != null
          ? IdentitySummary.fromJson(identityJson)
          : IdentitySummary(fullName: null, gender: null, ninMasked: null, passportImageUrl: null),
      steps: VerificationSteps.fromJson(
        (json['steps'] as Map?)?.cast<String, dynamic>() ?? <String, dynamic>{},
      ),
      assessment: RiskAssessment.fromJson(
        (json['assessment'] as Map?)?.cast<String, dynamic>() ??
            <String, dynamic>{},
      ),
      certificate: json['certificate'] != null
          ? VerificationCertificateSummary.fromJson(
              (json['certificate'] as Map).cast<String, dynamic>(),
            )
          : null,
      certificateEligible: json['certificate_eligible'] as bool? ?? false,
      certificateError: json['certificate_error'] as String?,
      verificationMode: json['verification_mode'] as String?,
      remainingAttempts: asInt(json['remaining_attempts']),
    );
  }

  VerificationResult copyWith({
    VerificationCertificateSummary? certificate,
    bool? certificateEligible,
    String? certificateError,
  }) {
    return VerificationResult(
      verificationLogId: verificationLogId,
      plotReference: plotReference,
      identity: identity,
      steps: steps,
      assessment: assessment,
      certificate: certificate ?? this.certificate,
      certificateEligible: certificateEligible ?? this.certificateEligible,
      certificateError: certificateError,
      remainingAttempts: remainingAttempts,
    );
  }

  Map<String, dynamic> toHistoryJson() {
    return {
      'type': 'success',
      'timestamp': DateTime.now().toIso8601String(),
      'plot_reference': plotReference,
      'verification_log_id': verificationLogId,
      'verdict': assessment.verdict,
      'verdict_label': assessment.verdictLabel,
      'risk_score': assessment.riskScore,
      'recommendation': assessment.recommendation,
      'reasons': assessment.reasons,
      'full_name': identity.fullName,
      'nin_masked': identity.ninMasked,
      'certificate_id': certificate?.id,
      'certificate_number': certificate?.certificateNumber,
      'certificate_fingerprint': certificate?.fingerprint,
      'steps': {
        'gps_passed': steps.gpsPassed,
        'nida_questions_passed': steps.nidaQuestionsPassed,
        'owner_link_passed': steps.ownerLinkPassed,
      },
    };
  }
}
