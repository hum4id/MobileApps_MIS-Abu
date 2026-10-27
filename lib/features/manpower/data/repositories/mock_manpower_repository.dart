import '../../domain/entities/manpower.dart';
import '../../domain/repositories/manpower_repository.dart';

/// Data contoh diambil dari mock web. Ganti dengan implementasi Dio saat API siap.
class MockManpowerRepository implements ManpowerRepository {
  @override
  Future<List<Manpower>> fetchManpower({
    String query = '',
    EmploymentStatus? status,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 300));
    final q = query.trim().toLowerCase();
    return _data.where((m) {
      final matchesQuery = q.isEmpty ||
          m.fullName.toLowerCase().contains(q) ||
          m.email.toLowerCase().contains(q) ||
          m.position.toLowerCase().contains(q);
      final matchesStatus = status == null || m.employmentStatus == status;
      return matchesQuery && matchesStatus;
    }).toList();
  }

  static const _data = <Manpower>[
    Manpower(
      id: '1',
      fullName: 'Agus T.',
      position: 'Director',
      employmentStatus: EmploymentStatus.fulltime,
      skills: ['Leadership', 'Management', 'Strategic Planning'],
      phoneNumber: '0821 5410 7123',
      email: 'agus@makromedia.id',
    ),
    Manpower(
      id: '2',
      fullName: 'Gusan',
      position: 'Marketing',
      employmentStatus: EmploymentStatus.fulltime,
      skills: ['Public Speaking', 'Client Relations', 'Event Production'],
      phoneNumber: '0823 5410 8129',
      email: 'gusan@makromedia.id',
    ),
    Manpower(
      id: '3',
      fullName: 'John Doe',
      position: 'Editor',
      employmentStatus: EmploymentStatus.freelance,
      skills: ['Video Editor (Premiere / DaVinci)', 'Drone Pilot (Certified)'],
      phoneNumber: '081234567890',
      email: 'john@makromedia.com',
    ),
    Manpower(
      id: '4',
      fullName: 'Siti Rahma',
      position: 'Project Manager',
      employmentStatus: EmploymentStatus.parttime,
      skills: ['Project Management', 'Budgeting & Finance'],
      phoneNumber: '0812 7788 1020',
      email: 'siti@makromedia.id',
    ),
    Manpower(
      id: '5',
      fullName: 'Rizky Pratama',
      position: 'Cameraman',
      employmentStatus: EmploymentStatus.internship,
      skills: ['Camera Operator / Cameraman'],
      phoneNumber: '0857 1234 5566',
      email: 'rizky@makromedia.id',
    ),
  ];
}
