MPT MUSLIM PRAYER TIMES v1.1 - SOURCE PACKAGE

এটি Flutter সোর্স কোড, সরাসরি ইনস্টলযোগ্য APK নয়।

GitHub repo: https://github.com/shahadat92/korea-prayer-times

আপলোডের নির্দেশনা:
1. ZIP Extract করুন।
2. GitHub রিপোজিটরির root-এ pubspec.yaml ও codemagic.yaml আপডেট করুন।
3. lib/main.dart ফাইলটি প্রতিস্থাপন করুন।
4. assets/images/mpt_icon.png একই path-এ আপলোড করুন।
5. Commit changes করে Codemagic-এ নতুন build চালান।
6. সফল Build-এর Artifacts থেকে APK ডাউনলোড করুন।

নতুন অংশ: MPT branding, green/gold UI, Hijri month grid, Ramadan countdown,
Dua and Tasbih, notification controls, existing prayer time and GPS code.

সীমাবদ্ধতা:
- রেফারেন্স ছবির pixel-perfect clone নয়; Flutter UI-তে অনুরূপ থিম।
- AdMob আসল বিজ্ঞাপন এখনো যুক্ত নয়।
- Notification default system sound; full Adhan audio নয়।
- Hijri calendar civil estimate; local moon sighting differ করতে পারে।
- International cities list সীমিত; GPS coordinates ব্যবহার করা যায়।
- কোড এই পরিবেশে Flutter compiler দিয়ে যাচাই করা যায়নি।
- Android debug APK testing-এর জন্য; Play Store release signing আলাদা।


MPT v1.2 Source Package
- Original white background, gold crescent, green mosque icon retained.
- Fixed flutter_timezone 4.x timezone identifier handling.
- Codemagic workflow included for Android debug APK.
- Not compiled or device-tested in this environment.
- For production, verify notification scheduling, prayer times, and app permissions on actual devices.
