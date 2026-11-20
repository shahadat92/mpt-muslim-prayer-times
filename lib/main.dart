import 'mpt_extra_languages.dart';
import 'mpt_extra_pronunciations.dart';
import 'dart:async';
import 'dart:ui' as ui;
import 'dart:math' as math;
import 'adhan_audio.dart';
import 'mpt_learning.dart';
import 'package:flutter/services.dart';

import 'package:adhan/adhan.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/data/latest.dart' as tzdata;
import 'package:timezone/timezone.dart' as tz;

const emerald = Color(0xFF116B53);
const deepGreen = Color(0xFF073E32);
const gold = Color(0xFFD8AF58);
const cream = Color(0xFFCFDDD4);
const ink = Color(0xFF18332B);
const muted = Color(0xFF78877E);
const logoAsset = 'assets/images/mpt_icon.png';

final notifications = FlutterLocalNotificationsPlugin();
const versionLabel = '1.5.3'; // MPT-153-VERIFIED-SOURCE
late final Future<void> mptServicesReady;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load timezone database synchronously for city calculations.
  tzdata.initializeTimeZones();

  // Start Flutter immediately so plugin initialization cannot hold the splash.
  runApp(const MuslimPrayerTimesApp());

  // Initialize optional platform services without blocking the first screen.
  mptServicesReady = initializeMptServices();
  unawaited(mptServicesReady);
}

Future<void> initializeMptServices() async {
  try {
    try {
      final zone = await FlutterTimezone.getLocalTimezone();
      tz.setLocalLocation(tz.getLocation(zone));
    } catch (error) {
      debugPrint('MPT timezone initialization: $error');
    }

    await notifications.initialize(
      const InitializationSettings(
        android: AndroidInitializationSettings('@mipmap/ic_launcher'),
        iOS: DarwinInitializationSettings(),
      ),
    );
    debugPrint('MPT notification service initialized');
  } catch (error, stackTrace) {
    debugPrint('MPT background initialization failed: $error');
    debugPrintStack(stackTrace: stackTrace);
  }
}

class PrayerCity {
  final String name;
  final String country;
  final double lat;
  final double lon;
  final String zone;
  const PrayerCity(this.name, this.country, this.lat, this.lon, this.zone);
  String get label => '$name, $country';
}

const cities = <PrayerCity>[
  PrayerCity('Seoul', 'South Korea', 37.5665, 126.9780, 'Asia/Seoul'),
  PrayerCity('Busan', 'South Korea', 35.1796, 129.0756, 'Asia/Seoul'),
  PrayerCity('Incheon', 'South Korea', 37.4563, 126.7052, 'Asia/Seoul'),
  PrayerCity('Daegu', 'South Korea', 35.8714, 128.6014, 'Asia/Seoul'),
  PrayerCity('Daejeon', 'South Korea', 36.3504, 127.3845, 'Asia/Seoul'),
  PrayerCity('Gwangju', 'South Korea', 35.1595, 126.8526, 'Asia/Seoul'),
  PrayerCity('Suwon', 'South Korea', 37.2636, 127.0286, 'Asia/Seoul'),
  PrayerCity('Jeju', 'South Korea', 33.4996, 126.5312, 'Asia/Seoul'),
  PrayerCity('Tokyo', 'Japan', 35.6762, 139.6503, 'Asia/Tokyo'),
  PrayerCity('Dhaka', 'Bangladesh', 23.8103, 90.4125, 'Asia/Dhaka'),
  PrayerCity('London', 'United Kingdom', 51.5072, -0.1276, 'Europe/London'),
  PrayerCity('New York', 'United States', 40.7128, -74.0060, 'America/New_York'),
  PrayerCity('Istanbul', 'Türkiye', 41.0082, 28.9784, 'Europe/Istanbul'),
  PrayerCity('Kuala Lumpur', 'Malaysia', 3.1390, 101.6869, 'Asia/Kuala_Lumpur'),
  PrayerCity('Makkah', 'Saudi Arabia', 21.3891, 39.8579, 'Asia/Riyadh'),
  PrayerCity('Dubai', 'United Arab Emirates', 25.2048, 55.2708, 'Asia/Dubai'),
  PrayerCity('Jakarta', 'Indonesia', -6.2088, 106.8456, 'Asia/Jakarta'),
  PrayerCity('Toronto', 'Canada', 43.6532, -79.3832, 'America/Toronto'),
  PrayerCity('Sydney', 'Australia', -33.8688, 151.2093, 'Australia/Sydney'),
];

