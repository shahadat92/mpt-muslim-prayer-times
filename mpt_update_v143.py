from pathlib import Path
import re

root=Path(__file__).resolve().parent
main=root/'lib/main.dart'
pub=root/'pubspec.yaml'
if not main.exists() or not pub.exists():
    raise SystemExit('ERROR: lib/main.dart or pubspec.yaml missing. Run from repository root.')
s=main.read_text(encoding='utf-8')
p=pub.read_text(encoding='utf-8')
if "import 'adhan_audio.dart';" not in s:
    s="import 'adhan_audio.dart';\n"+s
s,n=re.subn(r"const versionLabel\s*=\s*'[^']+';", "const versionLabel = '1.4.3';",s,count=1)
if n!=1: raise SystemExit('Could not find versionLabel in main.dart')

# Replace only the Settings page, preserving all other pages.
start=s.find('class SettingsPage extends StatelessWidget {')
if start<0:
    start=s.find('class SettingsPage extends StatefulWidget {')
end=s.find('class _GoldCard extends StatelessWidget {',start)
if start<0 or end<0: raise SystemExit('Could not locate SettingsPage boundaries; no files changed')
settings=r'''class SettingsPage extends StatefulWidget {
  final PrayerCity city;
  final bool hanafi;
  final String language;
  final bool dark;
  final bool sound;
  final ValueChanged<bool> onSoundChanged;
  final ValueChanged<bool> onMadhabChanged;
  final ValueChanged<String> onLanguageChanged;
  final ValueChanged<bool> onDarkChanged;
  const SettingsPage({super.key, required this.city, required this.hanafi,
    required this.language, required this.dark, required this.sound,
    required this.onSoundChanged, required this.onMadhabChanged,
    required this.onLanguageChanged, required this.onDarkChanged});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final AdhanAudioService adhanAudio = AdhanAudioService();
  bool adhanReady = false;

  @override
  void initState() {
    super.initState();
    _loadAdhan();
  }

  Future<void> _loadAdhan() async {
    try {
      await adhanAudio.load();
      if (mounted) setState(() => adhanReady = true);
    } catch (e) {
      debugPrint('Adhan settings load failed: $e');
    }
  }

  @override
  void dispose() {
    unawaited(adhanAudio.dispose());
    super.dispose();
  }

  Future<void> _preview(bool fajr) async {
    try {
      await adhanAudio.preview(fajr: fajr);
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Adhan audio error: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final language = widget.language;
    final color = Theme.of(context).colorScheme.onSurface;
    return ListView(padding: const EdgeInsets.fromLTRB(22, 32, 22, 32), children: [
      Text(tr(language, 'settings'), style: TextStyle(fontSize: 30,
        fontWeight: FontWeight.w900, color: color)),
      const SizedBox(height: 28),
      Text(tr(language, 'language'), style: const TextStyle(fontSize: 17,
        fontWeight: FontWeight.w800)),
      DropdownButton<String>(value: language, isExpanded: true, items: const [
        DropdownMenuItem(value: 'en', child: Text('English')),
        DropdownMenuItem(value: 'bn', child: Text('বাংলা')),
        DropdownMenuItem(value: 'ko', child: Text('한국어')),
        DropdownMenuItem(value: 'ar', child: Text('العربية')),
      ], onChanged: (value) { if (value != null) widget.onLanguageChanged(value); }),
      const SizedBox(height: 20),
      SwitchListTile(contentPadding: EdgeInsets.zero,
        title: Text(tr(language, 'appearance'),
          style: const TextStyle(fontWeight: FontWeight.w800)),
        subtitle: Text(widget.dark ? tr(language, 'dark') : tr(language, 'light')),
        value: widget.dark, onChanged: widget.onDarkChanged),
      const SizedBox(height: 24),
      Text(tr(language, 'asr'), style: const TextStyle(fontSize: 17,
        fontWeight: FontWeight.w800)),
      const SizedBox(height: 12),
      SegmentedButton<bool>(segments: const [
        ButtonSegment(value: false, label: Text('Shafi')),
        ButtonSegment(value: true, label: Text('Hanafi')),
      ], selected: {widget.hanafi},
        onSelectionChanged: (value) => widget.onMadhabChanged(value.first)),
      const SizedBox(height: 25),
      Text('${tr(language, 'calculation')}: ${tr(language, 'method')}',
        style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
      const SizedBox(height: 22),
      const Text('Adhan Settings · আজান সেটিংস',
        style: TextStyle(fontSize: 19, fontWeight: FontWeight.w800)),
      const SizedBox(height: 10),
      if (!adhanReady)
        const Padding(padding: EdgeInsets.all(12), child: CircularProgressIndicator())
      else ...[
        RadioListTile<AdhanLength>(
          title: const Text('Full Adhan · পূর্ণ আজান'),
          value: AdhanLength.full, groupValue: adhanAudio.length,
          onChanged: (v) async {
            if (v == null) return;
            await adhanAudio.setLength(v);
            if (mounted) setState(() {});
          }),
        RadioListTile<AdhanLength>(
          title: const Text('Short Adhan · সংক্ষিপ্ত আজান'),
          value: AdhanLength.short, groupValue: adhanAudio.length,
          onChanged: (v) async {
            if (v == null) return;
            await adhanAudio.setLength(v);
            if (mounted) setState(() {});
          }),
        SwitchListTile(
          title: const Text('Special Fajr Adhan'),
          subtitle: const Text('ফজরের বিশেষ আজান চালু'),
          value: adhanAudio.specialFajr,
          onChanged: (v) async {
            await adhanAudio.setSpecialFajr(v);
            if (mounted) setState(() {});
          }),
        Wrap(spacing: 8, runSpacing: 8, children: [
          OutlinedButton.icon(onPressed: () => _preview(false),
            icon: const Icon(Icons.play_arrow), label: const Text('Preview Adhan')),
          OutlinedButton.icon(onPressed: () => _preview(true),
            icon: const Icon(Icons.play_arrow), label: const Text('Preview Fajr')),
          OutlinedButton.icon(onPressed: () async { await adhanAudio.stop(); },
            icon: const Icon(Icons.stop), label: const Text('Stop')),
        ]),
        const SizedBox(height: 8),
        const Text('Preview plays inside the app. Scheduled reminders currently use the device notification sound.',
          style: TextStyle(fontSize: 12, color: muted)),
      ],
      const SizedBox(height: 22),
      SwitchListTile(contentPadding: EdgeInsets.zero,
        title: Text(tr(language, 'sound'),
          style: const TextStyle(fontWeight: FontWeight.w800)),
        subtitle: Text(tr(language, 'soundHint')),
        value: widget.sound, onChanged: widget.onSoundChanged),
      ListTile(leading: const Icon(Icons.notifications_active, color: emerald),
        title: Text(tr(language, 'prayerAlerts')),
        subtitle: Text(tr(language, 'manageAlerts')),
        trailing: const Icon(Icons.chevron_right),
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) =>
          NotificationPage(city: widget.city, hanafi: widget.hanafi,
            language: language)))),
      const SizedBox(height: 24),
      FilledButton.icon(style: FilledButton.styleFrom(
        backgroundColor: emerald, foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 17)),
        onPressed: () async {
          try {
            await schedulePrayerAlerts(widget.city, widget.hanafi,
              sound: widget.sound);
            if (context.mounted) ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(tr(language, 'notificationSuccess'))));
          } catch (error) {
            if (context.mounted) ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Could not schedule alerts: $error')));
          }
        }, icon: const Icon(Icons.notifications_active_outlined),
        label: Text(tr(language, 'alerts'))),
      const SizedBox(height: 15),
      Text(tr(language, 'refreshHint'),
        style: const TextStyle(fontSize: 12, color: muted)),
      const SizedBox(height: 28),
      Center(child: Text('MPT · MUSLIM PRAYER TIMES · v$versionLabel',
        style: const TextStyle(color: muted, fontSize: 12))),
    ]);
  }
}

'''
s=s[:start]+settings+s[end:]

