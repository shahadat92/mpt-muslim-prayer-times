from pathlib import Path
p=Path('lib/mpt_learning.dart')
s=p.read_text(encoding='utf-8')
marker='// MPT DAILY DUAS INTEGRATION V1'
if marker in s:
    print('Daily duas already integrated'); raise SystemExit(0)
def change(old,new):
    global s
    n=s.count(old)
    if n!=1: raise SystemExit(f'Unexpected source layout: expected exactly 1 occurrence, found {n}: {old[:90]!r}')
    s=s.replace(old,new,1)
change("import 'mpt_extra_languages.dart';", "import 'mpt_extra_languages.dart';\nimport 'mpt_daily_duas_additions.dart';")
change('String _localizedEntryTitle(_Entry d, String lang) {', '''String _localizedEntryTitle(_Entry d, String lang) {
  final addition = _mptAddedDuasByTitle[d.title];
  if (addition != null) return addition.titles[lang] ?? addition.titles['en']!;''')
change('String _localizedEntryPron(_Entry d, String lang) {', '''String _localizedEntryPron(_Entry d, String lang) {
  final addition = _mptAddedDuasByTitle[d.title];
  if (addition != null) return addition.pronunciations[lang] ?? addition.pronunciations['en']!;''')
change('const _dailyDuas = <_Entry>[', '''// MPT DAILY DUAS INTEGRATION V1
final _mptAddedDuasByTitle = <String, MptDailyDuaAddition>{
  for (final d in mptDailyDuaAdditions) d.titles['en']!: d,
};
final _dailyDuas = <_Entry>[
  for (final d in mptDailyDuaAdditions)
    _Entry(d.titles['en']!, d.arabic, d.pronunciations['en']!,
        d.meanings['bn']!, d.meanings['en']!, d.meanings['ko']!, d.reference),''')
change("if (widget.language != 'ar' && widget.language != 'ur') ...[", "if (widget.language != 'ar' && (widget.language != 'ur' || _mptAddedDuasByTitle.containsKey(d.title))) ...[")
change("Text(mptDuaMeanings[widget.language]?[d.title] ?? (widget.language=='bn'?d.bn:widget.language=='ko'?d.ko:widget.language=='ar'?(_arabicEntryMeanings[d.title] ?? d.en):d.en)", "Text(_mptAddedDuasByTitle[d.title]?.meanings[widget.language] ?? mptDuaMeanings[widget.language]?[d.title] ?? (widget.language=='bn'?d.bn:widget.language=='ko'?d.ko:widget.language=='ar'?(_arabicEntryMeanings[d.title] ?? d.en):d.en)")
# Fail closed if any expected anchor is absent. Existing files are otherwise untouched.
p.write_text(s,encoding='utf-8')
print('PASS: 7 new Daily Duas integrated into existing learning screen')
