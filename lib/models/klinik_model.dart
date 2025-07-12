class KlinikModel {
  final int id;
  final String nama;
  final String alamat;
  final String noTelpon;
  final String kategori;
  final double latitude;
  final double longitude;

  KlinikModel({
    required this.id,
    required this.nama,
    required this.alamat,
    required this.noTelpon,
    required this.kategori,
    required this.latitude,
    required this.longitude,
  });

  factory KlinikModel.fromJson(Map<String, dynamic> json) {
    return KlinikModel(
      id: json['id'] ?? 0,
      nama: json['nama'] ?? '',
      alamat: json['alamat'] ?? '',
      noTelpon: json['no_telpon'] ?? '',
      kategori: json['kategori'] ?? '',
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nama': nama,
      'alamat': alamat,
      'no_telpon': noTelpon,
      'kategori': kategori,
      'latitude': latitude,
      'longitude': longitude,
    };
  }
}
