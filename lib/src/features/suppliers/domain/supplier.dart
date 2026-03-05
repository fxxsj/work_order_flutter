class Supplier {
  const Supplier({
    required this.id,
    required this.name,
    this.code,
    this.contactPerson,
    this.phone,
    this.email,
    this.address,
    this.status,
    this.statusDisplay,
    this.materialCount,
    this.notes,
  });

  final int id;
  final String name;
  final String? code;
  final String? contactPerson;
  final String? phone;
  final String? email;
  final String? address;
  final String? status;
  final String? statusDisplay;
  final int? materialCount;
  final String? notes;
}
