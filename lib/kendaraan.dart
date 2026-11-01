// ===================== Kendaraan =====================
abstract class Kendaraan {
  final String plat;
  final DateTime waktuMasuk;

  Kendaraan(this.plat, this.waktuMasuk);

  String get jenis; // abstrak: wajib diisi subclass
  int get tarifPerJam; // abstrak: wajib diisi subclass
  double get diskon => 0; // 0 = tanpa diskon, bisa ditimpa mixin

  // Dibulatkan ke atas per jam, minimal 1 jam
  int biaya(DateTime keluar) {
    final menit = keluar.difference(waktuMasuk).inMinutes;
    var jam = (menit / 60).ceil();
    if (jam < 1) jam = 1;
    return (jam * tarifPerJam * (1 - diskon)).round();
  }
}

// ===================== Mixin =====================
mixin Berlangganan on Kendaraan {
  @override
  double get diskon => 0.5; // diskon 50%
}

// ===================== Subclass =====================
class Motor extends Kendaraan {
  Motor(super.plat, super.waktuMasuk);

  @override
  String get jenis => 'Motor';

  @override
  int get tarifPerJam => 2000;
}

class Mobil extends Kendaraan {
  Mobil(super.plat, super.waktuMasuk);

  @override
  String get jenis => 'Mobil';

  @override
  int get tarifPerJam => 5000;
}

class Truk extends Kendaraan {
  Truk(super.plat, super.waktuMasuk);

  @override
  String get jenis => 'Truk';

  @override
  int get tarifPerJam => 10000;
}

// Mobil berlangganan: tarif Mobil + diskon dari mixin
class MobilMember extends Mobil with Berlangganan {
  MobilMember(super.plat, super.waktuMasuk);

  @override
  String get jenis => '${super.jenis} (member)';
}