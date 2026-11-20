MPT URDU DISPLAY FIX - বাংলা নির্দেশনা

সমস্যা: নতুন Daily Duas-এ উর্দু ভাষার জন্য আরবি-লিপির উচ্চারণ অতিরিক্ত দেখাচ্ছে।
সমাধান: integrate_daily_duas.py-এর একটি নিয়ম সরানো হয়েছে।
পুরোনো দোয়া, সূরা, RTL, আরবি লেখা, অর্থ, অন্যান্য ভাষা ও Build configuration অপরিবর্তিত।

Android থেকে:
1. এই ZIP Extract করুন।
2. integrate_daily_duas.py ফাইলটি GitHub repository-র ROOT-এ (lib ফোল্ডারে নয়) আপলোড করে পুরোনো ফাইলটি Replace করুন।
3. Commit changes দিন।
4. Codemagic mpt_android_debug Build চালান।
5. Urdu > Daily Duas-এ আরবি মূল পাঠ, অর্থ ও সূত্র পরীক্ষা করুন।

দ্রষ্টব্য: এটি উর্দু উচ্চারণের ডেটা মুছে দেয় না, শুধু একই লিপির ডুপ্লিকেট লাইন লুকায়।
Surah screenshot-এ কোনো নিশ্চিত টেক্সট ত্রুটি শনাক্ত করা যায়নি; তাই Surah layout পরিবর্তন করা হয়নি।
Flutter SDK এখানে উপলব্ধ নয়; প্রকৃত APK Build ও ডিভাইস পরীক্ষা Codemagic-এ করতে হবে।
