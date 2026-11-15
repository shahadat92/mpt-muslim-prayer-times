import 'dart:async';
import 'dart:ui' as ui;
import 'dart:math' as math;
import 'adhan_audio.dart';

import 'package:adhan/adhan.dart';
import 'package:flutter/material.dart';
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
const versionLabel = '1.3.2';
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
};
String tr(String lang, String key) => translations[lang]?[key] ?? translations['en']?[key] ?? key;

// Extra strings introduced in v1.3.1, without disturbing existing translations.
const extraTranslations = <String, Map<String, String>>{
  'en': {'northBearing':'from North','testTitle':'MPT · Test notification','testBody':'Prayer notification test successful.'},
  'bn': {'northBearing':'উত্তর দিক থেকে','testTitle':'MPT · পরীক্ষামূলক নোটিফিকেশন','testBody':'নামাজের নোটিফিকেশন পরীক্ষা সফল হয়েছে।'},
  'ko': {'northBearing':'북쪽 기준','testTitle':'MPT · 테스트 알림','testBody':'기도 알림 테스트가 완료되었습니다.'},
  'ar': {'northBearing':'من الشمال','testTitle':'MPT · إشعار تجريبي','testBody':'نجح اختبار إشعار الصلاة.'},
};
String tx(String lang, String key) => extraTranslations[lang]?[key] ?? extraTranslations['en']?[key] ?? key;

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
};
const hijriMonths = <String, List<String>>{
  'en':['Muharram','Safar','Rabi al-Awwal','Rabi al-Thani','Jumada al-Ula','Jumada al-Akhirah','Rajab','Sha’ban','Ramadan','Shawwal','Dhu al-Qadah','Dhu al-Hijjah'],
  'bn':['মুহাররম','সফর','রবিউল আউয়াল','রবিউস সানি','জমাদিউল আউয়াল','জমাদিউস সানি','রজব','শাবান','রমজান','শাওয়াল','জিলকদ','জিলহজ'],
  'ko':['무하람','사파르','라비 알아우왈','라비 알타니','주마다 알아울라','주마다 알아키라','라자브','샤반','라마단','샤왈','둘카다','둘히자'],
  'ar':['محرم','صفر','ربيع الأول','ربيع الآخر','جمادى الأولى','جمادى الآخرة','رجب','شعبان','رمضان','شوال','ذو القعدة','ذو الحجة'],
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
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Using GPS coordinates and device timezone.')));
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
      CalendarPage(city: city, hanafi: hanafi, language: lang),
      DuaPage(language: lang),
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
        selectedIndex: tab,
        onDestinationSelected: (value) => setState(() => tab = value),
        destinations: [
          NavigationDestination(icon: const Icon(Icons.home_outlined), selectedIcon: const Icon(Icons.home), label: tr(lang, 'home')),
          NavigationDestination(icon: const Icon(Icons.explore_outlined), selectedIcon: const Icon(Icons.explore), label: tr(lang, 'qibla')),
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
          Text('MUSLIM PRAYER TIMES', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: foreground)),
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
        Text('${tr(lang, 'remaining')}  $countdown', style: const TextStyle(color: Colors.white70, fontSize: 14)),
      ])),
      const SizedBox(height: 26),
      Row(children: [
        Expanded(child: Text(tr(lang, 'today'), style: TextStyle(fontSize: 21, fontWeight: FontWeight.w800, color: foreground))),
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
          Text(DateFormat('h:mm a').format(p.localTime), style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16, color: foreground)),
        ]),
      )),
      const SizedBox(height: 8),
      Row(children: [
        Expanded(child: _FeatureButton(icon: Icons.calendar_month, title: tr(lang, 'ramadan'), onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => RamadanPage(city: widget.city, hanafi: widget.hanafi, language: lang))))),
        const SizedBox(width: 8),
        Expanded(child: _FeatureButton(icon: Icons.menu_book, title: tr(lang, 'duaTab'), onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => DuaPage(language: lang))))),
        const SizedBox(width: 8),
        Expanded(child: _FeatureButton(icon: Icons.touch_app_outlined, title: tr(lang, 'tasbih'), onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => DuaPage(language: lang))))),
      ]),
      const SizedBox(height: 16),
      Text(tr(lang, 'about'), style: TextStyle(color: secondary, fontSize: 12)),
      const SizedBox(height: 20),
      const AdPlaceholder(),
    ]);
  }
}

