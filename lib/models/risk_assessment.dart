import 'parsing.dart';

class RiskAssessment {
  RiskAssessment({
    required this.verdict,
    required this.verdictLabel,
    required this.riskScore,
    required this.reasons,
    required this.recommendation,
  });

  final String verdict;
  final String verdictLabel;
  final int riskScore;
  final List<String> reasons;
  final String recommendation;

  factory RiskAssessment.fromJson(Map<String, dynamic> json) {
    final reasons = ((json['reasons'] as List?) ?? const [])
        .map((item) => item.toString())
        .toList();

    return RiskAssessment(
      verdict: json['verdict'] as String? ?? '',
      verdictLabel: json['verdict_label'] as String? ?? '',
      riskScore: asInt(json['risk_score']) ?? 0,
      reasons: reasons,
      recommendation: json['recommendation'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'verdict': verdict,
      'verdict_label': verdictLabel,
      'risk_score': riskScore,
      'reasons': reasons,
      'recommendation': recommendation,
    };
  }
}