# Keep the Prayer notifications screen for individual prayer toggles, remove duplicate adhan controls.
start=s.find('class _NotificationPageState extends State<NotificationPage> {')
if start<0: raise SystemExit('NotificationPage not found')
section=s[start:]
section=section.replace('  final adhanAudio = AdhanAudioService();\n  bool adhanReady = false;\n','')
section=section.replace('super.initState(); _load(); _loadAdhan();','super.initState(); _load();')
section=re.sub(r'  Future<void> _loadAdhan\(\) async \{.*?\n  \}\n  @override void dispose\(\) \{\n    adhanAudio.dispose\(\);\n    super.dispose\(\);\n  \}\n','',section,flags=re.S,count=1)
section,count=re.subn(r'    if \(adhanReady\) \.\.\.\[.*?\n    \],\n', '',section,flags=re.S,count=1)
if count!=1: raise SystemExit('Could not remove duplicate Adhan settings from NotificationPage')
s=s[:start]+section

# Existing Arabic dua and English remain unchanged; add localized meanings.
needle="Text(duas[selected][1], textAlign: TextAlign.center)"
if needle not in s: raise SystemExit('Dua meaning widget not found')
s=s.replace(needle,"Text(mptDuaMeaning(widget.language, selected, duas[selected][1]), textAlign: TextAlign.center)",1)
helper='''
String mptDuaMeaning(String language, int index, String english) {
  const meanings = <String, List<String>>{
    'bn': [
      'হে আমাদের রব! আমাদের দুনিয়াতে কল্যাণ দিন, আখিরাতেও কল্যাণ দিন এবং আমাদের জাহান্নামের আগুন থেকে রক্ষা করুন। (কুরআন ২:২০১)',
      'হে আমার রব! আমার জ্ঞান বৃদ্ধি করে দিন। (কুরআন ২০:১১৪)',
      'হে আমাদের রব! আমরা নিজেদের প্রতি অন্যায় করেছি। আপনি যদি আমাদের ক্ষমা না করেন এবং দয়া না করেন, তবে অবশ্যই আমরা ক্ষতিগ্রস্তদের অন্তর্ভুক্ত হব। (কুরআন ৭:২৩)',
    ],
    'ko': [
      '주님, 현세와 내세에서 저희에게 선을 베푸시고 불의 형벌로부터 보호해 주소서. (꾸란 2:201)',
      '주님, 저의 지식을 늘려 주소서. (꾸란 20:114)',
      '주님, 저희는 스스로에게 잘못을 저질렀습니다. 저희를 용서하시고 자비를 베풀지 않으시면 저희는 패배자가 될 것입니다. (꾸란 7:23)',
    ],
    'ar': [
      'ربنا آتنا في الدنيا حسنة وفي الآخرة حسنة وقنا عذاب النار. (البقرة ٢:٢٠١)',
      'رب زدني علما. (طه ٢٠:١١٤)',
      'ربنا ظلمنا أنفسنا وإن لم تغفر لنا وترحمنا لنكونن من الخاسرين. (الأعراف ٧:٢٣)',
    ],
  };
  final values = meanings[language];
  return values != null && index >= 0 && index < values.length
      ? values[index] : english;
}

'''
pos=s.find('class DuaPage extends StatefulWidget {')
if pos<0: raise SystemExit('DuaPage not found')
s=s[:pos]+helper+s[pos:]

# Update pubspec without deleting any existing dependencies or assets.
p,n=re.subn(r'(?m)^version:\s*[^\n]+', 'version: 1.4.3+143',p,count=1)
if n!=1: raise SystemExit('pubspec version not found')
if not re.search(r'(?m)^\s{2}audioplayers\s*:',p):
    p=p.replace('dependencies:\n','dependencies:\n  audioplayers: ^6.1.0\n',1)
if 'assets/audio/' not in p:
    if re.search(r'(?m)^\s{2}assets:\s*$',p):
        p=re.sub(r'(?m)^(\s{2}assets:\s*)$',r'\1\n    - assets/audio/',p,count=1)
    elif re.search(r'(?m)^flutter:\s*$',p):
        p=re.sub(r'(?m)^flutter:\s*$', 'flutter:\n  assets:\n    - assets/audio/',p,count=1)
    else:
        raise SystemExit('Could not locate flutter assets section')
# Only write after every validation succeeds.
main.write_text(s,encoding='utf-8')
pub.write_text(p,encoding='utf-8')
print('MPT v1.4.3 patch applied successfully')
