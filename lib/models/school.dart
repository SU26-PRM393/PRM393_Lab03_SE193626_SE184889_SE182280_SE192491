class School {
  final String id;
  final String provinceCode;
  final String provinceName;
  final String communeCode;
  final String communeName;
  final String schoolCode;
  final String schoolName;
  final String address;
  final String region;

  School({
    required this.id,
    required this.provinceCode,
    required this.provinceName,
    required this.communeCode,
    required this.communeName,
    required this.schoolCode,
    required this.schoolName,
    required this.address,
    required this.region,
  });

  factory School.fromMap(String id, Map<String, dynamic> data) {
    return School(
      id: id,
      provinceCode: data['provinceCode'] as String? ?? '',
      provinceName: data['provinceName'] as String? ?? '',
      communeCode: data['communeCode'] as String? ?? '',
      communeName: data['communeName'] as String? ?? '',
      schoolCode: data['schoolCode'] as String? ?? '',
      schoolName: data['schoolName'] as String? ?? '',
      address: data['address'] as String? ?? '',
      region: data['region'] as String? ?? '',
    );
  }
}
