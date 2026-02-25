import 'identity_summary.dart';
import 'risk_assessment.dart';
import 'verification_steps.dart';
import 'parsing.dart';

class VerificationResult {
  VerificationResult({
    required this.verificationLogId,
    required this.plotReference,
    required this.identity,
    required this.steps,
    required this.assessment,
  });

  final int verificationLogId;
  final String plotReference;
  final IdentitySummary identity;
  final VerificationSteps steps;
  final RiskAssessment assessment;

  factory VerificationResult.fromJson(Map<String, dynamic> json) {
    return VerificationResult(
      verificationLogId: asInt(json['verification_log_id']) ?? 0,
      plotReference: json['plot_reference'] as String? ?? '',
      identity: IdentitySummary.fromJson(
        (json['identity'] as Map?)?.cast<String, dynamic>() ??
            <String, dynamic>{},
      ),
      steps: VerificationSteps.fromJson(
        (json['steps'] as Map?)?.cast<String, dynamic>() ?? <String, dynamic>{},
      ),
      assessment: RiskAssessment.fromJson(
        (json['assessment'] as Map?)?.cast<String, dynamic>() ??
            <String, dynamic>{},
      ),
    );
  }

  Map<String, dynamic> toHistoryJson() {
    return {
      'type': 'success',
      'timestamp': DateTime.now().toIso8601String(),
      'plot_reference': plotReference,
      'verification_log_id': verificationLogId,
      'verdict': assessment.verdict,
      'risk_score': assessment.riskScore,
      'recommendation': assessment.recommendation,
      'full_name': identity.fullName,
      'nin_masked': identity.ninMasked,
    };
  }
}
