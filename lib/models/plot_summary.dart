import 'parsing.dart';

class PlotSummary {
  PlotSummary({
    required this.id,
    required this.plotReference,
    required this.region,
    required this.district,
    required this.ward,
    required this.villageMtaa,
    required this.street,
    required this.gpsLatitude,
    required this.gpsLongitude,
    required this.sizeHectares,
    required this.landUse,
    required this.tenureType,
    required this.certificateType,
    required this.issueDate,
    required this.expiryDate,
    required this.status,
  });

  final int id;
  final String plotReference;
  final String region;
  final String district;
  final String ward;
  final String villageMtaa;
  final String? street;
  final double? gpsLatitude;
  final double? gpsLongitude;
  final String sizeHectares;
  final String landUse;
  final String tenureType;
  final String certificateType;
  final String? issueDate;
  final String? expiryDate;
  final String status;

  factory PlotSummary.fromJson(Map<String, dynamic> json) {
    return PlotSummary(
      id: asInt(json['id']) ?? 0,
      plotReference: json['plot_reference'] as String? ?? '',
      region: json['region'] as String? ?? '',
      district: json['district'] as String? ?? '',
      ward: json['ward'] as String? ?? '',
      villageMtaa: json['village_mtaa'] as String? ?? '',
      street: json['street'] as String?,
      gpsLatitude: asDouble(json['gps_latitude']),
      gpsLongitude: asDouble(json['gps_longitude']),
      sizeHectares: json['size_hectares']?.toString() ?? '',
      landUse: json['land_use'] as String? ?? '',
      tenureType: json['tenure_type'] as String? ?? '',
      certificateType: json['certificate_type'] as String? ?? '',
      issueDate: json['issue_date'] as String?,
      expiryDate: json['expiry_date'] as String?,
      status: json['status'] as String? ?? '',
    );
  }
}
