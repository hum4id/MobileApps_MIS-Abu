import 'package:equatable/equatable.dart';

/// Status kepegawaian (mengikuti web: Fulltime / Parttime / Internship / Freelance).
enum EmploymentStatus {
  fulltime('Fulltime'),
  parttime('Parttime'),
  internship('Internship'),
  freelance('Freelance');

  const EmploymentStatus(this.label);
  final String label;
}

class Manpower extends Equatable {
  const Manpower({
    required this.id,
    required this.fullName,
    required this.position,
    required this.employmentStatus,
    required this.skills,
    required this.phoneNumber,
    required this.email,
  });

  final String id;
  final String fullName;
  final String position;
  final EmploymentStatus employmentStatus;
  final List<String> skills;
  final String phoneNumber;
  final String email;

  @override
  List<Object?> get props =>
      [id, fullName, position, employmentStatus, skills, phoneNumber, email];
}
