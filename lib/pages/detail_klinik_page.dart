import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:klinik_mi2a/models/klinik_model.dart';

class DetailKlinikPage extends StatelessWidget {
  final KlinikModel klinik;

  const DetailKlinikPage({Key? key, required this.klinik}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final LatLng lokasiKlinik = LatLng(klinik.latitude, klinik.longitude);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: Text(klinik.nama),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            klinik.nama,
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Text('Alamat: ${klinik.alamat}'),
          SizedBox(height: 4),
          Text('No. Telepon: ${klinik.noTelpon}'),
          SizedBox(height: 4),
          Text('Kategori: ${klinik.kategori}'),
          SizedBox(height: 16),
          Text(
            'Lokasi Klinik',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          Container(
            height: 250,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.orange),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: GoogleMap(
                initialCameraPosition: CameraPosition(
                  target: lokasiKlinik,
                  zoom: 15,
                ),
                markers: {
                  Marker(
                    markerId: MarkerId(klinik.nama),
                    position: lokasiKlinik,
                    infoWindow: InfoWindow(title: klinik.nama),
                  ),
                },
                zoomControlsEnabled: false,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
