class Tenant {
  final String tenantName;
  final String tenantLicenseNo;
  final String mobileNo;
  final String emiratesId;
  final String nationality;
  final String email;
  final String trnNo;
  final String registrationNo;
  final String address;

  Tenant({
    required this.tenantName,
    required this.tenantLicenseNo,
    required this.mobileNo,
    required this.emiratesId,
    required this.nationality,
    required this.email,
    required this.trnNo,
    required this.registrationNo,
    required this.address,
  });

  // Factory constructor to create a Tenant instance from a map
  factory Tenant.fromMap(Map<String, dynamic> map) {
    return Tenant(
      tenantName: map['Tenant Name'] ?? '',
      tenantLicenseNo: map['Trade License no'] ?? '',
      mobileNo: map['Mobile No'] ?? '',
      emiratesId: map['Emirates ID'] ?? '',
      nationality: map['Nationality'] ?? '',
      email: map['Email'] ?? '',
      trnNo: map['TRN No'] ?? '',
      registrationNo: map['Registered'] ?? '',
      address: map['Address'] ?? '',
    );
  }

  // Convert the Tenant instance to a map
  Map<String, dynamic> toMap() {
    return {
      'Tenant Name': tenantName,
      'Trade License no': tenantLicenseNo,
      'Mobile No': mobileNo,
      'Emirates ID': emiratesId,
      'Nationality': nationality,
      'Email': email,
      'TRN No': trnNo,
      'Registered': registrationNo,
      'Address': address,
    };
  }
}


class TenantInfo {
  final String id;
  final String name;

  TenantInfo({required this.id, required this.name});
}
