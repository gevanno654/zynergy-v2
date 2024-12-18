import 'package:flutter/material.dart';
import 'package:zynergy/core/config/theme/app_colors.dart';
import '../api/api_service.dart';
import '../api/api_response.dart'; // Impor ApiResponse

class UbahJenisKelamin extends StatefulWidget {
  const UbahJenisKelamin({Key? key}) : super(key: key);

  @override
  _UbahJenisKelaminState createState() => _UbahJenisKelaminState();
}

class _UbahJenisKelaminState extends State<UbahJenisKelamin> {
  String? _selectedGender;
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
        _selectedGender = gender;
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
        leading: IconButton(
          icon: Icon(Icons.chevron_left, size: 32, color: Colors.black), // Chevron left rounded
          onPressed: () {
            Navigator.pop(context); // Kembali ke halaman sebelumnya
          },
        ),
        elevation: 0,
        title: SizedBox.shrink(),
      ),
      body: _buildGenderPage(),
      persistentFooterButtons: [
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () async {
              if (_selectedGender == null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Pilih jenis kelamin terlebih dahulu')),
                );
                return;
              }

              ApiResponse response = await _apiService.updateGender(_selectedGender!);

              if (response.success) {
                Navigator.pop(context, _selectedGender);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Gagal memperbarui jenis kelamin: ${response.message}')),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary, // Warna latar belakang tombol
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
            child: const Text(
              'Save',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white, // Warna teks tombol
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildGenderPage() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Spill Jenis Kelaminmu",
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w600,
                  height: 1,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Isi personalisasi untuk rekomendasimu",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
              ),
            ],
          ),
          SizedBox(height: 60),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Pilih jenis kelamin',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.normal),
              ),
            ],
          ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                children: [
                  _buildGenderCard(
                    gender: 'male',
                    label: 'Cowok',
                    imagePath: 'assets/images/male_avatar.png',
                  ),
                  SizedBox(height: 8), // Jarak antara gambar dan teks
                  Text(
                    'Cowok',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: _selectedGender == 'male' ? AppColors.primary : Colors.black,
                    ),
                  ),
                ],
              ),
              SizedBox(width: 16),
              Column(
                children: [
                  _buildGenderCard(
                    gender: 'female',
                    label: 'Cewek',
                    imagePath: 'assets/images/female_avatar.png',
                  ),
                  SizedBox(height: 8), // Jarak antara gambar dan teks
                  Text(
                    'Cewek',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: _selectedGender == 'female' ? AppColors.primary : Colors.black,
                    ),
                  ),
                ],
              ),
            ],
          ),
          if (_selectedGender == null)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: Text(
                    'Pilih jenis kelamin terlebih dahulu',
                    style: TextStyle(
                      color: Colors.red,
                    ),
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildGenderCard({
    required String gender,
    required String label,
    required String imagePath,
  }) {
    return GestureDetector(
      onTap: () => setState(() => _selectedGender = gender),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 700), // Durasi animasi
        curve: Curves.easeInOut, // Kurva animasi
        decoration: BoxDecoration(
          color: _selectedGender == gender ? AppColors.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          border: _selectedGender == gender
              ? null
              : Border.all(color: Color(0xFFDFDFDF), width: 1.5),
        ),
        child: Image.asset(
          imagePath,
          width: 130,
          height: 130,
        ),
      ),
    );
  }
}