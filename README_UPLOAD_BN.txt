MPT v1.5.3 সংশোধিত সোর্স

সমস্যার কারণ: পুরোনো lib/main.dart (v1.3.2) ছিল, নতুন কোড ভুল করে রুট main.dart-এ রাখা হয়েছিল। Flutter ব্যবহার করে lib/main.dart।

এই ZIP-এর সব ফাইল ও ফোল্ডার GitHub রিপোজিটরির মূল ফোল্ডারে আপলোড/প্রতিস্থাপন করুন। বিশেষ করে lib/main.dart অবশ্যই বদলাতে হবে। পুরোনো রুট main.dart থাকলে মুছে দিন।

Codemagic-এ নতুন Build শুরু করুন এবং কোন commit থেকে Build হচ্ছে দেখুন। প্রথম ধাপ Verify correct Flutter source-এ ১০টি PASS আসতে হবে।

১০টি PASS মানে কেবল সোর্স যাচাই, APK compilation বা background Adhan নিশ্চিত নয়। Android-এ exact alarm permission ও battery settings পরীক্ষা প্রয়োজন।
