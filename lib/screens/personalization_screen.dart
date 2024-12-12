import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../core/config/assets/app_vectors.dart';
import '../core/config/theme/app_colors.dart';
import '../api/api_service.dart';
import 'beranda_screen.dart';

class PersonalizationScreen extends StatefulWidget {
  final bool fromProfil; // Tambahkan parameter ini

  PersonalizationScreen({this.fromProfil = false}); // Default value adalah false

  @override
  _PersonalizationScreenState createState() => _PersonalizationScreenState();
}

class _PersonalizationScreenState extends State<PersonalizationScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  String? _selectedGender; // Variabel untuk menyimpan jenis kelamin yang dipilih

  List<Map<String, dynamic>> _interests = [
    {'id': 1, 'name': 'Berenang'},
    {'id': 2, 'name': 'Voli'},
    {'id': 3, 'name': 'Jogging'},
    {'id': 4, 'name': 'Yoga'},
    {'id': 5, 'name': 'Aerobik'},
    {'id': 6, 'name': 'Senam'},
    {'id': 7, 'name': 'Bersepeda'},
    {'id': 8, 'name': 'Hiking'},
    {'id': 9, 'name': 'Pilates'},
    {'id': 10, 'name': 'Badminton'},
    {'id': 11, 'name': 'Sepak Bola'},
    {'id': 12, 'name': 'Tenis'},
    {'id': 13, 'name': 'Golf'},
    {'id': 14, 'name': 'Senam Lantai'},
    {'id': 15, 'name': 'Zumba'},
  ];

  List<Map<String, dynamic>> _favorites = [
    {'id': 1, 'name': 'Ayam'},
    {'id': 2, 'name': 'Bebek'},
    {'id': 3, 'name': 'Ikan'},
    {'id': 4, 'name': 'Daging Sapi'},
    {'id': 5, 'name': 'Daging Kambing'},
    {'id': 6, 'name': 'Udang'},
    {'id': 7, 'name': 'Cumi'},
    {'id': 8, 'name': 'Tempe'},
    {'id': 9, 'name': 'Tahu'},
    {'id': 10, 'name': 'Telur'},
    {'id': 11, 'name': 'Kentang'},
    {'id': 12, 'name': 'Nasi'},
    {'id': 13, 'name': 'Mie'},
    {'id': 14, 'name': 'Pasta'},
    {'id': 15, 'name': 'Roti'},
  ];

  List<Map<String, dynamic>> _diseases = [
    {'id': 1, 'name': 'Maag'},
    {'id': 2, 'name': 'Obesitas'},
    {'id': 3, 'name': 'Bipolar'},
    {'id': 4, 'name': 'Insomnia'},
    {'id': 5, 'name': 'Nyeri Otot'},
    {'id': 6, 'name': 'Penyakit Jantung'},
    {'id': 7, 'name': 'Flu'},
    {'id': 8, 'name': 'Batuk'},
    {'id': 9, 'name': 'Radang Usus'},
    {'id': 10, 'name': 'Anemia'},
    {'id': 11, 'name': 'Radang Tenggorokan'},
    {'id': 12, 'name': 'Asma'},
    {'id': 13, 'name': 'Asam Lambung'},
    {'id': 14, 'name': 'Sakit Kepala'},
    {'id': 15, 'name': 'Hipertensi'},
    {'id': 16, 'name': 'Nyeri Sendi'},
  ];

  List<Map<String, dynamic>> _allergies = [
    {'id': 1, 'name': 'Kacang'},
    {'id': 2, 'name': 'Gluten'},
    {'id': 3, 'name': 'Laktosa'},
    {'id': 4, 'name': 'Telur'},
    {'id': 5, 'name': 'Ikan'},
    {'id': 6, 'name': 'Kerang'},
    {'id': 7, 'name': 'Kedelai'},
    {'id': 8, 'name': 'Gandum'},
    {'id': 9, 'name': 'Susu'},
    {'id': 10, 'name': 'Jagung'},
    {'id': 11, 'name': 'Stroberi'},
    {'id': 12, 'name': 'Tomat'},
    {'id': 13, 'name': 'Wijen'},
    {'id': 14, 'name': 'Bawang Putih'},
    {'id': 15, 'name': 'Seledri'},
    {'id': 0, 'name': 'Gaada'},
  ];

  List<int> _selectedInterests = [];
  List<int> _selectedFavorites = [];
  List<int> _selectedDiseases = [];
  List<int> _selectedAllergies = [];

  final ApiService _apiService = ApiService();

  @override
  void initState() {
    super.initState();
    // Tidak perlu mengambil data dari server
  }

  void _toggleItem(int itemId, List<int> selectedList) {
    setState(() {
      if (itemId == 99) {
        // Jika "Tidak Ada" dipilih, hapus semua alergi lain
        if (selectedList.contains(99)) {
          selectedList.clear();
        } else {
          selectedList.clear();
          selectedList.add(99);
        }
      } else {
        // Jika alergi lain dipilih, hapus "Tidak Ada" jika ada
        if (selectedList.contains(99)) {
          selectedList.remove(99);
        }
        if (selectedList.contains(itemId)) {
          selectedList.remove(itemId);
        } else if (selectedList.length < 3) {
          selectedList.add(itemId);
        }
      }
    });
  }

  void _showWarningDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Text(
            'Dilarang Skip!',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 24,
              color: AppColors.darkGrey,
            ),
          ),
          content: Text(
            message,
            style: TextStyle(
              fontWeight: FontWeight.normal,
              fontSize: 16,
              color: AppColors.darkGrey,
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(
                'OK',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
              style: TextButton.styleFrom(
                backgroundColor: AppColors.primary,
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

  Future<void> _savePersonalizationData() async {
    try {
      if (_currentPage == 0 && _selectedGender == null) {
        // Show error dialog or snackbar
        print("Pilih jenis kelamin terlebih dahulu");
        return;
      }

      if (_currentPage == 1 && _selectedInterests.isEmpty) {
        // Show error dialog or snackbar
        print("Pilih minimal 1 minat aktivitasmu");
        return;
      }

      if (_currentPage == 2 && _selectedFavorites.isEmpty) {
        // Show error dialog or snackbar
        print("Pilih minimal 1 kesukaan yang kamu konsumsi");
        return;
      }

      if (_currentPage == 3 && _selectedDiseases.isEmpty) {
        // Show error dialog or snackbar
        print("Pilih minimal 1 riwayat penyakitmu");
        return;
      }

      if (_currentPage == 4 && _selectedAllergies.isEmpty) {
        // Show error dialog or snackbar
        print("Pilih minimal 1 pantangan atau alergi");
        return;
      }

      List<int> allergiesToSend = _selectedAllergies.contains(0) ? [0] : _selectedAllergies;

      await _apiService.savePersonalizationData(
        interests: _selectedInterests,
        favorites: _selectedFavorites,
        diseases: _selectedDiseases,
        allergies: allergiesToSend,
      );

      // Save gender to server
      if (_selectedGender != null) {
        await _apiService.updateGender(_selectedGender!);
      }
    } catch (e) {
      print("Error saving personalization data: $e");
      // Show error dialog or snackbar
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Konten utama
          Column(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(top: 108.0),
                  child: PageView.builder(
                    controller: _pageController,
                    onPageChanged: (int page) {
                      setState(() {
                        if (page == 1 && _selectedGender == null) {
                          _showWarningDialog("Spill Jenis Kelaminmu dulu!");
                          _pageController.jumpToPage(_currentPage);
                        } else if (page == 2 && _selectedInterests.isEmpty) {
                          _showWarningDialog("Spill minimal 1 aktivitas kesukaanmu!");
                          _pageController.jumpToPage(_currentPage);
                        } else if (page == 3 && _selectedFavorites.isEmpty) {
                          _showWarningDialog("Spill minimal 1 makanan kesukaanmu!");
                          _pageController.jumpToPage(_currentPage);
                        } else if (page == 4 && _selectedDiseases.isEmpty) {
                          _showWarningDialog("Spill minimal 1 riwayat penyakitmu!");
                          _pageController.jumpToPage(_currentPage);
                        } else if (page == 5 && _selectedAllergies.isEmpty) {
                          _showWarningDialog("Spill minimal 1 pantangan atau alergi!");
                          _pageController.jumpToPage(_currentPage);
                        } else {
                          _currentPage = page;
                        }
                      });
                    },
                    itemCount: 6,
                    itemBuilder: (context, index) {
                      switch (index) {
                        case 0:
                          return _buildGenderPage();
                        case 1:
                          return _buildFirstPage();
                        case 2:
                          return _buildSecondPage();
                        case 3:
                          return _buildThirdPage();
                        case 4:
                          return _buildFourthPage();
                        case 5:
                          return _buildFifthPage();
                        default:
                          return Container();
                      }
                    },
                  ),
                ),
              ),
              SizedBox(
                width: 320,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF1FC29D),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                  ),
                  onPressed: _currentPage == 5
                      ? () async {
                    await _savePersonalizationData();
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => BerandaScreen()),
                    );
                  }
                      : () async {
                    if (_currentPage == 0 && _selectedGender == null) {
                      _showWarningDialog("Spill Jenis Kelaminmu dulu!");
                      return;
                    }

                    if (_currentPage == 1 && _selectedInterests.isEmpty) {
                      _showWarningDialog("Spill minimal 1 aktivitas kesukaanmu!");
                      return;
                    }

                    if (_currentPage == 2 && _selectedFavorites.isEmpty) {
                      _showWarningDialog("Spill minimal 1 makanan kesukaanmu!");
                      return;
                    }

                    if (_currentPage == 3 && _selectedDiseases.isEmpty) {
                      _showWarningDialog("Spill minimal 1 riwayat penyakitmu!");
                      return;
                    }

                    if (_currentPage == 4 && _selectedAllergies.isEmpty) {
                      _showWarningDialog("Spill minimal 1 pantangan atau alergi!");
                      return;
                    }

                    // Pindah ke halaman berikutnya jika validasi terpenuhi
                    await _savePersonalizationData();
                    _pageController.nextPage(
                      duration: Duration(milliseconds: 300),
                      curve: Curves.easeIn,
                    );
                  },
                  child: Text(
                    _currentPage == 5 ? 'Gaaasss!' : 'Lanjut',
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
            ],
          ),

          // Tombol "Batal" di pojok kiri atas
          if (widget.fromProfil) // Hanya tampilkan jika dari ProfilScreen
            Positioned(
              top: 46,
              left: 10,
              child: IconButton(
                icon: Icon(Icons.arrow_back, color: Colors.black),
                onPressed: () {
                  Navigator.pop(context); // Kembali ke ProfilScreen
                },
              ),
            ),
        ],
      ),
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
                  GestureDetector(
                    onTap: () => setState(() => _selectedGender = 'male'),
                    child: Container(
                      decoration: BoxDecoration(
                        color: _selectedGender == 'male' ? AppColors.primary : Colors.transparent,
                        borderRadius: BorderRadius.circular(8),
                        border: _selectedGender == 'male' ? null : Border.all(color: Color(0xFFDFDFDF), width: 1.5),
                      ),
                      child: Image.asset(
                        'assets/images/male_avatar.png',
                        width: 130,
                        height: 130,
                      ),
                    ),
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
                  GestureDetector(
                    onTap: () => setState(() => _selectedGender = 'female'),
                    child: Container(
                      decoration: BoxDecoration(
                        color: _selectedGender == 'female' ? AppColors.primary : Colors.transparent,
                        borderRadius: BorderRadius.circular(8),
                        border: _selectedGender == 'female' ? null : Border.all(color: Color(0xFFDFDFDF), width: 1.5),
                      ),
                      child: Image.asset(
                        'assets/images/female_avatar.png',
                        width: 130,
                        height: 130,
                      ),
                    ),
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

  Widget _buildFirstPage() {
    return _buildPage(
      title: "Spill Aktivitas\nKesukaanmu",
      description: "Isi personalisasi untuk rekomendasimu",
      items: _interests,
      selectedList: _selectedInterests,
    );
  }

  Widget _buildSecondPage() {
    return _buildPage(
      title: "Spill Makanan\nKesukaanmu",
      description: "Isi personalisasi untuk rekomendasimu",
      items: _favorites,
      selectedList: _selectedFavorites,
    );
  }

  Widget _buildThirdPage() {
    return _buildPage(
      title: "Spill Riwayat\nPenyakitmu",
      description: "Isi personalisasi untuk rekomendasimu",
      items: _diseases,
      selectedList: _selectedDiseases,
    );
  }

  Widget _buildFourthPage() {
    return _buildPage(
      title: "Spill Pantangan\natau Alergimu",
      description: "Kalo gapunya pantangan/alergi pilih Gaada",
      items: _allergies,
      selectedList: _selectedAllergies,
    );
  }

  Widget _buildFifthPage() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Semua udah Ready\nWaktumu Hidup Sehat!",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 32, fontWeight: FontWeight.w600),
          ),
          SizedBox(height: 20),
          Text(
            "Ingat Kesehatan harus jadi yang utama!",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16),
          ),
          SizedBox(height: 20),
          SvgPicture.asset(
            AppVectors.iconPersonalization,
          ),
        ],
      ),
    );
  }

  Widget _buildPage({
    required String title,
    required String description,
    required List<Map<String, dynamic>> items,
    required List<int> selectedList,
  }) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                title,
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
                description,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
              ),
            ],
          ),
          SizedBox(height: 60),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Pilih minimal 1 dan maksimal 3',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.normal),
              ),
            ],
          ),
          SizedBox(height: 10),
          Wrap(
            spacing: 8.0,
            runSpacing: 8.0,
            children: items.map((item) {
              final int itemId = item['id'];
              final String itemName = item['name'];
              return GestureDetector(
                onTap: () => _toggleItem(itemId, selectedList),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: selectedList.contains(itemId) ? Color(0xFF1FC29D) : Colors.transparent,
                    borderRadius: BorderRadius.circular(8),
                    border: selectedList.contains(itemId) ? null : Border.all(color: Color(0xFFDFDFDF), width: 1.5),
                  ),
                  child: Text(
                    itemName,
                    style: TextStyle(
                      color: selectedList.contains(itemId) ? Colors.white : Colors.black,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          if (selectedList.isEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: Text(
                'Pilih minimal 1 item',
                style: TextStyle(color: Colors.red),
              ),
            ),
        ],
      ),
    );
  }
}