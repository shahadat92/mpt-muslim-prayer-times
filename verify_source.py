from pathlib import Path
import sys
root=Path(__file__).resolve().parent
main=(root/'lib/main.dart').read_text(encoding='utf-8')
learning=(root/'lib/mpt_learning.dart').read_text(encoding='utf-8')
pubspec=(root/'pubspec.yaml').read_text(encoding='utf-8')
checks={
 'v1.5.3 source': "const versionLabel = '1.5.3';" in main,
 'visible build marker': 'MPT-153-VERIFIED-SOURCE' in main,
 'localized weekdays used in calendar': 'calendarWeekdays(widget.language).map' in main,
 'compact Bangla weekdays': "'bn': ['রবি', 'সোম', 'মঙ্গল', 'বুধ', 'বৃহ', 'শুক্র', 'শনি']" in main,
 'native Adhan schedule integrated': 'await scheduleNativeAdhan(city, hanafi, enabled: enabled);' in main,
 'native alarm channel': "MethodChannel('mpt/adhan_alarm')" in main,
 'pubspec version': 'version: 1.5.3+153' in pubspec,
 'native installer': (root/'apply_native_v150.py').is_file(),
 'native Kotlin files': all((root/n).is_file() for n in ('MainActivity.kt','AdhanService.kt','AdhanReceiver.kt')),
 'all Adhan audio': all((root/'assets/audio'/f'{n}.mp3').is_file() for n in ('fajr_full','fajr_short','regular_full','regular_short')),
 'approved C banner image': (root/'assets/images/mpt_banner_c.png').is_file() and "Image.asset('assets/images/mpt_banner_c.png'" in main,
 'Quran surah search': 'class _SurahLibraryPageState' in learning and 'TextField(' in learning,
 'Quran bookmarks': "mpt_surah_bookmarks" in learning,
 'Quran last read': "mpt_last_read_surah" in learning,
 'Phone Sound UI removed': "title: Text(tr(widget.language, 'sound'))" not in main,
}
for label,ok in checks.items():
 print(('PASS' if ok else 'FAIL')+' '+label)
if not all(checks.values()): sys.exit('Incomplete source. Build stopped.')
