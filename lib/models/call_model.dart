class CallModel {
  final String firstName;
  final String lastName;
  final String title;
  final String phone;
  final String otherPhone1;

  /// Full raw record, so fields not modelled yet are still available.
  final Map<String, dynamic> raw;

  const CallModel({
    required this.firstName,
    required this.lastName,
    required this.title,
    required this.phone,
    required this.otherPhone1,
    required this.raw,
  });

  String get fullName =>
      [title, firstName, lastName].where((s) => s.isNotEmpty).join(' ');

  factory CallModel.fromJson(Map<String, dynamic> json) => CallModel(
        firstName: json['FirstName']?.toString() ?? '',
        lastName: json['LastName']?.toString() ?? '',
        title: json['Title']?.toString() ?? '',
        phone: json['Phone']?.toString() ?? '',
        otherPhone1: json['Other Phone 1']?.toString() ?? '',
        raw: json,
      );
}
