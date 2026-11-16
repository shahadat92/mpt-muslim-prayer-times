MPT v1.5.1 build fix
1. GitHub repository root-এ এই ZIP-এর সব ফাইল আপলোড/replace করুন।
2. Codemagic থেকে নতুন build চালু করুন।
3. Calendar weekday বাংলা/কোরিয়ান/আরবি/ইংরেজি অনুযায়ী দেখাবে।
4. Native installer root Kotlin files এবং assets/audio MP3 ব্যবহার করে।
5. Automatic Adhan scheduling এখনও Dart থেকে native MethodChannel-এ যুক্ত নয়; APK build সফল হওয়া মানেই স্বয়ংক্রিয় আজান চালু নয়।
6. Android-এ notification/exact alarm permissions আলাদা পরীক্ষা করতে হবে।