class AdPlaceholder extends StatelessWidget {
  const AdPlaceholder({super.key});
  @override Widget build(BuildContext context) => Container(
    height: 60, alignment: Alignment.center,
    decoration: BoxDecoration(color: Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: .5), borderRadius: BorderRadius.circular(15)),
    child: const Padding(padding: EdgeInsets.symmetric(horizontal: 8), child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      Icon(Icons.campaign_outlined, size: 17), SizedBox(width: 8),
      Flexible(child: Text('Ad space · AdMob not configured', style: TextStyle(fontSize: 12), overflow: TextOverflow.ellipsis)),
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
      Center(child: Text('${b.toStringAsFixed(0)}° ${tx(language, 'northBearing')}', style: TextStyle(fontSize: 25, fontWeight: FontWeight.w800, color: color))),
      const SizedBox(height: 12), Text(tr(language, 'compassHelp'), textAlign: TextAlign.center, style: const TextStyle(color: muted, height: 1.5)),
      const SizedBox(height: 35), const AdPlaceholder(),
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
    final first = DateTime(today.year, today.month, today.day).add(
      Duration(days: islamicStart(shownYear, shownMonth) - julianDay(today) - hijriAdjustment));
    final monthStart = first.weekday % 7;
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
      Row(children: ['Sun','Mon','Tue','Wed','Thu','Fri','Sat'].map((d) => Expanded(child: Center(child: Text(d, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12))))).toList()),
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
            await schedulePrayerAlerts(city, hanafi, sound: sound);
            if (context.mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(tr(language, 'notificationSuccess'))));
          } catch (error) {
            if (context.mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Could not schedule alerts: $error')));
          }
        }, icon: const Icon(Icons.notifications_active_outlined), label: Text(tr(language, 'alerts'))),
      const SizedBox(height: 15), Text(tr(language, 'refreshHint'), style: const TextStyle(fontSize: 12, color: muted)),
      const SizedBox(height: 28), const Center(child: Text('MPT · MUSLIM PRAYER TIMES · v1.3.0', style: TextStyle(color: muted, fontSize: 12))),
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
    Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(Icons.mosque, color: gold, size: compact ? 45 : 62), const SizedBox(height: 5), Text('MUSLIM PRAYER TIMES', style: TextStyle(color: Colors.white, fontSize: compact ? 15 : 18, fontWeight: FontWeight.w900)), const Text('MPT  •  Prayer wherever you are', style: TextStyle(color: gold, fontSize: 11))])),
  ]));
}
class _FeatureButton extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;
  const _FeatureButton({required this.icon, required this.title, required this.onTap});
  @override Widget build(BuildContext context) => InkWell(onTap: onTap, borderRadius: BorderRadius.circular(14), child: _GoldCard(child: Column(children: [Icon(icon, color: emerald, size: 27), const SizedBox(height: 5), Text(title, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 12))])));
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
  ];
  @override Widget build(BuildContext context) => Scaffold(body: SafeArea(child: ListView(padding: const EdgeInsets.all(18), children: [
    const IslamicHeroBanner(compact: true), const SizedBox(height: 18), Text(tr(widget.language, 'dailyDua'), style: TextStyle(fontSize: 26, fontWeight: FontWeight.w900)), const SizedBox(height: 14),
    _GoldCard(child: Column(children: [Text('Dua ${selected + 1}/${duas.length}', style: const TextStyle(color: emerald, fontWeight: FontWeight.w800)), const SizedBox(height: 18), Text(duas[selected][0], textDirection: ui.TextDirection.rtl, textAlign: TextAlign.center, style: const TextStyle(fontSize: 25, height: 1.9)), const SizedBox(height: 16), Text(duas[selected][1], textAlign: TextAlign.center), const SizedBox(height: 14), Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [IconButton(onPressed: () => setState(() => selected = (selected + duas.length - 1) % duas.length), icon: const Icon(Icons.chevron_left)), IconButton(onPressed: () => setState(() => selected = (selected + 1) % duas.length), icon: const Icon(Icons.chevron_right))])])),
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
        const Text('Adhan settings · আজান সেটিংস', style: TextStyle(fontSize: 19, fontWeight: FontWeight.w800)),
        const SizedBox(height: 10),
        RadioListTile<AdhanLength>(
          title: const Text('Full Adhan · পূর্ণ আজান'),
          value: AdhanLength.full,
          groupValue: adhanAudio.length,
          onChanged: (v) async { if (v == null) return; await adhanAudio.setLength(v); if (mounted) setState(() {}); },
        ),
        RadioListTile<AdhanLength>(
          title: const Text('Short Adhan · সংক্ষিপ্ত আজান'),
          value: AdhanLength.short,
          groupValue: adhanAudio.length,
          onChanged: (v) async { if (v == null) return; await adhanAudio.setLength(v); if (mounted) setState(() {}); },
        ),
        SwitchListTile(
          title: const Text('Special Fajr Adhan'),
          subtitle: const Text('ফজরের বিশেষ আজান চালু'),
          value: adhanAudio.specialFajr,
          onChanged: (v) async { await adhanAudio.setSpecialFajr(v); if (mounted) setState(() {}); },
        ),
        Wrap(spacing: 8, runSpacing: 8, children: [
          OutlinedButton.icon(
            onPressed: () async { try { await adhanAudio.preview(fajr: false); } catch (e) { if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Audio error: $e'))); } },
            icon: const Icon(Icons.play_arrow), label: const Text('Preview Adhan'),
          ),
          OutlinedButton.icon(
            onPressed: () async { try { await adhanAudio.preview(fajr: true); } catch (e) { if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Audio error: $e'))); } },
            icon: const Icon(Icons.play_arrow), label: const Text('Preview Fajr'),
          ),
          OutlinedButton.icon(
            onPressed: () async { await adhanAudio.stop(); },
            icon: const Icon(Icons.stop), label: const Text('Stop'),
          ),
        ]),
        const SizedBox(height: 8),
        const Text('Preview works inside the app. Scheduled alerts still use the device notification sound.', style: TextStyle(fontSize: 12, color: muted)),
      ])),
    ],
    const SizedBox(height: 12), _GoldCard(child: SwitchListTile(title: Text(tr(widget.language, 'sound')), value: sound, onChanged: (v) async { setState(() => sound = v); (await SharedPreferences.getInstance()).setBool('sound', v); })),
    const SizedBox(height: 14), FilledButton.icon(onPressed: () async { try { await schedulePrayerAlerts(widget.city, widget.hanafi, sound: sound, enabled: enabled); if (context.mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(tr(widget.language, 'notificationSuccess')))); } catch(e) { if (context.mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$e'))); } }, icon: const Icon(Icons.notifications_active), label: Text(tr(widget.language, 'saveAlerts'))),
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
