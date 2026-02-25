import 'plot_summary.dart';

class PlotStepData {
  PlotStepData({
    required this.verificationToken,
    required this.plot,
    required this.nextStep,
  });

  final String verificationToken;
  final PlotSummary plot;
  final String nextStep;

  factory PlotStepData.fromJson(Map<String, dynamic> json) {
    return PlotStepData(
      verificationToken: json['verification_token'] as String? ?? '',
      plot: PlotSummary.fromJson(
        (json['plot'] as Map?)?.cast<String, dynamic>() ?? <String, dynamic>{},
      ),
      nextStep: json['next_step'] as String? ?? '',
    );
  }
}
