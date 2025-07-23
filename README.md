# Akıllı Plaka Tanıma ve Erişim Kontrol Sistemi

## 📱 Proje Hakkında

Bu proje, **Android işletim sistemine sahip mobil cihazlar** üzerinden çalışan bir uygulama ile **plaka tanıma** işlemini gerçekleştirmekte ve **Arduino tabanlı bir erişim kontrol sistemi** ile entegre çalışmaktadır.

Mobil uygulama, kamera ile plaka görüntüsünü alır ve bu görüntüyü işleyerek plaka metnini çıkarır. Elde edilen plaka verisi, sistemin veritabanındaki kayıtlarla karşılaştırılır. Kayıt bulunması durumunda:

- Plaka sahibinin **adı, soyadı**, 
- **Görev yaptığı birim**, 
- Ve **otopark yetkisi** gibi bilgiler veritabanından alınır.

Bu bilgiler ışığında sistem:

- LCD ekran üzerinde bilgileri gösterir
- Servo motor ile fiziksel bariyeri **otomatik olarak açar**
- **Yeşil LED** ile geçişin onaylandığını belirtir

Geçersiz plaka durumunda ise:

- LCD ekranda "Kapalı" uyarısı gösterilir
- Servo motor kapalı pozisyonda kalır
- **Kırmızı LED** yanar

## 🧩 Proje Bileşenleri

### Yazılım:
- Android Mobil Uygulama (Flutter)
- Plaka Tanıma Algoritması (OpenCV/ML tabanlı)
- Firebase veya özel veritabanı bağlantısı
- REST API (isteğe bağlı)

### Donanım:
- Arduino UNO
- LCD Ekran (16x2)
- Servo Motor (SG90)
- Breadboard ve bağlantı kabloları
- Kırmızı & Yeşil LED
- 220 Ohm dirençler

## 🖼️ Uygulama Arayüzü

| Giriş Ekranı | Plaka Tanındı | Geçersiz Plaka |
|-------------|----------------|----------------|
| ![Giriş](https://github.com/alim1202003/ANPRwithMobile/blob/main/assets/giris_resmi.jpg) | ![Açık](https://github.com/alim1202003/ANPRwithMobile/blob/main/assets/servo_acik_yesil_led_lcd.png) | ![Kapalı](https://github.com/alim1202003/ANPRwithMobile/blob/main/assets/servo_kapali_kirmizi_led_lcd.png) |

## ⚙️ Sistem Çalışma Prensibi

1. Kullanıcı, Android uygulamasını açar ve giriş yapar.
2. Kamera ile aracın plakası taranır.
3. Plaka metni işlenerek veritabanı ile karşılaştırılır.
4. Eşleşme varsa:
   - LCD ekranda plaka sahibi bilgisi gösterilir.
   - Bariyer (servo motor) açılır.
   - Yeşil LED yanar.
5. Eşleşme yoksa:
   - LCD'de "Kapalı" yazısı çıkar.
   - Bariyer kapalı kalır.
   - Kırmızı LED yanar.

## 🎯 Hedef

Bu sistem sayesinde, kampüs veya bina otoparklarına birim bazlı ve **güvenli erişim** sağlanmaktadır. Proje, gerçek donanımlar üzerinde test edilmiş ve başarılı sonuçlar vermiştir.

---

## 👨‍💻 Geliştirici

**Alim Haciverdiyev**

Bu proje, bitirme/teknoloji projesi kapsamında geliştirilmiştir.