const translations = <String, Map<String, String>>{
  'en': {'home':'Home','qibla':'Qibla','calendar':'Calendar','settings':'Settings','next':'NEXT PRAYER','today':"Today's prayers",'remaining':'Time remaining','location':'Use my location','alerts':'Enable prayer notifications','calculation':'Calculation method','asr':'Asr calculation','language':'Language','appearance':'Appearance','light':'Light','dark':'Dark','hijri':'Hijri calendar','sehri':'Sehri ends (Fajr)','iftar':'Iftar (Maghrib)','notice':'Hijri dates are approximate; verify with your local mosque.','prayer':'Prayer, wherever you are','sound':'Notification sound','soundHint':'Device alert sound (not a full adhan recording)','refreshHint':'Reopen the app to refresh upcoming prayer alerts.','compassHelp':'Keep your phone level and away from magnets.','compassUnavailable':'Compass sensor unavailable. Use the bearing below.','selectCity':'Choose a city','gps':'GPS location','about':'Prayer times are calculated estimates. Verify with your local mosque.','notificationSuccess':'Prayer reminders scheduled for the next 10 days.','permission':'Location permission is required.','method':'Muslim World League (MWL)','duaTab':'Dua','ramadan':'Ramadan','tasbih':'Tasbih','prayerAlerts':'Prayer notifications','manageAlerts':'Manage each prayer alert','saveAlerts':'Save & Schedule Alerts','testAlert':'Test notification (10 seconds)','testSuccess':'Test notification scheduled (Android may delay delivery).' ,'hijriAdjust':'Hijri date adjustment','hijriHint':'Match your local mosque’s moon sighting (±2 days).','reset':'Reset','tasbihCounter':'Tasbih Counter','dailyDua':'Daily Dua & Tasbih','ramadanHere':'Ramadan is here','ramadanStarts':'Estimated Ramadan starts in','days':'days','ramadanNotice':'Ramadan dates are estimates. Confirm with your local mosque.','notifyHint':'Uses device notification sound. Android may delay inexact alarms.','adSpace':'Ad space · AdMob not configured'},
  'bn': {'home':'হোম','qibla':'কিবলা','calendar':'ক্যালেন্ডার','settings':'সেটিংস','next':'পরবর্তী নামাজ','today':'আজকের নামাজের সময়','remaining':'বাকি সময়','location':'আমার অবস্থান','alerts':'নামাজের নোটিফিকেশন চালু','calculation':'গণনার পদ্ধতি','asr':'আসরের পদ্ধতি','language':'ভাষা','appearance':'থিম','light':'লাইট','dark':'ডার্ক','hijri':'হিজরি ক্যালেন্ডার','sehri':'সেহরি শেষ (ফজর)','iftar':'ইফতার (মাগরিব)','notice':'হিজরি তারিখ আনুমানিক; স্থানীয় মসজিদের সঙ্গে মিলিয়ে নিন।','prayer':'যেখানেই থাকুন, নামাজের সাথে','sound':'নোটিফিকেশনের শব্দ','soundHint':'ফোনের অ্যালার্ট টোন; পূর্ণ আজান নয়','refreshHint':'পরবর্তী নামাজের অ্যালার্ট নবায়ন করতে অ্যাপ খুলুন।','compassHelp':'ফোন সমতল রাখুন ও চুম্বক থেকে দূরে রাখুন।','compassUnavailable':'কম্পাস সেন্সর নেই; নিচের দিকনির্দেশনা দেখুন।','selectCity':'শহর নির্বাচন','gps':'জিপিএস অবস্থান','about':'নামাজের সময় গণনাভিত্তিক। স্থানীয় মসজিদের সঙ্গে মিলিয়ে নিন।','notificationSuccess':'পরবর্তী ১০ দিনের নামাজের অ্যালার্ট নির্ধারিত হয়েছে।','permission':'লোকেশন অনুমতি প্রয়োজন।','method':'মুসলিম ওয়ার্ল্ড লীগ (MWL)','duaTab':'দোয়া','ramadan':'রমজান','tasbih':'তাসবিহ','prayerAlerts':'নামাজের নোটিফিকেশন','manageAlerts':'প্রতিটি ওয়াক্তের অ্যালার্ট নিয়ন্ত্রণ','saveAlerts':'সংরক্ষণ ও অ্যালার্ট চালু','testAlert':'১০ সেকেন্ডের টেস্ট নোটিফিকেশন','testSuccess':'১০ সেকেন্ড পর পরীক্ষামূলক নোটিফিকেশন আসার কথা।','hijriAdjust':'হিজরি তারিখ সমন্বয়','hijriHint':'স্থানীয় মসজিদের চাঁদ দেখার হিসাবে ±২ দিন ঠিক করুন।','reset':'রিসেট','tasbihCounter':'তাসবিহ কাউন্টার','dailyDua':'প্রতিদিনের দোয়া ও তাসবিহ','ramadanHere':'রমজান চলছে','ramadanStarts':'আনুমানিক রমজান শুরু হতে বাকি','days':'দিন','ramadanNotice':'রমজানের তারিখ আনুমানিক। স্থানীয় মসজিদের সঙ্গে মিলিয়ে নিন।','notifyHint':'ফোনের নোটিফিকেশন টোন ব্যবহার করে। অ্যান্ড্রয়েডে অ্যালার্ট দেরি হতে পারে।','adSpace':'বিজ্ঞাপনের স্থান · AdMob চালু হয়নি'},
  'ko': {'home':'홈','qibla':'키블라','calendar':'달력','settings':'설정','next':'다음 기도','today':'오늘의 기도 시간','remaining':'남은 시간','location':'현재 위치','alerts':'기도 알림 켜기','calculation':'계산 방식','asr':'아스르 계산','language':'언어','appearance':'테마','light':'라이트','dark':'다크','hijri':'히즈리 달력','sehri':'수후르 종료 (파즈르)','iftar':'이프타르 (마그리브)','notice':'히즈리 날짜는 근사치입니다. 현지 모스크에 확인하세요.','prayer':'어디서나 기도를','sound':'알림 소리','soundHint':'기본 알림음 (전체 아잔 녹음 아님)','refreshHint':'알림을 갱신하려면 앱을 다시 여세요.','compassHelp':'휴대전화를 수평으로 두고 자석에서 멀리하세요.','compassUnavailable':'나침반 센서를 사용할 수 없습니다. 아래 각도를 참고하세요.','selectCity':'도시 선택','gps':'GPS 위치','about':'기도 시간은 계산된 추정치입니다. 현지 모스크에 확인하세요.','notificationSuccess':'향후 10일간의 기도 알림이 예약되었습니다.','permission':'위치 권한이 필요합니다.','method':'세계무슬림연맹 (MWL)','duaTab':'두아','ramadan':'라마단','tasbih':'타스비흐','prayerAlerts':'기도 알림','manageAlerts':'기도별 알림 설정','saveAlerts':'알림 저장 및 예약','testAlert':'10초 후 테스트 알림','testSuccess':'10초 후 테스트 알림이 예약되었습니다.','hijriAdjust':'히즈리 날짜 조정','hijriHint':'현지 모스크 기준 ±2일 조정','reset':'초기화','tasbihCounter':'타스비흐 카운터','dailyDua':'매일 두아와 타스비흐','ramadanHere':'라마단 기간','ramadanStarts':'라마단 예상 시작까지','days':'일','ramadanNotice':'라마단 날짜는 추정치입니다. 현지 모스크에서 확인하세요.','notifyHint':'기본 알림음을 사용합니다. Android에서 지연될 수 있습니다.','adSpace':'광고 공간 · AdMob 미설정'},
  'ar': {'home':'الرئيسية','qibla':'القبلة','calendar':'التقويم','settings':'الإعدادات','next':'الصلاة القادمة','today':'مواقيت الصلاة اليوم','remaining':'الوقت المتبقي','location':'موقعي','alerts':'تفعيل تنبيهات الصلاة','calculation':'طريقة الحساب','asr':'حساب العصر','language':'اللغة','appearance':'المظهر','light':'فاتح','dark':'داكن','hijri':'التقويم الهجري','sehri':'نهاية السحور (الفجر)','iftar':'الإفطار (المغرب)','notice':'التاريخ الهجري تقريبي؛ يرجى التأكد من المسجد المحلي.','prayer':'الصلاة أينما كنت','sound':'صوت التنبيه','soundHint':'نغمة الهاتف الافتراضية وليست أذاناً كاملاً','refreshHint':'افتح التطبيق لتجديد التنبيهات القادمة.','compassHelp':'أبق الهاتف مستوياً وبعيداً عن المغناطيس.','compassUnavailable':'مستشعر البوصلة غير متاح. استخدم الزاوية أدناه.','selectCity':'اختر مدينة','gps':'موقع GPS','about':'مواقيت الصلاة تقديرية بالحساب؛ تحقق من المسجد المحلي.','notificationSuccess':'تم جدولة تنبيهات الصلاة لعشرة أيام.','permission':'يلزم إذن الموقع.','method':'رابطة العالم الإسلامي (MWL)','duaTab':'الدعاء','ramadan':'رمضان','tasbih':'التسبيح','prayerAlerts':'تنبيهات الصلاة','manageAlerts':'إدارة تنبيهات الصلوات','saveAlerts':'حفظ وجدولة التنبيهات','testAlert':'اختبار التنبيه بعد 10 ثوانٍ','testSuccess':'تمت جدولة تنبيه تجريبي بعد 10 ثوانٍ.','hijriAdjust':'ضبط التاريخ الهجري','hijriHint':'اضبط ±يومين حسب رؤية الهلال المحلية','reset':'إعادة تعيين','tasbihCounter':'عداد التسبيح','dailyDua':'دعاء وتسبيح يومي','ramadanHere':'رمضان مبارك','ramadanStarts':'بداية رمضان المتوقعة بعد','days':'أيام','ramadanNotice':'مواعيد رمضان تقديرية؛ تحقق من المسجد المحلي.','notifyHint':'يستخدم صوت تنبيه الهاتف وقد يتأخر على أندرويد.','adSpace':'مساحة إعلان · AdMob غير مفعّل'},
  'ur': {'home':'ہوم','qibla':'قبلہ','calendar':'کیلنڈر','settings':'ترتیبات','next':'اگلی نماز','today':'آج کی نمازوں کے اوقات','remaining':'باقی وقت','location':'میرا مقام استعمال کریں','alerts':'نماز کی اطلاعات فعال کریں','calculation':'حساب کا طریقہ','asr':'عصر کا حساب','language':'زبان','appearance':'ظاہری شکل','light':'روشن','dark':'تاریک','hijri':'ہجری کیلنڈر','sehri':'سحری ختم (فجر)','iftar':'افطار (مغرب)','notice':'ہجری تاریخ تخمینی ہے؛ مقامی مسجد سے تصدیق کریں۔','prayer':'آپ جہاں بھی ہوں، نماز','sound':'اطلاع کی آواز','soundHint':'فون کی اطلاع کی آواز (مکمل اذان نہیں)','refreshHint':'آئندہ اطلاعات تازہ کرنے کے لیے ایپ دوبارہ کھولیں۔','compassHelp':'فون سیدھا رکھیں اور مقناطیس سے دور رکھیں۔','compassUnavailable':'کمپاس دستیاب نہیں؛ نیچے درج زاویہ دیکھیں۔','selectCity':'شہر منتخب کریں','gps':'جی پی ایس مقام','about':'نماز کے اوقات حسابی اندازے ہیں؛ مقامی مسجد سے تصدیق کریں۔','notificationSuccess':'اگلے ۱۰ دن کی نماز کی اطلاعات مقرر ہو گئیں۔','permission':'مقام کی اجازت درکار ہے۔','method':'مسلم ورلڈ لیگ (MWL)','duaTab':'دعا','ramadan':'رمضان','tasbih':'تسبیح','prayerAlerts':'نماز کی اطلاعات','manageAlerts':'ہر نماز کی اطلاع کا انتظام','saveAlerts':'محفوظ کریں اور اطلاعات مقرر کریں','testAlert':'آزمائشی اطلاع (۱۰ سیکنڈ)','testSuccess':'آزمائشی اطلاع مقرر ہو گئی۔','hijriAdjust':'ہجری تاریخ کی درستی','hijriHint':'مقامی رویتِ ہلال کے مطابق ±۲ دن درست کریں۔','reset':'دوبارہ ترتیب دیں','tasbihCounter':'تسبیح کاؤنٹر','dailyDua':'روزانہ دعائیں اور تسبیح','ramadanHere':'رمضان جاری ہے','ramadanStarts':'رمضان شروع ہونے میں متوقع دن','days':'دن','ramadanNotice':'رمضان کی تاریخ تخمینی ہے؛ مقامی مسجد سے تصدیق کریں۔','notifyHint':'فون کی اطلاع کی آواز استعمال ہوتی ہے۔','adSpace':'اشتہار کی جگہ · AdMob فعال نہیں'},
  'uz': {'home':'Bosh sahifa','qibla':'Qibla','calendar':'Taqvim','settings':'Sozlamalar','next':'KEYINGI NAMOZ','today':'Bugungi namoz vaqtlari','remaining':'Qolgan vaqt','location':'Joylashuvimdan foydalanish','alerts':'Namoz bildirishnomalarini yoqish','calculation':'Hisoblash usuli','asr':'Asr hisobi','language':'Til','appearance':'Ko‘rinish','light':'Yorug‘','dark':'Qorong‘i','hijri':'Hijriy taqvim','sehri':'Saharlik tugashi (Bomdod)','iftar':'Iftor (Shom)','notice':'Hijriy sana taxminiy; mahalliy masjiddan tekshiring.','prayer':'Qayerda bo‘lsangiz ham, namoz','sound':'Bildirishnoma ovozi','soundHint':'Telefon ogohlantirish ovozi (to‘liq azon emas)','refreshHint':'Bildirishnomalarni yangilash uchun ilovani qayta oching.','compassHelp':'Telefonni tekis tuting va magnitlardan uzoqroq saqlang.','compassUnavailable':'Kompas mavjud emas. Quyidagi yo‘nalishga qarang.','selectCity':'Shaharni tanlang','gps':'GPS joylashuvi','about':'Namoz vaqtlari hisoblangan taxminiy qiymatlar; masjiddan tekshiring.','notificationSuccess':'Keyingi 10 kun uchun eslatmalar belgilandi.','permission':'Joylashuv ruxsati kerak.','method':'Musulmonlar jahon ligasi (MWL)','duaTab':'Duo','ramadan':'Ramazon','tasbih':'Tasbeh','prayerAlerts':'Namoz eslatmalari','manageAlerts':'Har bir namoz eslatmasini boshqarish','saveAlerts':'Saqlash va rejalashtirish','testAlert':'Sinov bildirishnomasi (10 soniya)','testSuccess':'Sinov bildirishnomasi belgilandi.','hijriAdjust':'Hijriy sanani tuzatish','hijriHint':'Mahalliy hilol kuzatuviga ko‘ra ±2 kun.','reset':'Qayta o‘rnatish','tasbihCounter':'Tasbeh hisoblagichi','dailyDua':'Kundalik duo va tasbeh','ramadanHere':'Ramazon boshlandi','ramadanStarts':'Ramazongacha taxminan','days':'kun','ramadanNotice':'Ramazon sanalari taxminiy; masjiddan tekshiring.','notifyHint':'Telefonning bildirishnoma ovozi ishlatiladi.','adSpace':'Reklama joyi · AdMob sozlanmagan'},
  'id': {'home':'Beranda','qibla':'Kiblat','calendar':'Kalender','settings':'Pengaturan','next':'SALAT BERIKUTNYA','today':'Jadwal salat hari ini','remaining':'Sisa waktu','location':'Gunakan lokasi saya','alerts':'Aktifkan notifikasi salat','calculation':'Metode perhitungan','asr':'Perhitungan Asar','language':'Bahasa','appearance':'Tampilan','light':'Terang','dark':'Gelap','hijri':'Kalender Hijriah','sehri':'Akhir sahur (Subuh)','iftar':'Buka puasa (Magrib)','notice':'Tanggal Hijriah adalah perkiraan; periksa dengan masjid setempat.','prayer':'Salat di mana pun Anda berada','sound':'Suara notifikasi','soundHint':'Suara notifikasi perangkat (bukan azan lengkap)','refreshHint':'Buka kembali aplikasi untuk memperbarui pengingat.','compassHelp':'Pegang ponsel mendatar dan jauhkan dari magnet.','compassUnavailable':'Sensor kompas tidak tersedia. Gunakan arah di bawah.','selectCity':'Pilih kota','gps':'Lokasi GPS','about':'Waktu salat adalah hasil perhitungan; konfirmasikan dengan masjid setempat.','notificationSuccess':'Pengingat salat untuk 10 hari ke depan telah dijadwalkan.','permission':'Izin lokasi diperlukan.','method':'Liga Muslim Dunia (MWL)','duaTab':'Doa','ramadan':'Ramadan','tasbih':'Tasbih','prayerAlerts':'Notifikasi salat','manageAlerts':'Atur pengingat setiap salat','saveAlerts':'Simpan dan jadwalkan','testAlert':'Uji notifikasi (10 detik)','testSuccess':'Notifikasi uji telah dijadwalkan.','hijriAdjust':'Penyesuaian tanggal Hijriah','hijriHint':'Sesuaikan ±2 hari dengan rukyat setempat.','reset':'Atur ulang','tasbihCounter':'Penghitung tasbih','dailyDua':'Doa harian dan tasbih','ramadanHere':'Ramadan telah tiba','ramadanStarts':'Perkiraan Ramadan dimulai dalam','days':'hari','ramadanNotice':'Tanggal Ramadan adalah perkiraan; konfirmasikan dengan masjid setempat.','notifyHint':'Menggunakan suara notifikasi perangkat.','adSpace':'Ruang iklan · AdMob belum dikonfigurasi'},
  'hi': {'home':'होम','qibla':'क़िबला','calendar':'कैलेंडर','settings':'सेटिंग्स','next':'अगली नमाज़','today':'आज की नमाज़ के समय','remaining':'शेष समय','location':'मेरी लोकेशन इस्तेमाल करें','alerts':'नमाज़ की सूचनाएँ चालू करें','calculation':'गणना विधि','asr':'अस्र की गणना','language':'भाषा','appearance':'दिखावट','light':'लाइट','dark':'डार्क','hijri':'हिजरी कैलेंडर','sehri':'सहरी समाप्त (फ़ज्र)','iftar':'इफ़्तार (मग़रिब)','notice':'हिजरी तारीख़ अनुमानित है; स्थानीय मस्जिद से पुष्टि करें।','prayer':'आप जहाँ भी हों, नमाज़','sound':'सूचना की ध्वनि','soundHint':'फ़ोन की सूचना ध्वनि (पूरी अज़ान नहीं)','refreshHint':'आगामी सूचनाएँ अपडेट करने के लिए ऐप फिर खोलें।','compassHelp':'फ़ोन सीधा रखें और चुंबक से दूर रखें।','compassUnavailable':'कंपास उपलब्ध नहीं है; नीचे दिशा देखें।','selectCity':'शहर चुनें','gps':'GPS लोकेशन','about':'नमाज़ के समय गणना आधारित अनुमान हैं; स्थानीय मस्जिद से पुष्टि करें।','notificationSuccess':'अगले 10 दिनों की नमाज़ की सूचनाएँ निर्धारित हैं।','permission':'लोकेशन की अनुमति आवश्यक है।','method':'मुस्लिम वर्ल्ड लीग (MWL)','duaTab':'दुआ','ramadan':'रमज़ान','tasbih':'तस्बीह','prayerAlerts':'नमाज़ की सूचनाएँ','manageAlerts':'हर नमाज़ की सूचना प्रबंधित करें','saveAlerts':'सहेजें और निर्धारित करें','testAlert':'टेस्ट सूचना (10 सेकंड)','testSuccess':'टेस्ट सूचना निर्धारित की गई।','hijriAdjust':'हिजरी तारीख़ समायोजन','hijriHint':'स्थानीय चाँद देखने के अनुसार ±2 दिन समायोजित करें।','reset':'रीसेट','tasbihCounter':'तस्बीह काउंटर','dailyDua':'रोज़ाना दुआ और तस्बीह','ramadanHere':'रमज़ान शुरू हो गया','ramadanStarts':'रमज़ान शुरू होने में अनुमानित','days':'दिन','ramadanNotice':'रमज़ान की तारीख़ अनुमानित है; स्थानीय मस्जिद से पुष्टि करें।','notifyHint':'फ़ोन की सूचना ध्वनि इस्तेमाल होती है।','adSpace':'विज्ञापन स्थान · AdMob सेट नहीं है'},
};
String tr(String lang, String key) => translations[lang]?[key] ?? translations['en']?[key] ?? key;

