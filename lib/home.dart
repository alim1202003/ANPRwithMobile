import 'dart:io';
import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:google_fonts/google_fonts.dart';
import 'dart:convert';

import 'package:skan_plak/history.dart';
import 'package:skan_plak/settings.dart';
import 'package:skan_plak/account.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;
  late PageController _pageController;
  List<Map<String, dynamic>> _scannedPlates = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onTabChange(int index) {
    setState(() {
      _selectedIndex = index;
    });
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  Future<void> scanAndSendPlate(Function(String) onResult) async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.camera);

    if (pickedImage == null) return;

    setState(() {
      _isLoading = true;
    });

    final request = http.MultipartRequest(
      'POST',
      Uri.parse('http://10.89.8.229:5000/scan'),
    );

    request.files.add(
      await http.MultipartFile.fromPath('image', pickedImage.path),
    );

    try {
      final response = await request.send().timeout(
        const Duration(seconds: 60),
      );

      final responseBody = await response.stream.bytesToString();

      setState(() {
        _isLoading = false;
      });

      if (response.statusCode == 200) {
        final decoded = jsonDecode(responseBody);
        final plate = decoded['plate'];
        final confidence = decoded['confidence'];
        final logTime = decoded['log_time'];
        final otoparkInfo = decoded['otopark']; // <-- Yeni ekleme
        final personInfo =
            decoded.containsKey('isim')
                ? '${decoded['isim']} ${decoded['soyisim']}'
                : 'Bilinmeyen Kişi';

        if (plate != null) {
          onResult(plate.toString());
          _scannedPlates.add({
            'plate': plate,
            'confidence': confidence,
            'time': logTime,
            'person_info': personInfo,
            'otopark': otoparkInfo, // <-- Yeni ekleme
          });
        } else {
          onResult("Plaka bulunamadı");
        }
      } else {
        onResult("Sunucu hatası: ${response.statusCode}");
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      onResult("Bağlantı hatası: $e");
    }
  }

  void _scanPlate() {
    scanAndSendPlate((result) {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeColor = Colors.black;
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 4,
        centerTitle: true,
        title: Text(
          'Plaka Tarama',
          style: GoogleFonts.roboto(
            textStyle: const TextStyle(
              color: Colors.white,
              fontSize: 26,
              fontWeight: FontWeight.w500,
              letterSpacing: 1.5,
              shadows: [
                Shadow(
                  offset: Offset(1.0, 2.0),
                  blurRadius: 4.0,
                  color: Colors.black54,
                ),
              ],
            ),
          ),
        ),
      ),
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        children: [
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton.icon(
                    onPressed: _scanPlate,
                    icon: const Icon(Icons.camera_alt_outlined, size: 26),
                    label: const Text("Plaka Tara"),
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: themeColor,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 50,
                        vertical: 18,
                      ),
                      textStyle: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                        fontFamily: 'Roboto',
                        letterSpacing: 1.2,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                      elevation: 10,
                    ),
                  ),
                  const SizedBox(height: 45),
                  if (_isLoading) const CircularProgressIndicator(),
                  if (!_isLoading && _scannedPlates.isNotEmpty)
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        vertical: 24,
                        horizontal: 20,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.black12, width: 1),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.shade300,
                            blurRadius: 12,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Plaka:",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            '${_scannedPlates.last['plate']}',
                            style: const TextStyle(fontSize: 20),
                          ),
                          const SizedBox(height: 12),
                          const Text(
                            "Kimlik Bilgisi:",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            '${_scannedPlates.last['person_info']}',
                            style: const TextStyle(fontSize: 20),
                          ),
                          const SizedBox(height: 12),
                          const Text(
                            "Tarih/Saat:",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            '${_scannedPlates.last['time']}',
                            style: const TextStyle(fontSize: 20),
                          ),
                          const SizedBox(height: 12),
                          const Text(
                            "Otopark:",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            '${_scannedPlates.last['otopark']}',
                            style: const TextStyle(fontSize: 20),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ),
          HistoryPage(scannedPlates: _scannedPlates),
          const SettingsPage(),
          const AccountPage(),
        ],
      ),
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: Colors.transparent,
        color: Colors.black,
        buttonBackgroundColor: Colors.grey.shade800,
        animationCurve: Curves.easeInOut,
        animationDuration: const Duration(milliseconds: 300),
        index: _selectedIndex,
        height: 70,
        onTap: _onTabChange,
        items: const [
          Icon(Icons.home, color: Colors.white),
          Icon(Icons.access_time_outlined, color: Colors.white),
          Icon(Icons.settings, color: Colors.white),
          Icon(Icons.account_circle_outlined, color: Colors.white),
        ],
      ),
    );
  }
}
