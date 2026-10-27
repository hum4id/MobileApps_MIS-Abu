import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/client.dart';

/// Data contoh dari mock web. Ganti dengan implementasi Dio saat API siap.
const _mockPics = <ClientPic>[
  ClientPic(id: '1', name: 'Budi Santoso', company: 'PT Innovate Indonesia', position: 'Marketing Manager', email: 'budi@innovate.co.id', phone: '0811 1222 333'),
  ClientPic(id: '2', name: 'Siti Rahma', company: 'Bank Nusantara', position: 'Head of Corporate Communications', email: 'siti@banknusantara.co.id', phone: '0812 2333 444'),
  ClientPic(id: '3', name: 'Ahmad Fauzi', company: 'Yayasan Seni Visual', position: 'Program Director', email: 'ahmad@senivisual.org', phone: '0813 3444 555'),
  ClientPic(id: '4', name: 'Dewi Lestari', company: 'Brand Retail Utama', position: 'Brand Manager', email: 'dewi@brandretail.co.id', phone: '0814 4555 666'),
  ClientPic(id: '5', name: 'Michael Henderson', company: 'Keluarga Henderson', position: 'Wedding Coordinator', email: 'henderson.family@gmail.com', phone: '0815 5666 777'),
];

const _mockCompanies = <ClientCompany>[
  ClientCompany(id: '1', name: 'PT Innovate Indonesia', code: 'CLT-001', email: 'info@innovate.co.id', phone: '021-5550100', city: 'Jakarta'),
  ClientCompany(id: '2', name: 'Bank Nusantara', code: 'CLT-002', email: 'contact@banknusantara.co.id', phone: '021-5550200', city: 'Jakarta'),
  ClientCompany(id: '3', name: 'Yayasan Seni Visual', code: 'CLT-003', email: 'secretariat@senivisual.org', phone: '022-4200300', city: 'Bandung'),
  ClientCompany(id: '4', name: 'Brand Retail Utama', code: 'CLT-004', email: 'hello@brandretail.co.id', phone: '031-5550400', city: 'Surabaya'),
  ClientCompany(id: '5', name: 'Keluarga Henderson', code: 'CLT-005', email: 'henderson.family@gmail.com', phone: '0815-5666-777', city: 'Malang'),
];

// --- PIC / Data Client ---
final clientPicSearchProvider = StateProvider<String>((ref) => '');

final clientPicListProvider = FutureProvider.autoDispose<List<ClientPic>>((ref) async {
  final q = ref.watch(clientPicSearchProvider).trim().toLowerCase();
  await Future<void>.delayed(const Duration(milliseconds: 250));
  return _mockPics.where((p) {
    return q.isEmpty ||
        p.name.toLowerCase().contains(q) ||
        p.company.toLowerCase().contains(q) ||
        p.email.toLowerCase().contains(q) ||
        p.phone.contains(q);
  }).toList();
});

// --- Company / Data Company ---
final clientCompanySearchProvider = StateProvider<String>((ref) => '');

final clientCompanyListProvider = FutureProvider.autoDispose<List<ClientCompany>>((ref) async {
  final q = ref.watch(clientCompanySearchProvider).trim().toLowerCase();
  await Future<void>.delayed(const Duration(milliseconds: 250));
  return _mockCompanies.where((c) {
    return q.isEmpty ||
        c.name.toLowerCase().contains(q) ||
        c.city.toLowerCase().contains(q) ||
        c.email.toLowerCase().contains(q) ||
        c.phone.contains(q);
  }).toList();
});