const uiExtras = <String, Map<String, String>>{
  'en': {'gpsSuccess': 'Using GPS coordinates and device timezone.', 'duaNumber': 'Dua', 'adhanSuccess': 'Prayer alerts and automatic Adhan scheduled.', 'alertError': 'Could not schedule alerts'},
  'bn': {'gpsSuccess': 'জিপিএস অবস্থান ও ফোনের সময় অঞ্চল ব্যবহার করা হচ্ছে।', 'duaNumber': 'দোয়া', 'adhanSuccess': 'নামাজের অ্যালার্ট ও স্বয়ংক্রিয় আজান নির্ধারিত হয়েছে।', 'alertError': 'অ্যালার্ট নির্ধারণ করা যায়নি'},
  'ko': {'gpsSuccess': 'GPS 좌표와 휴대전화 시간대를 사용합니다.', 'duaNumber': '두아', 'adhanSuccess': '기도 알림과 자동 아잔이 예약되었습니다.', 'alertError': '알림을 예약할 수 없습니다'},
  'ar': {'gpsSuccess': 'يتم استخدام إحداثيات GPS والمنطقة الزمنية للجهاز.', 'duaNumber': 'دعاء', 'adhanSuccess': 'تمت جدولة تنبيهات الصلاة والأذان التلقائي.', 'alertError': 'تعذرت جدولة التنبيهات'},
};
String uix(String lang, String key) => mptExtraTranslations[lang]?[key] ?? uiExtras[lang]?[key] ?? uiExtras['en']?[key] ?? key;


// Extra strings introduced in v1.3.1, without disturbing existing translations.
const extraTranslations = <String, Map<String, String>>{
  'en': {'northBearing':'from North','testTitle':'MPT · Test notification','testBody':'Prayer notification test successful.'},
  'bn': {'northBearing':'উত্তর দিক থেকে','testTitle':'MPT · পরীক্ষামূলক নোটিফিকেশন','testBody':'নামাজের নোটিফিকেশন পরীক্ষা সফল হয়েছে।'},
  'ko': {'northBearing':'북쪽 기준','testTitle':'MPT · 테스트 알림','testBody':'기도 알림 테스트가 완료되었습니다.'},
  'ar': {'northBearing':'من الشمال','testTitle':'MPT · إشعار تجريبي','testBody':'نجح اختبار إشعار الصلاة.'},
};
String tx(String lang, String key) => mptExtraTranslations[lang]?[key] ?? extraTranslations[lang]?[key] ?? extraTranslations['en']?[key] ?? key;

// Additional localized Adhan controls for the next release.
const adhanTranslations = <String, Map<String, String>>{
  'en': {
    'preciseAdhan': 'Allow precise Adhan alarms',
    'adhanSettings': 'Adhan settings',
    'fullAdhan': 'Full Adhan',
    'shortAdhan': 'Short Adhan',
    'specialFajr': 'Special Fajr Adhan',
    'specialFajrHint': 'Use a special Adhan for Fajr',
    'previewAdhan': 'Preview Adhan',
    'previewFajr': 'Preview Fajr',
    'stopAdhan': 'Stop',
    'adhanHelp': 'Preview plays inside the app. Save & Schedule Alerts also schedules Android Adhan audio. Allow precise alarms in Settings; Android battery restrictions may delay playback.',
    'adhanScheduled': 'Automatic Adhan scheduled.',
    'audioError': 'Audio error',
  },
  'bn': {
    'preciseAdhan': 'সঠিক সময়ে আজানের অনুমতি দিন',
    'adhanSettings': 'আজান সেটিংস',
    'fullAdhan': 'পূর্ণ আজান',
    'shortAdhan': 'সংক্ষিপ্ত আজান',
    'specialFajr': 'ফজরের বিশেষ আজান',
    'specialFajrHint': 'ফজরের জন্য বিশেষ আজান ব্যবহার করুন',
    'previewAdhan': 'আজান শুনুন',
    'previewFajr': 'ফজরের আজান শুনুন',
    'stopAdhan': 'বন্ধ করুন',
    'adhanHelp': 'প্রিভিউ অ্যাপের ভেতরে বাজে। অ্যালার্ট সংরক্ষণ করলে Android-এ আজানও নির্ধারিত হয়। সেটিংসে সঠিক সময়ের অ্যালার্ম অনুমতি দিন; ব্যাটারি সীমাবদ্ধতায় আজান দেরি হতে পারে।',
    'adhanScheduled': 'স্বয়ংক্রিয় আজান নির্ধারিত হয়েছে।',
    'audioError': 'অডিও সমস্যা',
  },
  'ko': {
    'preciseAdhan': '정확한 아잔 알람 허용',
    'adhanSettings': '아잔 설정',
    'fullAdhan': '전체 아잔',
    'shortAdhan': '짧은 아잔',
    'specialFajr': '파즈르 특별 아잔',
    'specialFajrHint': '파즈르 기도에 특별 아잔 사용',
    'previewAdhan': '아잔 미리 듣기',
    'previewFajr': '파즈르 아잔 미리 듣기',
    'stopAdhan': '중지',
    'adhanHelp': '미리 듣기는 앱 안에서 재생됩니다. 알림을 저장하면 Android 아잔도 예약됩니다. 설정에서 정확한 알람을 허용하세요. 배터리 제한으로 재생이 지연될 수 있습니다.',
    'adhanScheduled': '자동 아잔이 예약되었습니다.',
    'audioError': '오디오 오류',
  },
  'ar': {
    'preciseAdhan': 'السماح بتنبيهات الأذان الدقيقة',
    'adhanSettings': 'إعدادات الأذان',
    'fullAdhan': 'الأذان الكامل',
    'shortAdhan': 'الأذان المختصر',
    'specialFajr': 'أذان الفجر الخاص',
    'specialFajrHint': 'استخدام أذان خاص لصلاة الفجر',
    'previewAdhan': 'استمع إلى الأذان',
    'previewFajr': 'استمع إلى أذان الفجر',
    'stopAdhan': 'إيقاف',
    'adhanHelp': 'تعمل المعاينة داخل التطبيق. عند حفظ التنبيهات، تتم جدولة الأذان على أندرويد أيضًا. اسمح بالمنبهات الدقيقة في الإعدادات؛ قد تؤخر قيود البطارية التشغيل.',
    'adhanScheduled': 'تمت جدولة الأذان تلقائيًا.',
    'audioError': 'خطأ صوتي',
  },
};
String atx(String lang, String key) => mptExtraTranslations[lang]?[key] ?? adhanTranslations[lang]?[key] ?? adhanTranslations['en']?[key] ?? key;

const calendarDayLabels = <String, List<String>>{
  'en': ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'],
  'bn': ['রবি', 'সোম', 'মঙ্গল', 'বুধ', 'বৃহস্পতি', 'শুক্র', 'শনি'],
  'ko': ['일', '월', '화', '수', '목', '금', '토'],
  'ar': ['أحد', 'إثن', 'ثلا', 'أرب', 'خمي', 'جمع', 'سبت'],
  'ur': ['اتوار','پیر','منگل','بدھ','جمعرات','جمعہ','ہفتہ'],
  'uz': ['Yak','Dush','Sesh','Chor','Pay','Jum','Shan'],
  'id': ['Min','Sen','Sel','Rab','Kam','Jum','Sab'],
  'hi': ['रवि','सोम','मंगल','बुध','गुरु','शुक्र','शनि'],
};
List<String> calendarWeekdays(String language) =>
    calendarDayLabels[language] ?? calendarDayLabels['en']!;

const MethodChannel nativeAdhanChannel = MethodChannel('mpt/adhan_alarm');

/// Schedules audio independently of the Flutter UI. Android only.
/// Exact alarm access must be granted in Android's special app access settings.
Future<String> scheduleNativeAdhan(PrayerCity city, bool hanafi,
    {List<bool>? enabled}) async {
  if (defaultTargetPlatform != TargetPlatform.android) {
    return 'Automatic audio alarm is Android-only in this build.';
  }
  final prefs = await SharedPreferences.getInstance();
  final length = prefs.getString('adhan_length') == 'short' ? 'short' : 'full';
  final specialFajr = prefs.getBool('special_fajr') ?? true;
  final canExact = await nativeAdhanChannel.invokeMethod<bool>('canExact') ?? false;
  await nativeAdhanChannel.invokeMethod<void>('cancelAll');
  var id = 10000;
  final today = cityNow(city);
  for (var day = 0; day < 10; day++) {
    final date = DateTime(today.year, today.month, today.day).add(Duration(days: day));
    for (final prayer in prayersFor(city, hanafi, date)) {
      if (enabled != null && !enabled[prayer.index]) continue;
      final instant = localToInstant(prayer.localTime, city);
      if (!instant.isAfter(DateTime.now())) continue;
      final prefix = prayer.index == 0 && specialFajr ? 'fajr' : 'regular';
      await nativeAdhanChannel.invokeMethod<bool>('schedule', <String, dynamic>{
        'id': id++, 'at': instant.millisecondsSinceEpoch,
        'audio': '${prefix}_$length',
      });
    }
  }
  return canExact
      ? 'Automatic Adhan scheduled for the next 10 days.'
      : 'Adhan scheduled approximately. Allow Alarms & reminders in Android settings for more precise timing.';
}


String localizedCity(PrayerCity city, String language) {
  if (language != 'bn') return city.label;
  const names = <String, String>{'Seoul':'সিউল','Busan':'বুসান','Incheon':'ইনচন','Daegu':'দেগু','Daejeon':'দেজন','Gwangju':'গোয়াংজু','Suwon':'সুওন','Jeju':'জেজু','Tokyo':'টোকিও','Dhaka':'ঢাকা','London':'লন্ডন','New York':'নিউইয়র্ক','Istanbul':'ইস্তাম্বুল','Kuala Lumpur':'কুয়ালালামপুর','Makkah':'মক্কা','Dubai':'দুবাই','Jakarta':'জাকার্তা','Toronto':'টরন্টো','Sydney':'সিডনি'};
  const countries = <String, String>{'South Korea':'দক্ষিণ কোরিয়া','Japan':'জাপান','Bangladesh':'বাংলাদেশ','United Kingdom':'যুক্তরাজ্য','United States':'যুক্তরাষ্ট্র','Türkiye':'তুরস্ক','Malaysia':'মালয়েশিয়া','Saudi Arabia':'সৌদি আরব','United Arab Emirates':'সংযুক্ত আরব আমিরাত','Indonesia':'ইন্দোনেশিয়া','Canada':'কানাডা','Australia':'অস্ট্রেলিয়া'};
  return '${names[city.name] ?? city.name}, ${countries[city.country] ?? city.country}';
}

