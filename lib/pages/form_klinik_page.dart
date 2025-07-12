import 'package:flutter/material.dart';
import '../models/klinik_model.dart';
import '../services/api_service.dart';

class FormKlinikPage extends StatefulWidget {
  final KlinikModel? klinik;
  final bool isEdit;

  const FormKlinikPage({Key? key, this.klinik, required this.isEdit}) : super(key: key);

  @override
  State<FormKlinikPage> createState() => _FormKlinikPageState();
}

class _FormKlinikPageState extends State<FormKlinikPage> {
  final _formKey = GlobalKey<FormState>();

  final _namaController = TextEditingController();
  final _alamatController = TextEditingController();
  final _noTelpController = TextEditingController();
  final _latController = TextEditingController();
  final _longController = TextEditingController();

  String _kategori = 'Umum';

  @override
  void initState() {
    super.initState();
    if (widget.isEdit && widget.klinik != null) {
      final klinik = widget.klinik!;
      _namaController.text = klinik.nama;
      _alamatController.text = klinik.alamat;
      _noTelpController.text = klinik.noTelpon;
      _latController.text = klinik.latitude.toString();
      _longController.text = klinik.longitude.toString();
      _kategori = klinik.kategori[0].toUpperCase() + klinik.kategori.substring(1).toLowerCase();
    }
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      try {
        final klinik = KlinikModel(
          id: widget.klinik?.id ?? 0,
          nama: _namaController.text,
          alamat: _alamatController.text,
          noTelpon: _noTelpController.text,
          kategori: _kategori,
          latitude: double.parse(_latController.text),
          longitude: double.parse(_longController.text),
        );

        bool success;
        if (widget.isEdit) {
          success = await ApiService.updateKlinik(klinik.id, klinik);
        } else {
          success = await ApiService.addKlinik(klinik);
        }

        if (success) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(widget.isEdit ? 'Berhasil diperbarui' : 'Berhasil ditambahkan')),
          );
          Navigator.pop(context, true);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Gagal menyimpan data')),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Input tidak valid')),
        );
      }
    }
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.orange[50],
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: Text(widget.isEdit ? 'Edit Klinik' : 'Tambah Klinik'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _buildTextField(
                controller: _namaController,
                label: 'Nama Klinik',
                icon: Icons.local_hospital,
                validator: (value) => value == null || value.isEmpty ? 'Wajib diisi' : null,
              ),
              const SizedBox(height: 16),
              _buildTextField(
                controller: _alamatController,
                label: 'Alamat Lengkap',
                icon: Icons.location_on,
                validator: (value) => value == null || value.isEmpty ? 'Wajib diisi' : null,
              ),
              const SizedBox(height: 16),
              _buildTextField(
                controller: _noTelpController,
                label: 'No Telepon',
                icon: Icons.phone,
                validator: (value) => value == null || value.isEmpty ? 'Wajib diisi' : null,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _kategori,
                decoration: InputDecoration(
                  labelText: 'Kategori',
                  prefixIcon: const Icon(Icons.category),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
                items: ['Umum', 'Spesialis'].map((kategori) {
                  return DropdownMenuItem(value: kategori, child: Text(kategori));
                }).toList(),
                onChanged: (value) => setState(() => _kategori = value ?? 'Umum'),
              ),
              const SizedBox(height: 16),
              _buildTextField(
                controller: _latController,
                label: 'Latitude',
                icon: Icons.map,
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Wajib diisi';
                  return double.tryParse(value) == null ? 'Harus berupa angka' : null;
                },
              ),
              const SizedBox(height: 16),
              _buildTextField(
                controller: _longController,
                label: 'Longitude',
                icon: Icons.map_outlined,
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Wajib diisi';
                  return double.tryParse(value) == null ? 'Harus berupa angka' : null;
                },
              ),
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  icon: Icon(widget.isEdit ? Icons.save : Icons.add),
                  label: Text(
                    widget.isEdit ? 'Update Klinik' : 'Simpan Klinik',
                    style: const TextStyle(fontSize: 16),
                  ),
                  onPressed: _submitForm,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
