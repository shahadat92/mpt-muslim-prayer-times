from pathlib import Path
import sys
root = Path(__file__).resolve().parent
main = (root/'lib/main.dart').read_text(encoding='utf-8')
checks = {
    'v1.5.3 source': "const versionLabel = '1.5.3';" in main,
    'unique visible build marker': 'MPT-153-VERIFIED-SOURCE' in main,
    'localized weekdays used in calendar': 'calendarWeekdays(widget.language).map' in main,
    'Bangla weekdays': "'bn': ['রবি', 'সোম', 'মঙ্গল'" in main,
    'native Adhan schedule integrated': 'await scheduleNativeAdhan(city, hanafi, enabled: enabled);' in main,
    'native alarm channel': "MethodChannel('mpt/adhan_alarm')" in main,
    'pubspec version': 'version: 1.5.3+153' in (root/'pubspec.yaml').read_text(),
    'native installer': (root/'apply_native_v150.py').is_file(),
    'native Kotlin files': all((root/n).is_file() for n in ('MainActivity.kt','AdhanService.kt','AdhanReceiver.kt')),
    'all Adhan audio': all((root/'assets/audio'/f'{n}.mp3').is_file() for n in ('fajr_full','fajr_short','regular_full','regular_short')),
}
for label, ok in checks.items(): print(('PASS' if ok else 'FAIL') + ' ' + label)
if not all(checks.values()): sys.exit('Incorrect/incomplete GitHub source. Build stopped.')
print('Verified source: MPT v1.5.3 / MPT-153-VERIFIED-SOURCE')