String localizedDate(DateTime date, String language) {
  if (language != 'bn') return DateFormat('EEEE, d MMMM yyyy').format(date);
  const weekdays = ['সোমবার','মঙ্গলবার','বুধবার','বৃহস্পতিবার','শুক্রবার','শনিবার','রবিবার'];
  const months = ['জানুয়ারি','ফেব্রুয়ারি','মার্চ','এপ্রিল','মে','জুন','জুলাই','আগস্ট','সেপ্টেম্বর','অক্টোবর','নভেম্বর','ডিসেম্বর'];
  return '${weekdays[date.weekday - 1]}, ${date.day} ${months[date.month - 1]} ${date.year}';
}


int hijriAdjustment = 0;
({int year, int month, int day}) adjustedHijri(DateTime date) =>
    hijriCivil(date.add(Duration(days: hijriAdjustment)));

const prayerNames = <String, List<String>>{
  'en':['Fajr','Dhuhr','Asr','Maghrib','Isha'],
  'bn':['ফজর','যোহর','আসর','মাগরিব','এশা'],
  'ko':['파즈르','두흐르','아스르','마그리브','이샤'],
  'ar':['الفجر','الظهر','العصر','المغرب','العشاء'],
  'ur': ['فجر','ظہر','عصر','مغرب','عشاء'],
  'uz': ['Bomdod','Peshin','Asr','Shom','Xufton'],
  'id': ['Subuh','Zuhur','Asar','Magrib','Isya'],
  'hi': ['फ़ज्र','ज़ुहर','अस्र','मग़रिब','इशा'],
};
const hijriMonths = <String, List<String>>{
  'en':['Muharram','Safar','Rabi al-Awwal','Rabi al-Thani','Jumada al-Ula','Jumada al-Akhirah','Rajab','Sha’ban','Ramadan','Shawwal','Dhu al-Qadah','Dhu al-Hijjah'],
  'bn':['মুহাররম','সফর','রবিউল আউয়াল','রবিউস সানি','জমাদিউল আউয়াল','জমাদিউস সানি','রজব','শাবান','রমজান','শাওয়াল','জিলকদ','জিলহজ'],
  'ko':['무하람','사파르','라비 알아우왈','라비 알타니','주마다 알아울라','주마다 알아키라','라자브','샤반','라마단','샤왈','둘카다','둘히자'],
  'ar':['محرم','صفر','ربيع الأول','ربيع الآخر','جمادى الأولى','جمادى الآخرة','رجب','شعبان','رمضان','شوال','ذو القعدة','ذو الحجة'],
  'ur': ['محرم','صفر','ربیع الاول','ربیع الثانی','جمادی الاول','جمادی الثانی','رجب','شعبان','رمضان','شوال','ذوالقعدہ','ذوالحجہ'],
  'uz': ['Muharram','Safar','Rabiul avval','Rabiul oxir','Jumodul avval','Jumodul oxir','Rajab','Sha’bon','Ramazon','Shavvol','Zulqa’da','Zulhijja'],
  'id': ['Muharam','Safar','Rabiulawal','Rabiulakhir','Jumadilawal','Jumadilakhir','Rajab','Syakban','Ramadan','Syawal','Zulkaidah','Zulhijah'],
  'hi': ['मुहर्रम','सफ़र','रबीउल अव्वल','रबीउल आख़िर','जमादिउल अव्वल','जमादिउल आख़िर','रजब','शाबान','रमज़ान','शव्वाल','ज़ुलक़ादा','ज़ुलहिज्जा'],
};

int julianDay(DateTime d) {
  var y = d.year;
  var m = d.month;
  if (m <= 2) { y--; m += 12; }
  final a = y ~/ 100;
  final b = 2 - a + a ~/ 4;
  return (365.25 * (y + 4716)).floor() + (30.6001 * (m + 1)).floor() + d.day + b - 1524;
}
int islamicStart(int y, int m) => (29.5 * (m - 1)).ceil() + (y - 1) * 354 + ((3 + 11 * y) ~/ 30) + 1948440 - 1;
({int year, int month, int day}) hijriCivil(DateTime date) {
  final jd = julianDay(date);
  var year = ((30 * (jd - 1948440) + 10646) ~/ 10631);
  if (year < 1) year = 1;
  var month = 1;
  while (month < 12 && jd >= islamicStart(year, month + 1)) { month++; }
  return (year: year, month: month, day: jd - islamicStart(year, month) + 1);
}

// Prayer calculations use the selected city's local wall-clock date and time.
// For GPS, the device timezone is used; users travelling should keep automatic
// device timezone enabled. This is not a general coordinate-to-timezone lookup.
tz.Location cityZone(PrayerCity city) {
  try { return tz.getLocation(city.zone); } catch (_) { return tz.local; }
}
DateTime wallClock(tz.TZDateTime d) => DateTime(d.year, d.month, d.day, d.hour, d.minute, d.second);
DateTime cityNow(PrayerCity city) => wallClock(tz.TZDateTime.now(cityZone(city)));
DateTime localToInstant(DateTime local, PrayerCity city) {
  final zone = cityZone(city);
  return tz.TZDateTime(zone, local.year, local.month, local.day, local.hour, local.minute, local.second);
}
CalculationParameters calculationParams(bool hanafi) => CalculationMethod.muslim_world_league.getParameters()
  ..madhab = hanafi ? Madhab.hanafi : Madhab.shafi;

class PrayerItem {
  final int index;
  final DateTime localTime;
  final IconData icon;
  const PrayerItem(this.index, this.localTime, this.icon);
}
List<PrayerItem> prayersFor(PrayerCity city, bool hanafi, DateTime date) {
  final times = PrayerTimes(Coordinates(city.lat, city.lon), DateComponents.from(date), calculationParams(hanafi));
  // Adhan returns absolute instants. Display them in the selected city's timezone.
  DateTime inCity(DateTime instant) => wallClock(tz.TZDateTime.from(instant, cityZone(city)));
  return [
    PrayerItem(0, inCity(times.fajr), Icons.nightlight_round),
    PrayerItem(1, inCity(times.dhuhr), Icons.wb_sunny_outlined),
    PrayerItem(2, inCity(times.asr), Icons.sunny),
    PrayerItem(3, inCity(times.maghrib), Icons.wb_twilight),
    PrayerItem(4, inCity(times.isha), Icons.nights_stay_outlined),
  ];
}

Future<void> schedulePrayerAlerts(PrayerCity city, bool hanafi, {bool sound = true, List<bool>? enabled}) async {
  await mptServicesReady;
  final android = notifications.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
  final grantedAndroid = await android?.requestNotificationsPermission();
  final ios = notifications.resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>();
  final grantedIos = await ios?.requestPermissions(alert: true, badge: true, sound: true);
  if (grantedAndroid == false || grantedIos == false) {
    throw StateError('Notification permission denied');
  }
  await notifications.cancelAll();
  final details = NotificationDetails(
    android: AndroidNotificationDetails(
      sound ? 'mpt_prayer_sound' : 'mpt_prayer_silent',
      'Prayer reminders',
      channelDescription: 'Daily prayer time reminders',
      importance: Importance.max,
      priority: Priority.high,
      playSound: sound,
    ),
    iOS: DarwinNotificationDetails(presentSound: sound),
  );
  var id = 0;
  final today = cityNow(city);
  for (var day = 0; day < 10; day++) {
    final date = DateTime(today.year, today.month, today.day).add(Duration(days: day));
    for (final prayer in prayersFor(city, hanafi, date)) {
      if (enabled != null && !enabled[prayer.index]) continue;
      final instant = localToInstant(prayer.localTime, city);
      if (instant.isAfter(DateTime.now())) {
        await notifications.zonedSchedule(
          id++, 'MUSLIM PRAYER TIMES · ${prayerNames['en']![prayer.index]}',
          'It is time for ${prayerNames['en']![prayer.index]}.',
          tz.TZDateTime.from(instant, tz.local), details,
          androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
          uiLocalNotificationDateInterpretation:
              UILocalNotificationDateInterpretation.absoluteTime,
          payload: prayerNames['en']![prayer.index],
        );
      }
    }
  }
  // Keep native audio scheduling in sync with prayer notification choices.
  // Audio and visual notifications are separate Android subsystems.
  await scheduleNativeAdhan(city, hanafi, enabled: enabled);
}

Future<void> scheduleTestNotification({String language = 'en'}) async {
  await mptServicesReady;
  final android = notifications.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
  final granted = await android?.requestNotificationsPermission();
  if (granted == false) throw StateError('Notification permission denied');
  await notifications.zonedSchedule(
    99001, tx(language, 'testTitle'), tx(language, 'testBody'),
    tz.TZDateTime.now(tz.local).add(const Duration(seconds: 10)),
    const NotificationDetails(android: AndroidNotificationDetails(
      'mpt_test_v130', 'MPT test notifications', importance: Importance.max,
      priority: Priority.high), iOS: DarwinNotificationDetails()),
    androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
    uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
  );
}

class MuslimPrayerTimesApp extends StatefulWidget {
  const MuslimPrayerTimesApp({super.key});
  @override State<MuslimPrayerTimesApp> createState() => _MuslimPrayerTimesAppState();
}
class _MuslimPrayerTimesAppState extends State<MuslimPrayerTimesApp> {
  String language = 'en';
  bool dark = false;
  @override void initState() { super.initState(); restore(); }
  Future<void> restore() async {
    final prefs = await SharedPreferences.getInstance();
    if (!mounted) return;
    setState(() {
      hijriAdjustment = (prefs.getInt('hijri_adjustment') ?? 0).clamp(-2, 2);
      final saved = prefs.getString('language') ?? 'en';
      language = translations.containsKey(saved) ? saved : 'en';
      dark = prefs.getBool('dark') ?? false;
    });
  }
  @override Widget build(BuildContext context) => MaterialApp(
    title: 'MUSLIM PRAYER TIMES', debugShowCheckedModeBanner: false,
    locale: Locale(language),
    builder: (context, child) => Directionality(
      textDirection: (language == 'ur' || language == 'ar') ? ui.TextDirection.rtl : ui.TextDirection.ltr,
      child: child ?? const SizedBox.shrink(),
    ),
    themeMode: dark ? ThemeMode.dark : ThemeMode.light,
    theme: ThemeData(useMaterial3: true, scaffoldBackgroundColor: cream,
      colorScheme: ColorScheme.fromSeed(seedColor: emerald, surface: const Color(0xFFF6F8F4)),
      navigationBarTheme: const NavigationBarThemeData(backgroundColor: Color(0xFFE5EEE7))),
    darkTheme: ThemeData(useMaterial3: true, brightness: Brightness.dark,
      colorScheme: ColorScheme.fromSeed(seedColor: gold, brightness: Brightness.dark),
      scaffoldBackgroundColor: const Color(0xFF0D1D19)),
    home: MainShell(language: language, dark: dark,
      onLanguageChanged: (value) {
        setState(() => language = value);
        SharedPreferences.getInstance().then((p) => p.setString('language', value));
      },
      onDarkChanged: (value) {
        setState(() => dark = value);
        SharedPreferences.getInstance().then((p) => p.setBool('dark', value));
      }),
  );
}

