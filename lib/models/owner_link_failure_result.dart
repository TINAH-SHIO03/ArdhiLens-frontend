import 'owner_link_info.dart';
import 'parsing.dart';
import 'risk_assessment.dart';

class OwnerLinkFailureResult {
  OwnerLinkFailureResult({
    required this.verificationLogId,
    required this.message,
    required this.ownerLink,
    required this.assessment,
  });

  final int verificationLogId;
  final String message;
  final OwnerLinkInfo ownerLink;
  final RiskAssessment assessment;

  factory OwnerLinkFailureResult.fromError(
    String message,
    Map<String, dynamic>? errors,
  ) {
    final ownerLinkJson =
        (errors?['owner_link'] as Map?)?.cast<String, dynamic>() ??
        <String, dynamic>{};
    final assessmentJson =
        (errors?['assessment'] as Map?)?.cast<String, dynamic>() ??
        <String, dynamic>{};

    return OwnerLinkFailureResult(
      verificationLogId: asInt(errors?['verification_log_id']) ?? 0,
      message: message,
      ownerLink: OwnerLinkInfo.fromJson(ownerLinkJson),
      assessment: RiskAssessment.fromJson(assessmentJson),
    );
  }

  Map<String, dynamic> toHistoryJson() {
    return {
      'type': 'blocked',
      'timestamp': DateTime.now().toIso8601String(),
      'verification_log_id': verificationLogId,
      'message': message,
      'verdict': assessment.verdict,
      'verdict_label': assessment.verdictLabel,
      'risk_score': assessment.riskScore,
      'recommendation': assessment.recommendation,
      'reasons': assessment.reasons,
    };
  }
}
