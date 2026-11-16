from pathlib import Path
import sys

checks = []
def check(name, condition):
    checks.append((name, bool(condition)))
    print(('PASS' if condition else 'FAIL') + ': ' + name)

main = Path('lib/main.dart')
s = main.read_text(encoding='utf-8') if main.exists() else ''
check('main.dart present', main.exists())
check('version 1.5.3 in source', "const versionLabel = '1.5.3';" in s)
check('visible version 1.5.3', 'MPT · MUSLIM PRAYER TIMES · v1.5.3' in s)
check('localized calendar weekday labels', 'calendarWeekdays(widget.language).map' in s)
check('Bangla weekdays', all(x in s for x in ['রবি', 'সোম', 'মঙ্গল', 'বুধ', 'বৃহস্পতি', 'শুক্র', 'শনি']))
check('settings respects per-prayer choices', 'sound: sound, enabled: selectedPrayers' in s)
check('adhan audio service exists', Path('lib/adhan_audio.dart').is_file())
check('native installer exists', Path('apply_native_v150.py').is_file())
for name in ('fajr_full', 'fajr_short', 'regular_full', 'regular_short'):
    check(name + '.mp3', Path('assets/audio/' + name + '.mp3').is_file())
check('native source exists', bool(list(Path('android').rglob('*.kt'))) if Path('android').exists() else False)
print(f'\n{sum(ok for _,ok in checks)}/{len(checks)} checks passed')
if not all(ok for _,ok in checks):
    sys.exit(1)
