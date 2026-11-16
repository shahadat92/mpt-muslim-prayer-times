from pathlib import Path
import sys
root=Path(__file__).resolve().parent
checks={
 'Flutter entrypoint':(root/'lib/main.dart').is_file(),
 'Visible version':"v$versionLabel" in (root/'lib/main.dart').read_text(),
 'Adhan bridge':"MethodChannel('mpt/adhan_alarm')" in (root/'lib/main.dart').read_text(),
 'Native MainActivity installed':(root/'android/app/src/main/kotlin/com/koreaprayertimes/korea_prayer_times/MainActivity.kt').is_file(),
 'Native receiver installed':(root/'android/app/src/main/kotlin/com/koreaprayertimes/korea_prayer_times/AdhanReceiver.kt').is_file(),
 'Native service installed':(root/'android/app/src/main/kotlin/com/koreaprayertimes/korea_prayer_times/AdhanService.kt').is_file(),
 'Android manifest':(root/'android/app/src/main/AndroidManifest.xml').is_file(),
 'Adhan audio resources':all((root/f'android/app/src/main/res/raw/{n}.mp3').is_file() for n in ['fajr_full','fajr_short','regular_full','regular_short']),
}
for label,ok in checks.items(): print(('PASS' if ok else 'FAIL'),label)
if not all(checks.values()):sys.exit(1)
