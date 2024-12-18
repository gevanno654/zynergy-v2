import 'package:flutter/material.dart';
import 'package:zynergy/core/config/theme/app_colors.dart';
import '../api/api_service.dart';

class UbahKataSandi extends StatefulWidget {
  const UbahKataSandi({Key? key}) : super(key: key);

  @override
  _UbahKataSandiState createState() => _UbahKataSandiState();
}

class _UbahKataSandiState extends State<UbahKataSandi> {
  final ApiService _apiService = ApiService();
  final _formKey = GlobalKey<FormState>();
  String _currentPassword = '';
  String _newPassword = '';
  String _newPasswordConfirmation = '';

  // State untuk menampilkan atau menyembunyikan password
  bool _obscureCurrentPassword = true;
  bool _obscureNewPassword = true;
  bool _obscureNewPasswordConfirmation = true;

  Future<void> _changePassword() async {
    if (_formKey.currentState!.validate()) {
      final response = await _apiService.changePassword(
        _currentPassword,
        _newPassword,
        _newPasswordConfirmation,
      );

      if (response.success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Password changed successfully')),
        );
        Navigator.pop(context); // Kembali ke halaman sebelumnya
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(response.message)),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.chevron_left), // Menggunakan chevron left
          onPressed: () {
            Navigator.pop(context); // Fungsi untuk kembali ke halaman sebelumnya
          },
        ),
        title: const Text(
          'Ubah Kata Sandi',
          style: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 16,
            color: AppColors.black,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Buat Kata Sandi Baru',
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                    color: AppColors.black,
                  ),
                ),
                const SizedBox(
                  height: 12,
                ),
                TextFormField(
                  obscureText: _obscureCurrentPassword,
                  decoration: InputDecoration(
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscureCurrentPassword ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                        color: AppColors.darkGrey,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscureCurrentPassword = !_obscureCurrentPassword;
                        });
                      },
                    ),
                    focusColor: AppColors.darkGrey,
                    hintText: 'Kata Sandi Saat Ini',
                    hintStyle: TextStyle(
                      color: AppColors.grey,
                    ),
                    border: OutlineInputBorder(
                      borderSide: const BorderSide(color: AppColors.darkGrey),
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Kata sandi saat ini harus diisi';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    setState(() {
                      _currentPassword = value;
                    });
                  },
                ),
                const SizedBox(
                  height: 24,
                ),
                TextFormField(
                  obscureText: _obscureNewPassword, // Gunakan state untuk mengatur obscureText
                  decoration: InputDecoration(
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscureNewPassword ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                        color: AppColors.darkGrey,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscureNewPassword = !_obscureNewPassword;
                        });
                      },
                    ),
                    focusColor: AppColors.darkGrey,
                    hintText: 'Kata Sandi Baru',
                    hintStyle: TextStyle(
                      color: AppColors.grey,
                    ),
                    border: OutlineInputBorder(
                      borderSide: const BorderSide(color: AppColors.darkGrey),
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Kata sandi baru harus diisi';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    setState(() {
                      _newPassword = value;
                    });
                  },
                ),
                const SizedBox(
                  height: 24,
                ),
                TextFormField(
                  obscureText: _obscureNewPasswordConfirmation, // Gunakan state untuk mengatur obscureText
                  decoration: InputDecoration(
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscureNewPasswordConfirmation ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                        color: AppColors.darkGrey,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscureNewPasswordConfirmation = !_obscureNewPasswordConfirmation;
                        });
                      },
                    ),
                    focusColor: AppColors.darkGrey,
                    hintText: 'Konfirmasi Kata Sandi Baru',
                    hintStyle: TextStyle(
                      color: AppColors.grey,
                    ),
                    border: OutlineInputBorder(
                      borderSide: const BorderSide(color: AppColors.darkGrey),
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Konfirmasi kata sandi baru harus diisi';
                    }
                    if (value != _newPassword) {
                      return 'Konfirmasi kata sandi tidak cocok';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    setState(() {
                      _newPasswordConfirmation = value;
                    });
                  },
                ),
                const SizedBox(
                  height: 24,
                ),
              ],
            ),
          ),
        ),
      ),
      persistentFooterButtons: [
        Container(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: _changePassword,
            child: const Text(
              'Simpan',
              style: TextStyle(
                color: AppColors.secondary,
                fontSize: 16,
              ),
            ),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)
              ),
              backgroundColor: AppColors.primary,
            ),
          ),
        ),
      ],
    );
  }
}