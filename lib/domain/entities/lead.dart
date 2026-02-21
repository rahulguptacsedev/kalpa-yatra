import 'package:cloud_firestore/cloud_firestore.dart';

enum LeadStatus { newLead, contacted }

class Lead {
  final String id;
  final String name;
  final String phone;
  final String serviceInterest;
  final DateTime timestamp;
  final LeadStatus status;
  final String tenantId;

  const Lead({
    required this.id,
    required this.name,
    required this.phone,
    required this.serviceInterest,
    required this.timestamp,
    this.status = LeadStatus.newLead,
    required this.tenantId,
  });

  Lead copyWith({
    String? id,
    String? name,
    String? phone,
    String? serviceInterest,
    DateTime? timestamp,
    LeadStatus? status,
    String? tenantId,
  }) {
    return Lead(
      id: id ?? this.id,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      serviceInterest: serviceInterest ?? this.serviceInterest,
      timestamp: timestamp ?? this.timestamp,
      status: status ?? this.status,
      tenantId: tenantId ?? this.tenantId,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'phone': phone,
      'serviceInterest': serviceInterest,
      'timestamp': Timestamp.fromDate(timestamp),
      'status': status.name,
      'tenantId': tenantId,
    };
  }

  factory Lead.fromMap(String id, Map<String, dynamic> map) {
    return Lead(
      id: id,
      name: map['name'] ?? '',
      phone: map['phone'] ?? '',
      serviceInterest: map['serviceInterest'] ?? '',
      timestamp: map['timestamp'] is Timestamp
          ? (map['timestamp'] as Timestamp).toDate()
          : DateTime.now(),
      status: LeadStatus.values.firstWhere(
        (s) => s.name == map['status'],
        orElse: () => LeadStatus.newLead,
      ),
      tenantId: map['tenantId'] ?? '',
    );
  }

  String get statusLabel {
    switch (status) {
      case LeadStatus.newLead:
        return 'New';
      case LeadStatus.contacted:
        return 'Contacted';
    }
  }
}
