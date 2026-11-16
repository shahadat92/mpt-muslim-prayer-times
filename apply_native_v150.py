from pathlib import Path
import shutil
root=Path(__file__).resolve().parent
android=root/'android/app/src/main'
manifest=android/'AndroidManifest.xml'
if not manifest.exists(): raise SystemExit('Run flutter create before this script')
s=manifest.read_text()
for perm in ['android.permission.INTERNET','android.permission.ACCESS_FINE_LOCATION','android.permission.ACCESS_COARSE_LOCATION','android.permission.FOREGROUND_SERVICE','android.permission.FOREGROUND_SERVICE_MEDIA_PLAYBACK','android.permission.SCHEDULE_EXACT_ALARM','android.permission.RECEIVE_BOOT_COMPLETED','android.permission.POST_NOTIFICATIONS']:
 if perm not in s: s=s.replace('<application',f'<uses-permission android:name="{perm}"/>\n    <application',1)
if 'com.koreaprayertimes.korea_prayer_times.AdhanService' not in s:
 s=s.replace('</application>', '''<service android:name="com.koreaprayertimes.korea_prayer_times.AdhanService" android:exported="false" android:foregroundServiceType="mediaPlayback" />
        <receiver android:name="com.koreaprayertimes.korea_prayer_times.AdhanReceiver" android:exported="false" />
        <receiver android:name="com.dexterous.flutterlocalnotifications.ScheduledNotificationReceiver" android:exported="false" />
        <receiver android:name="com.dexterous.flutterlocalnotifications.ScheduledNotificationBootReceiver" android:exported="false">
          <intent-filter>
            <action android:name="android.intent.action.BOOT_COMPLETED" />
            <action android:name="android.intent.action.MY_PACKAGE_REPLACED" />
            <action android:name="android.intent.action.QUICKBOOT_POWERON" />
            <action android:name="com.htc.intent.action.QUICKBOOT_POWERON" />
          </intent-filter>
        </receiver>
    </application>''',1)
manifest.write_text(s)
package_dir=android/'kotlin/com/koreaprayertimes/korea_prayer_times'
package_dir.mkdir(parents=True,exist_ok=True)
for name in ['MainActivity.kt','AdhanReceiver.kt','AdhanService.kt']:
 
 source = root/'native_templates'/name
 if not source.exists():
  source = root/name
 if not source.exists():
  raise FileNotFoundError(f'Missing {name}: upload it to repository root or native_templates/')
 shutil.copy2(source,package_dir/name)
raw=android/'res/raw';raw.mkdir(parents=True,exist_ok=True)
for name in ['fajr_full','fajr_short','regular_full','regular_short']:
 
 source_audio = root/'assets/audio'/f'{name}.mp3'
 if not source_audio.is_file():
  raise FileNotFoundError(f'Missing audio: {source_audio}')
 shutil.copy2(source_audio,raw/f'{name}.mp3')
print('MPT 1.5 native alarm files installed')