class MainShell extends StatefulWidget {
  final String language;
  final bool dark;
  final ValueChanged<String> onLanguageChanged;
  final ValueChanged<bool> onDarkChanged;
  const MainShell({super.key, required this.language, required this.dark, required this.onLanguageChanged, required this.onDarkChanged});
  @override State<MainShell> createState() => _MainShellState();
}
class _MainShellState extends State<MainShell> {
  int tab = 0;
  PrayerCity city = cities.first;
  bool hanafi = true;
  bool sound = true;
  @override void initState() { super.initState(); restore(); }
  Future<void> restore() async {
    final prefs = await SharedPreferences.getInstance();
    if (!mounted) return;
    setState(() {
      hanafi = prefs.getBool('hanafi') ?? true;
      sound = prefs.getBool('sound') ?? true;
      final selected = prefs.getString('city');
      if (selected == 'My location') {
        final lat = prefs.getDouble('gps_lat');
        final lon = prefs.getDouble('gps_lon');
        final zone = prefs.getString('gps_zone') ?? tz.local.name;
        if (lat != null && lon != null) {
          city = PrayerCity('My location', 'GPS', lat, lon, zone);
        }
      } else {
        for (final candidate in cities) { if (candidate.name == selected) city = candidate; }
      }
    });
  }
  Future<void> useLocation() async {
    try {
      if (!await Geolocator.isLocationServiceEnabled()) throw StateError('Turn on location services.');
      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied || permission == LocationPermission.deniedForever) throw StateError(tr(widget.language, 'permission'));
      final pos = await Geolocator.getCurrentPosition();
      if (!mounted) return;
      setState(() => city = PrayerCity('My location', 'GPS', pos.latitude, pos.longitude, tz.local.name));
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('city', 'My location');
      await prefs.setDouble('gps_lat', pos.latitude);
      await prefs.setDouble('gps_lon', pos.longitude);
      await prefs.setString('gps_zone', tz.local.name);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(uix(widget.language, 'gpsSuccess'))));
    } catch (error) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$error')));
    }
  }
  @override Widget build(BuildContext context) {
    final lang = widget.language;
    final pages = <Widget>[
      PrayerHome(city: city, hanafi: hanafi, language: lang,
        onCityChanged: (value) {
          setState(() => city = value);
          SharedPreferences.getInstance().then((p) => p.setString('city', value.name));
        }, onUseLocation: useLocation),
      QiblaPage(city: city, language: lang),
      SurahLibraryPage(language: lang),
      CalendarPage(city: city, hanafi: hanafi, language: lang),
      LearningDuaPage(language: lang, onOpenQuranicDuas: () => Navigator.push(context, MaterialPageRoute(builder: (_) => DuaPage(language: lang)))),
      SettingsPage(city: city, hanafi: hanafi, language: lang, dark: widget.dark,
        sound: sound, onLanguageChanged: widget.onLanguageChanged,
        onDarkChanged: widget.onDarkChanged,
        onSoundChanged: (value) {
          setState(() => sound = value);
          SharedPreferences.getInstance().then((p) => p.setBool('sound', value));
        }, onMadhabChanged: (value) {
          setState(() => hanafi = value);
          SharedPreferences.getInstance().then((p) => p.setBool('hanafi', value));
        }),
    ];
    return Scaffold(
      body: SafeArea(child: IndexedStack(index: tab, children: pages)),
      bottomNavigationBar: NavigationBar(
        labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
        height: 66,
        selectedIndex: tab,
        onDestinationSelected: (value) => setState(() => tab = value),
        destinations: [
          NavigationDestination(icon: const Icon(Icons.home_outlined), selectedIcon: const Icon(Icons.home), label: tr(lang, 'home')),
          NavigationDestination(icon: const Icon(Icons.explore_outlined), selectedIcon: const Icon(Icons.explore), label: tr(lang, 'qibla')),
          NavigationDestination(icon: const Icon(Icons.menu_book_outlined), label: learningLabel(lang, 'surah')),
          NavigationDestination(icon: const Icon(Icons.calendar_month_outlined), label: tr(lang, 'calendar')),
          NavigationDestination(icon: const Icon(Icons.volunteer_activism_outlined), label: tr(lang, 'duaTab')),
          NavigationDestination(icon: const Icon(Icons.tune), label: tr(lang, 'settings')),
        ],
      ),
    );
  }
}

class MptLogo extends StatelessWidget {
  final double size;
  const MptLogo({super.key, this.size = 54});
  @override Widget build(BuildContext context) => ClipRRect(
    borderRadius: BorderRadius.circular(size * .24),
    child: Image.asset(logoAsset, width: size, height: size, fit: BoxFit.cover,
      errorBuilder: (_, __, ___) => Container(width: size, height: size,
        decoration: BoxDecoration(color: deepGreen, borderRadius: BorderRadius.circular(size * .24)),
        child: Icon(Icons.mosque, color: gold, size: size * .56))),
  );
}

class PrayerHome extends StatefulWidget {
  final PrayerCity city;
  final bool hanafi;
  final String language;
  final ValueChanged<PrayerCity> onCityChanged;
  final VoidCallback onUseLocation;
  const PrayerHome({super.key, required this.city, required this.hanafi, required this.language, required this.onCityChanged, required this.onUseLocation});
  @override State<PrayerHome> createState() => _PrayerHomeState();
}
class _PrayerHomeState extends State<PrayerHome> {
  Timer? ticker;
  @override void initState() {
    super.initState();
    ticker = Timer.periodic(const Duration(seconds: 1), (_) { if (mounted) setState(() {}); });
  }
  @override void dispose() { ticker?.cancel(); super.dispose(); }
  @override Widget build(BuildContext context) {
    final lang = widget.language;
    final now = cityNow(widget.city);
    final entries = prayersFor(widget.city, widget.hanafi, now);
    final next = entries.where((p) => p.localTime.isAfter(now)).firstOrNull;
    final nextItem = next ?? prayersFor(widget.city, widget.hanafi, now.add(const Duration(days: 1))).first;
    final remaining = localToInstant(nextItem.localTime, widget.city).difference(DateTime.now());
    final duration = remaining.isNegative ? Duration.zero : remaining;
    final countdown = '${duration.inHours.toString().padLeft(2, '0')}:${(duration.inMinutes % 60).toString().padLeft(2, '0')}:${(duration.inSeconds % 60).toString().padLeft(2, '0')}';
    final theme = Theme.of(context);
    final dark = theme.brightness == Brightness.dark;
    final foreground = theme.colorScheme.onSurface;
    final secondary = dark ? Colors.white70 : muted;
    return ListView(padding: const EdgeInsets.fromLTRB(20, 18, 20, 28), children: [
      Row(children: [
        const MptLogo(size: 56), const SizedBox(width: 12),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('MUSLIM PRAYER TIMES', maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: foreground)),
          Text(tr(lang, 'prayer'), style: TextStyle(fontSize: 12, color: secondary)),
        ])),
        IconButton(onPressed: widget.onUseLocation, icon: const Icon(Icons.my_location, color: emerald)),
      ]),
      const IslamicHeroBanner(),
      const SizedBox(height: 14),
      Container(padding: const EdgeInsets.all(22), decoration: BoxDecoration(
        gradient: const LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [emerald, deepGreen]),
        borderRadius: BorderRadius.circular(27),
      ), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          const Icon(Icons.location_on_outlined, color: gold, size: 21), const SizedBox(width: 8),
          Expanded(child: DropdownButtonHideUnderline(child: DropdownButton<PrayerCity>(
            isExpanded: true, value: cities.contains(widget.city) ? widget.city : null,
            hint: Text(localizedCity(widget.city, widget.language), style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
            dropdownColor: deepGreen, iconEnabledColor: gold,
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 15),
            items: cities.map((city) => DropdownMenuItem(value: city, child: Text(localizedCity(city, widget.language), overflow: TextOverflow.ellipsis))).toList(),
            onChanged: (value) { if (value != null) widget.onCityChanged(value); },
          ))),
          IconButton(onPressed: widget.onUseLocation, icon: const Icon(Icons.gps_fixed, color: Colors.white)),
        ]),
        const SizedBox(height: 23),
        Text(localizedDate(now, widget.language), style: const TextStyle(color: Colors.white70, fontSize: 13)),
        const SizedBox(height: 21),
        Text(tr(lang, 'next'), style: const TextStyle(color: gold, fontSize: 12, fontWeight: FontWeight.w800, letterSpacing: 1.5)),
        const SizedBox(height: 8),
        Text(prayerNames[lang]![nextItem.index], style: const TextStyle(color: Colors.white, fontSize: 34, fontWeight: FontWeight.w800)),
        const SizedBox(height: 7),
        Text(DateFormat('h:mm a').format(nextItem.localTime), style: const TextStyle(color: Colors.white, fontSize: 25, fontWeight: FontWeight.w700)),
        const SizedBox(height: 10),
        FittedBox(fit: BoxFit.scaleDown, alignment: Alignment.centerLeft, child: Text('${tr(lang, 'remaining')}  $countdown', style: const TextStyle(color: Colors.white70, fontSize: 14))),
      ])),
      const SizedBox(height: 26),
      Row(children: [
        Expanded(child: Text(tr(lang, 'today'), maxLines: 2, style: TextStyle(fontSize: 19, fontWeight: FontWeight.w800, color: foreground))),
        Text('MWL · ${widget.hanafi ? 'Hanafi' : 'Shafi'}', style: TextStyle(color: dark ? gold : emerald, fontSize: 12, fontWeight: FontWeight.w700)),
      ]),
      const SizedBox(height: 13),
      ...entries.map((p) => Container(
        margin: const EdgeInsets.only(bottom: 10), padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
        decoration: BoxDecoration(color: theme.colorScheme.surface, borderRadius: BorderRadius.circular(20), border: Border.all(color: theme.dividerColor.withValues(alpha: .25))),
        child: Row(children: [
          Container(width: 44, height: 44, decoration: BoxDecoration(color: dark ? deepGreen : const Color(0xFFEAF4EF), borderRadius: BorderRadius.circular(14)), child: Icon(p.icon, color: dark ? gold : emerald)),
          const SizedBox(width: 13),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(prayerNames[lang]![p.index], style: TextStyle(fontWeight: FontWeight.w800, color: foreground)),
            if (lang != 'en') Text(prayerNames['en']![p.index], style: TextStyle(color: secondary, fontSize: 12)),
          ])),
          FittedBox(fit: BoxFit.scaleDown, child: Text(DateFormat('h:mm a').format(p.localTime), style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16, color: foreground))),
        ]),
      )),
      const SizedBox(height: 8),
      Row(children: [
        Expanded(child: _FeatureButton(icon: Icons.calendar_month, title: tr(lang, 'ramadan'), onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => RamadanPage(city: widget.city, hanafi: widget.hanafi, language: lang))))),
        const SizedBox(width: 8),
        Expanded(child: _FeatureButton(icon: Icons.menu_book, title: tr(lang, 'duaTab'), onTap: () { Navigator.push(context, MaterialPageRoute(builder: (_) => LearningDuaPage(language: lang, onOpenQuranicDuas: () { Navigator.push(context, MaterialPageRoute(builder: (_) => DuaPage(language: lang))); }))); })),
        const SizedBox(width: 8),
        Expanded(child: _FeatureButton(icon: Icons.touch_app_outlined, title: tr(lang, 'tasbih'), onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => DuaPage(language: lang))))),
      ]),
      const SizedBox(height: 16),
      Text(tr(lang, 'about'), style: TextStyle(color: secondary, fontSize: 12)),
      const SizedBox(height: 20),
      AdPlaceholder(language: lang),
    ]);
  }
}

class AdPlaceholder extends StatelessWidget {
  final String language;
  const AdPlaceholder({super.key, required this.language});
  @override Widget build(BuildContext context) => Container(
    height: 60, alignment: Alignment.center,
    decoration: BoxDecoration(color: Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: .5), borderRadius: BorderRadius.circular(15)),
    child: Padding(padding: const EdgeInsets.symmetric(horizontal: 8), child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      const Icon(Icons.campaign_outlined, size: 17), const SizedBox(width: 8),
      Flexible(child: Text(tr(language, 'adSpace'), style: const TextStyle(fontSize: 12), overflow: TextOverflow.ellipsis)),
    ])),
  );
}

