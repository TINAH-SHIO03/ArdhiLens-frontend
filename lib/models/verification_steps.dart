class VerificationSteps {
  VerificationSteps({
    required this.plotFound,
    required this.gpsPassed,
    required this.nidaQuestionsPassed,
    required this.ownerLinkPassed,
  });

  final bool plotFound;
  final bool gpsPassed;
  final bool nidaQuestionsPassed;
  final bool ownerLinkPassed;

  factory VerificationSteps.fromJson(Map<String, dynamic> json) {
    return VerificationSteps(
      plotFound: json['plot_found'] as bool? ?? false,
      gpsPassed: json['gps_passed'] as bool? ?? false,
      nidaQuestionsPassed: json['nida_questions_passed'] as bool? ?? false,
      ownerLinkPassed: json['owner_link_passed'] as bool? ?? false,
    );
  }
}
