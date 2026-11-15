MPT v1.4.2 — lib/main.dart corrected package

মূল সমস্যা: আগের ZIP-এ root/main.dart ছিল v1.4.2, কিন্তু Flutter যে lib/main.dart কম্পাইল করে সেটি পুরোনো v1.3.2 ছিল।
এই ZIP-এ নতুন v1.4.2 কোড lib/main.dart-এ বসানো হয়েছে এবং বিভ্রান্তিকর root-level duplicate files সরানো হয়েছে।

যা সংশোধিত:
- Settings-এর version label v1.4.2
- Calendar-এর সপ্তাহের দিন নির্বাচিত ভাষায়
- Dua-এর অর্থ নির্বাচিত ভাষায়
- Prayer alert schedule-এ প্রতিটি ওয়াক্তের saved on/off নির্বাচন
- Exact alarm অনুমতি থাকলে exact scheduling, না থাকলে fallback
- Adhan preview assets/settings অক্ষত

ব্যবহার:
1. ZIP Extract করুন।
2. ভেতরের lib, assets, codemagic.yaml, pubspec.yaml সহ ফাইলগুলো GitHub repository root-এ আপলোড/replace করুন। বিশেষ করে lib/main.dart অবশ্যই Replace করুন।
3. Codemagic-এ নতুন build চালান।
4. নতুন APK ইনস্টল করে Settings-এর নিচে v1.4.2 দেখুন।

সীমাবদ্ধতা: অ্যাপ বন্ধ থাকলে পূর্ণ MP3 আজান স্বয়ংক্রিয়ভাবে বাজানোর native integration এই ZIP-এ নেই। Flutter/Android SDK এখানে নেই, তাই APK build পরীক্ষা করা যায়নি।
