import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../core/config/strings/app_text.dart';
import '../core/config/theme/app_colors.dart';
import '../core/config/assets/app_vectors.dart';
import '../api/api_service.dart';
import '../api/notification_service.dart';

class EditJadwalTidurScreen extends StatefulWidget {
  final int id;
  final String sleepName;
  final int sleepHour;
  final int sleepMinute;
  final int wakeHour;
  final int wakeMinute;
  final String sleepFrequency;

  EditJadwalTidurScreen({
    required this.id,
    required this.sleepName,
    required this.sleepHour,
    required this.sleepMinute,
    required this.wakeHour,
    required this.wakeMinute,
    required this.sleepFrequency,
  });

  @override
  _EditJadwalTidurScreenState createState() => _EditJadwalTidurScreenState();
}

class _EditJadwalTidurScreenState extends State<EditJadwalTidurScreen> {
  late int _selectedSleepHour;
  late int _selectedSleepMinute;
  late int _selectedWakeHour;
  late int _selectedWakeMinute;
  late String _selectedFrequency;
  late TextEditingController _namaJadwalController;
  bool _isDurasiTidurTerbaikEnabled = false;

  List<int> _hours = List.generate(24, (index) => index);
  List<int> _minutes = List.generate(60, (index) => index);

  @override
  void initState() {
    super.initState();
    _selectedSleepHour = widget.sleepHour;
    _selectedSleepMinute = widget.sleepMinute;
    _selectedWakeHour = widget.wakeHour;
    _selectedWakeMinute = widget.wakeMinute;
    _selectedFrequency = widget.sleepFrequency;
    _namaJadwalController = TextEditingController(text: widget.sleepName);
  }

