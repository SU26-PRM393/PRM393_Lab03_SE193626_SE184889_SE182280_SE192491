import 'package:cloud_firestore/cloud_firestore.dart';

class Event {
  final String id;
  final String campaignId;
  final String name;
  final DateTime? date;
  final List<String> schoolIds;
  final List<String> assignedEmployeeIds;
  final int totalInteractions;
  final String status;
  final DateTime? createdAt;
  final String? hostId;
  final double? latitude;
  final double? longitude;

  Event({
    required this.id,
    required this.campaignId,
    required this.name,
    this.date,
    required this.schoolIds,
    required this.assignedEmployeeIds,
    this.totalInteractions = 0,
    required this.status,
    this.createdAt,
    this.hostId,
    this.latitude,
    this.longitude,
  });

  factory Event.fromMap(String id, Map<String, dynamic> data) {
    return Event(
      id: id,
      campaignId: data['campaignId'] as String? ?? '',
      name: data['name'] as String? ?? '',
      date: (data['date'] as Timestamp?)?.toDate(),
      schoolIds: List<String>.from(data['schoolIds'] ?? []),
      assignedEmployeeIds: List<String>.from(data['assignedEmployeeIds'] ?? []),
      totalInteractions: data['totalInteractions'] as int? ?? 0,
      status: data['status'] as String? ?? 'in-progress',
      createdAt: (data['createdAt'] as Timestamp?)?.toDate(),
      hostId: data['hostId'] as String?,
      latitude: (data['latitude'] as num?)?.toDouble(),
      longitude: (data['longitude'] as num?)?.toDouble(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'campaignId': campaignId,
      'name': name.trim(),
      'date': date == null ? null : Timestamp.fromDate(date!),
      'schoolIds': schoolIds,
      'assignedEmployeeIds': assignedEmployeeIds,
      'totalInteractions': totalInteractions,
      'status': status,
      'hostId': hostId,
      'latitude': latitude,
      'longitude': longitude,
    };
  }

  Event copyWith({
    String? id,
    String? campaignId,
    String? name,
    DateTime? date,
    List<String>? schoolIds,
    List<String>? assignedEmployeeIds,
    int? totalInteractions,
    String? status,
    DateTime? createdAt,
    String? hostId,
    double? latitude,
    double? longitude,
  }) {
    return Event(
      id: id ?? this.id,
      campaignId: campaignId ?? this.campaignId,
      name: name ?? this.name,
      date: date ?? this.date,
      schoolIds: schoolIds ?? this.schoolIds,
      assignedEmployeeIds: assignedEmployeeIds ?? this.assignedEmployeeIds,
      totalInteractions: totalInteractions ?? this.totalInteractions,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      hostId: hostId ?? this.hostId,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
    );
  }
}
