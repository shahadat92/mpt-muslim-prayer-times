from pathlib import Path
import re

p = Path('lib/main.dart')
if not p.is_file():
    raise SystemExit('ERROR: lib/main.dart missing')
s = p.read_text(encoding='utf-8')
original = s

# Normalize version markers without rewriting UI.
s = re.sub(r"const versionLabel = '[^']+';", "const versionLabel = '1.5.3';", s)
s = re.sub(r"MPT · MUSLIM PRAYER TIMES · v[0-9.]+", "MPT · MUSLIM PRAYER TIMES · v1.5.3", s)

# Localize calendar weekday headers, preserving Sun-first layout.
old = "['Sun','Mon','Tue','Wed','Thu','Fri','Sat'].map((d)"
new = "calendarWeekdays(widget.language).map((d)"
if old not in s and new not in s:
    raise SystemExit('ERROR: calendar weekday widget not found; patch aborted')
s = s.replace(old, new)
helper = '''
const calendarWeekdayLabels = <String, List<String>>{
  'en': ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'],
  'bn': ['রবি', 'সোম', 'মঙ্গল', 'বুধ', 'বৃহস্পতি', 'শুক্র', 'শনি'],
  'ko': ['일', '월', '화', '수', '목', '금', '토'],
  'ar': ['الأحد', 'الإثنين', 'الثلاثاء', 'الأربعاء', 'الخميس', 'الجمعة', 'السبت'],
};
List<String> calendarWeekdays(String language) =>
    calendarWeekdayLabels[language] ?? calendarWeekdayLabels['en']!;
'''
if 'const calendarWeekdayLabels' not in s:
    anchor = 'int hijriAdjustment = 0;'
    if anchor not in s:
        raise SystemExit('ERROR: weekday helper anchor missing; patch aborted')
    s = s.replace(anchor, helper + '\n' + anchor, 1)

# Avoid accidentally resetting individual prayer choices when using the settings shortcut.
old = 'await schedulePrayerAlerts(city, hanafi, sound: sound);'
new = '''final prefs = await SharedPreferences.getInstance();
            final selectedPrayers = List<bool>.generate(
              5, (i) => prefs.getBool('prayer_$i') ?? true);
            await schedulePrayerAlerts(city, hanafi,
                sound: sound, enabled: selectedPrayers);'''
if old not in s and new not in s:
    raise SystemExit('ERROR: settings scheduling call not found; patch aborted')
s = s.replace(old, new)

# Make a small explicit status correction: previews are not scheduled native adhan.
# Do not claim that the native alarm is integrated without knowing the method channel.
if s == original:
    print('Already patched; no changes')
else:
    backup = p.with_suffix('.dart.before_mpt_fix')
    if not backup.exists():
        backup.write_text(original, encoding='utf-8')
    p.write_text(s, encoding='utf-8')
    print('PASS: main.dart version, localized weekdays and per-prayer settings patched')