  void _showTimePicker(BuildContext context, bool isSleepTime) {
    // Ambil waktu saat ini
    final now = DateTime.now();
    final currentHour = now.hour;
    final currentMinute = now.minute;

    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 250,
          child: CupertinoTimerPicker(
            mode: CupertinoTimerPickerMode.hm,
            initialTimerDuration: Duration(
              hours: isSleepTime ? _selectedSleepHour : _selectedWakeHour,
              minutes: isSleepTime ? _selectedSleepMinute : _selectedWakeMinute,
            ),
            onTimerDurationChanged: (Duration newDuration) {
              setState(() {
                if (isSleepTime) {
                  _selectedSleepHour = newDuration.inHours;
                  _selectedSleepMinute = newDuration.inMinutes % 60;
                  _calculateWakeTime();
                } else {
                  _selectedWakeHour = newDuration.inHours;
                  _selectedWakeMinute = newDuration.inMinutes % 60;
                }
              });
            },
          ),
        );
      },
    );
  }

  void _calculateWakeTime() {
    if (_isDurasiTidurTerbaikEnabled) {
      DateTime sleepTime = DateTime(0, 0, 0, _selectedSleepHour, _selectedSleepMinute);
      DateTime wakeTime = sleepTime.add(Duration(hours: 8));
      setState(() {
        _selectedWakeHour = wakeTime.hour;
        _selectedWakeMinute = wakeTime.minute;
      });
    }
  }

  void _showFrequencyModal(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Text(
            'Pilih Frekuensi',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 20,
            ),
            textAlign: TextAlign.center,
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              InkWell(
                onTap: () {
                  setState(() {
                    _selectedFrequency = 'Sekali';
                  });
                  Navigator.pop(context);
                },
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: AppColors.primary, // Warna outline
                      width: 1.0, // Ketebalan outline
                    ),
                    borderRadius: BorderRadius.circular(8.0), // Border radius
                  ),
                  padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Sekali',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Icon(
                        Icons.check,
                        color: _selectedFrequency == 'Sekali' ? AppColors.primary : Colors.transparent,
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 8.0),
              InkWell(
                onTap: () {
                  setState(() {
                    _selectedFrequency = 'Harian';
                  });
                  Navigator.pop(context);
                },
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: AppColors.primary, // Warna outline
                      width: 1.0, // Ketebalan outline
                    ),
                    borderRadius: BorderRadius.circular(8.0), // Border radius
                  ),
                  padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Harian',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Icon(
                        Icons.check,
                        color: _selectedFrequency == 'Harian' ? AppColors.primary : Colors.transparent,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(
                'Batal',
                style: TextStyle(
                  color: AppColors.danger,
                ),
              ),
              style: TextButton.styleFrom(
                side: BorderSide(
                  color: AppColors.danger,
                ),
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

  Future<void> _updateSleepReminder() async {
    if (!mounted) return; // Pastikan widget masih aktif sebelum memulai operasi

    // Tampilkan dialog konfirmasi
    final bool? confirm = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Text(
            'Konfirmasi Edit',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: Text('Siap simpan jadwal tidurmu?'),
          actions: [
            TextButton(
              child: Text(
                'Batal',
                style: TextStyle(color: AppColors.danger),
              ),
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              style: TextButton.styleFrom(
                  side: BorderSide(
                    color: AppColors.danger,
                    width: 1.0,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  )
              ),
            ),
            TextButton(
              child: Text(
                'Simpan',
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () {
                Navigator.of(context).pop(true);
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

    if (confirm != true || !mounted) return; // Batalkan jika pengguna menolak atau widget tidak aktif

    // Lakukan update data
    final apiService = ApiService();
    final response = await apiService.updateSleepReminder(widget.id, {
      'sleep_name': _namaJadwalController.text,
      'sleep_hour': _selectedSleepHour,
      'sleep_minute': _selectedSleepMinute,
      'wake_hour': _selectedWakeHour,
      'wake_minute': _selectedWakeMinute,
      'sleep_frequency': _selectedFrequency == 'Sekali' ? 0 : 1,
      'toggle_value': 1,
    });

    if (response.success) {
      // Perbarui notifikasi setelah berhasil menyimpan
      final NotificationService notificationService = NotificationService();
      final now = DateTime.now();

      // Jadwalkan ulang notifikasi tidur
      DateTime sleepScheduledDate = DateTime(
        now.year,
        now.month,
        now.day,
        _selectedSleepHour,
        _selectedSleepMinute,
      );

      if (sleepScheduledDate.isBefore(now) && _selectedFrequency == 'Sekali') {
        sleepScheduledDate = sleepScheduledDate.add(Duration(days: 1));
      }

      await notificationService.scheduleNotification(
        widget.id,
        'Pengingat Tidur',
        'Ingatlah untuk tidur sesuai jadwal!',
        sleepScheduledDate,
        _selectedFrequency,
      );

      // Jadwalkan ulang notifikasi bangun
      DateTime wakeScheduledDate = DateTime(
        now.year,
        now.month,
        now.day,
        _selectedWakeHour,
        _selectedWakeMinute,
      );

      if (wakeScheduledDate.isBefore(now) && _selectedFrequency == 'Sekali') {
        wakeScheduledDate = wakeScheduledDate.add(Duration(days: 1));
      }

      await notificationService.scheduleNotificationWithCustomSound(
        widget.id + 1,
        'Pengingat Bangun',
        'Ingatlah untuk bangun sesuai jadwal!',
        wakeScheduledDate,
        _selectedFrequency,
      );

      // Kembali ke halaman `PengingatTidurScreen`
      if (mounted) {
        Navigator.of(context).pop(); // Kembali ke halaman sebelumnya
      }
    } else {
      // Tangani kesalahan
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(response.message)),
        );
      }
    }
  }

  Future<void> _deleteSleepReminder() async {
    if (!mounted) return; // Pastikan widget masih aktif sebelum memulai operasi

    // Tampilkan dialog konfirmasi
    final bool? confirm = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Text(
            'Konfirmasi Hapus',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: Text('Beneran mau hapus jadwal ini?'),
          actions: [
            TextButton(
              child: Text(
                'Batal',
                style: TextStyle(color: AppColors.darkGrey),
              ),
              onPressed: () {
                Navigator.of(context).pop(false); // Kembalikan nilai false
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
              child: Text(
                'Hapus',
                style: TextStyle(color: Colors.white),
              ),
              style: TextButton.styleFrom(
                backgroundColor: AppColors.danger,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop(true); // Kembalikan nilai true
              },
            ),
          ],
        );
      },
    );

    if (confirm != true || !mounted) return; // Batal jika pengguna menolak atau widget tidak aktif

    // Lakukan penghapusan
    final apiService = ApiService();
    final response = await apiService.deleteSleepReminder(widget.id);

    if (response.success) {
      // Batalkan notifikasi
      final NotificationService notificationService = NotificationService();
      await notificationService.cancelNotification(widget.id); // Cancel sleep notification
      await notificationService.cancelNotification(widget.id + 1); // Cancel wake notification

      // Kembali ke halaman sebelumnya
      if (mounted) {
        Navigator.of(context).pop(); // Kembali ke halaman sebelumnya
      }
    } else {
      // Tangani kesalahan
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(response.message)),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.chevron_left_rounded, color: AppColors.darkGrey),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Edit Jadwal Tidur',
          style: TextStyle(
            color: AppColors.darkGrey,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: 10),
                    TextField(
                      controller: _namaJadwalController,
                      decoration: InputDecoration(
                        labelText: EditJadwalTidurText.namaJadwalLabel,
                        labelStyle: TextStyle(
                          color: AppColors.darkGrey,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide: BorderSide(
                            color: AppColors.grey,
                            width: 1.0,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide: BorderSide(
                            color: AppColors.grey,
                            width: 1.0,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    Text(
                      'Jam Tidur',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 5),
                    GestureDetector(
                      onTap: () => _showTimePicker(context, true),
                      child: Container(
                        width: 136,
                        height: 60,
                        padding: EdgeInsets.all(12.0),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8.0),
                          border: Border.all(
                            color: AppColors.grey,
                            width: 1.0,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            '${_selectedSleepHour.toString().padLeft(2, '0')}  :  ${_selectedSleepMinute.toString().padLeft(2, '0')}',
                            style: TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      PengingatDetailText.infoPilihWaktu,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: AppColors.darkGrey,
                      ),
                    ),
                    SizedBox(height: 20),
                    Text(
                      'Jam Bangun',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 5),
                    GestureDetector(
                      onTap: _isDurasiTidurTerbaikEnabled ? null : () => _showTimePicker(context, false),
                      child: Container(
                        width: 136,
                        height: 60,
                        padding: EdgeInsets.all(12.0),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8.0),
                          border: Border.all(
                            color: AppColors.grey,
                            width: 1.0,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            '${_selectedWakeHour.toString().padLeft(2, '0')}  :  ${_selectedWakeMinute.toString().padLeft(2, '0')}',
                            style: TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      PengingatDetailText.infoPilihWaktu,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: AppColors.darkGrey,
                      ),
                    ),
                    SizedBox(height: 20),
                    Card(
                      color: AppColors.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(99.0),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 16.0, right: 6.0, top: 6.0, bottom: 6.0),
                        child: Row(
                          children: [
                            SizedBox(
                              width: 20,
                              height: 20,
                              child: SvgPicture.asset(
                                AppVectors.iconTidur,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 12.0),
                              child: Text(
                                'Durasi Tidur Terbaik',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            Spacer(),
                            IconButton(
                              icon: Icon(
                                Icons.info_rounded,
                                color: Colors.white,
                              ),
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(16.0),
                                      ),
                                      content: Text(
                                        AppText.infoDurasiTidur,
                                        style: TextStyle(
                                          fontSize: 14,
                                        ),
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: Text(
                                            'Tutup',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: AppColors.primary,
                                            foregroundColor: Colors.white,
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(8.0),
                                            ),
                                          ),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                            ),
                            Transform.scale(
                              scale: 0.9,
                              child: CupertinoSwitch(
                                value: _isDurasiTidurTerbaikEnabled,
                                onChanged: (value) {
                                  setState(() {
                                    _isDurasiTidurTerbaikEnabled = value;
                                    if (value) {
                                      _calculateWakeTime();
                                    }
                                  });
                                },
                                activeTrackColor: Colors.white,
                                inactiveTrackColor: AppColors.lightGrey,
                                thumbColor: AppColors.primary,
                                inactiveThumbColor: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    Card(
                      color: Colors.white,
                      elevation: 0.0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        side: BorderSide(
                          color: AppColors.grey,
                          width: 1.0,
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 4.0, right: 0.0, top: 4.0, bottom: 4.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 60,
                              child: ListTile(
                                leading: SvgPicture.asset(
                                  AppVectors.iconFreq,
                                  width: 24,
                                  height: 24,
                                ),
                                title: Text(
                                  CardSettingTambahEditJadwalText.frekuensi,
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      _selectedFrequency,
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    SizedBox(width: 4),
                                    Icon(
                                      Icons.chevron_right,
                                      size: 18,
                                      color: AppColors.darkGrey,
                                    ),
                                  ],
                                ),
                                onTap: () => _showFrequencyModal(context),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 40,
              child: ElevatedButton(
                onPressed: _deleteSleepReminder,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                ),
                child: Text(
                  'Hapus Jadwal',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
            SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              height: 40,
              child: ElevatedButton(
                onPressed: _updateSleepReminder,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                ),
                child: Text(
                  ButtonPengingatText.simpan,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}