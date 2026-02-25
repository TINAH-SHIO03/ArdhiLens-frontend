class OwnerLinkInfo {
  OwnerLinkInfo({
    required this.passed,
    required this.plotOwnerMatch,
    required this.historyOwnerMatch,
  });

  final bool passed;
  final bool plotOwnerMatch;
  final bool historyOwnerMatch;

  factory OwnerLinkInfo.fromJson(Map<String, dynamic> json) {
    return OwnerLinkInfo(
      passed: json['passed'] as bool? ?? false,
      plotOwnerMatch: json['plot_owner_match'] as bool? ?? false,
      historyOwnerMatch: json['history_owner_match'] as bool? ?? false,
    );
  }
}
