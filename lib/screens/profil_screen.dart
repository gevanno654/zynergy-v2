import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:url_launcher/url_launcher.dart';
import '../core/config/assets/app_vectors.dart';
import '../core/config/theme/app_colors.dart';
import '../api/api_service.dart';
import 'login_screen.dart';
import 'ubah_jenis_kelamin.dart';
import 'ubah_kata_sandi.dart';
import 'ubah_nama_screen.dart';
import 'personalization_screen.dart';

class ProfilScreen extends StatefulWidget {
  @override
  _ProfilScreen createState() => _ProfilScreen();
}

class _ProfilScreen extends State<ProfilScreen> {
  final ApiService _apiService = ApiService();
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  Map<String, dynamic>? _userData;

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    try {
      final localUserData = await _apiService.getLocalUserData();
      if (localUserData != null) {
        setState(() {
          _userData = localUserData;
        });
      } else {
        final userData = await _apiService.getUserData();
        setState(() {
          _userData = userData;
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load user data: $e')),
      );
    }
  }

  Future<void> _logout(BuildContext context) async {
    try {
      await _apiService.logout();
      await _googleSignIn.signOut();
      if (context.mounted) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => LoginScreen()),
              (route) => false,
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to logout: $e')),
        );
      }
    }
  }

  Future<void> _showLogoutDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Text(
            'Konfirmasi Keluar',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          content: const Text(
            'Lo yakin mau keluar dari akun ini?',
            style: TextStyle(
              fontWeight: FontWeight.normal,
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text(
                'Batal',
                style: TextStyle(
                  color: AppColors.primary,
                ),
              ),
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
              style: TextButton.styleFrom(
                side: BorderSide(
                  color: AppColors.primary,
                  width: 1.0,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            TextButton(
              child: const Text(
                'Keluar',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              onPressed: () async {
                Navigator.of(dialogContext).pop();
                await _logout(context);
              },
              style: TextButton.styleFrom(
                backgroundColor: AppColors.danger,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
            gradient: RadialGradient(
              center: Alignment(0.7, -1),
              radius: 0.4,
              colors: [
                Color(0xFF4AF5CE),
                AppColors.primary,
              ],
              stops: <double>[0.0, 1.0],
            ),
          ),
          child: Column(
            children: [
              Container(
                height: 240 - 64,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 60,
                      backgroundColor: AppColors.secondary,
                      child: ClipOval(
                        child: SvgPicture.asset(
                          AppVectors.iconUser,
                          height: 100,
                          width: 100,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 1,
                child: Container(
                  alignment: Alignment.topCenter,
                  padding: const EdgeInsets.only(left: 20, right: 20, top: 28),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(24),
                    ),
                  ),
                  child: ListView(
                    children: [
                      const Text(
                        "Informasi Pribadi",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: AppColors.lightGrey, width: 1),
                        ),
                        child: Column(
                          children: [
                            ListTile(
                              contentPadding: const EdgeInsets.only(
                                  right: 16, left: 16, top: 16),
                              title: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Nama Lengkap',
                                    style: TextStyle(
                                      color: AppColors.darkGrey,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 14,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    _userData?['name'] ?? 'Loading...',
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                      color: AppColors.darkGrey,
                                    ),
                                  ),
                                ],
                              ),
                              trailing: const Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    'Ubah',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: AppColors.darkGrey,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  SizedBox(width: 4),
                                  Icon(Icons.chevron_right, color: AppColors.darkGrey),
                                ],
                              ),
                              onTap: () async {
                                // Navigasi ke UbahNamaScreen
                                await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => UbahNamaScreen()),
                                );

                                // Setelah kembali, ambil data pengguna terbaru
                                await _fetchUserData();
                              },
                            ),
                            ListTile(
                              contentPadding: const EdgeInsets.only(right: 16, left: 16, top: 16),
                              title: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Jenis Kelamin',
                                    style: TextStyle(
                                      color: AppColors.darkGrey,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 14,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    _userData?['gender'] == 'male' ? 'Laki-Laki' : 'Perempuan',
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: AppColors.darkGrey,
                                    ),
                                  ),
                                ],
                              ),
                              trailing: const Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    'Ubah',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: AppColors.darkGrey,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  SizedBox(width: 4),
                                  Icon(Icons.chevron_right, color: AppColors.darkGrey),
                                ],
                              ),
                              onTap: () async {
                                // Kirim data jenis kelamin yang baru ke ProfilScreen
                                final newGender = await Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => UbahJenisKelamin()),
                                );

                                if (newGender != null) {
                                  // Perbarui data pengguna secara lokal
                                  setState(() {
                                    _userData?['gender'] = newGender;
                                  });
                                }
                              },
                            ),
                            ListTile(
                              contentPadding: const EdgeInsets.only(right: 16, left: 16, top: 16),
                              title: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Edit Personalisasi',
                                    style: TextStyle(
                                      color: AppColors.darkGrey,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                              trailing: const Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    'Ubah',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: AppColors.darkGrey,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  SizedBox(width: 4),
                                  Icon(Icons.chevron_right, color: AppColors.darkGrey),
                                ],
                              ),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => PersonalizationScreen(fromProfil: true)),
                                );
                              },
                            ),
                            ListTile(
                              contentPadding: const EdgeInsets.only(
                                  right: 16, left: 16, top: 16),
                              title: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Email',
                                    style: TextStyle(
                                      color: AppColors.darkGrey,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 14,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    _userData?['email'] ?? 'Loading...',
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: AppColors.darkGrey,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            ListTile(
                              contentPadding: const EdgeInsets.only(
                                  right: 16, left: 16, top: 16, bottom: 16),
                              title: const Text(
                                'Kata Sandi',
                                style: TextStyle(
                                  color: AppColors.darkGrey,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14,
                                ),
                              ),
                              trailing: const Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    'Ubah',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: AppColors.darkGrey,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  SizedBox(width: 4),
                                  Icon(Icons.chevron_right, color: AppColors.darkGrey),
                                ],
                              ),
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => UbahKataSandi()));
                              },
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 16),
                      ElevatedButton.icon(
                        onPressed: () => _showLogoutDialog(context),
                        icon: const Icon(Icons.logout, color: Colors.white),
                        label: const Text(
                          'Keluar',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.danger,
                          padding: const EdgeInsets.symmetric(
                              vertical: 12, horizontal: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                      const SizedBox(height: 32),
                      const Text(
                        'Dukung dan Ikuti Kami',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColors.darkGrey,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _socialButton(AppVectors.iconInstagram, 'https://www.instagram.com/zynergy.id/'),
                          const SizedBox(width: 12),
                          _socialButton(AppVectors.iconGithub, 'https://github.com/yulia30359/finpro-msib-7-kelompok-2'),
                        ],
                      ),
                      SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _socialButton(String icon, String url) {
    return GestureDetector(
      onTap: () async {
        final Uri uri = Uri.parse(url);
        if (await canLaunchUrl(uri)) {
          await launchUrl(uri);
        } else {
          throw 'Could not launch $url';
        }
      },
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.lightGrey),
          borderRadius: BorderRadius.circular(8),
        ),
        child: SvgPicture.asset(
          icon,
          width: 24,
          height: 24,
        ),
      ),
    );
  }
}