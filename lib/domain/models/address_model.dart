class Address {
  final String id;
  final String label;
  final String address;
  final bool isDefault;

  Address({
    required this.id,
    required this.label,
    required this.address,
    this.isDefault = false,
  });
}