class QiblaPage extends StatelessWidget {
  final PrayerCity city;
  final String language;
  const QiblaPage({super.key, required this.city, required this.language});
  double bearing() {
    const rad = math.pi / 180;
    final lat = city.lat * rad;
    final delta = (39.8262 - city.lon) * rad;
    final y = math.sin(delta);
    final x = math.cos(lat) * math.tan(21.4225 * rad) - math.sin(lat) * math.cos(delta);
    return (math.atan2(y, x) / rad + 360) % 360;
  }
  @override Widget build(BuildContext context) {
    final b = bearing();
    final color = Theme.of(context).colorScheme.onSurface;
    return ListView(padding: const EdgeInsets.fromLTRB(24, 32, 24, 28), children: [
      Text(tr(language, 'qibla'), style: TextStyle(fontSize: 30, fontWeight: FontWeight.w900, color: color)),
      const SizedBox(height: 8), Text(localizedCity(city, language), style: const TextStyle(color: muted, fontSize: 16)),
      const IslamicHeroBanner(compact: true),
      const SizedBox(height: 24),
      StreamBuilder<CompassEvent?>(stream: FlutterCompass.events, builder: (context, snapshot) {
        final heading = snapshot.data?.heading;
        if (heading == null) return Column(children: [
          const Icon(Icons.explore_outlined, size: 100, color: emerald),
          const SizedBox(height: 16), Text(tr(language, 'compassUnavailable'), textAlign: TextAlign.center),
        ]);
        return Center(child: AspectRatio(aspectRatio: 1, child: Container(
          decoration: BoxDecoration(shape: BoxShape.circle, gradient: const RadialGradient(colors: [emerald, deepGreen]), border: Border.all(color: gold, width: 6), boxShadow: [BoxShadow(color: gold.withValues(alpha: .25), blurRadius: 15)]),
          child: Stack(alignment: Alignment.center, children: [
            const Positioned(top: 22, child: Text('N', style: TextStyle(fontWeight: FontWeight.w900, color: muted))),
            Transform.rotate(angle: (b - heading) * math.pi / 180, child: const Icon(Icons.navigation, size: 150, color: gold)),
            Container(width: 13, height: 13, decoration: const BoxDecoration(color: gold, shape: BoxShape.circle)),
          ]),
        )));
      }),
      const SizedBox(height: 25),
      Center(child: Text('${b.toStringAsFixed(0)}° ${tx(language, 'northBearing')}', textAlign: TextAlign.center, style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: color))),
      const SizedBox(height: 12), Text(tr(language, 'compassHelp'), textAlign: TextAlign.center, style: const TextStyle(color: muted, height: 1.5)),
      const SizedBox(height: 35), AdPlaceholder(language: language),
    ]);
  }
}

class CalendarPage extends StatefulWidget {
  final PrayerCity city;
  final bool hanafi;
  final String language;
  const CalendarPage({super.key, required this.city, required this.hanafi, required this.language});
  @override State<CalendarPage> createState() => _CalendarPageState();
}
class _CalendarPageState extends State<CalendarPage> {
  int offset = 0;
  @override Widget build(BuildContext context) {
    final today = cityNow(widget.city);
    final h = adjustedHijri(today);
    final monthIndex = (h.year - 1) * 12 + (h.month - 1) + offset;
    final shownYear = monthIndex ~/ 12 + 1;
    final shownMonth = monthIndex % 12 + 1;
    // Julian day 0 is Monday; calendar headings start on Sunday.
    final monthStart = (islamicStart(shownYear, shownMonth) + 1) % 7;
    final monthLength = islamicStart(shownYear + (shownMonth == 12 ? 1 : 0),
      shownMonth == 12 ? 1 : shownMonth + 1) - islamicStart(shownYear, shownMonth);
    final prayers = prayersFor(widget.city, widget.hanafi, today);
    return ListView(padding: const EdgeInsets.fromLTRB(18, 14, 18, 30), children: [
      const IslamicHeroBanner(),
      const SizedBox(height: 18),
      Text(tr(widget.language, 'hijri'), style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w900)),
      const SizedBox(height: 12),
      Row(children: [IconButton(onPressed: () => setState(() => offset--), icon: const Icon(Icons.chevron_left)),
        Expanded(child: Text('${hijriMonths[widget.language]![shownMonth - 1]} $shownYear AH', textAlign: TextAlign.center, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 17))),
        IconButton(onPressed: () => setState(() => offset++), icon: const Icon(Icons.chevron_right))]),
      const SizedBox(height: 10),
      Row(children: calendarWeekdays(widget.language).map((d) => Expanded(child: Center(child: Text(d, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12))))).toList()),
      const SizedBox(height: 8),
      GridView.builder(shrinkWrap: true, physics: const NeverScrollableScrollPhysics(), itemCount: monthStart + monthLength,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 7, childAspectRatio: 1.05, mainAxisSpacing: 5, crossAxisSpacing: 5),
        itemBuilder: (context, index) { final day = index - monthStart + 1; if (day < 1) return const SizedBox();
          final active = offset == 0 && day == h.day;
          return Container(alignment: Alignment.center, decoration: BoxDecoration(color: active ? emerald : Theme.of(context).colorScheme.surface, borderRadius: BorderRadius.circular(10), border: Border.all(color: gold.withValues(alpha: .35))), child: Text('$day', style: TextStyle(color: active ? Colors.white : null, fontWeight: FontWeight.w700)));
        }),
      const SizedBox(height: 18),
      _GoldCard(child: Column(children: [Text('${h.day} ${hijriMonths[widget.language]![h.month - 1]} ${h.year} AH', style: const TextStyle(fontSize: 19, fontWeight: FontWeight.w900)), Text(localizedDate(today, widget.language))])),
      const SizedBox(height: 12),
      Row(children: [Expanded(child: _GoldCard(child: Column(children: [const Icon(Icons.nightlight_round, color: emerald, size: 35), Text(tr(widget.language,'sehri')), Text(DateFormat('h:mm a').format(prayers[0].localTime), style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 18))]))), const SizedBox(width: 10), Expanded(child: _GoldCard(child: Column(children: [const Icon(Icons.wb_twilight, color: emerald, size: 35), Text(tr(widget.language,'iftar')), Text(DateFormat('h:mm a').format(prayers[3].localTime), style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 18))])))]),
      const SizedBox(height: 16),
      _GoldCard(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(tr(widget.language, 'hijriAdjust'), style: const TextStyle(fontWeight: FontWeight.w800)),
        Text(tr(widget.language, 'hijriHint'), style: const TextStyle(fontSize: 12, color: muted)),
        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          IconButton(onPressed: hijriAdjustment > -2 ? () async {
            setState(() => hijriAdjustment--);
            (await SharedPreferences.getInstance()).setInt('hijri_adjustment', hijriAdjustment);
          } : null, icon: const Icon(Icons.remove_circle_outline)),
          Text('${hijriAdjustment > 0 ? '+' : ''}$hijriAdjustment', style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 20)),
          IconButton(onPressed: hijriAdjustment < 2 ? () async {
            setState(() => hijriAdjustment++);
            (await SharedPreferences.getInstance()).setInt('hijri_adjustment', hijriAdjustment);
          } : null, icon: const Icon(Icons.add_circle_outline)),
          TextButton(onPressed: () async {
            setState(() => hijriAdjustment = 0);
            (await SharedPreferences.getInstance()).setInt('hijri_adjustment', 0);
          }, child: Text(tr(widget.language, 'reset'))),
        ]),
      ])),
      const SizedBox(height: 12), Text(tr(widget.language, 'notice'), style: const TextStyle(fontSize: 12, color: muted)),
    ]);
  }
}

class SettingsPage extends StatelessWidget {
  final PrayerCity city;
  final bool hanafi;
  final String language;
  final bool dark;
  final bool sound;
  final ValueChanged<bool> onSoundChanged;
  final ValueChanged<bool> onMadhabChanged;
  final ValueChanged<String> onLanguageChanged;
  final ValueChanged<bool> onDarkChanged;
  const SettingsPage({super.key, required this.city, required this.hanafi, required this.language, required this.dark, required this.sound, required this.onSoundChanged, required this.onMadhabChanged, required this.onLanguageChanged, required this.onDarkChanged});
  @override Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.onSurface;
    return ListView(padding: const EdgeInsets.fromLTRB(22, 32, 22, 32), children: [
      Text(tr(language, 'settings'), style: TextStyle(fontSize: 30, fontWeight: FontWeight.w900, color: color)),
      const SizedBox(height: 28),
      Text(tr(language, 'language'), style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w800)),
      DropdownButton<String>(value: language, isExpanded: true, items: const [
        DropdownMenuItem(value: 'en', child: Text('English')),
        DropdownMenuItem(value: 'bn', child: Text('বাংলা')),
        DropdownMenuItem(value: 'ko', child: Text('한국어')),
        DropdownMenuItem(value: 'ar', child: Text('العربية')),
        DropdownMenuItem(value: 'ur', child: Text('اردو')),
        DropdownMenuItem(value: 'uz', child: Text('O‘zbekcha')),
        DropdownMenuItem(value: 'id', child: Text('Bahasa Indonesia')),
        DropdownMenuItem(value: 'hi', child: Text('हिन्दी')),
      ], onChanged: (value) { if (value != null) onLanguageChanged(value); }),
      const SizedBox(height: 20),
      SwitchListTile(contentPadding: EdgeInsets.zero, title: Text(tr(language, 'appearance'), style: const TextStyle(fontWeight: FontWeight.w800)),
        subtitle: Text(dark ? tr(language, 'dark') : tr(language, 'light')), value: dark, onChanged: onDarkChanged),
      const SizedBox(height: 24),
      Text(tr(language, 'asr'), style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w800)),
      const SizedBox(height: 12),
      SegmentedButton<bool>(segments: const [ButtonSegment(value: false, label: Text('Shafi')), ButtonSegment(value: true, label: Text('Hanafi'))],
        selected: {hanafi}, onSelectionChanged: (value) => onMadhabChanged(value.first)),
      const SizedBox(height: 25),
      Text('${tr(language, 'calculation')}: ${tr(language, 'method')}', style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
      const SizedBox(height: 22),
      SwitchListTile(contentPadding: EdgeInsets.zero, title: Text(tr(language, 'sound'), style: const TextStyle(fontWeight: FontWeight.w800)),
        subtitle: Text(tr(language, 'soundHint')), value: sound, onChanged: onSoundChanged),
      ListTile(leading: const Icon(Icons.notifications_active, color: emerald), title: Text(tr(language, 'prayerAlerts')), subtitle: Text(tr(language, 'manageAlerts')), trailing: const Icon(Icons.chevron_right), onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => NotificationPage(city: city, hanafi: hanafi, language: language)))),
      const SizedBox(height: 24),
      FilledButton.icon(style: FilledButton.styleFrom(backgroundColor: emerald, foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: 17)),
        onPressed: () async {
          try {
            final prefs = await SharedPreferences.getInstance();
            final selected = List.generate(5, (i) => prefs.getBool('prayer_$i') ?? true);
            await schedulePrayerAlerts(city, hanafi, sound: sound, enabled: selected);
            if (context.mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(tr(language, 'notificationSuccess'))));
          } catch (error) {
            if (context.mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${uix(language, 'alertError')}: $error')));
          }
        }, icon: const Icon(Icons.notifications_active_outlined), label: Text(tr(language, 'alerts'))),
      if (defaultTargetPlatform == TargetPlatform.android)
        OutlinedButton.icon(
          onPressed: () async {
            try {
              await nativeAdhanChannel.invokeMethod<void>('openExactSettings');
            } catch (error) {
              if (context.mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$error')));
            }
          },
          icon: const Icon(Icons.alarm),
          label: Text(atx(language, 'preciseAdhan')),
        ),
      const SizedBox(height: 15), Text(tr(language, 'refreshHint'), style: const TextStyle(fontSize: 12, color: muted)),
      const SizedBox(height: 28), Center(child: Text('MPT · MUSLIM PRAYER TIMES · v$versionLabel', style: const TextStyle(color: muted, fontSize: 12))),
    ]);
  }
}


