import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ForgotpasswordPage extends StatefulWidget {
  const ForgotpasswordPage({super.key});

  @override
  State<ForgotpasswordPage> createState() => _ForgotpasswordPageState();
}

class _ForgotpasswordPageState extends State<ForgotpasswordPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _emailController = TextEditingController();

  Future<void> _sendPasswordResetEmail() async {
    try {
      await _auth.sendPasswordResetEmail(email: _emailController.text.trim());
      showDialog(
        context: context,
        builder:
            (context) => AlertDialog(
              title: const Text('E-posta Gönderildi'),
              content: const Text('Şifre sıfırlama e-postası gönderildi.'),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).pop(); // Geri dön
                  },
                  child: const Text(
                    'Tamam',
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              ],
            ),
      );
    } catch (e) {
      showDialog(
        context: context,
        builder:
            (context) => AlertDialog(
              title: const Text('Hata'),
              content: Text(
                'E-posta gönderilemedi. Gmailinizi kontrol edin ve tekrar deneyin.',
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Tamam'),
                ),
              ],
            ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: const Text('Şifremi Unuttum'),
        backgroundColor: Colors.grey[200],
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(25),
          child: Column(
            children: [
              const Icon(Icons.lock_reset_rounded, size: 100),
              const SizedBox(height: 20),
              const Text(
                'Şifrenizi mi unuttunuz?',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              const Text(
                'E-posta adresinizi girin, size bir şifre sıfırlama bağlantısı gönderelim.',
                style: TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30),
              TextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.email),
                  hintText: 'E-posta adresi',
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 20,
                    horizontal: 20,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _sendPasswordResetEmail,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 5,
                    shadowColor: Colors.white,
                  ),
                  child: const Text(
                    'Şifreyi Sıfırla',
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
