from pathlib import Path
p = Path('lib/main.dart')
s = p.read_text(encoding='utf-8')
def replace_once(old, new):
    global s
    count = s.count(old)
    if count != 1:
        raise SystemExit(f'Expected exactly one occurrence, found {count}: {old[:100]!r}')
    s = s.replace(old, new, 1)

replace_once("import 'package:flutter/material.dart';", "import 'package:flutter/material.dart';\nimport 'package:flutter/services.dart';")
replace_once("const versionLabel = '1.3.2';", "const versionLabel = '1.5.3';\nconst mptBuildMarker = 'MPT-153-VERIFIED-SOURCE';")
needle = "String tx(String lang, String key) => extraTranslations[lang]?[key] ?? extraTranslations['en']?[key] ?? key;"
insert = '''
const calendarWeekdayLabels = <String, List<String>>{
  'en': ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'],
  'bn': ['রবি', 'সোম', 'মঙ্গল', 'বুধ', 'বৃহস্পতি', 'শুক্র', 'শনি'],
  'ko': ['일', '월', '화', '수', '목', '금', '토'],
  'ar': ['أحد', 'إثن', 'ثلا', 'أرب', 'خمي', 'جمع', 'سبت'],
};
List<String> calendarWeekdays(String lang) =>
    calendarWeekdayLabels[lang] ?? calendarWeekdayLabels['en']!;
'''
replace_once(needle, needle + '\n' + insert)
replace_once("['Sun','Mon','Tue','Wed','Thu','Fri','Sat'].map((d)", "calendarWeekdays(widget.language).map((d)")
replace_once("const Center(child: Text('MPT · MUSLIM PRAYER TIMES · v1.3.0', style: TextStyle(color: muted, fontSize: 12)))", "Center(child: Text('MPT · MUSLIM PRAYER TIMES · v$versionLabel', style: const TextStyle(color: muted, fontSize: 12)))")

bridge = '''
// Android native alarms play the selected Adhan even when Flutter is not in the foreground.
const MethodChannel nativeAdhanChannel = MethodChannel('mpt/adhan_alarm');
Future<void> scheduleNativeAdhan(PrayerCity city, bool hanafi,
    {List<bool>? enabled}) async {
  if (defaultTargetPlatform != TargetPlatform.android) return;
  final prefs = await SharedPreferences.getInstance();
  final length = prefs.getString('adhan_length') == 'short' ? 'short' : 'full';
  final specialFajr = prefs.getBool('special_fajr') ?? true;
  await nativeAdhanChannel.invokeMethod<void>('cancelAll');
  final today = cityNow(city);
  final now = DateTime.now();
  var id = 10000;
  for (var day = 0; day < 10; day++) {
    final date = DateTime(today.year, today.month, today.day)
        .add(Duration(days: day));
    for (final prayer in prayersFor(city, hanafi, date)) {
      if (enabled != null && !enabled[prayer.index]) continue;
      final instant = localToInstant(prayer.localTime, city);
      if (!instant.isAfter(now)) continue;
      if (id >= 10050) return;
      final prefix = prayer.index == 0 && specialFajr ? 'fajr' : 'regular';
      await nativeAdhanChannel.invokeMethod<bool>('schedule', <String, Object>{
        'id': id++,
        'at': instant.millisecondsSinceEpoch,
        'audio': '${prefix}_$length',
      });
    }
  }
}
'''
replace_once('Future<void> schedulePrayerAlerts(PrayerCity city, bool hanafi, {bool sound = true, List<bool>? enabled}) async {', bridge + '\nFuture<void> schedulePrayerAlerts(PrayerCity city, bool hanafi, {bool sound = true, List<bool>? enabled}) async {')
replace_once('  await notifications.cancelAll();\n  final details = NotificationDetails(', '  await notifications.cancelAll();\n  await scheduleNativeAdhan(city, hanafi, enabled: enabled);\n  final details = NotificationDetails(')
# Prevent duplicate device notification sound while native Adhan audio is playing.
replace_once("      sound ? 'mpt_prayer_sound' : 'mpt_prayer_silent',", "      'mpt_prayer_silent_v153',")
replace_once('      playSound: sound,\n    ),\n    iOS: DarwinNotificationDetails(presentSound: sound),', '      playSound: false,\n    ),\n    iOS: DarwinNotificationDetails(presentSound: sound),')
replace_once("        const Text('Preview works inside the app. Scheduled alerts still use the device notification sound.', style: TextStyle(fontSize: 12, color: muted)),", "        const Text('Saving alerts also schedules Android Adhan playback for the next 10 days. Exact timing depends on Android alarm permission and battery restrictions.', style: TextStyle(fontSize: 12, color: muted)),")
p.write_text(s, encoding='utf-8')
print('Upgraded main.dart to MPT 1.5.3; native Adhan bridge and localized calendar added.')
