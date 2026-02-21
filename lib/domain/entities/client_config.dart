import 'package:flutter/material.dart';

class ClientConfig {
  final String tenantId;
  final String clientName;
  final String primaryColorHex;
  final String logoUrl;
  final String whatsappNumber;
  final String supportEmail;
  final String contactPersonName;

  const ClientConfig({
    required this.tenantId,
    required this.clientName,
    required this.primaryColorHex,
    required this.logoUrl,
    required this.whatsappNumber,
    required this.supportEmail,
    this.contactPersonName = '',
  });

  ClientConfig copyWith({
    String? tenantId,
    String? clientName,
    String? primaryColorHex,
    String? logoUrl,
    String? whatsappNumber,
    String? supportEmail,
    String? contactPersonName,
  }) {
    return ClientConfig(
      tenantId: tenantId ?? this.tenantId,
      clientName: clientName ?? this.clientName,
      primaryColorHex: primaryColorHex ?? this.primaryColorHex,
      logoUrl: logoUrl ?? this.logoUrl,
      whatsappNumber: whatsappNumber ?? this.whatsappNumber,
      supportEmail: supportEmail ?? this.supportEmail,
      contactPersonName: contactPersonName ?? this.contactPersonName,
    );
  }

  Color get primaryColor {
    final hex = primaryColorHex.replaceFirst('#', '');
    return Color(int.parse('FF$hex', radix: 16));
  }

  Map<String, dynamic> toMap() => {
    'clientName': clientName,
    'primaryColorHex': primaryColorHex,
    'logoUrl': logoUrl,
    'whatsappNumber': whatsappNumber,
    'supportEmail': supportEmail,
    'contactPersonName': contactPersonName,
  };

  factory ClientConfig.fromMap(String tenantId, Map<String, dynamic> map) {
    return ClientConfig(
      tenantId: tenantId,
      clientName: map['clientName'] ?? '',
      primaryColorHex: map['primaryColorHex'] ?? '#E65100',
      logoUrl: map['logoUrl'] ?? '',
      whatsappNumber: map['whatsappNumber'] ?? '',
      supportEmail: map['supportEmail'] ?? '',
      contactPersonName: map['contactPersonName'] ?? '',
    );
  }

  static const defaultConfig = ClientConfig(
    tenantId: 'varanasi_default',
    clientName: 'Kalpa Yatra',
    primaryColorHex: '#E65100',
    logoUrl: 'https://img.icons8.com/color/96/om.png',
    whatsappNumber: '919876543210',
    supportEmail: 'namaste@kalpayatra.com',
    contactPersonName: 'Rahul Sharma',
  );
}
