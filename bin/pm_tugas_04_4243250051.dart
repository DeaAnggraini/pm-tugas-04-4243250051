import 'package:pm_tugas_04_4243250051/kendaraan.dart';
import 'package:pm_tugas_04_4243250051/parkiran.dart';

Future<void> main() async {
  final parkiran = Parkiran(3);

  // Layar pos jaga: menampilkan setiap kejadian dari Stream
  parkiran.event.listen((pesan) => print(pesan));

  final awal = DateTime(2026, 11, 1, 8, 0);

  // Polimorfisme: satu List berisi berbagai jenis kendaraan
  final antrean = <Kendaraan>[
    Motor('BK 1234 AB', awal),
    Mobil('BK 88 UN', awal.add(const Duration(minutes: 15))),
    MobilMember('BK 7 MIPA', awal.add(const Duration(minutes: 30))),
    Truk('BK 9 TRK', awal.add(const Duration(minutes: 45))), // akan ditolak
  ];

  // Kendaraan masuk (kapasitas 3, jadi yang ke-4 ditolak)
  for (final k in antrean) {
    try {
      await parkiran.masuk(k);
    } on ParkirPenuh {
      // pesan penolakan sudah ditampilkan lewat Stream
    }
  }

  // Kendaraan keluar
  final jamKeluar = {
    'BK 1234 AB': awal.add(const Duration(hours: 2, minutes: 30)),
    'BK 88 UN': awal.add(const Duration(hours: 3)),
    'BK 7 MIPA': awal.add(const Duration(hours: 3, minutes: 20)),
  };
  for (final e in jamKeluar.entries) {
    await parkiran.keluar(e.key, e.value);
  }

  // Beri kesempatan listener menampilkan event terakhir
  await Future.delayed(Duration.zero);

  print('Pendapatan: Rp${parkiran.pendapatan}');
  await parkiran.tutup();
}