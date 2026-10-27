import '../entities/manpower.dart';

abstract interface class ManpowerRepository {
  Future<List<Manpower>> fetchManpower({
    String query = '',
    EmploymentStatus? status,
  });
}