class _GoldCard extends StatelessWidget {
  final Widget child;
  const _GoldCard({required this.child});
  @override Widget build(BuildContext context) => Container(width: double.infinity, padding: const EdgeInsets.all(15), decoration: BoxDecoration(color: Theme.of(context).colorScheme.surface, borderRadius: BorderRadius.circular(17), border: Border.all(color: gold.withValues(alpha: .65)), boxShadow: [BoxShadow(color: gold.withValues(alpha: .12), blurRadius: 8)]), child: child);
}
class IslamicHeroBanner extends StatelessWidget {
  final bool compact;
  const IslamicHeroBanner({super.key, this.compact = false});
  @override Widget build(BuildContext context) => Container(height: compact ? 120 : 145, decoration: BoxDecoration(gradient: const LinearGradient(colors: [deepGreen, emerald, deepGreen]), borderRadius: BorderRadius.circular(22), border: Border.all(color: gold, width: 2)), child: Stack(children: [
    const Positioned(top: 12, left: 18, child: Icon(Icons.auto_awesome, color: gold, size: 25)),
    const Positioned(top: 12, right: 18, child: Icon(Icons.auto_awesome, color: gold, size: 25)),
    Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(Icons.mosque, color: gold, size: compact ? 45 : 62), const SizedBox(height: 5), Text('MUSLIM PRAYER TIMES', maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(color: Colors.white, fontSize: compact ? 15 : 18, fontWeight: FontWeight.w900)), const Text('MPT  •  Prayer wherever you are', maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(color: gold, fontSize: 11))])),
  ]));
}
class _FeatureButton extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;
  const _FeatureButton({required this.icon, required this.title, required this.onTap});
  @override Widget build(BuildContext context) => InkWell(onTap: onTap, borderRadius: BorderRadius.circular(14), child: _GoldCard(child: Column(children: [Icon(icon, color: emerald, size: 27), const SizedBox(height: 5), Text(title, textAlign: TextAlign.center, maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 12))])));
}
class RamadanPage extends StatelessWidget {
  final PrayerCity city;
  final bool hanafi;
  final String language;
  const RamadanPage({super.key, required this.city, required this.hanafi, required this.language});
  @override Widget build(BuildContext context) {
    final today = cityNow(city);
    final h = adjustedHijri(today);
    final p = prayersFor(city, hanafi, today);
    var days = 0;
    var cursor = today;
    while (days < 360 && adjustedHijri(cursor).month != 9) { days++; cursor = cursor.add(const Duration(days: 1)); }
    return Scaffold(appBar: AppBar(title: Text(tr(language, 'ramadan'))), body: ListView(padding: const EdgeInsets.all(18), children: [
      const IslamicHeroBanner(), const SizedBox(height: 20),
      Center(child: Text('Ramadan ${h.month <= 9 ? h.year : h.year + 1} AH', style: const TextStyle(fontSize: 29, fontWeight: FontWeight.w900, color: emerald))),
      const SizedBox(height: 14), _GoldCard(child: Column(children: [Text(h.month == 9 ? tr(language, 'ramadanHere') : tr(language, 'ramadanStarts'), style: const TextStyle(fontSize: 16)), Text(h.month == 9 ? '${h.day} ${tr(language, 'days')}' : '$days ${tr(language, 'days')}', style: const TextStyle(fontSize: 27, fontWeight: FontWeight.w900, color: emerald))])),
      const SizedBox(height: 12), Row(children: [Expanded(child: _GoldCard(child: Column(children: [const Icon(Icons.nightlight_round, color: emerald), Text(tr(language,'sehri')), Text(DateFormat('h:mm a').format(p[0].localTime), style: const TextStyle(fontWeight: FontWeight.w900))]))), const SizedBox(width: 8), Expanded(child: _GoldCard(child: Column(children: [const Icon(Icons.wb_twilight, color: emerald), Text(tr(language,'iftar')), Text(DateFormat('h:mm a').format(p[3].localTime), style: const TextStyle(fontWeight: FontWeight.w900))])))]),
      const SizedBox(height: 15), Text(tr(language, 'ramadanNotice'), style: TextStyle(color: muted)),
    ]));
  }
}
class DuaPage extends StatefulWidget {
  final String language;
  const DuaPage({super.key, required this.language});
  @override State<DuaPage> createState() => _DuaPageState();
}
class _DuaPageState extends State<DuaPage> {
  int count = 0;
  int selected = 0;
  static const duas = [
    ['رَبَّنَا آتِنَا فِي الدُّنْيَا حَسَنَةً وَفِي الْآخِرَةِ حَسَنَةً وَقِنَا عَذَابَ النَّارِ', 'Our Lord, grant us good in this world and good in the Hereafter, and protect us from the Fire. (Quran 2:201)'],
    ['رَبِّ زِدْنِي عِلْمًا', 'My Lord, increase me in knowledge. (Quran 20:114)'],
    ['رَبَّنَا ظَلَمْنَا أَنْفُسَنَا وَإِنْ لَمْ تَغْفِرْ لَنَا وَتَرْحَمْنَا لَنَكُونَنَّ مِنَ الْخَاسِرِينَ', 'Our Lord, we have wronged ourselves. If You do not forgive us and have mercy on us, we will be among the losers. (Quran 7:23)'],
    ['رَبِّ اشْرَحْ لِي صَدْرِي', 'My Lord, expand my chest for me. (Quran 20:25)'],
    ['وَيَسِّرْ لِي أَمْرِي', 'And make my task easy for me. (Quran 20:26)'],
    ['رَبِّ هَبْ لِي مِنَ الصَّالِحِينَ', 'My Lord, grant me righteous offspring. (Quran 37:100)'],
    ['رَبَّنَا تَقَبَّلْ مِنَّا إِنَّكَ أَنْتَ السَّمِيعُ الْعَلِيمُ', 'Our Lord, accept this from us. You are the All-Hearing, All-Knowing. (Quran 2:127)'],
    ['رَبَّنَا اغْفِرْ لِي وَلِوَالِدَيَّ وَلِلْمُؤْمِنِينَ يَوْمَ يَقُومُ الْحِسَابُ', 'Our Lord, forgive me, my parents and the believers on the Day of Reckoning. (Quran 14:41)'],
    ['رَبَّنَا لَا تُزِغْ قُلُوبَنَا بَعْدَ إِذْ هَدَيْتَنَا وَهَبْ لَنَا مِنْ لَدُنْكَ رَحْمَةً إِنَّكَ أَنْتَ الْوَهَّابُ', 'Our Lord, do not let our hearts deviate after You have guided us; grant us mercy from Yourself. You are the Bestower. (Quran 3:8)'],
    ['رَبِّ لَا تَذَرْنِي فَرْدًا وَأَنْتَ خَيْرُ الْوَارِثِينَ', 'My Lord, do not leave me childless; You are the best of inheritors. (Quran 21:89)'],
    ['رَبِّ أَعُوذُ بِكَ مِنْ هَمَزَاتِ الشَّيَاطِينِ', 'My Lord, I seek refuge in You from the temptations of the devils. (Quran 23:97)'],
    ['رَبِّ أَنْزِلْنِي مُنْزَلًا مُبَارَكًا وَأَنْتَ خَيْرُ الْمُنْزِلِينَ', 'My Lord, grant me a blessed landing, for You are the best of those who grant lodging. (Quran 23:29)'],
    ['رَبَّنَا أَفْرِغْ عَلَيْنَا صَبْرًا وَتَوَفَّنَا مُسْلِمِينَ', 'Our Lord, pour patience upon us and let us die as Muslims. (Quran 7:126)'],
  ];
  // Phonetic reading guides; Arabic is already displayed above.
  static const duaPronunciations = <String, List<String>>{
    'en': [
      'Rabbana atina fid-dunya hasanatan wa fil-akhirati hasanatan wa qina adhaban-nar.',
      'Rabbi zidni ilma.',
      'Rabbana zalamna anfusana wa illam taghfir lana wa tarhamna lanakunanna minal-khasirin.',
      'Rabbi ishrah li sadri.',
      'Wa yassir li amri.',
      'Rabbi hab li minas-salihin.',
      'Rabbana taqabbal minna innaka antas-samiul-alim.',
      'Rabbanaghfir li wa liwalidayya wa lil-mu’minina yawma yaqumul-hisab.',
      'Rabbana la tuzigh qulubana ba’da idh hadaytana wa hab lana mil-ladunka rahmatan innaka antal-wahhab.',
      'Rabbi la tadharni fardan wa anta khayrul-warithin.',
      'Rabbi audhu bika min hamazatish-shayatin.',
      'Rabbi anzilni munzalan mubarakan wa anta khayrul-munzilin.',
      'Rabbana afrigh alayna sabran wa tawaffana muslimin.',
    ],
    'bn': [
      'রাব্বানা আতিনা ফিদ্দুনিয়া হাসানাতান ওয়া ফিল আখিরাতি হাসানাতান ওয়া ক্বিনা আযাবান্নার।',
      'রাব্বি যিদনী ইলমা।',
      'রাব্বানা যলামনা আনফুসানা ওয়া ইল্লাম তাগফির লানা ওয়া তারহামনা লানাকূনান্না মিনাল খাসিরীন।',
      'রাব্বিশরাহ লী সদরী।',
      'ওয়া ইয়াসসির লী আমরী।',
      'রাব্বি হাব লী মিনাস সালিহীন।',
      'রাব্বানা তাকাব্বাল মিন্না ইন্নাকা আনতাস সামীউল আলীম।',
      'রাব্বানাগফির লী ওয়া লিওয়ালিদাইয়্যা ওয়া লিল মুমিনীনা ইয়াওমা ইয়াকূমুল হিসাব।',
      'রাব্বানা লা তুযিগ কুলূবানা বা’দা ইয হাদাইতানা ওয়া হাব লানা মিল্লাদুনকা রাহমাহ, ইন্নাকা আনতাল ওয়াহহাব।',
      'রাব্বি লা তাযারনী ফারদাওঁ ওয়া আনতা খাইরুল ওয়ারিসীন।',
      'রাব্বি আউযু বিকা মিন হামাযাতিশ শায়াতীন।',
      'রাব্বি আনযিলনী মুনযালাম মুবারাকাওঁ ওয়া আনতা খাইরুল মুনযিলীন।',
      'রাব্বানা আফরিগ আলাইনা সাবরাওঁ ওয়া তাওয়াফফানা মুসলিমীন।',
    ],
    'ko': [
      '랍바나 아티나 핏둔야 하사나탄 와 필 아키라티 하사나탄 와 키나 아자반나르.',
      '랍비 지드니 일마.',
      '랍바나 잘람나 안푸사나 와 일람 타그피르 라나 와 타르함나 라나쿠난나 미날 카시린.',
      '랍비 이슈라흐 리 사드리.',
      '와 얏시르 리 암리.',
      '랍비 합 리 미낫살리힌.',
      '랍바나 타깝발 민나 인나카 안탓사미울 알림.',
      '랍바나그피르 리 와 리왈리다이야 와 릴무미니나 야우마 야꾸물 히삽.',
      '랍바나 라 투지그 꿀루바나 바다 이즈 하다이타나 와 합 라나 민 라둔카 라흐마, 인나카 안탈 와합.',
      '랍비 라 타자르니 파르단 와 안타 카이룰 와리신.',
      '랍비 아우주 비카 민 하마자티쉬 샤야틴.',
      '랍비 안질니 문잘란 무바라칸 와 안타 카이룰 문질린.',
      '랍바나 아프리그 알라이나 사브란 와 타와파나 무슬리민.',
    ],
  };
  String? duaPronunciation() => widget.language == 'ar' ? null : (mptExtraQuranicDuaPronunciations[widget.language] ?? duaPronunciations[widget.language] ?? duaPronunciations['en'])?[selected];
  static const duaMeanings = <String, List<String>>{
    'bn': [
      'হে আমাদের রব! আমাদের দুনিয়ায় কল্যাণ দিন, আখিরাতেও কল্যাণ দিন এবং আগুনের শাস্তি থেকে রক্ষা করুন। (কুরআন ২:২০১)',
      'হে আমার রব! আমার জ্ঞান বৃদ্ধি করে দিন। (কুরআন ২০:১১৪)',
      'হে আমাদের রব! আমরা নিজেদের প্রতি জুলুম করেছি। আপনি ক্ষমা ও দয়া না করলে আমরা ক্ষতিগ্রস্তদের অন্তর্ভুক্ত হব। (কুরআন ৭:২৩)',
      'হে আমার রব, আমার বক্ষ প্রশস্ত করে দিন। (কুরআন 20:25)',
      'আর আমার কাজ সহজ করে দিন। (কুরআন 20:26)',
      'হে আমার রব, আমাকে সৎ সন্তান দান করুন। (কুরআন 37:100)',
      'হে আমাদের রব, আমাদের পক্ষ থেকে কবুল করুন; আপনি সর্বশ্রোতা, সর্বজ্ঞ। (কুরআন 2:127)',
      'হে আমাদের রব, হিসাবের দিনে আমাকে, আমার পিতা-মাতাকে ও মুমিনদের ক্ষমা করুন। (কুরআন 14:41)',
      'হে আমাদের রব, হেদায়াত দেওয়ার পর আমাদের অন্তরকে বিচ্যুত করবেন না; আপনার পক্ষ থেকে রহমত দিন। (কুরআন 3:8)',
      'হে আমার রব, আমাকে সন্তানহীন রেখে দেবেন না; আপনিই সর্বোত্তম উত্তরাধিকারী। (কুরআন ২১:৮৯)',
      'হে আমার রব, শয়তানদের কুমন্ত্রণা থেকে আপনার আশ্রয় চাই। (কুরআন 23:97)',
      'হে আমার রব, আমাকে বরকতময় স্থানে অবতরণ করান; আপনিই সর্বোত্তম অবতরণকারী। (কুরআন 23:29)',
      'হে আমাদের রব, আমাদের ওপর ধৈর্য ঢেলে দিন এবং মুসলিম হিসেবে মৃত্যু দিন। (কুরআন 7:126)',
    ],
    'ko': [
      '주님, 현세와 내세에서 저희에게 선을 베푸시고 불의 형벌에서 보호해 주소서. (꾸란 2:201)',
      '주님, 저의 지식을 더하여 주소서. (꾸란 20:114)',
      '주님, 저희는 스스로에게 잘못을 저질렀습니다. 용서와 자비를 베풀지 않으시면 저희는 손실을 입을 것입니다. (꾸란 7:23)',
      '주님, 제 가슴을 넓혀 주소서. (꾸란 20:25)',
      '제 일을 쉽게 해 주소서. (꾸란 20:26)',
      '주님, 제게 의로운 자손을 허락해 주소서. (꾸란 37:100)',
      '주님, 저희에게서 받아 주소서. 주님은 모든 것을 들으시고 아십니다. (꾸란 2:127)',
      '주님, 심판의 날에 저와 부모님과 믿는 이들을 용서해 주소서. (꾸란 14:41)',
      '주님, 저희를 인도하신 뒤 마음이 빗나가지 않게 하시고 자비를 베풀어 주소서. (꾸란 3:8)',
      '주님, 저를 자녀 없이 홀로 남겨 두지 마소서. 주님은 가장 훌륭한 상속자이십니다. (꾸란 21:89)',
      '주님, 악마들의 유혹으로부터 주님께 보호를 구합니다. (꾸란 23:97)',
      '주님, 저를 복된 곳에 머물게 하소서. 주님은 가장 훌륭하게 머물 곳을 마련해 주시는 분이십니다. (꾸란 23:29)',
      '주님, 저희에게 인내를 내려 주시고 무슬림으로 죽게 하소서. (꾸란 7:126)',
    ],
    'ar': [
      'ربنا آتنا خير الدنيا والآخرة وقنا عذاب النار. (البقرة ٢:٢٠١)',
      'رب زدني علماً. (طه ٢٠:١١٤)',
      'ربنا ظلمنا أنفسنا، وإن لم تغفر لنا وترحمنا لنكونن من الخاسرين. (الأعراف ٧:٢٣)',
      'يا رب، وسّع صدري ويسّر لي تحمّل المهمة. (طه ٢٠:٢٥)',
      'يا رب، سهّل لي أمري. (طه ٢٠:٢٦)',
      'يا رب، ارزقني ذرية صالحة. (الصافات ٣٧:١٠٠)',
      'ربنا تقبل منا إنك أنت السميع العليم. (القرآن 2:127)',
      'ربنا اغفر لي ولوالدي وللمؤمنين يوم يقوم الحساب. (القرآن 14:41)',
      'ربنا لا تزغ قلوبنا بعد إذ هديتنا وهب لنا من لدنك رحمة إنك أنت الوهاب. (القرآن 3:8)',
      'يا رب، لا تتركني بلا ولد، وأنت خير الوارثين. (الأنبياء ٢١:٨٩)',
      'رب أعوذ بك من همزات الشياطين. (القرآن 23:97)',
      'يا رب، أنزلني في مكان مبارك، وأنت خير من يُنزل عباده. (المؤمنون ٢٣:٢٩)',
      'ربنا أفرغ علينا صبرا وتوفنا مسلمين. (القرآن 7:126)',
    ],
  };
  String duaMeaning() => mptQuranicDuaMeanings[widget.language]?[selected] ?? duaMeanings[widget.language]?[selected] ?? duas[selected][1];
  @override Widget build(BuildContext context) => Scaffold(body: SafeArea(child: ListView(padding: const EdgeInsets.all(18), children: [
    const IslamicHeroBanner(compact: true), const SizedBox(height: 18), Text(tr(widget.language, 'dailyDua'), maxLines: 2, style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900)), const SizedBox(height: 14),
    _GoldCard(child: Column(children: [Text('${uix(widget.language, 'duaNumber')} ${selected + 1}/${duas.length}', style: const TextStyle(color: emerald, fontWeight: FontWeight.w800)), const SizedBox(height: 18), Text(duas[selected][0], textDirection: ui.TextDirection.rtl, textAlign: TextAlign.center, style: const TextStyle(fontSize: 25, height: 1.9)), const SizedBox(height: 16), if (duaPronunciation() != null) ...[Text(duaPronunciation()!, textAlign: TextAlign.center, style: TextStyle(fontSize: 17, height: 1.7, fontWeight: FontWeight.w600, color: Theme.of(context).colorScheme.primary)), const SizedBox(height: 12)], Text(duaMeaning(), textAlign: TextAlign.center), const SizedBox(height: 14), Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [IconButton(onPressed: () => setState(() => selected = (selected + duas.length - 1) % duas.length), icon: const Icon(Icons.chevron_left)), IconButton(onPressed: () => setState(() => selected = (selected + 1) % duas.length), icon: const Icon(Icons.chevron_right))])])),
    const SizedBox(height: 20), _GoldCard(child: Column(children: [Text(tr(widget.language, 'tasbihCounter'), style: TextStyle(fontSize: 21, fontWeight: FontWeight.w900)), const Icon(Icons.grain, color: emerald, size: 46), Text('$count', style: const TextStyle(fontSize: 45, fontWeight: FontWeight.w900, color: emerald)), Row(mainAxisAlignment: MainAxisAlignment.center, children: [IconButton(onPressed: () => setState(() => count = 0), icon: const Icon(Icons.restart_alt)), const SizedBox(width: 22), FilledButton(onPressed: () => setState(() => count++), child: const Icon(Icons.add))])])),
  ])));
}
class NotificationPage extends StatefulWidget {
  final PrayerCity city;
  final bool hanafi;
  final String language;
  const NotificationPage({super.key, required this.city, required this.hanafi, required this.language});
  @override State<NotificationPage> createState() => _NotificationPageState();
}
class _NotificationPageState extends State<NotificationPage> {
  List<bool> enabled = List.filled(5, true);
  bool sound = true;
  final adhanAudio = AdhanAudioService();
  bool adhanReady = false;
  @override void initState() { super.initState(); _load(); _loadAdhan(); }
  Future<void> _loadAdhan() async {
    await adhanAudio.load();
    if (mounted) setState(() => adhanReady = true);
  }
  @override void dispose() {
    adhanAudio.dispose();
    super.dispose();
  }
  Future<void> _load() async { final prefs = await SharedPreferences.getInstance(); if (mounted) setState(() { enabled = List.generate(5, (i) => prefs.getBool('prayer_$i') ?? true); sound = prefs.getBool('sound') ?? true; }); }
  @override Widget build(BuildContext context) => Scaffold(appBar: AppBar(title: Text(tr(widget.language, 'prayerAlerts'))), body: ListView(padding: const EdgeInsets.all(18), children: [
    const IslamicHeroBanner(compact: true), const SizedBox(height: 18),
    ...List.generate(5, (i) => _GoldCard(child: SwitchListTile(contentPadding: EdgeInsets.zero, secondary: Icon([Icons.nightlight_round, Icons.wb_sunny, Icons.sunny, Icons.wb_twilight, Icons.nights_stay][i], color: emerald), title: Text(prayerNames[widget.language]![i]), value: enabled[i], onChanged: (v) async { setState(() => enabled[i] = v); (await SharedPreferences.getInstance()).setBool('prayer_$i', v); }))),
    if (adhanReady) ...[
      const SizedBox(height: 16),
      _GoldCard(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(atx(widget.language, 'adhanSettings'), style: TextStyle(fontSize: 19, fontWeight: FontWeight.w800)),
        const SizedBox(height: 10),
        RadioListTile<AdhanLength>(
          title: Text(atx(widget.language, 'fullAdhan')),
          value: AdhanLength.full,
          groupValue: adhanAudio.length,
          onChanged: (v) async { if (v == null) return; await adhanAudio.setLength(v); if (mounted) setState(() {}); },
        ),
        RadioListTile<AdhanLength>(
          title: Text(atx(widget.language, 'shortAdhan')),
          value: AdhanLength.short,
          groupValue: adhanAudio.length,
          onChanged: (v) async { if (v == null) return; await adhanAudio.setLength(v); if (mounted) setState(() {}); },
        ),
        SwitchListTile(
          title: Text(atx(widget.language, 'specialFajr')),
          subtitle: Text(atx(widget.language, 'specialFajrHint')),
          value: adhanAudio.specialFajr,
          onChanged: (v) async { await adhanAudio.setSpecialFajr(v); if (mounted) setState(() {}); },
        ),
        Wrap(spacing: 8, runSpacing: 8, children: [
          OutlinedButton.icon(
            onPressed: () async { try { await adhanAudio.preview(fajr: false); } catch (e) { if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${atx(widget.language, 'audioError')}: $e'))); } },
            icon: const Icon(Icons.play_arrow), label: Text(atx(widget.language, 'previewAdhan')),
          ),
          OutlinedButton.icon(
            onPressed: () async { try { await adhanAudio.preview(fajr: true); } catch (e) { if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${atx(widget.language, 'audioError')}: $e'))); } },
            icon: const Icon(Icons.play_arrow), label: Text(atx(widget.language, 'previewFajr')),
          ),
          OutlinedButton.icon(
            onPressed: () async { await adhanAudio.stop(); },
            icon: const Icon(Icons.stop), label: Text(atx(widget.language, 'stopAdhan')),
          ),
        ]),
        const SizedBox(height: 8),
        Text(atx(widget.language, 'adhanHelp'), style: TextStyle(fontSize: 12, color: muted)),
      ])),
    ],
    const SizedBox(height: 12), _GoldCard(child: SwitchListTile(title: Text(tr(widget.language, 'sound')), value: sound, onChanged: (v) async { setState(() => sound = v); (await SharedPreferences.getInstance()).setBool('sound', v); })),
    const SizedBox(height: 14), FilledButton.icon(onPressed: () async { try { await schedulePrayerAlerts(widget.city, widget.hanafi, sound: sound, enabled: enabled); if (context.mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(uix(widget.language, 'adhanSuccess')))); } catch(e) { if (context.mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$e'))); } }, icon: const Icon(Icons.notifications_active), label: Text(tr(widget.language, 'saveAlerts'))),
    const SizedBox(height: 10),
    OutlinedButton.icon(onPressed: () async {
      try {
        await scheduleTestNotification(language: widget.language);
        if (context.mounted) ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(tr(widget.language, 'testSuccess'))));
      } catch (e) {
        if (context.mounted) ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('$e')));
      }
    }, icon: const Icon(Icons.notification_add_outlined), label: Text(tr(widget.language, 'testAlert'))),
    const SizedBox(height: 12), Text(tr(widget.language, 'notifyHint'), style: const TextStyle(fontSize: 12, color: muted)),
  ]));
}
