import 'dart:async';
import 'kendaraan.dart';

// ===================== Exception kustom =====================
class ParkirPenuh implements Exception {
  final int kapasitas;
  ParkirPenuh(this.kapasitas);

  @override
  String toString() => 'Parkiran penuh (kapasitas $kapasitas)';
}

// ===================== Parkiran =====================
class Parkiran {
  final int kapasitas;
  final List<Kendaraan> _terparkir = []; // privat (enkapsulasi)
  int _pendapatan = 0; // privat
  final _event = StreamController<String>.broadcast();

  Parkiran(this.kapasitas);

  Stream<String> get event => _event.stream;
  int get sisa => kapasitas - _terparkir.length;
  int get pendapatan => _pendapatan;

  Future<void> masuk(Kendaraan k) async {
    await Future.delayed(const Duration(milliseconds: 300)); // palang terbuka

    if (sisa <= 0) {
      final galat = ParkirPenuh(kapasitas);
      _event.add('Ditolak: $galat');
      throw galat;
    }

    _terparkir.add(k);
    _event.add('MASUK ${k.jenis} ${k.plat} (sisa $sisa)');
  }

  Future<int> keluar(String plat, DateTime waktuKeluar) async {
    await Future.delayed(const Duration(milliseconds: 300)); // palang terbuka

    final k = _terparkir.where((x) => x.plat == plat).firstOrNull;
    if (k == null) {
      throw Exception('Kendaraan $plat tidak ada di parkiran');
    }

    final bayar = k.biaya(waktuKeluar); // polimorfisme
    _terparkir.remove(k);
    _pendapatan += bayar;
    _event.add('KELUAR ${k.jenis} ${k.plat} bayar Rp$bayar');
    return bayar;
  }

  Future<void> tutup() => _event.close();
}