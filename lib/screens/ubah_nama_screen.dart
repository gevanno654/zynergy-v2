import 'package:flutter/material.dart';
import 'package:zynergy/core/config/theme/app_colors.dart';
import '../api/api_service.dart';
import 'package:shimmer/shimmer.dart';

class UbahNamaScreen extends StatefulWidget {
  const UbahNamaScreen({Key? key}) : super(key: key);

  @override
  _UbahNamaScreenState createState() => _UbahNamaScreenState();
}

class _UbahNamaScreenState extends State<UbahNamaScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _currentNameController = TextEditingController();
  final ApiService _apiService = ApiService();

  bool _isLoading = true; // Menandakan apakah data sedang dimuat

  Future<void> _fetchCurrentName() async {
    try {
      final userData = await _apiService.getUserData(); // Asumsikan ini mengembalikan Map<String, dynamic>
      if (userData != null && userData['name'] != null) { // Akses 'name' langsung dari Map
        setState(() {
          _currentNameController.text = userData['name']; // Set nilai nama saat ini
          _isLoading = false; // Set loading selesai
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal mengambil nama saat ini: $e')),
      );
      setState(() {
        _isLoading = false; // Set loading selesai meskipun gagal
      });
    }
  }

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
  void initState() {
    super.initState();
    _fetchCurrentName();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.chevron_left), // Mengganti tombol kembali menjadi chevron left
          onPressed: () {
            Navigator.pop(context); // Fungsi untuk kembali ke halaman sebelumnya
          },
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center, // Memastikan teks berada di tengah
          children: const [
            Text(
              'Ubah Nama',
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 16,
                color: AppColors.black,
              ),
            ),
          ],
        ),
        centerTitle: false, // Menonaktifkan centerTitle default
        actions: [
          // Menambahkan widget kosong di sisi kanan untuk menyeimbangkan posisi
          Container(width: 48), // Sesuaikan lebar ini sesuai kebutuhan
        ],
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
                  'Namamu sekarang:',
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                    color: AppColors.black,
                  ),
                ),
                const SizedBox(height: 12),
                _isLoading // Jika sedang loading, tampilkan shimmer
                    ? Shimmer.fromColors(
                  baseColor: AppColors.lightGrey,
                  highlightColor: AppColors.secondary,
                  child: Container(
                    height: 56,
                    decoration: BoxDecoration(
                      color: AppColors.lightGrey,
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                )
                    : IgnorePointer(
                  ignoring: true, // Membuat kolom ini tidak dapat diinteraksi
                  child: TextFormField(
                    controller: _currentNameController,
                    decoration: InputDecoration(
                      // Menggunakan border untuk outline default
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: AppColors.darkGrey),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      // Mengganti warna border saat disabled
                      disabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: AppColors.darkGrey),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      // Mengganti warna teks saat disabled
                      labelStyle: TextStyle(
                        color: AppColors.darkGrey,
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                const Text(
                  'Ketikkan nama barumu:',
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                    color: AppColors.black,
                  ),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    focusColor: AppColors.lightGrey,
                    hintText: 'Nama Baru',
                    hintStyle: TextStyle(
                      color: AppColors.grey,
                    ),
                    // Menggunakan border untuk outline default
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: AppColors.darkGrey),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    // Mengganti warna border saat fokus
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: AppColors.primary),
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Nama tidak boleh kosong';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
      persistentFooterButtons: [
        Container(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: _updateName,
            child: const Text(
              'Simpan',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              backgroundColor: AppColors.primary,
            ),
          ),
        ),
      ],
    );
  }
}