import 'package:equatable/equatable.dart';

/// PIC (narahubung) klien — halaman "Data Client".
class ClientPic extends Equatable {
  const ClientPic({
    required this.id,
    required this.name,
    required this.company,
    required this.position,
    required this.email,
    required this.phone,
  });

  final String id;
  final String name;
  final String company;
  final String position;
  final String email;
  final String phone;

  @override
  List<Object?> get props => [id, name, company, position, email, phone];
}

/// Perusahaan klien — halaman "Data Company".
class ClientCompany extends Equatable {
  const ClientCompany({
    required this.id,
    required this.name,
    required this.code,
    required this.email,
    required this.phone,
    required this.city,
  });

  final String id;
  final String name;
  final String code;
  final String email;
  final String phone;
  final String city;

  @override
  List<Object?> get props => [id, name, code, email, phone, city];
}
