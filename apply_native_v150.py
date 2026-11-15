from pathlib import Path
import shutil
root=Path(__file__).resolve().parent
android=root/'android/app/src/main'
manifest=android/'AndroidManifest.xml'
if not manifest.exists(): raise SystemExit('Run flutter create before this script')
s=manifest.read_text()
for perm in ['android.permission.FOREGROUND_SERVICE','android.permission.FOREGROUND_SERVICE_MEDIA_PLAYBACK','android.permission.SCHEDULE_EXACT_ALARM','android.permission.RECEIVE_BOOT_COMPLETED']:
 if perm not in s: s=s.replace('<application',f'<uses-permission android:name="{perm}"/>\n    <application',1)
if 'com.koreaprayertimes.korea_prayer_times.AdhanService' not in s:
 s=s.replace('</application>', '''<service android:name="com.koreaprayertimes.korea_prayer_times.AdhanService" android:exported="false" android:foregroundServiceType="mediaPlayback" />
        <receiver android:name="com.koreaprayertimes.korea_prayer_times.AdhanReceiver" android:exported="false" />
    </application>''',1)
manifest.write_text(s)
package_dir=android/'kotlin/com/koreaprayertimes/korea_prayer_times'
package_dir.mkdir(parents=True,exist_ok=True)
for name in ['MainActivity.kt','AdhanReceiver.kt','AdhanService.kt']:
 shutil.copy2(root/'native_templates'/name,package_dir/name)
raw=android/'res/raw';raw.mkdir(parents=True,exist_ok=True)
for name in ['fajr_full','fajr_short','regular_full','regular_short']:
 shutil.copy2(root/'assets/audio'/f'{name}.mp3',raw/f'{name}.mp3')
print('MPT 1.5 native alarm files installed')
