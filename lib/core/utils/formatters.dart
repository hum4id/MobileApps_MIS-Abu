import 'package:intl/intl.dart';

abstract final class Formatters {
  static final _rupiah =
      NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);
  // Tanpa locale eksplisit -> pakai locale default (en_US) yang selalu
  // terinisialisasi; nama bulan tetap Bahasa Inggris (mis. "21 May 2026").
  static final _date = DateFormat('d MMMM y');

  static String rupiah(num value) => _rupiah.format(value);
  static String date(DateTime value) => _date.format(value);
}
