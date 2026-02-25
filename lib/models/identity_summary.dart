class IdentitySummary {
  IdentitySummary({
    required this.fullName,
    required this.gender,
    required this.ninMasked,
    required this.passportImageUrl,
  });

  final String? fullName;
  final String? gender;
  final String? ninMasked;
  final String? passportImageUrl;

  factory IdentitySummary.fromJson(Map<String, dynamic> json) {
    return IdentitySummary(
      fullName: json['full_name'] as String?,
      gender: json['gender'] as String?,
      ninMasked: json['nin_masked'] as String?,
      passportImageUrl: json['passport_image_url'] as String?,
    );
  }
}
