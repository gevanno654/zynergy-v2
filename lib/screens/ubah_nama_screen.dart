import 'package:flutter/material.dart';
import 'package:zynergy/core/config/theme/app_colors.dart';
import '../api/api_service.dart';

class UbahNamaScreen extends StatefulWidget {
  const UbahNamaScreen({Key? key}) : super(key: key);

  @override
  _UbahNamaScreenState createState() => _UbahNamaScreenState();
}

class _UbahNamaScreenState extends State<UbahNamaScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final ApiService _apiService = ApiService();

  Future<void> _updateName() async {
    if (_formKey.currentState!.validate()) {
      final newName = _nameController.text;

      try {
        final response = await _apiService.updateUserName(newName);
        if (response.success) {
          // Panggil API untuk mengambil data pengguna terbaru
          await _apiService.getUserData();

          // Tampilkan pesan sukses
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Nama berhasil diubah')),
          );

          // Kembali ke halaman sebelumnya
          Navigator.pop(context);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Gagal mengubah nama: ${response.message}')),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Terjadi kesalahan: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Ubah Nama',
          style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 16,
              color: AppColors.black),
        ),
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Masukkan nama baru',
                  style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                      color: AppColors.black),
                ),
                const SizedBox(
                  height: 12,
                ),
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(
                      focusColor: AppColors.lightGrey,
                      labelText: 'Nama',
                      hintText: 'Masukkan nama anda',
                      border: OutlineInputBorder(
                          borderSide: const BorderSide(color: AppColors.lightGrey),
                          borderRadius: BorderRadius.circular(8))),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Nama tidak boleh kosong';
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 24,
                ),
                Container(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _updateName,
                    child: const Text(
                      'Save',
                      style: TextStyle(
                        color: AppColors.secondary,
                        fontSize: 16,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            vertical: 16, horizontal: 12),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8))),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}