import 'package:flutter/material.dart';
import 'package:zynergy/core/config/theme/app_colors.dart';
import '../api/api_service.dart';
import '../api/api_response.dart'; // Impor ApiResponse

class UbahJenisKelamin extends StatefulWidget {
  const UbahJenisKelamin({Key? key}) : super(key: key);

  @override
  _UbahJenisKelaminState createState() => _UbahJenisKelaminState();
}

enum JenisKelamin {
  male('Laki-Laki'),
  female('Perempuan');

  final String label;
  const JenisKelamin(this.label);
}

class _UbahJenisKelaminState extends State<UbahJenisKelamin> {
  JenisKelamin? _jenisKelamin;
  final ApiService _apiService = ApiService();

  @override
  void initState() {
    super.initState();
    _fetchGender();
  }

  Future<void> _fetchGender() async {
    try {
      final userData = await _apiService.getUserData();
      final gender = userData['gender'];

      setState(() {
        _jenisKelamin = gender == 'male' ? JenisKelamin.male : JenisKelamin.female;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load gender data: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ubah Jenis Kelamin'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Pilih Jenis Kelamin',
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 16,
              ),
            ),
            Row(
              children: [
                SizedBox(
                  width: 20,
                  child: Radio(
                    activeColor: AppColors.primary,
                    value: JenisKelamin.male,
                    groupValue: _jenisKelamin,
                    onChanged: (JenisKelamin? value) {
                      setState(() {
                        _jenisKelamin = value;
                      });
                    },
                  ),
                ),
                SizedBox(
                  width: 8,
                ),
                Text(
                  JenisKelamin.male.label, // Tampilkan "Laki-Laki"
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
            Row(
              children: [
                SizedBox(
                  width: 20,
                  child: Radio(
                    activeColor: AppColors.primary,
                    value: JenisKelamin.female,
                    groupValue: _jenisKelamin,
                    onChanged: (JenisKelamin? value) {
                      setState(() {
                        _jenisKelamin = value;
                      });
                    },
                  ),
                ),
                SizedBox(
                  width: 8,
                ),
                Text(
                  JenisKelamin.female.label, // Tampilkan "Perempuan"
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  String gender = _jenisKelamin == JenisKelamin.male ? 'male' : 'female';
                  ApiResponse response = await _apiService.updateGender(gender);

                  if (response.success) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Jenis kelamin berhasil diperbarui')),
                    );
                    // Kirim data jenis kelamin yang baru ke ProfilScreen
                    Navigator.pop(context, gender);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Gagal memperbarui jenis kelamin: ${response.message}')),
                    );
                  }
                },
                child: const Text('Save'),
              ),
            )
          ],
        ),
      ),
    );
  }
}