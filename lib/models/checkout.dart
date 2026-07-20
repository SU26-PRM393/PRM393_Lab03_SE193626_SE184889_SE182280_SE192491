import 'package:cloud_firestore/cloud_firestore.dart';

class CheckOut {
  final String id;
  final String eventId;
  final String employeeId;
  final String employeeName;
  final DateTime timestamp;
  final String photoUrl;
  final double latitude;
  final double longitude;
  final double distanceMeters;

  CheckOut({
    required this.id,
    required this.eventId,
    required this.employeeId,
    required this.employeeName,
    required this.timestamp,
    required this.photoUrl,
    required this.latitude,
    required this.longitude,
    required this.distanceMeters,
  });

  factory CheckOut.fromMap(String id, Map<String, dynamic> data) {
    return CheckOut(
      id: id,
      eventId: data['eventId'] as String? ?? '',
      employeeId: data['employeeId'] as String? ?? '',
      employeeName: data['employeeName'] as String? ?? '',
      timestamp: (data['timestamp'] as Timestamp?)?.toDate() ?? DateTime.now(),
      photoUrl: data['photoUrl'] as String? ?? '',
      latitude: (data['latitude'] as num? ?? 0.0).toDouble(),
      longitude: (data['longitude'] as num? ?? 0.0).toDouble(),
      distanceMeters: (data['distanceMeters'] as num? ?? 0.0).toDouble(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'eventId': eventId,
      'employeeId': employeeId,
      'employeeName': employeeName,
      'timestamp': Timestamp.fromDate(timestamp),
      'photoUrl': photoUrl,
      'latitude': latitude,
      'longitude': longitude,
      'distanceMeters': distanceMeters,
    };
  }
}
